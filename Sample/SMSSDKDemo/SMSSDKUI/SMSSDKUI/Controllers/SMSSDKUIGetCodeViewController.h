//
//  SMSSDKUIGetCodeViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"

@interface SMSSDKUIGetCodeViewController : SMSSDKUIBaseViewController

/**
 初始化获取验证码视图控制器
 
  *  @param methodType 获取验证码方法
 */
- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType;


/**
 初始化获取验证码视图控制器
 
  *  @param methodType 获取验证码方法
  *  @param tempCode           模板id
 */
- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType template:(NSString *)tempCode;


@end

