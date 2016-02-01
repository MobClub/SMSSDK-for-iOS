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
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>

//SMSSDK官网公共key
#define appkey @"f3fc6baa9ac4"
#define app_secrect @"7f3dedcb36d92deebcb373af921d635a"

@interface YJAppDelegate ()

@end

@implementation YJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
  
    [SMSSDK registerApp:appkey
             withSecret:app_secrect];
  //[SMSSDK enableAppContactFriends:NO];
    
    YJViewController* yj = [[YJViewController alloc] init];
    self.window.rootViewController = yj;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
