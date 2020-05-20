//
//  SMSSDKUIGetCodeViewController_Private.h
//  SMSSDKUI
//
//  Created by hower on 2018/4/19.
//  Copyright © 2018年 youzu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SMSDefines.h"

@interface SMSSDKUIGetCodeViewController()

/**
 初始化获取验证码视图控制器
 
 *  @param methodType 获取验证码方法
 *  @param codeBusiness 业务逻辑类型
 */
- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType codeBusiness:(SMSCheckCodeBusiness)codeBusiness template:(NSString *)tempCode;


@end
