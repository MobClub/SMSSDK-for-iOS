//
//  VerifyViewController.m
//  SMS_SDKDemo
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "VerifyViewController.h"

#import "SMS_MBProgressHUD+Add.h"
#import <AddressBook/AddressBook.h>
#import "YJViewController.h"
#import "RegisterByVoiceCallViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKUserInfo.h>
#import <SMS_SDK/SMSSDKAddressBook.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>

@interface VerifyViewController ()
{
    NSString* _phone;
    NSString* _areaCode;
    int _state;
    NSMutableData* _data;
    NSString* _localVerifyCode;
    
    NSString* _appKey;
    NSString* _appSecret;
    NSString* _duid;
    NSString* _token;
    NSString* _localPhoneNumber;
    
    NSString* _localZoneNumber;
    NSMutableArray* _addressBookTemp;
    NSString* _contactkey;
    SMSSDKUserInfo* _localUser;
    
    NSTimer* _timer1;
    NSTimer* _timer2;
    NSTimer* _timer3;
    
    UIAlertView* _alert1;
    UIAlertView* _alert2;
    UIAlertView* _alert3;
    
    UIAlertView *_tryVoiceCallAlertView;

}

@end

static int count = 0;

//最近新好友信息
static NSMutableArray* _userData2;

@implementation VerifyViewController

-(void)clickLeftButton
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                  message:NSLocalizedString(@"codedelaymsg", nil)
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"back", nil)
                                        otherButtonTitles:NSLocalizedString(@"wait", nil), nil];
    _alert2 = alert;
    [alert show];    
}

-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode
{
    _phone = phone;
    _areaCode = areaCode;
}

-(void)submit
{
    //验证号码
    //验证成功后 获取通讯录 上传通讯录
    [self.view endEditing:YES];
    
    if(self.verifyCodeField.text.length != 4)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:NSLocalizedString(@"verifycodeformaterror", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [SMSSDK commitVerificationCode:self.verifyCodeField.text phoneNumber:_phone zone:_areaCode result:^(NSError *error) {
            
            if (!error) {
                
                NSLog(@"验证成功");
                NSString* str = [NSString stringWithFormat:NSLocalizedString(@"verifycoderightmsg", nil)];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycoderighttitle", nil)
                                                                message:str
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                _alert3 = alert;
                
            }
            else
            {
                NSLog(@"验证失败");
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycodeerrortitle", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
            
            }
        }];
    }
}


-(void)CannotGetSMS
{
    NSString* str = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"cannotgetsmsmsg", nil) ,_phone];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"surephonenumber", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
    _alert1 = alert;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alert1)
    {
        if (1 == buttonIndex)
        {
            NSLog(@"重发验证码");
            
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone zone:_areaCode customIdentifier:nil result:^(NSError *error) {
                
                if (!error)
                {
                    
                    NSLog(@"获取验证码成功");
                    
                }
                else
                {
                  
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                  message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                        otherButtonTitles:nil, nil];
                    [alert show];
                
                }
                
            }];

        }
        
    }
    
    if (alertView == _alert2) {
        if (0 == buttonIndex)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [_timer2 invalidate];
                [_timer1 invalidate];
            }];
        }
    }
    
    if (alertView == _alert3)
    {
        YJViewController* yj = [[YJViewController alloc] init];
        [self presentViewController:yj animated:YES completion:^{
            //解决等待时间乱跳的问题
            [_timer2 invalidate];
            [_timer1 invalidate];
        }];
    }
    
    if (alertView == _tryVoiceCallAlertView)
    {
        if (0 == buttonIndex)
        {
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice
                                    phoneNumber:_phone
                                           zone:_areaCode
                               customIdentifier:nil
                                         result:^(NSError *error)
             
            {
                if (error)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                    message:[NSString stringWithFormat:@"错误描述%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }

            }];
            
        }
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    
    //设置导航栏内容
    [navigationItem setTitle:NSLocalizedString(@"verifycode", nil)];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 53+statusBarHeight, self.view.frame.size.width - 30, 21);
    label.text = [NSString stringWithFormat:NSLocalizedString(@"verifylabel", nil)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:label];
    
    _telLabel = [[UILabel alloc] init];
    _telLabel.frame=CGRectMake(15, 82+statusBarHeight, self.view.frame.size.width - 30, 21);
    _telLabel.textAlignment = NSTextAlignmentCenter;
    _telLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:_telLabel];
    self.telLabel.text = [NSString stringWithFormat:@"+%@ %@",_areaCode,_phone];
    
    _verifyCodeField = [[UITextField alloc] init];
    _verifyCodeField.frame = CGRectMake(15, 111+statusBarHeight, self.view.frame.size.width - 30, 46);
    _verifyCodeField.borderStyle = UITextBorderStyleBezel;
    _verifyCodeField.textAlignment = NSTextAlignmentCenter;
    _verifyCodeField.placeholder = NSLocalizedString(@"verifycode", nil);
    _verifyCodeField.font = [UIFont fontWithName:@"Helvetica" size:18];
    _verifyCodeField.keyboardType = UIKeyboardTypePhonePad;
    _verifyCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_verifyCodeField];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(15, 169+statusBarHeight, self.view.frame.size.width - 30, 40);
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _timeLabel.text = NSLocalizedString(@"timelabel", nil);
    [self.view addSubview:_timeLabel];
    
    _repeatSMSBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _repeatSMSBtn.frame = CGRectMake(15, 169+statusBarHeight, self.view.frame.size.width - 30, 30);
    [_repeatSMSBtn setTitle:NSLocalizedString(@"repeatsms", nil) forState:UIControlStateNormal];
    [_repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_repeatSMSBtn];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    _submitBtn.frame = CGRectMake(15, 220 + statusBarHeight, self.view.frame.size.width - 30, 42);
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    _voiceCallMsgLabel = [[UILabel alloc] init];
    _voiceCallMsgLabel.frame = CGRectMake(15, 268+statusBarHeight, self.view.frame.size.width - 30, 25);
    _voiceCallMsgLabel.textAlignment = NSTextAlignmentCenter;
    _voiceCallMsgLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_voiceCallMsgLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    _voiceCallMsgLabel.text = NSLocalizedString(@"voiceCallMsgLabel", nil);
    [self.view addSubview:_voiceCallMsgLabel];
    _voiceCallMsgLabel.hidden = YES;
    
    _voiceCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_voiceCallButton setTitle:NSLocalizedString(@"try voice call", nil) forState:UIControlStateNormal];
    [_voiceCallButton setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    _voiceCallButton.frame = CGRectMake(15, 300+statusBarHeight, self.view.frame.size.width - 30, 42);
    [_voiceCallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_voiceCallButton addTarget:self action:@selector(tryVoiceCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_voiceCallButton];
    _voiceCallButton.hidden = YES;

    self.repeatSMSBtn.hidden = YES;
    
    [_timer2 invalidate];
    [_timer1 invalidate];
    
    count = 0;
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:60
                                           target:self
                                         selector:@selector(showRepeatButton)
                                         userInfo:nil
                                          repeats:YES];
    
    NSTimer* timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];
    _timer1 = timer;
    _timer2 = timer2;
    
    [SMS_MBProgressHUD showMessag:NSLocalizedString(@"sendingin", nil) toView:self.view];
    
}

-(void)tryVoiceCall
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verificationByVoiceCallConfirm", nil)
                                                  message:[NSString stringWithFormat:@"%@: +%@ %@",NSLocalizedString(@"willsendthecodeto", nil),_areaCode, _phone]
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                        otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
    _tryVoiceCallAlertView = alert;
    [alert show];
}


-(void)updateTime
{
    count++;
    if (count >= 60)
    {
        [_timer2 invalidate];
        return;
    }
    //NSLog(@"更新时间");
    self.timeLabel.text = [NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"timelablemsg", nil),60-count,NSLocalizedString(@"second", nil)];
    
    if (count == 30)
    {
        if (_voiceCallMsgLabel.hidden)
        {
            _voiceCallMsgLabel.hidden = NO;
        }
        
        if (_voiceCallButton.hidden)
        {
            _voiceCallButton.hidden = NO;
        }
    }
}

-(void)showRepeatButton{
    self.timeLabel.hidden = YES;
    self.repeatSMSBtn.hidden = NO;
    
    [_timer1 invalidate];
    return;
}

@end
