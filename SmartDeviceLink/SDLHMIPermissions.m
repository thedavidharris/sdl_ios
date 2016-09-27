//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "SDLHMILevel.h"
#import "SDLNames.h"

@implementation SDLHMIPermissions

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setAllowed:(NSMutableArray *)allowed {
    if (allowed != nil) {
        [store setObject:allowed forKey:SDLNameAllowed];
    } else {
        [store removeObjectForKey:SDLNameAllowed];
    }
}

- (NSMutableArray *)allowed {
    NSMutableArray *array = [store objectForKey:SDLNameAllowed];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLHMILevel.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLHMILevel valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setUserDisallowed:(NSMutableArray *)userDisallowed {
    if (userDisallowed != nil) {
        [store setObject:userDisallowed forKey:SDLNameUserDisallowed];
    } else {
        [store removeObjectForKey:SDLNameUserDisallowed];
    }
}

- (NSMutableArray *)userDisallowed {
    NSMutableArray *array = [store objectForKey:SDLNameUserDisallowed];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLHMILevel.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLHMILevel valueOf:enumString]];
        }
        return newList;
    }
}

@end
