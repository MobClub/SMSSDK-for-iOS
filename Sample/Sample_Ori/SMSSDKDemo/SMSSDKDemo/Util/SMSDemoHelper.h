//
//  SMSDemoHelper.h
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSDemoHelper : NSObject

+ (NSString *)currentZone;

+ (NSString *)currentCountryName;


+ (NSString *)errorTextWithError:(NSError *)error;

+ (BOOL)isZhHans;

@end

NS_ASSUME_NONNULL_END
