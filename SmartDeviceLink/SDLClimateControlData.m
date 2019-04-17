//
//  SDLClimateControlData.m
//

#import "SDLClimateControlData.h"
#import "SDLRPCParameterNames.h"
#import "SDLTemperature.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClimateControlData

- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode {
    return [self initWithFanSpeed:fanSpeed desiredTemperature:desiredTemperature acEnable:acEnable circulateAirEnable:circulateAirEnable autoModeEnable:autoModeEnable defrostZone:defrostZone dualModeEnable:dualModeEnable acMaxEnable:acMaxEnable ventilationMode:ventilationMode heatedSteeringWheelEnable:@NO heatedWindshieldEnable:@NO heatedRearWindowEnable:@NO heatedMirrorsEnable:@NO];
}

- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode heatedSteeringWheelEnable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable heatedWindshieldEnable:(nullable NSNumber<SDLBool> *)heatedWindshieldEnable heatedRearWindowEnable:(nullable NSNumber<SDLBool> *)heatedRearWindowEnable heatedMirrorsEnable:(nullable NSNumber<SDLBool> *)heatedMirrorsEnable {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.fanSpeed = fanSpeed;
    self.desiredTemperature = desiredTemperature;
    self.acEnable = acEnable;
    self.circulateAirEnable = circulateAirEnable;
    self.autoModeEnable = autoModeEnable;
    self.defrostZone = defrostZone;
    self.dualModeEnable = dualModeEnable;
    self.acMaxEnable = acMaxEnable;
    self.ventilationMode = ventilationMode;
    self.heatedSteeringWheelEnable = heatedSteeringWheelEnable;
    self.heatedWindshieldEnable = heatedWindshieldEnable;
    self.heatedRearWindowEnable = heatedRearWindowEnable;
    self.heatedMirrorsEnable = heatedMirrorsEnable;

    return self;
}

- (void)setFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed {
    [store sdl_setObject:fanSpeed forName:SDLRPCParameterNameFanSpeed];
}

- (nullable NSNumber<SDLInt> *)fanSpeed {
    return [store sdl_objectForName:SDLRPCParameterNameFanSpeed ofClass:NSNumber.class error:nil];
}

- (void)setCurrentTemperature:(nullable SDLTemperature *)currentTemperature {
    [store sdl_setObject:currentTemperature forName:SDLRPCParameterNameCurrentTemperature];
}

- (nullable SDLTemperature *)currentTemperature {
    return [store sdl_objectForName:SDLRPCParameterNameCurrentTemperature ofClass:SDLTemperature.class error:nil];
}

- (void)setDesiredTemperature:(nullable SDLTemperature *)desiredTemperature {
    [store sdl_setObject:desiredTemperature forName:SDLRPCParameterNameDesiredTemperature];
}

- (nullable SDLTemperature *)desiredTemperature {
    return [store sdl_objectForName:SDLRPCParameterNameDesiredTemperature ofClass:SDLTemperature.class error:nil];
}

- (void)setAcEnable:(nullable NSNumber<SDLBool> *)acEnable {
    [store sdl_setObject:acEnable forName:SDLRPCParameterNameACEnable];
}

- (nullable NSNumber<SDLBool> *)acEnable {
    return [store sdl_objectForName:SDLRPCParameterNameACEnable ofClass:NSNumber.class error:nil];
}

- (void)setCirculateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable {
    [store sdl_setObject:circulateAirEnable forName:SDLRPCParameterNameCirculateAirEnable];
}

- (nullable NSNumber<SDLBool> *)circulateAirEnable {
    return [store sdl_objectForName:SDLRPCParameterNameCirculateAirEnable ofClass:NSNumber.class error:nil];
}

- (void)setAutoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable {
    [store sdl_setObject:autoModeEnable forName:SDLRPCParameterNameAutoModeEnable];
}

- (nullable NSNumber<SDLBool> *)autoModeEnable {
    return [store sdl_objectForName:SDLRPCParameterNameAutoModeEnable ofClass:NSNumber.class error:nil];
}

- (void)setDefrostZone:(nullable SDLDefrostZone)defrostZone {
    [store sdl_setObject:defrostZone forName:SDLRPCParameterNameDefrostZone];
}

- (nullable SDLDefrostZone)defrostZone {
    return [store sdl_enumForName:SDLRPCParameterNameDefrostZone error:nil];
}

- (void)setDualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable {
    [store sdl_setObject:dualModeEnable forName:SDLRPCParameterNameDualModeEnable];
}

- (nullable NSNumber<SDLBool> *)dualModeEnable {
    return [store sdl_objectForName:SDLRPCParameterNameDualModeEnable ofClass:NSNumber.class error:nil];
}

- (void)setAcMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable {
    [store sdl_setObject:acMaxEnable forName:SDLRPCParameterNameACMaxEnable];
}

- (nullable NSNumber<SDLBool> *)acMaxEnable {
    return [store sdl_objectForName:SDLRPCParameterNameACMaxEnable ofClass:NSNumber.class error:nil];
}

- (void)setVentilationMode:(nullable SDLVentilationMode)ventilationMode {
    [store sdl_setObject:ventilationMode forName:SDLRPCParameterNameVentilationMode];
}

- (nullable SDLVentilationMode)ventilationMode {
    return [store sdl_enumForName:SDLRPCParameterNameVentilationMode error:nil];
}

- (void)setHeatedSteeringWheelEnable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable {
    [store sdl_setObject:heatedSteeringWheelEnable forName:SDLRPCParameterNameHeatedSteeringWheelEnable];
}

- (nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable {
    return [store sdl_objectForName:SDLRPCParameterNameHeatedSteeringWheelEnable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedWindshieldEnable:(nullable NSNumber<SDLBool> *)heatedWindshieldEnable {
    [store sdl_setObject:heatedWindshieldEnable forName:SDLRPCParameterNameHeatedWindshieldEnable];
}

- (nullable NSNumber<SDLBool> *)heatedWindshieldEnable {
    return [store sdl_objectForName:SDLRPCParameterNameHeatedWindshieldEnable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedRearWindowEnable:(nullable NSNumber<SDLBool> *)heatedRearWindowEnable {
    [store sdl_setObject:heatedRearWindowEnable forName:SDLRPCParameterNameHeatedRearWindowEnable];
}

- (nullable NSNumber<SDLBool> *)heatedRearWindowEnable {
    return [store sdl_objectForName:SDLRPCParameterNameHeatedRearWindowEnable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedMirrorsEnable:(nullable NSNumber<SDLBool> *)heatedMirrorsEnable {
    [store sdl_setObject:heatedMirrorsEnable forName:SDLRPCParameterNameHeatedMirrorsEnable];
}

- (nullable NSNumber<SDLBool> *)heatedMirrorsEnable {
    return [store sdl_objectForName:SDLRPCParameterNameHeatedMirrorsEnable ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
