//
//  SMSSDKUI.h
//  SMSSDKUI
//
//  Created by 李愿生 on 15/12/30.
//  Copyright © 2015年 zhangtaokeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMS_SDK/Extend/SMSSDKUserInfo.h>
#import <SMS_SDK/Extend/SMSSDKResultHanderDef.h>

/**
 * @brief                 提交用户信息回调
 * @from                  v2.0.1
 * @param error           当error为空时表示成功
 * @param friendsArray    获取的好友列表
 */
typedef void (^showContactFriendViewResult) (NSArray *friendsArray,NSError *error);


@interface SMSSDKUI : NSObject

/**
 * @brief                展示获取验证码界面
 * @param getCodeMehtod  获取验证码的方法
 */
+ (void)showVerificationCodeViewWithMethod:(SMSGetCodeMethod)getCodeMehtod;


/**
 * @brief                展示好友列表界面
 * @param  result        获取好友列表结果
 */
+ (void)showContactFriendView:(showContactFriendViewResult)result;


/**
 * @brief                提交用户信息
 * @param userInfo       提交用户信息数据
 */
+ (void)submitUserinformation:(SMSSDKUserInfo *)userInfo;

@end
