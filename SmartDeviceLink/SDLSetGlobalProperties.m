//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"


@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:nil vrHelp:nil];
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:nil menuIcon:nil keyboardProperties:nil];
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(NSString *)menuTitle menuIcon:(SDLImage *)menuIcon keyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    self.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    self.vrHelpTitle = vrHelpTitle;
    self.vrHelp = [vrHelp mutableCopy];
    self.menuTitle = menuTitle;
    self.menuIcon = menuIcon;
    self.keyboardProperties = keyboardProperties;

    return self;
}


- (void)setHelpPrompt:(NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameHelpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameTimeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVrHelpTitle:(NSString *)vrHelpTitle {
    if (vrHelpTitle != nil) {
        [parameters setObject:vrHelpTitle forKey:SDLNameVRHelpTitle];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelpTitle];
    }
}

- (NSString *)vrHelpTitle {
    return [parameters objectForKey:SDLNameVRHelpTitle];
}

- (void)setVrHelp:(NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    NSMutableArray<SDLVRHelpItem *> *array = [parameters objectForKey:SDLNameVRHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray<SDLVRHelpItem *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMenuTitle:(NSString *)menuTitle {
    if (menuTitle != nil) {
        [parameters setObject:menuTitle forKey:SDLNameMenuTitle];
    } else {
        [parameters removeObjectForKey:SDLNameMenuTitle];
    }
}

- (NSString *)menuTitle {
    return [parameters objectForKey:SDLNameMenuTitle];
}

- (void)setMenuIcon:(SDLImage *)menuIcon {
    if (menuIcon != nil) {
        [parameters setObject:menuIcon forKey:SDLNameMenuIcon];
    } else {
        [parameters removeObjectForKey:SDLNameMenuIcon];
    }
}

- (SDLImage *)menuIcon {
    NSObject *obj = [parameters objectForKey:SDLNameMenuIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setKeyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    if (keyboardProperties != nil) {
        [parameters setObject:keyboardProperties forKey:SDLNameKeyboardProperties];
    } else {
        [parameters removeObjectForKey:SDLNameKeyboardProperties];
    }
}

- (SDLKeyboardProperties *)keyboardProperties {
    NSObject *obj = [parameters objectForKey:SDLNameKeyboardProperties];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardProperties.class]) {
        return (SDLKeyboardProperties *)obj;
    } else {
        return [[SDLKeyboardProperties alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
