//
//  SMSSDKUICommitCodeViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/2.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"
#import "SMSDefines.h"

@interface SMSSDKUICommitCodeViewController()

/**
 初始化提交验证码
 
 *  @param phone 号码
 *  @param zone 地区
 *  @param method 获取验证码方法
 *  @param codeBusiness 业务逻辑类型
 */
- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method codeBusiness:(SMSCheckCodeBusiness)codeBusiness;

@end

