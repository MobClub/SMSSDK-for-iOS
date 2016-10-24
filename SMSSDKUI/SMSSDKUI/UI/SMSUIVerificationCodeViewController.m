//
//  SMSUIShowActionViewController.m
//  SMSUI
//
//  Created by 李愿生 on 15/8/12.
//  Copyright (c) 2015年 liys. All rights reserved.
//

#import "SMSUIVerificationCodeViewController.h"

#import "RegViewController.h"
#import "SMSUIVerificationCodeViewResultDef.h"
#import <SMS_SDK/SMSSDK.h>

@interface SMSUIVerificationCodeViewController ()
{
    
    SMSGetCodeMethod _getCodeMethod;
    
}

@property (nonatomic, copy) SMSUIVerificationCodeResultHandler verificationCodeResult;

@property (nonatomic, strong) UIWindow *actionViewWindow;

@property (nonatomic, strong) SMSUIVerificationCodeViewController *selfVerificationCodeViewController;

@end

@implementation SMSUIVerificationCodeViewController

- (instancetype)initVerificationCodeViewWithMethod:(SMSGetCodeMethod)whichMethod
{
    
    if (self = [super init])
    {
        _getCodeMethod = whichMethod;
    }
    return self;
}

- (void)show
{
    self.selfVerificationCodeViewController = self;
    
    self.actionViewWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootVC = [[UIViewController alloc] init];
    
    self.actionViewWindow.rootViewController = rootVC;
    
    self.actionViewWindow.userInteractionEnabled = YES;
    
    [self.actionViewWindow makeKeyAndVisible];
    
    __weak SMSUIVerificationCodeViewController *verificationCodeVC = self;
    
    RegViewController *registerViewBySMS = [[RegViewController alloc] init];
    
    registerViewBySMS.getCodeMethod = _getCodeMethod;
    
    registerViewBySMS.verificationCodeResult = ^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone,NSError *error){
        
        if (state == SMSUIResponseStateCancel)
        {
            
            if (verificationCodeVC.verificationCodeResult)
            {
                
                verificationCodeVC.verificationCodeResult (SMSUIResponseStateCancel ,phoneNumber,zone,error);
                
            }
            
        }
        else if (state == SMSUIResponseStateSuccess )
        {
            
            if (verificationCodeVC.verificationCodeResult)
            {
                
                verificationCodeVC.verificationCodeResult (SMSUIResponseStateSuccess,phoneNumber,zone,error);
            }
            
            
        }
        else if (state == SMSUIResponseStateFail )
        {
            
            if (verificationCodeVC.verificationCodeResult)
            {
                verificationCodeVC.verificationCodeResult (SMSUIResponseStateFail,phoneNumber,zone,error);
            }
        }
        
        [verificationCodeVC dismiss];
        
    };
    
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:registerViewBySMS];
    
    [self.actionViewWindow.rootViewController presentViewController:navc animated:YES completion:^{
        
    }];
}

- (void)dismiss;
{
    self.selfVerificationCodeViewController = nil;
    
    [self.actionViewWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        self.actionViewWindow = nil;
        
    }];
}

- (void)onVerificationCodeViewReslut:(SMSUIVerificationCodeResultHandler)result
{
    self.verificationCodeResult = result;
}


@end
