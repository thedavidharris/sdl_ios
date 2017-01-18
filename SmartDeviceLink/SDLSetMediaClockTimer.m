//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLStartTime.h"

@implementation SDLSetMediaClockTimer

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetMediaClockTimer]) {
    }
    return self;
}


- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds {
    self = [self initWithUpdateMode:updateMode];
    if (!self) {
        return nil;
    }

    self.startTime = [[SDLStartTime alloc] initWithHours:hours minutes:minutes seconds:seconds];

    return self;
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.updateMode = updateMode;

    return self;
}

- (void)setStartTime:(SDLStartTime *)startTime {
    [parameters sdl_setObject:startTime forName:SDLNameStartTime];
}

- (SDLStartTime *)startTime {
    return [parameters sdl_objectForName:SDLNameStartTime ofClass:SDLStartTime.class];
}

- (void)setEndTime:(SDLStartTime *)endTime {
    [parameters sdl_setObject:endTime forName:SDLNameEndTime];
}

- (SDLStartTime *)endTime {
    return [parameters sdl_objectForName:SDLNameEndTime ofClass:SDLStartTime.class];
}

- (void)setUpdateMode:(SDLUpdateMode)updateMode {
    [parameters sdl_setObject:updateMode forName:SDLNameUpdateMode];
}

- (SDLUpdateMode)updateMode {
    return [parameters sdl_objectForName:SDLNameUpdateMode];
}

@end
