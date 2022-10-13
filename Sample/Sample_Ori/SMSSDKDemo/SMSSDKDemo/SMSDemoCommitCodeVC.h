//
//  SMSDemoCommitCodeVC.h
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMSSDK.h>


typedef void(^SMSDCommitCodeResultHanler)(NSDictionary *dict,NSError *error);


@interface SMSDemoCommitCodeVC : UIViewController

/**
 初始化获取验证码视图控制器
 
 *  @param methodType 获取验证码方法
 *  @param tempCode           模板id
 */
- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType template:(NSString *)tempCode result:(SMSDCommitCodeResultHanler)result;

@end

