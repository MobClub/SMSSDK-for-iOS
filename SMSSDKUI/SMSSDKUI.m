//
//  SMSSDKUI.m
//  SMSSDKUI
//
//  Created by 李愿生 on 15/12/30.
//  Copyright © 2015年 zhangtaokeji. All rights reserved.
//

#import "SMSSDKUI.h"
#import "RegViewController.h"
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <SMS_SDK/Extend/SMSSDKUserInfo.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>

@interface SMSSDKUI()

@property (nonatomic, strong) UIWindow *showWindow;

@end

@implementation SMSSDKUI

static SMSSDKUI * sharedSingleton = nil;

+ (SMSSDKUI *) sharedInstance
{
    @synchronized (self)
    {
        if (sharedSingleton == nil)
        {
            sharedSingleton = [[SMSSDKUI alloc] init];
        }
        return sharedSingleton;
    }
}


+ (void)showVerificationCodeViewWithMethod:(SMSGetCodeMethod)getCodeMehtod
{
    
    [[SMSSDKUI sharedInstance] _showView:getCodeMehtod];
    
}

-(void)_showView:(SMSGetCodeMethod)getCodeMehtod
{
    
    self.showWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootVC = [[UIViewController alloc] init];
    
    self.showWindow.rootViewController = rootVC;
    
    self.showWindow.userInteractionEnabled = YES;
    
    [self.showWindow makeKeyAndVisible];
    
    RegViewController *regView = [[RegViewController alloc] init];
    
    regView.getCodeMethod = getCodeMehtod;
    
    regView.window = self.showWindow;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regView];
    
    [self.showWindow.rootViewController presentViewController:nav animated:YES completion:^{
        
        
    }];
    
}

+ (void)showContactFriendView:(showContactFriendViewResult)result;
{
    [SMSSDK getAllContactFriends:1 result:^(NSError *error, NSArray *friendsArray) {
        
        result (friendsArray,error);
        
    }];
    
}


+ (void)submitUserinformation:(SMSSDKUserInfo *)userInfo
{
    
    [SMSSDK submitUserInfoHandler:userInfo result:^(NSError *error) {
        
        if (!error) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }
        
    }];
}

@end
