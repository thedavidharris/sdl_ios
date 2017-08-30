//
//  SDLStreamingMediaConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLStreamingMediaConfiguration

- (instancetype)init {
    return [self initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil];
}

+ (instancetype)insecureConfiguration {
    return [[self alloc] init];
}

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *_Nullable)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(NSDictionary<NSString *, id> *_Nullable)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource {
    self = [super init];
    if (!self) {
        return nil;
    }

    _securityManagers = securityManagers;
    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;
    _dataSource = dataSource;

    return self;
}

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    NSAssert(securityManagers.count > 0, @"A secure streaming media configuration requires security managers to be passed.");
    SDLStreamingEncryptionFlag encryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;

    return [self initWithSecurityManagers:securityManagers encryptionFlag:encryptionFlag videoSettings:nil dataSource:nil];
}

+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    return [[self alloc] initWithSecurityManagers:securityManagers];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithSecurityManagers:_securityManagers encryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings dataSource:_dataSource];
}

@end

NS_ASSUME_NONNULL_END
