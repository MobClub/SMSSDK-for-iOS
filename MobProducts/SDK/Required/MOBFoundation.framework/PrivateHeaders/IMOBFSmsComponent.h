//
//  IMOBFSmsComponent.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/2/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOBFServiceComponent.h"

/**
 短信组件
 */
@protocol IMOBFSmsComponent <IMOBFServiceComponent>

/**
 *  @from                    v1.1.1
 *  @brief                   获取验证码(Get verification code)
 *
 *  @param method            获取验证码的方法(The method of getting verificationCode)
 *  @param phoneNumber       电话号码(The phone number)
 *  @param zone              区域号，不要加"+"号(Area code)
 *  @param result            请求结果回调(Results of the request)
 */
+ (void) getVerificationCodeByMethod:(NSInteger)method
                         phoneNumber:(NSString *)phoneNumber
                                zone:(NSString *)zone
                              result:(void (^) (NSError *error))result;


/**
 提交验证码

 @param verificationCode 验证码
 @param phoneNumber 手机号码
 @param zone 区域号
 @param result 请求结果回调
 */
+ (void) commitVerificationCode:(NSString *)verificationCode
                    phoneNumber:(NSString *)phoneNumber
                           zone:(NSString *)zone
                         result:(void (^) (id userInfo, NSError *error))result;

/**
 获取区域号

 @param result 请求结果回调
 */
+ (void) getCountryZone:(void (^)(NSError *error, NSArray* zonesArray))result;

@end
