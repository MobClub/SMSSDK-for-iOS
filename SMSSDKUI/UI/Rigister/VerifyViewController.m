//
//  VerifyViewController.m
//  SMS_SDKDemo
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "VerifyViewController.h"
#import <AddressBook/AddressBook.h>
#import "YJLocalCountryData.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDKUserInfo.h>
#import <SMS_SDK/Extend/SMSSDKAddressBook.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>

@interface VerifyViewController ()
{
    NSString* _phone;
    NSString* _areaCode;
    UIAlertView* _alert1;
    UIAlertView* _alert2;
    UIAlertView* _alert3;
    UIAlertView *_tryVoiceCallAlertView;

}

@property (nonatomic, strong) NSTimer* timer2;

@property (nonatomic, strong) NSTimer* timer1;

@end

static int count = 0;

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
                NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycodeerrortitle", nil)
                                                                message:NSLocalizedString(messageStr, nil)
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
    __weak VerifyViewController *verifyViewController = self;
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
                  
                    NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                  message:NSLocalizedString(messageStr, nil)
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
            
            [verifyViewController dismissViewControllerAnimated:YES completion:^{
                [verifyViewController.timer2 invalidate];
                [verifyViewController.timer1 invalidate];
            }];
        }
    }
    
    if (alertView == _alert3)
    {
        
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            //解决等待时间乱跳的问题
            verifyViewController.window.hidden = YES;
            verifyViewController.window = nil;
            [verifyViewController.timer2 invalidate];
            [verifyViewController.timer1 invalidate];
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
                    NSString *messageStr = [NSString stringWithFormat:@"%zidescription",error.code];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                    message:NSLocalizedString(messageStr, nil)
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
    
    UILabel* telLabel = [[UILabel alloc] init];
    telLabel.frame=CGRectMake(15, 82+statusBarHeight, self.view.frame.size.width - 30, 21);
    telLabel.textAlignment = NSTextAlignmentCenter;
    telLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:telLabel];
    telLabel.text = [NSString stringWithFormat:@"+%@ %@",_areaCode,_phone];
    
    UILabel *seperaterLineUp = [[UILabel alloc] initWithFrame:CGRectMake(10, 110 + statusBarHeight, self.view.frame.size.width - 20, 1)];
    seperaterLineUp.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperaterLineUp];
    
    UILabel *verifyCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 111 + statusBarHeight, 80, 46)];
    verifyCodeLabel.text = NSLocalizedString(@"Code", nil);
    [self.view addSubview:verifyCodeLabel];
    
    UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(verifyCodeLabel.frame.origin.x - 10 + verifyCodeLabel.frame.size.width + 1, verifyCodeLabel.frame.origin.y, 1, verifyCodeLabel.frame.size.height)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:verticalLine];
    
    _verifyCodeField = [[UITextField alloc] init];
    _verifyCodeField.frame = CGRectMake(verticalLine.frame.origin.x, 111 + statusBarHeight, self.view.frame.size.width - verifyCodeLabel.frame.size.width - 20, 46);
    _verifyCodeField.textAlignment = NSTextAlignmentCenter;
    _verifyCodeField.placeholder = NSLocalizedString(@"verifycode", nil);
    _verifyCodeField.font = [UIFont fontWithName:@"Helvetica" size:18];
    _verifyCodeField.keyboardType = UIKeyboardTypePhonePad;
    _verifyCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_verifyCodeField];
    
    UILabel *seperaterLineDown = [[UILabel alloc] initWithFrame:CGRectMake(seperaterLineUp.frame.origin.x, _verifyCodeField.frame.origin.y + _verifyCodeField.frame.size.height + 1, seperaterLineUp.frame.size.width, 1)];
    seperaterLineDown.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperaterLineDown];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(15, 169 + statusBarHeight, self.view.frame.size.width - 30, 40);
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _timeLabel.text = NSLocalizedString(@"timelabel", nil);
    [self.view addSubview:_timeLabel];
    
    _repeatSMSBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _repeatSMSBtn.frame = CGRectMake(15, 169 + statusBarHeight, self.view.frame.size.width - 30, 30);
    [_repeatSMSBtn setTitle:NSLocalizedString(@"repeatsms", nil) forState:UIControlStateNormal];
    [_repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_repeatSMSBtn];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitBtn setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"SMSSDKUI.bundle/button4.png"];
    [submitBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(15, 220 + statusBarHeight, self.view.frame.size.width - 30, 42);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    _voiceCallMsgLabel = [[UILabel alloc] init];
    _voiceCallMsgLabel.frame = CGRectMake(15, 268 + statusBarHeight, self.view.frame.size.width - 30, 25);
    _voiceCallMsgLabel.textAlignment = NSTextAlignmentCenter;
    _voiceCallMsgLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_voiceCallMsgLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    _voiceCallMsgLabel.text = NSLocalizedString(@"voiceCallMsgLabel", nil);
    [self.view addSubview:_voiceCallMsgLabel];
    _voiceCallMsgLabel.hidden = YES;
    
    _voiceCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_voiceCallButton setTitle:NSLocalizedString(@"try voice call", nil) forState:UIControlStateNormal];
    [_voiceCallButton setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    _voiceCallButton.frame = CGRectMake(15, 300 + statusBarHeight, self.view.frame.size.width - 30, 42);
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
    
    self.timeLabel.textColor = [UIColor lightGrayColor];
    NSTimer* timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];
    _timer1 = timer;
    _timer2 = timer2;
    
    [YJLocalCountryData showMessag:NSLocalizedString(@"sendingin", nil) toView:self.view];
    
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
    
    count ++;
    if (count >= 60)
    {
        [_timer2 invalidate];
        return;
    }
    //NSLog(@"更新时间");
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"timelablemsg", nil),60 - count, NSLocalizedString(@"second", nil)];
    
    if (count == 30)
    {
        if (self.getCodeMethod == SMSGetCodeMethodSMS) {
            
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
}

-(void)showRepeatButton{
    self.timeLabel.hidden = YES;
    self.repeatSMSBtn.hidden = NO;
    
    [_timer1 invalidate];
    return;
}

@end
