
//
//  SDLSendHapticDataResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/4/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSendHapticDataResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendHapticDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSendHapticData]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
