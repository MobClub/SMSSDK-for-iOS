//
//  SMSSDKUICommitCodeViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/2.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUICommitCodeViewController.h"
#import "SMSSDKUIProcessHUD.h"

@interface SMSSDKUICommitCodeViewController ()
{
    NSTimer *_timer;
    NSInteger _i;
}

@property (nonatomic, assign) SMSGetCodeMethod methodType;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *zone;

@property (nonatomic, strong) UILabel *phoneNumber;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UILabel *timeAlert;
@property (nonatomic, strong) UIButton *resentCode;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UIView *retryView;
@property (nonatomic, strong) UILabel *retryLabel;
@property (nonatomic, strong) UIButton *retryBtn;

@property (nonatomic, strong) UILabel *otherChoiceLabel;
@property (nonatomic, strong) UIButton *otherChoiceButton;

@end

@implementation SMSSDKUICommitCodeViewController

- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method
{
    if (self = [super init])
    {
        _phone = phone;
        _zone  = zone;
        _methodType = method;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = SMSLocalized(@"verifycode");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 53+StatusBarHeight, self.view.frame.size.width - 30, 21);
        label.text = SMSLocalized(@"verifylabel");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:17];
        [self.view addSubview:label];
    }
    
    self.phoneNumber =
    ({
        UILabel *phoneNumber = [[UILabel alloc] init];
        phoneNumber.frame=CGRectMake(15, 82+StatusBarHeight, self.view.frame.size.width - 30, 21);
        phoneNumber.textAlignment = NSTextAlignmentCenter;
        phoneNumber.font = [UIFont fontWithName:@"Helvetica" size:17];
        [self.view addSubview:phoneNumber];
        phoneNumber.text = [NSString stringWithFormat:@"%@ %@",_zone,_phone];
        phoneNumber;
    });

    self.codeView =
    ({
        UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(10, 110 + StatusBarHeight, self.view.frame.size.width - 20, 48)];
        
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, codeView.frame.size.width, 1)];
        lineTop.backgroundColor = [UIColor lightGrayColor];
        [codeView addSubview:lineTop];
        
        UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 46)];
        verifyLabel.textAlignment = NSTextAlignmentCenter;
        verifyLabel.text = SMSLocalized(@"Code");
        [codeView addSubview:verifyLabel];
        
        UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame)+1, 1, 1, 46)];
        lineVertical.backgroundColor = [UIColor lightGrayColor];
        [codeView addSubview:lineVertical];
        
        self.codeTextField =
        ({
            UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(lineVertical.frame.origin.x + 1, lineVertical.frame.origin.y, codeView.frame.size.width - verifyLabel.frame.size.width-1, 46)];
            codeTextField.textAlignment = NSTextAlignmentCenter;
            codeTextField.placeholder = SMSLocalized(@"verifycode");
            codeTextField.font = [UIFont fontWithName:@"Helvetica" size:18];
            codeTextField.keyboardType = UIKeyboardTypePhonePad;
            codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [codeView addSubview:codeTextField];
            codeTextField;
        });
        
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, codeView.frame.size.height-1, codeView.frame.size.width,1)];
        lineBottom.backgroundColor = [UIColor lightGrayColor];
        [codeView addSubview:lineBottom];

        [self.view addSubview:codeView];
        codeView;
    });
    
    self.resentCode =
    ({
        UIButton *resentCode = [UIButton buttonWithType:UIButtonTypeSystem];
        resentCode.frame = CGRectMake(15, 169 + StatusBarHeight, self.view.frame.size.width - 30, 40);
        resentCode.titleLabel.textAlignment = NSTextAlignmentCenter;
        resentCode.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [resentCode setTitle:SMSLocalized(@"repeatsms") forState:UIControlStateNormal];
        [resentCode addTarget:self action:@selector(retrySend:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:resentCode];
        resentCode.hidden = YES;
        resentCode ;
    });
    
    self.timeAlert =
    ({
        UILabel *timeAlert = [[UILabel alloc] init];
        timeAlert.frame = CGRectMake(15, 169 + StatusBarHeight, self.view.frame.size.width - 30, 40);
        timeAlert.numberOfLines = 0;
        timeAlert.textColor = [UIColor lightGrayColor];
        timeAlert.textAlignment = NSTextAlignmentCenter;
        timeAlert.font = [UIFont fontWithName:@"Helvetica" size:15];
        
        timeAlert.text = [@[SMSLocalized(@"timelablemsg"),@"60",SMSLocalized(@"second")] componentsJoinedByString:@""];
        
        [self.view addSubview:timeAlert];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
        _i = 60;
        [self startCount];
        timeAlert;
    });

    self.commitBtn =
    ({
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [commitBtn setTitle:SMSLocalized(@"submit") forState:UIControlStateNormal];
        NSString *imageString = [SMSSDKUIBundle pathForResource:@"button4" ofType:@"png"];
        
        [commitBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:imageString] forState:UIControlStateNormal];
        commitBtn.frame = CGRectMake(15, 220 + StatusBarHeight, self.view.frame.size.width - 30, 42);
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:commitBtn];
        commitBtn;
    });
    
    self.otherChoiceLabel =
    ({
        UILabel *otherChoiceLabel = [[UILabel alloc] init];
        otherChoiceLabel.frame = CGRectMake(15, 268 + StatusBarHeight, self.view.frame.size.width - 30, 25);
        otherChoiceLabel.textAlignment = NSTextAlignmentCenter;
        otherChoiceLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [otherChoiceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        otherChoiceLabel.text = SMSLocalized(@"voiceCallMsgLabel");
        [self.view addSubview:otherChoiceLabel];
        otherChoiceLabel.hidden = YES;
        otherChoiceLabel ;
    });
    
    self.otherChoiceButton =
    ({
        UIButton *otherChoiceButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [otherChoiceButton setTitle:SMSLocalized(@"try voice call") forState:UIControlStateNormal];
        
        NSString *imageString = [SMSSDKUIBundle pathForResource:@"button4" ofType:@"png"];
        [otherChoiceButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:imageString] forState:UIControlStateNormal];
        otherChoiceButton.frame = CGRectMake(15, 300 + StatusBarHeight, self.view.frame.size.width - 30, 42);
        [otherChoiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [otherChoiceButton addTarget:self action:@selector(tryOtherChoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherChoiceButton];
        otherChoiceButton.hidden = YES;
    
        otherChoiceButton;
    });
}

- (void)back:(id)sender
{
    NSString *title = SMSLocalized(@"notice");
    NSString *message = SMSLocalized(@"codedelaymsg");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *back = SMSLocalized(@"back");
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:back style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    NSString *wait = SMSLocalized(@"wait");
    UIAlertAction *waitAction = [UIAlertAction actionWithTitle:wait style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:backAction];
    [alert addAction:waitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)submit:(id)sender
{
    [SMSSDKUIProcessHUD showProcessHUDWithInfo:SMSLocalized(@"commitingCode")];
    
    [SMSSDK commitVerificationCode:_codeTextField.text phoneNumber:_phone zone:_zone result:^(NSError *error) {
        
        NSString *msg = SMSLocalized(@"verifycodeerrortitle");
        if (error)
        {
            [SMSSDKUIProcessHUD dismiss];
            SMSSDKAlert(@"%@:%@",msg,error);
        }
        else
        {
            SMSUILog(@"commit code success !");
            [SMSSDKUIProcessHUD showSuccessInfo:SMSLocalized(@"commitSuccess")];
            [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                [_timer invalidate];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

- (void)tryOtherChoice:(id)sender
{
    NSString *title = SMSLocalized(@"verificationByVoiceCallConfirm");
    NSString *message = [NSString stringWithFormat:@"%@: %@ %@",SMSLocalized(@"willsendthecodeto"),_zone,_phone];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *back = SMSLocalized(@"cancel");
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:back style:UIAlertActionStyleCancel handler:nil];
    NSString *send = SMSLocalized(@"sure");
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:send style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendVoiceCode:nil];
    }];
    
    [alert addAction:backAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)retrySend:(id)sender
{
    NSString *title = SMSLocalized(@"surephonenumber");
    NSString *message = [SMSLocalized(@"cannotgetsmsmsg") stringByAppendingFormat:@":%@",_phone];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *back = SMSLocalized(@"cancel");
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:back style:UIAlertActionStyleCancel handler:nil];
    NSString *send = SMSLocalized(@"sure");
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:send style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendTextCode:nil];
    }];
    
    [alert addAction:backAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendVoiceCode:(id)sender
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:_phone zone:_zone result:^(NSError *error) {
        if (error)
        {
            NSString *msg = SMSLocalized(@"codesenderrtitle");
            SMSSDKAlert(@"%@:%@",msg,error);
        }
        else
        {
            SMSUILog(@"send voice SMSCode success !");
        }
    }];
}

- (void)sendTextCode:(id)sender
{
    [SMSSDKUIProcessHUD showProcessHUDWithInfo:SMSLocalized(@"sendingRequest")];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone zone:_zone result:^(NSError *error) {
        if (error)
        {
            [SMSSDKUIProcessHUD dismiss];
            NSString *msg = SMSLocalized(@"codesenderrtitle");
            SMSSDKAlert(@"%@:%@",msg,error);
        }
        else
        {
            SMSUILog(@"send text SMSCode success !");
            [SMSSDKUIProcessHUD showSuccessInfo:SMSLocalized(@"requestSuccess")];
            [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:nil];
        }
    }];
}

#define MsgPre SMSLocalized(@"timelablemsg")
#define MsgLast SMSLocalized(@"second")

- (void)startCount
{
    NSString *text = [@[MsgPre,[NSString stringWithFormat:@"%zd",_i],MsgLast] componentsJoinedByString:@""];
    
    _timeAlert.text = text;
    
    if (_i==30 && _methodType==SMSGetCodeMethodSMS)
    {
        _otherChoiceLabel.hidden = NO;
        _otherChoiceButton.hidden = NO;
    }
    
    if (!_i--)
    {
        _timeAlert.enabled = YES;
        _resentCode.hidden = NO;
        _timeAlert.hidden = YES;
        [_timer invalidate];
    }
}

@end
