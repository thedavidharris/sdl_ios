//  SDLDeviceStatus.m
//

#import "SDLDeviceStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDeviceLevelStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLPrimaryAudioSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeviceStatus

- (void)setVoiceRecOn:(NSNumber<SDLBool> *)voiceRecOn {
    [store sdl_setObject:voiceRecOn forName:SDLRPCParameterNameVoiceRecognitionOn];
}

- (NSNumber<SDLBool> *)voiceRecOn {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameVoiceRecognitionOn ofClass:NSNumber.class error:&error];
}

- (void)setBtIconOn:(NSNumber<SDLBool> *)btIconOn {
    [store sdl_setObject:btIconOn forName:SDLRPCParameterNameBluetoothIconOn];
}

- (NSNumber<SDLBool> *)btIconOn {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameBluetoothIconOn ofClass:NSNumber.class error:&error];
}

- (void)setCallActive:(NSNumber<SDLBool> *)callActive {
    [store sdl_setObject:callActive forName:SDLRPCParameterNameCallActive];
}

- (NSNumber<SDLBool> *)callActive {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameCallActive ofClass:NSNumber.class error:&error];
}

- (void)setPhoneRoaming:(NSNumber<SDLBool> *)phoneRoaming {
    [store sdl_setObject:phoneRoaming forName:SDLRPCParameterNamePhoneRoaming];
}

- (NSNumber<SDLBool> *)phoneRoaming {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNamePhoneRoaming ofClass:NSNumber.class error:&error];
}

- (void)setTextMsgAvailable:(NSNumber<SDLBool> *)textMsgAvailable {
    [store sdl_setObject:textMsgAvailable forName:SDLRPCParameterNameTextMessageAvailable];
}

- (NSNumber<SDLBool> *)textMsgAvailable {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameTextMessageAvailable ofClass:NSNumber.class error:&error];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus )battLevelStatus {
    [store sdl_setObject:battLevelStatus forName:SDLRPCParameterNameBatteryLevelStatus];
}

- (SDLDeviceLevelStatus)battLevelStatus {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameBatteryLevelStatus error:&error];
}

- (void)setStereoAudioOutputMuted:(NSNumber<SDLBool> *)stereoAudioOutputMuted {
    [store sdl_setObject:stereoAudioOutputMuted forName:SDLRPCParameterNameStereoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)stereoAudioOutputMuted {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameStereoAudioOutputMuted ofClass:NSNumber.class error:&error];
}

- (void)setMonoAudioOutputMuted:(NSNumber<SDLBool> *)monoAudioOutputMuted {
    [store sdl_setObject:monoAudioOutputMuted forName:SDLRPCParameterNameMonoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)monoAudioOutputMuted {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameMonoAudioOutputMuted ofClass:NSNumber.class error:&error];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus {
    [store sdl_setObject:signalLevelStatus forName:SDLRPCParameterNameSignalLevelStatus];
}

- (SDLDeviceLevelStatus)signalLevelStatus {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameSignalLevelStatus error:&error];
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource {
    [store sdl_setObject:primaryAudioSource forName:SDLRPCParameterNamePrimaryAudioSource];
}

- (SDLPrimaryAudioSource)primaryAudioSource {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNamePrimaryAudioSource error:&error];
}

- (void)setECallEventActive:(NSNumber<SDLBool> *)eCallEventActive {
    [store sdl_setObject:eCallEventActive forName:SDLRPCParameterNameECallEventActive];
}

- (NSNumber<SDLBool> *)eCallEventActive {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameECallEventActive ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
