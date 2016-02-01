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
#import <AddressBook/AddressBook.h>
#import "YJLocalCountryData.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import "SMSSDKUI.h"


@interface YJViewController ()
{
    SMS_HYZBadgeView* _testView;
}

@property(nonatomic,strong) SMSShowNewFriendsCountBlock friendsBlock;

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    //状态栏的屏幕设配
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    
    //短信验证码注册
    UIButton* regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(self.view.frame.size.width/2 - 100 , 50 + 1 * 70 + statusBarHeight, 200, 40);
    [regBtn setTitle:NSLocalizedString(@"RegisterBySMS", nil) forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    NSString *icon = [NSString stringWithFormat:@"SMSSDKUI.bundle/button5.png"];
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

    //添加版本号
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 56 + statusBarHeight, 50, 15)];
    versionLabel.text = [NSString stringWithFormat:@"V%@",[SMSSDK SMSSDKVersion]];
    versionLabel.font = [UIFont systemFontOfSize:15.0f];
    versionLabel.textColor = [UIColor redColor];
    UIBarButtonItem *rightButtonView = [[UIBarButtonItem alloc] initWithCustomView:versionLabel];
    
    [navigationItem setTitle:@"SMSSDK"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setRightBarButtonItem:rightButtonView];
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
//    userInfo.phone = @"186162619800";
    [SMSSDKUI submitUserinformation:userInfo];
   
}

- (void)registerUser
{
    //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
    [SMSSDKUI showVerificationCodeViewWithMethod:SMSGetCodeMethodSMS];
}

- (void)registerWithSpeechVerification
{
    //展示获取验证码界面，SMSGetCodeMethodVoice:表示通过语音短信方式获取验证
    [SMSSDKUI showVerificationCodeViewWithMethod:SMSGetCodeMethodVoice];
    
}


- (void)getAddressBookFriends
{
    
    [_testView setNumber:0];
    
    __weak YJViewController *yjViewController = self;
    
    SectionsViewControllerFriends* friends = [[SectionsViewControllerFriends alloc] init];
    
    [friends setMyBlock:_friendsBlock];
    
    [YJLocalCountryData showMessag:NSLocalizedString(@"loading", nil) toView:self.view];
    
    [SMSSDKUI showContactFriendView:^(NSArray *friendsArray, NSError *error) {
        
        if (!error) {
            
            [friends setMyData:[NSMutableArray arrayWithArray:friendsArray]];
            
            [yjViewController presentViewController:friends animated:YES completion:^{
                ;
            }];
        }
        else
        {
            NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:NSLocalizedString(messageStr, nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
  
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        NSString* str = [NSString stringWithFormat:NSLocalizedString(@"authorizedcontact", nil)];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:str
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
