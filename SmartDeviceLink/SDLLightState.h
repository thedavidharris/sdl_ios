//  SDLLightState.h
//

#import "SDLRPCMessage.h"
#import "SDLLightName.h"
#import "SDLLightStatus.h"

@class SDLSRGBColor;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLightState : SDLRPCStruct

/**
 Constructs a newly allocated SDLLightState object with given parameters

 @param id The name of a light or a group of lights
 @param status Reflects the status of Light.
 @return An instance of the SDLLightState class
 */
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status;

/**
 Constructs a newly allocated SDLLightState object with given parameters

 @param id The name of a light or a group of lights
 @param status Reflects the status of Light.
 @param density Reflects the density of Light.
 @param sRGBColor Reflects the color of Light.
 @return An instance of the SDLLightState class
 */
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status density:(double)density sRGBColor:(SDLSRGBColor *)sRGBColor;

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName id;

/**
 * @abstract Reflects the status of Light.
 *
 * Required, SDLLightStatus
 */
@property (strong, nonatomic) SDLLightStatus status;

/**
 * @abstract Reflects the density of Light.
 *
 * Optional, Float type with minValue: 0 maxValue:1
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *density;

/**
 * @abstract Reflects the color of Light.
 *
 * Optional, SDLLightStatus
 */
@property (nullable, strong, nonatomic) SDLSRGBColor *sRGBColor;

@end

NS_ASSUME_NONNULL_END
