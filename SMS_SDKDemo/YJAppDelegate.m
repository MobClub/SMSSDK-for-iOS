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

#define appKey @"5b2655c71290"
#define appSecret @"55988074b9a3faadffa6f74cd3ae7845"

@implementation YJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化应用，appKey和appSecret从后台申请得到
    [SMSSDK registerApp:appKey
              withSecret:appSecret];
    
//    [SMSSDK enableAppContactFriends:NO];
  
    YJViewController* yj = [[YJViewController alloc] init];
    self.window.rootViewController = yj;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
