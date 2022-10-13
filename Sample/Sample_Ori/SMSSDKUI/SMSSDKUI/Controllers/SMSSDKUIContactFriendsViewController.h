//
//  SMSSDKUIContactFriendsViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/7.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"

@interface SMSSDKUIContactFriendsViewController : SMSSDKUIBaseViewController

/**
 初始化联系人列表视图控制器
 
 *  @param contactFriends 联系人
 */
- (instancetype)initWithContactFriends:(NSArray *)contactFriends;


/**
 初始化联系人列表视图控制器
 
 *  @param contactFriends 联系人
 *  @param tempCode           短信模板id
 */
- (instancetype)initWithContactFriends:(NSArray *)contactFriends template:(NSString *)tempCode;

@end
