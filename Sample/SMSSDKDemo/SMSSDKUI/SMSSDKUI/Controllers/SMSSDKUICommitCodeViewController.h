//
//  SMSSDKUICommitCodeViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/2.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSSDKUICommitCodeViewController : UIViewController

- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method;

@end
