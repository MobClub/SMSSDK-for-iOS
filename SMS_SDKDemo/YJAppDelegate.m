//
//  YJAppDelegate.m
//  SMS_SDKDemo
//
//  Created by 刘 靖煌 on 14-8-28.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "YJAppDelegate.h"
#import "YJViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <MOBFoundation/MOBFoundation.h>
//
////////官网key
//#define appKey @"d57e4c5a5a70"
//#define appSecret @"495aec16058a6098523bba10001b0e99"

@interface YJAppDelegate ()<UIAlertViewDelegate>

@end

@implementation YJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self showInputAlertView];
    
    YJViewController* yj = [[YJViewController alloc] init];
    self.window.rootViewController = yj;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showInputAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您的应用信息" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView textFieldAtIndex:0].placeholder = @"请输入appkey";
    [alertView textFieldAtIndex:1].placeholder = @"请输入appSecret";
    
    NSString *appKey = [[MOBFDataService sharedInstance] cacheDataForKey:@"appKey" domain:nil];
    NSString *appSecret = [[MOBFDataService sharedInstance] cacheDataForKey:@"appSecret" domain:nil];
    
    if (appKey && appSecret) {
        [alertView textFieldAtIndex:0].text = appKey;
        [alertView textFieldAtIndex:1].text = appSecret;
    }
    
    [alertView textFieldAtIndex:1].secureTextEntry = NO;
    alertView.tag = 101;
    alertView.delegate = self;
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 101) {
        
        //初始化应用，appKey和appSecret从后台申请得到
        [SMSSDK registerApp:[[alertView textFieldAtIndex:0] text]
                 withSecret:[[alertView textFieldAtIndex:1] text]];
        
        //    [SMSSDK enableAppContactFriends:NO];
        
        NSString  *key = [[alertView textFieldAtIndex:0] text];
        NSString  *serect = [[alertView textFieldAtIndex:1] text];
        NSLog(@"key_%@  serect_%@",key,serect);
        [[MOBFDataService sharedInstance] setCacheData:[[alertView textFieldAtIndex:0] text] forKey:@"appKey" domain:nil];
        [[MOBFDataService sharedInstance] setCacheData:[[alertView textFieldAtIndex:1] text] forKey:@"appSecret" domain:nil];
        
    }
    
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    if ([[alertView textFieldAtIndex:0].placeholder isEqualToString:@"请输入appkey"] || [[alertView textFieldAtIndex:1].placeholder isEqualToString:@"请输入appSecret"]) {
        
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""] || [[alertView textFieldAtIndex:1].text isEqualToString:@""]) {
            
            return NO;
            
        }
        else
        {
            
            return YES;
        }
    }
    else
    {
        
        return YES;
    }
    
}

@end
