//
//  ViewController.m
//  SMSSDKDemo
//
//  Created by youzu_Max on 2017/5/25.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import "SMSSDKUI.h"
#import <MOBFoundation/MOBFoundation.h>

#define SMSSDKUIBundle [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SMSSDKUI" ofType:@"bundle"]]

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define SMSSDKAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    self.title = NSLocalizedStringFromTableInBundle(@"smssdk", @"Localizable", SMSSDKUIBundle, nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[SMSSDK sdkVersion] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *path = [SMSSDKUIBundle pathForResource:@"button2" ofType:@"png"];
    UIImage *background = [[UIImage alloc] initWithContentsOfFile:path];
    
    //获取短信验证码
    UIButton* regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 1 * 70 + StatusBarHeight, 200, 40);
    
    [regBtn setTitle:NSLocalizedStringFromTableInBundle(@"RegisterBySMS", @"Localizable", SMSSDKUIBundle, nil) forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(getVerificationCodeText:) forControlEvents:UIControlEventTouchUpInside];
    [regBtn setBackgroundImage:background forState:UIControlStateNormal];
    [self.view addSubview:regBtn];

    //语音验证码注册
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 2 * 70 + StatusBarHeight, 200, 40);
    [btn setTitle:NSLocalizedStringFromTableInBundle(@"RegisterByVoiceCall", @"Localizable", SMSSDKUIBundle, nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getVerificationCodeVoice:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:background forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    //获取朋友列表按钮
    UIButton* friendsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    friendsBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 3 * 70 + StatusBarHeight, 200, 40);
    [friendsBtn setTitle:NSLocalizedStringFromTableInBundle(@"addressbookfriends", @"Localizable", SMSSDKUIBundle, nil) forState:UIControlStateNormal];
    [friendsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(getAddressBookFriends) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setBackgroundImage:background forState:UIControlStateNormal];
    [self.view addSubview:friendsBtn];
    
    
    //提交用户信息
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 4 * 70 + StatusBarHeight, 200, 40);
    [infoBtn setTitle:NSLocalizedStringFromTableInBundle(@"submitUserInfo", @"Localizable", SMSSDKUIBundle, nil) forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(submitUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setBackgroundImage:background forState:UIControlStateNormal];
    [self.view addSubview:infoBtn];
}

- (void)submitUserInfo:(id)sender
{
    SMSSDKUserInfo* userInfo=[[SMSSDKUserInfo alloc] init];
    userInfo.phone = @"15537110874";
    userInfo.zone = @"86";
    userInfo.avatar = @"http://www.mob.com/favicon.ico";
    userInfo.nickname = @"MOB";
    userInfo.uid = @"112";
    [SMSSDK submitUserInfo:userInfo result:^(NSError *error) {
        if (!error)
        {
            SMSSDKAlert(@"提交成功");
        }
        else
        {
            SMSSDKAlert(@"提交失败:%@",error);
        }
    }];
}

- (void)getVerificationCodeText:(id)sender
{
    [self getVerificationCodeWithMethod:SMSGetCodeMethodSMS];
}

- (void)getVerificationCodeVoice:(id)sender
{
    [self getVerificationCodeWithMethod:SMSGetCodeMethodVoice];
}

- (void)getVerificationCodeWithMethod:(SMSGetCodeMethod)method
{
    SMSSDKUIGetCodeViewController *vc = [[SMSSDKUIGetCodeViewController alloc] initWithMethod:method];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)getAddressBookFriends
{
    [SMSSDKUIProcessHUD showProcessHUDWithInfo:@"正在获取好友列表..."];
    [SMSSDK getAllContactFriends:^(NSError *error, NSArray *friendsArray) {
        
        if (error)
        {
            [SMSSDKUIProcessHUD dismiss];
            SMSSDKAlert(@"获取好友列表失败:%@",error);
        }
        else
        {
            NSLog(@"%@",friendsArray);
            [SMSSDKUIProcessHUD showSuccessInfo:[NSString stringWithFormat:@"获取到%zd条好友信息",friendsArray.count]];
            [SMSSDKUIProcessHUD dismissWithDelay:1 result:^{
                
                SMSSDKUIContactFriendsViewController *vc = [[SMSSDKUIContactFriendsViewController alloc] initWithContactFriends:friendsArray];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }];
        }
    }];
}


@end
