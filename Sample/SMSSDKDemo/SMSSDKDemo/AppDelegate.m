//
//  AppDelegate.m
//  SMSSDKDemo
//
//  Created by youzu_Max on 2017/5/25.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    BOOL oldUI = NO;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"smsdemo_oldui"])
    {
        oldUI = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smsdemo_oldui"] boolValue];
    }

    UIViewController *vc = nil;
    if(!oldUI)
    {
        vc = [[HomeVC alloc] init];
    }
    else
    {
        vc = [[ViewController alloc] init];
    }


    [SMSSDK enableAppContactFriends:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
