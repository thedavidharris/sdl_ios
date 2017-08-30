//
//  SDLStreamingMediaLifecycleManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaLifecycleManager.h"

#import "SDLAbstractProtocol.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLHMICapabilities.h"
#import "SDLImageResolution.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLSystemCapability.h"
#import "SDLTouchManager.h"
#import "SDLVideoEncoder.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

#import "CVPixelBufferRef+SDLUtil.h"


NS_ASSUME_NONNULL_BEGIN

SDLAppState *const SDLAppStateInactive = @"AppInactive";
SDLAppState *const SDLAppStateActive = @"AppActive";

SDLVideoStreamState *const SDLVideoStreamStateStopped = @"VideoStreamStopped";
SDLVideoStreamState *const SDLVideoStreamStateStarting = @"VideoStreamStarting";
SDLVideoStreamState *const SDLVideoStreamStateReady = @"VideoStreamReady";
SDLVideoStreamState *const SDLVideoStreamStateShuttingDown = @"VideoStreamShuttingDown";

SDLAudioStreamState *const SDLAudioStreamStateStopped = @"AudioStreamStopped";
SDLAudioStreamState *const SDLAudioStreamStateStarting = @"AudioStreamStarting";
SDLAudioStreamState *const SDLAudioStreamStateReady = @"AudioStreamReady";
SDLAudioStreamState *const SDLAudioStreamStateShuttingDown = @"AudioStreamShuttingDown";

static NSUInteger const SDLFramesToSendOnBackground = 30;

typedef void(^SDLVideoCapabilityResponse)(SDLVideoStreamingCapability *_Nullable capability);


@interface SDLStreamingMediaLifecycleManager () <SDLVideoEncoderDelegate>

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) id<SDLStreamingMediaManagerDataSource> dataSource;
@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (copy, nonatomic) SDLStreamingMediaReadyBlock readyHandler;

@property (assign, nonatomic, readonly, getter=isAppStateVideoStreamCapable) BOOL appStateVideoStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateVideoStreamCapable) BOOL hmiStateVideoStreamCapable;

@property (assign, nonatomic, readwrite) BOOL restartVideoStream;

@property (strong, nonatomic, nullable) SDLVideoEncoder *videoEncoder;
@property (copy, nonatomic) NSDictionary<NSString *, id> *videoEncoderSettings;
@property (strong, nonatomic, nullable) SDLControlFramePayloadVideoStartService *videoStartServicePayload;
@property (strong, nonatomic) NSArray<SDLVideoStreamingFormat *> *preferredFormats;
@property (assign, nonatomic) NSUInteger preferredFormatIndex;
@property (strong, nonatomic) NSArray<SDLImageResolution *> *preferredResolutions;
@property (assign, nonatomic) NSUInteger preferredResolutionIndex;

@property (strong, nonatomic, readwrite) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *videoStreamStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;

@property (assign, nonatomic) CV_NULLABLE CVPixelBufferRef backgroundingPixelBuffer;

@end


@implementation SDLStreamingMediaLifecycleManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Creating StreamingLifecycleManager");

    _connectionManager = connectionManager;

    _videoEncoderSettings = configuration.customVideoEncoderSettings ?: SDLVideoEncoder.defaultVideoEncoderSettings;
    _requestedEncryptionType = configuration.maximumDesiredEncryption;
    _screenSize = SDLDefaultScreenSize;
    _backgroundingPixelBuffer = NULL;
    
    SDLAppState *initialState = SDLAppStateInactive;
    switch ([[UIApplication sharedApplication] applicationState]) {
        case UIApplicationStateActive: {
            initialState = SDLAppStateActive;
        } break;
        case UIApplicationStateInactive: // fallthrough
        case UIApplicationStateBackground: {
            initialState = SDLAppStateInactive;
        } break;
        default: break;
    }
    
    _touchManager = [[SDLTouchManager alloc] init];
    
    _appStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:initialState states:[self.class sdl_appStateTransitionDictionary]];
    _videoStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLVideoStreamStateStopped states:[self.class sdl_videoStreamStateTransitionDictionary]];
    _audioStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLAudioStreamStateStopped states:[self.class sdl_audioStreamingStateTransitionDictionary]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];
    
    return self;
}

- (void)startWithProtocol:(SDLAbstractProtocol *)protocol completionHandler:(SDLStreamingMediaReadyBlock)readyHandler {
    _protocol = protocol;
    _readyHandler = readyHandler;
    
    if (![self.protocol.protocolDelegateTable containsObject:self]) {
        [self.protocol.protocolDelegateTable addObject:self];
    }

    __weak typeof(self) weakSelf = self;
    [self sdl_requestVideoCapabilities:^(SDLVideoStreamingCapability * _Nullable capability) {
        // If we can't get capabilities, we're assuming it's H264 RAW at whatever the display capabilities said in the RAIR. We also aren't going to call the data source because they have no options.
        if (capability == nil) {
            weakSelf.videoStartServicePayload = nil;

            SDLVideoStreamingFormat *format = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
            SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:weakSelf.screenSize.width height:weakSelf.screenSize.height];
            weakSelf.preferredFormats = @[format];
            weakSelf.preferredResolutions = @[resolution];

            BLOCK_RETURN;
        }

        // If we got a response, get our preferred formats and resolutions
        weakSelf.preferredFormats = capability.supportedFormats;
        weakSelf.preferredResolutions = @[capability.preferredResolution];

        if (weakSelf.dataSource != nil) {
            weakSelf.preferredFormats = [weakSelf.dataSource preferredVideoFormatOrderFromHeadUnitPreferredOrder:weakSelf.preferredFormats];
            weakSelf.preferredResolutions = [weakSelf.dataSource resolutionFromHeadUnitPreferredResolution:weakSelf.preferredResolutions.firstObject];
        }
    }];
}

- (void)stop {
    [self sdl_stopAudioSession];
    [self sdl_stopVideoSession];
    
    self.restartVideoStream = NO;
    [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    if (!self.isVideoConnected) {
        SDLLogW(@"Attempted to send video data, but not connected");
        return NO;
    } else if (!self.isAppStateVideoStreamCapable) {
        SDLLogW(@"Attempted to send video data, but app is not in the foreground");
        return NO;
    } else if (!self.isHmiStateVideoStreamCapable) {
        SDLLogW(@"Attempted to send video data, but the app is not in LIMITED or FULL HMI state");
        return NO;
    }
    
    return [self.videoEncoder encodeFrame:imageBuffer];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    if (!self.isAudioConnected) {
        return NO;
    }
    
    if (self.isAudioEncrypted) {
        [self.protocol sendEncryptedRawData:audioData onService:SDLServiceTypeAudio];
    } else {
        [self.protocol sendRawData:audioData withServiceType:SDLServiceTypeAudio];
    }
    return YES;
}

#pragma mark Getters
- (BOOL)isAudioConnected {
    return [self.audioStreamStateMachine isCurrentState:SDLAudioStreamStateReady];
}

- (BOOL)isVideoConnected {
    return [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady];
}

- (BOOL)isVideoStreamingPaused {
    return !(self.isVideoConnected && self.isHmiStateVideoStreamCapable && self.isAppStateVideoStreamCapable);
}

- (CVPixelBufferPoolRef __nullable)pixelBufferPool {
    return self.videoEncoder.pixelBufferPool;
}

- (SDLAppState *)currentAppState {
    return self.appStateMachine.currentState;
}

- (SDLAudioStreamState *)currentAudioStreamState {
    return self.audioStreamStateMachine.currentState;
}

- (SDLVideoStreamState *)currentVideoStreamState {
    return self.videoStreamStateMachine.currentState;
}

#pragma mark - State Machines
#pragma mark App State
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_appStateTransitionDictionary {
    return @{
             // Will go from Inactive to Active if coming from a Phone Call.
             // Will go from Inactive to IsRegainingActive if coming from Background.
             SDLAppStateInactive : @[SDLAppStateActive],
             SDLAppStateActive : @[SDLAppStateInactive]
             };
}

- (void)sdl_appStateDidUpdate:(NSNotification*)notification {
    if (notification.name == UIApplicationWillResignActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateInactive];
    } else if (notification.name == UIApplicationDidBecomeActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateActive];
    }
}

- (void)didEnterStateAppInactive {
    SDLLogD(@"Manager became inactive");
    if (!self.protocol) { return; }

    [self sdl_sendBackgroundFrames];
    [self.touchManager cancelPendingTouches];
    self.restartVideoStream = YES;
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateAppActive {
    SDLLogD(@"Manager became active");
    if (!self.protocol) { return; }

    [self sdl_startVideoSession];
    [self sdl_startAudioSession];
}

#pragma mark Video Streaming
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_videoStreamStateTransitionDictionary {
    return @{
             SDLVideoStreamStateStopped : @[SDLVideoStreamStateStarting],
             SDLVideoStreamStateStarting : @[SDLVideoStreamStateStopped, SDLVideoStreamStateReady],
             SDLVideoStreamStateReady : @[SDLVideoStreamStateShuttingDown, SDLVideoStreamStateStopped],
             SDLVideoStreamStateShuttingDown : @[SDLVideoStreamStateStopped]
             };
}

- (void)didEnterStateVideoStreamStopped {
    SDLLogD(@"Video stream stopped");
    _videoEncrypted = NO;
    
    if (_videoEncoder != nil) {
        [_videoEncoder stop];
        _videoEncoder = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStopNotification object:nil];
    
    if (self.shouldRestartVideoStream) {
        self.restartVideoStream = NO;
        [self sdl_startVideoSession];
    }
}

- (void)didEnterStateVideoStreamStarting {
    SDLLogD(@"Video stream starting");
    self.restartVideoStream = NO;

    // Decide if we need to start a secure service or not
    if (self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) {
        [self.protocol startSecureServiceWithType:SDLServiceTypeVideo completionHandler:^(BOOL success, NSError *error) {
            // This only fires if we fail
            if (error) {
                SDLLogE(@"TLS setup error: %@", error);
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceTypeVideo];
    }
}

- (void)didEnterStateVideoStreamReady {
    SDLLogD(@"Video stream ready");
    // TODO: What if it is nil, is it even possible for it to be nil?
    if (self.videoEncoder == nil) {
        NSError* error = nil;
        self.videoEncoder = [[SDLVideoEncoder alloc] initWithDimensions:self.screenSize properties:self.videoEncoderSettings delegate:self error:&error];
        
        if (error) {
            SDLLogE(@"Could not create a video encoder: %@", error);
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            return;
        }
        
        if (!self.backgroundingPixelBuffer) {
            CVPixelBufferRef backgroundingPixelBuffer = [self.videoEncoder newPixelBuffer];
            if (CVPixelBufferAddText(backgroundingPixelBuffer, @"") == NO) {
                SDLLogE(@"Could not create a backgrounding frame");
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
                return;
            }
            
            self.backgroundingPixelBuffer = backgroundingPixelBuffer;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStartNotification object:nil];
}

- (void)didEnterStateVideoStreamShuttingDown {
    SDLLogD(@"Video stream shutting down");
    [self.protocol endServiceWithType:SDLServiceTypeVideo];
}

#pragma mark Audio
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_audioStreamingStateTransitionDictionary {
    return @{
             SDLAudioStreamStateStopped : @[SDLAudioStreamStateStarting],
             SDLAudioStreamStateStarting : @[SDLAudioStreamStateStopped, SDLAudioStreamStateReady],
             SDLAudioStreamStateReady : @[SDLAudioStreamStateShuttingDown, SDLAudioStreamStateStopped],
             SDLAudioStreamStateShuttingDown : @[SDLAudioStreamStateStopped]
             };
}

- (void)didEnterStateAudioStreamStopped {
    SDLLogD(@"Audio stream stopped");
    _audioEncrypted = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStopNotification object:nil];
}

- (void)didEnterStateAudioStreamStarting {
    SDLLogD(@"Audio stream starting");
    if (self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) {
        [self.protocol startSecureServiceWithType:SDLServiceTypeAudio payload:nil completionHandler:^(BOOL success, NSError * _Nonnull error) {
            if (error) {
                SDLLogE(@"TLS setup error: %@", error);
                [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceTypeAudio payload:nil];
    }
}

- (void)didEnterStateAudioStreamReady {
    SDLLogD(@"Audio stream ready");
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStartNotification object:nil];
}

- (void)didEnterStateAudioStreamShuttingDown {
    SDLLogD(@"Audio stream shutting down");
    [self.protocol endServiceWithType:SDLServiceTypeAudio];
}

#pragma mark - SDLProtocolListener
- (void)handleProtocolStartSessionACK:(SDLProtocolHeader *)header {
    switch (header.serviceType) {
        case SDLServiceTypeAudio: {
            _audioEncrypted = header.encrypted;
            
            [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateReady];
        } break;
        case SDLServiceTypeVideo: {
            _videoEncrypted = header.encrypted;
            
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateReady];
        } break;
        default: break;
    }
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

#pragma mark - SDLVideoEncoderDelegate
- (void)videoEncoder:(SDLVideoEncoder *)encoder hasEncodedFrame:(NSData *)encodedVideo {
    SDLLogV(@"Video encoder encoded frame, sending");
    // Do we care about app state here? I don't think so…
    BOOL capableVideoStreamState = [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady];
    
    if (self.isHmiStateVideoStreamCapable && capableVideoStreamState) {
        if (self.isVideoEncrypted) {
            [self.protocol sendEncryptedRawData:encodedVideo onService:SDLServiceTypeVideo];
        } else {
            [self.protocol sendRawData:encodedVideo withServiceType:SDLServiceTypeVideo];
        }
    }
}

#pragma mark - SDL RPC Notification callbacks
- (void)sdl_didReceiveRegisterAppInterfaceResponse:(SDLRPCResponseNotification *)notification {
    NSAssert([notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]], @"A notification was sent with an unanticipated object");
    if (![notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]]) {
        return;
    }
    
    SDLRegisterAppInterfaceResponse* registerResponse = (SDLRegisterAppInterfaceResponse*)notification.response;

    _streamingSupported = registerResponse.hmiCapabilities.videoStreaming ? registerResponse.hmiCapabilities.videoStreaming.boolValue : registerResponse.displayCapabilities.graphicSupported.boolValue;
    
    if (!self.isStreamingSupported) {
        SDLLogE(@"Graphics are not supported on this head unit. We are are assuming screen size is also unavailable.");
        return;
    }
    
    SDLImageResolution* resolution = registerResponse.displayCapabilities.screenParams.resolution;
    if (resolution != nil) {
        _screenSize = CGSizeMake(resolution.resolutionWidth.floatValue,
                                 resolution.resolutionHeight.floatValue);
    } else {
        _screenSize = SDLDefaultScreenSize;
    }
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }
    
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    
    self.hmiLevel = hmiStatus.hmiLevel;
    
    if (self.isHmiStateVideoStreamCapable) {
        [self sdl_startVideoSession];
    } else {
        [self sdl_stopVideoSession];
    }
    
    if (self.isHmiStateAudioStreamCapable) {
        [self sdl_startAudioSession];
    } else {
        [self sdl_stopAudioSession];
    }
}


#pragma mark - Streaming session helpers

- (void)sdl_startVideoSession {
    if (!self.isStreamingSupported) {
        return;
    }
    
    if (self.shouldRestartVideoStream
        && [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady]) {
        [self sdl_stopVideoSession];
        return;
    }
    
    if ([self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateStopped]
        && self.isHmiStateVideoStreamCapable
        && self.isAppStateVideoStreamCapable) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStarting];
    } else {
        SDLLogE(@"Unable to start video stream\n"
                "State: %@\n"
                "HMI state: %@\n"
                "App state: %@", self.videoStreamStateMachine.currentState, self.hmiLevel, self.appStateMachine.currentState);
    }
}

- (void)sdl_startAudioSession {
    if (!self.isStreamingSupported) {
        return;
    }
    
    if ([self.audioStreamStateMachine isCurrentState:SDLAudioStreamStateStopped]
        && self.isHmiStateAudioStreamCapable) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStarting];
    }
}

- (void)sdl_stopVideoSession {
    if (!self.isStreamingSupported) {
        return;
    }
    
    if (self.isVideoConnected) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateShuttingDown];
    }
}

- (void)sdl_stopAudioSession {
    if (!self.isStreamingSupported) {
        return;
    }
    
    if (self.isAudioConnected) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateShuttingDown];
    }
}

- (void)sdl_transitionToStoppedState:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceTypeAudio:
            [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
            break;
        case SDLServiceTypeVideo:
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            break;
        default:
            break;
    }
}

- (void)sdl_sendBackgroundFrames {
    if (!self.backgroundingPixelBuffer) {
        return;
    }
    
    for (int frameCount = 0; frameCount < SDLFramesToSendOnBackground; frameCount++) {
        [self.videoEncoder encodeFrame:self.backgroundingPixelBuffer];
    }
}

- (void)sdl_requestVideoCapabilities:(SDLVideoCapabilityResponse)responseHandler {
    SDLGetSystemCapability *getVideoCapabilityRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming];

    [self.connectionManager sendManagerRequest:getVideoCapabilityRequest withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLVideoStreamingCapability *videoCapability = ((SDLGetSystemCapabilityResponse *)response).systemCapability.videoStreamingCapability;

        responseHandler(videoCapability);
    }];
}

#pragma mark Getters
- (BOOL)isAppStateVideoStreamCapable {
    return [self.appStateMachine isCurrentState:SDLAppStateActive];
}

- (BOOL)isHmiStateAudioStreamCapable {
    return YES;
}

- (BOOL)isHmiStateVideoStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

@end

NS_ASSUME_NONNULL_END
