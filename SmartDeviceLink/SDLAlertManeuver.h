//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTTSChunk;


/**
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest

- (instancetype)initWithTTS:(NSString *)ttsText softButtons:(NSArray<SDLSoftButton *> *)softButtons;
- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(NSArray<SDLSoftButton *> *)softButtons;

@property (strong) NSMutableArray<SDLTTSChunk *> *ttsChunks;
@property (strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end
