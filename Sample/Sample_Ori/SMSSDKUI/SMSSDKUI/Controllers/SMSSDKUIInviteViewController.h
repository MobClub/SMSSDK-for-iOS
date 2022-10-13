//
//  SMSSDKUIInviteViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/8.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"

@class SMSSDKAddressBook;

@interface SMSSDKUIInviteViewController : SMSSDKUIBaseViewController

- (instancetype)initWithContact:(SMSSDKAddressBook *)contact;

@end
