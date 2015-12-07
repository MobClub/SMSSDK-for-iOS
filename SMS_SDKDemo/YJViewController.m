//
//  YJViewController.m
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-6-27.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "YJViewController.h"
#import "SMS_HYZBadgeView.h"
#import "RegViewController.h"
#import "SectionsViewControllerFriends.h"
#import "SMS_MBProgressHUD+Add.h"
#import <AddressBook/AddressBook.h>
#import "RegisterByVoiceCallViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>


@interface YJViewController ()
{
    SMS_HYZBadgeView* _testView;
    SectionsViewControllerFriends* _friendsController;
}

@end

static UIAlertView* _alert1 = nil;

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    //状态栏的屏幕设配
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    //短信验证码注册
    UIButton* regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(self.view.frame.size.width/2 - 100 , 50 + 1 * 70 + statusBarHeight, 200, 40);
    [regBtn setTitle:NSLocalizedString(@"RegisterBySMS", nil) forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button5.png"];
    [regBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:regBtn];
    
    //语音验证码注册
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(self.view.frame.size.width/2 - 100 , 50 + 2 * 70 + statusBarHeight, 200, 40);
    [btn setTitle:NSLocalizedString(@"RegisterByVoiceCall", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerWithSpeechVerification) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    //获取朋友列表按钮
    UIButton* friendsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    friendsBtn.frame = CGRectMake(self.view.frame.size.width/2 - 100 , 50 + 3 * 70 + statusBarHeight, 200, 40);
    [friendsBtn setTitle:NSLocalizedString(@"addressbookfriends", nil) forState:UIControlStateNormal];
    [friendsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(getAddressBookFriends) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:friendsBtn];
    
    //提交用户信息
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(self.view.frame.size.width/2 - 100 , 50 + 4 * 70 + statusBarHeight, 200, 40);
    [infoBtn setTitle:NSLocalizedString(@"submitUserInfo", nil) forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(submitUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:infoBtn];
    
    //创建导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0 + statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    [navigationItem setTitle:@"SMSSDK"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    SMS_HYZBadgeView *testView = [[SMS_HYZBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _testView = testView;
    [testView setNumber:0];
    [friendsBtn addSubview:testView];
     
    _friendsBlock = ^(enum SMSResponseState state,int latelyFriendsCount)
    {
        if (SMSResponseStateSuccess == state)
        {
            int count = latelyFriendsCount;
            
            [testView setNumber:count];
        }
    };
    [SMSSDK showFriendsBadge:_friendsBlock];
}


- (void)submitUserInfo:(id)sender
{
    SMSSDKUserInfo* userInfo=[[SMSSDKUserInfo alloc] init];
    userInfo.avatar = @"http://123.jpg";
    userInfo.nickname = @"Jimmy";
    userInfo.uid = @"010";
    //    user.phone = @"1861
    
    //最新方法
    [SMSSDK submitUserInfoHandler:userInfo result:^(NSError *error) {
        
        if (!error)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交失败"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        
        }
        
    }];
    
}

- (void)registerUser
{
    RegViewController* reg = [[RegViewController alloc] init];
    [self presentViewController:reg animated:YES completion:^{
        
    }];
}

- (void)registerWithSpeechVerification
{
    RegisterByVoiceCallViewController *sv = [[RegisterByVoiceCallViewController alloc] init];
    [self presentViewController:sv
                       animated:YES
                     completion:^{
                     }];
}

- (void)getAddressBookFriends
{
    [_testView setNumber:0];
    
    SectionsViewControllerFriends* friends = [[SectionsViewControllerFriends alloc] init];
    
    _friendsController = friends;
    
    [_friendsController setMyBlock:_friendsBlock];
    
    [SMS_MBProgressHUD showMessag:NSLocalizedString(@"loading", nil) toView:self.view];
    
    [SMSSDK getAllContactFriends:1 result:^(NSError *error, NSArray *friendsArray) {
        
        if (!error) {
            
            [_friendsController setMyData:[NSMutableArray arrayWithArray:friendsArray]];
            
            [self presentViewController:_friendsController animated:YES completion:^{
                ;
            }];
        }
        
    }];
    
    //判断用户通讯录是否授权
    if (_alert1)
    {
        [_alert1 show];
    }
    
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized && _alert1 == nil)
    {
        NSString* str = [NSString stringWithFormat:NSLocalizedString(@"authorizedcontact", nil)];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:str
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                            otherButtonTitles:nil, nil];
        _alert1 = alert;
        [alert show];
    }
}


@end
