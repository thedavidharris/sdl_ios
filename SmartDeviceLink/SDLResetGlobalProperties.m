//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLGlobalProperty.h"
#import "SDLNames.h"

@implementation SDLResetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameResetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithProperties:(NSArray<SDLGlobalProperty> *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = [properties mutableCopy];

    return self;
}

- (void)setProperties:(NSMutableArray<SDLGlobalProperty> *)properties {
    [parameters sdl_setObject:properties forName:SDLNameProperties];
}

- (NSMutableArray<SDLGlobalProperty> *)properties {
    return [parameters sdl_enumsForName:SDLNameProperties];
}

@end
