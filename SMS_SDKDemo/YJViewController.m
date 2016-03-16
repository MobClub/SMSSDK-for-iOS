//
//  YJViewController.m
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-6-27.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "YJViewController.h"
#import "SMS_HYZBadgeView.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import "SMSSDKUI.h"

#import "YJLocalCountryData.h"

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
    regBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 1 * 70 + statusBarHeight, 200, 40);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SMSSDKUI" ofType:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithPath:filePath];
    [regBtn setTitle:NSLocalizedStringFromTableInBundle(@"RegisterBySMS", @"Localizable", bundle, nil) forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    NSString *icon = [NSString stringWithFormat:@"button5.png"];
    [regBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:regBtn];
    
    //语音验证码注册
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 2 * 70 + statusBarHeight, 200, 40);
    [btn setTitle:NSLocalizedStringFromTableInBundle(@"RegisterByVoiceCall", @"Localizable", bundle, nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerWithSpeechVerification) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    //获取朋友列表按钮
    UIButton* friendsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    friendsBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 3 * 70 + statusBarHeight, 200, 40);
    [friendsBtn setTitle:NSLocalizedStringFromTableInBundle(@"addressbookfriends", @"Localizable", bundle, nil) forState:UIControlStateNormal];
    [friendsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(getAddressBookFriends) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.view addSubview:friendsBtn];
    
    //提交用户信息
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100 , 50 + 4 * 70 + statusBarHeight, 200, 40);
    [infoBtn setTitle:NSLocalizedStringFromTableInBundle(@"submitUserInfo", @"Localizable", bundle, nil) forState:UIControlStateNormal];
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
    
    [navigationItem setTitle:NSLocalizedStringFromTableInBundle(@"smssdk", @"Localizable", bundle, nil)];
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

- (void)registerUser
{
    //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodSMS result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
        
    }];
}

- (void)registerWithSpeechVerification
{
    //展示获取验证码界面，SMSGetCodeMethodVoice:表示通过语音短信方式获取验证
    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodVoice result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
        
    }];
    
}


- (void)getAddressBookFriends
{
    
    [_testView setNumber:0];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SMSSDKUI" ofType:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithPath:filePath];
    [YJLocalCountryData showMessag:NSLocalizedStringFromTableInBundle(@"loading", @"Localizable", bundle, nil) toView:self.view];
    
    [SMSSDK getAllContactFriends:1 result:^(NSError *error, NSArray *friendsArray) {
        
        if (!error)
        {
            [SMSSDKUI showGetContactsFriendsViewWithNewFriends:[NSMutableArray arrayWithArray:friendsArray] newFriendClock:_friendsBlock result:^{
                
            }];
            
        }
        else
        {
            NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"codesenderrtitle", @"Localizable", bundle, nil)
                                                            message:NSLocalizedStringFromTableInBundle(messageStr, @"Localizable", bundle, nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"sure", @"Localizable", bundle, nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        NSString* str = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"authorizedcontact", @"Localizable", bundle, nil)];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"notice", @"Localizable", bundle, nil)
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"sure", @"Localizable", bundle, nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
