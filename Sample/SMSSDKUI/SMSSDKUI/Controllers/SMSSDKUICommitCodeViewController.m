//
//  SMSSDKUICommitCodeViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/2.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUICommitCodeViewController.h"
#import "SMSSDKUIProcessHUD.h"
#import "SMSGlobalManager.h"
#import "SMSSDKUIBindUserInfoViewController.h"
#import "SMSSDKUIHelper.h"

@interface SMSSDKUICommitCodeViewController () <UITextViewDelegate>
{
    NSTimer *_timer;
    NSInteger _i;
    BOOL _hasResend;
}

@property (nonatomic, assign) SMSGetCodeMethod methodType;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *zone;

@property (nonatomic, strong) UILabel *phoneNumber;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIView *phoneNumberView;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UILabel *timeAlert;
@property (nonatomic, strong) UIButton *resentCode;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UIView *retryView;
@property (nonatomic, strong) UILabel *retryLabel;
@property (nonatomic, strong) UIButton *retryBtn;

@property (nonatomic, strong) UITextView *otherChoiceLabel;
@property (nonatomic, strong) UIButton *otherChoiceButton;

@property (nonatomic, assign) SMSCheckCodeBusiness codeBusiness;
//@property (nonatomic, strong) NSString *tempCode;

@end

@implementation SMSSDKUICommitCodeViewController

- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method
{
    if (self = [super init])
    {
        _phone = phone;
        _zone  = zone;
        _methodType = method;
        _codeBusiness = SMSCheckCodeBusinessGetCode;
    }
    return self;
}


- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method codeBusiness:(SMSCheckCodeBusiness)codeBusiness
{
    if (self = [super init])
    {
        _phone = phone;
        _zone  = zone;
        _methodType = method;
        _codeBusiness = codeBusiness;
    }
    return self;
}

//- (instancetype)initWithPhoneNumber:(NSString *)phone zone:(NSString *)zone methodType:(SMSGetCodeMethod)method tempCode:(NSString *)tempCode
//{
//    if (self = [super init])
//    {
//        _phone = phone;
//        _zone  = zone;
//        _methodType = method;
//        _tempCode = tempCode;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = SMSLocalized(@"verifycode");
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 53+StatusBarHeight, self.view.frame.size.width - 30, 26);
        label.text = SMSLocalized(@"verifylabel");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:19];
        [self.view addSubview:label];
    }
    
    /*
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
     */
    
    
    self.phoneNumberView =
    ({
        UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(20, 110 + StatusBarHeight, self.view.frame.size.width - 40, 48)];
        
        /*
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, codeView.frame.size.width, 1)];
        lineTop.backgroundColor = [UIColor lightGrayColor];
        [codeView addSubview:lineTop];
         */
        
        UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 80, 46)];
        verifyLabel.textAlignment = NSTextAlignmentLeft;
        verifyLabel.text = SMSLocalized(@"phonecode");
        verifyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [codeView addSubview:verifyLabel];
        
        UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame)+1, 1, 1, 46)];
        lineVertical.backgroundColor = [UIColor lightGrayColor];
        lineVertical.hidden = YES;
        [codeView addSubview:lineVertical];
        
        self.codeTextField =
        ({
            UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(lineVertical.frame.origin.x + 10, lineVertical.frame.origin.y, codeView.frame.size.width - verifyLabel.frame.size.width-1, 46)];
            codeTextField.textAlignment = NSTextAlignmentLeft;
            codeTextField.placeholder = SMSLocalized(@"verifycode");
            codeTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
            codeTextField.keyboardType = UIKeyboardTypePhonePad;
            codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            codeTextField.userInteractionEnabled = NO;
            codeTextField.text =  [NSString stringWithFormat:@"%@ %@",_zone, _phone];
            [codeView addSubview:codeTextField];
            codeTextField;

        });
        
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, codeView.frame.size.height-1, codeView.frame.size.width,1)];
        lineBottom.backgroundColor = SMSRGB(0xE0E0E6);
        [codeView addSubview:lineBottom];
        
        [self.view addSubview:codeView];
        codeView;
    });

    self.codeView =
    ({
        UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(10, 158 + StatusBarHeight, self.view.frame.size.width - 20, 48)];
        
        UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 46)];
        verifyLabel.textAlignment = NSTextAlignmentLeft;
        verifyLabel.text = SMSLocalized(@"Code");
        verifyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [codeView addSubview:verifyLabel];
        
        UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame)+1, 0, 1, 46)];
        lineVertical.backgroundColor = [UIColor lightGrayColor];
        lineVertical.hidden = YES;
        [codeView addSubview:lineVertical];
        
        self.codeTextField =
        ({
            UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(lineVertical.frame.origin.x + 10, lineVertical.frame.origin.y, codeView.frame.size.width - verifyLabel.frame.size.width-1 - 20 - 100, 46)];
            codeTextField.textAlignment = NSTextAlignmentLeft;
            codeTextField.placeholder = SMSLocalized(@"verifycode");
            codeTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
            codeTextField.keyboardType = UIKeyboardTypePhonePad;
//            codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [codeView addSubview:codeTextField];
            codeTextField;
        });
        
        
        self.timeAlert =
        ({
            UILabel *timeAlert = [[UILabel alloc] init];
            timeAlert.frame = CGRectMake(self.view.frame.size.width - 20 - 100, lineVertical.frame.origin.y, 100, 40);
            timeAlert.numberOfLines = 0;
            timeAlert.textColor = [UIColor lightGrayColor];
            timeAlert.textAlignment = NSTextAlignmentRight;
            timeAlert.font = [UIFont fontWithName:@"Helvetica" size:14];
            
            timeAlert.text = [@[SMSLocalized(@"resendmsg"),@"(60)"] componentsJoinedByString:@""];
            
            [codeView addSubview:timeAlert];
            timeAlert.userInteractionEnabled = NO;
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
            _i = 60;
            [self startCount];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retrySend:)];
            
            [timeAlert addGestureRecognizer:tap];
            
            timeAlert;
        });
        
        
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, codeView.frame.size.height-1, codeView.frame.size.width,1)];
        lineBottom.backgroundColor = SMSRGB(0xE0E0E6);
        [codeView addSubview:lineBottom];

        [self.view addSubview:codeView];

        codeView;
    });
    
    /*
    self.resentCode =
    ({
        UIButton *resentCode = [UIButton buttonWithType:UIButtonTypeSystem];
        resentCode.frame = CGRectMake(15, 169 + StatusBarHeight, self.view.frame.size.width - 30, 40);
        resentCode.titleLabel.textAlignment = NSTextAlignmentCenter;
        resentCode.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [resentCode setTitle:SMSLocalized(@"repeatsms") forState:UIControlStateNormal];
        [resentCode addTarget:self action:@selector(retrySend:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:resentCode];
        //resentCode.hidden = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
        _i = 60;
        [self startCount];
        
        resentCode ;
    });
     */
    
    

    

    self.commitBtn =
    ({
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [commitBtn setTitle:SMSLocalized(@"submit") forState:UIControlStateNormal];
        //NSString *imageString = [SMSSDKUIBundle pathForResource:@"button4" ofType:@"png"];
        
        //[commitBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:imageString] forState:UIControlStateNormal];
        commitBtn.frame = CGRectMake(15, 235 + StatusBarHeight, self.view.frame.size.width - 30, 45);
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [commitBtn setBackgroundColor:SMSRGB(0x00D69C)];
        commitBtn.layer.cornerRadius = 4;
        
        [self.view addSubview:commitBtn];
        commitBtn;
    });
    
    
    self.otherChoiceLabel =
    ({
        /*
        UILabel *otherChoiceLabel = [[UILabel alloc] init];
        otherChoiceLabel.frame = CGRectMake(15, 268 + StatusBarHeight, self.view.frame.size.width - 30, 25);
        otherChoiceLabel.textAlignment = NSTextAlignmentCenter;
        otherChoiceLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [otherChoiceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        otherChoiceLabel.text = SMSLocalized(@"voiceCallMsgLabel");
        [self.view addSubview:otherChoiceLabel];
        otherChoiceLabel.hidden = YES;
        otherChoiceLabel ;
         */
        
        UITextView *otherChoiceLabel = [[UITextView alloc] init];
        otherChoiceLabel.frame = CGRectMake(15, CGRectGetMaxY(self.commitBtn.frame) + 20, self.view.frame.size.width - 30, 46);
        otherChoiceLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        otherChoiceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:otherChoiceLabel];
        otherChoiceLabel.hidden = YES;
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",SMSLocalized(@"repeatsms"),SMSLocalized(@"voiceCallMsgLabel")]];
        [attributedString addAttribute:NSLinkAttributeName value:@"voicecall://" range:[[attributedString string] rangeOfString:SMSLocalized(@"voiceCall")]];
        
        [attributedString addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"Helvetica" size:15]
                              range:NSMakeRange(0 , attributedString.length)];
        
        NSMutableParagraphStyle *ornamentParagraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        ornamentParagraph.alignment = NSTextAlignmentCenter;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:ornamentParagraph range:NSMakeRange(0 , attributedString.length)];
      
        otherChoiceLabel.attributedText = attributedString;
        otherChoiceLabel.linkTextAttributes = @{NSForegroundColorAttributeName: SMSCommonColor(), NSUnderlineColorAttributeName: [UIColor lightGrayColor], NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
        otherChoiceLabel.delegate = self;
        otherChoiceLabel.editable = NO; //必须禁止输入，否则点击将弹出输入键盘 _textview.scrollEnabled = NO;
        
        
         otherChoiceLabel;
    });
    
    /*
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
     */
    
    _otherChoiceLabel.hidden = NO;
    _otherChoiceButton.hidden = NO;
}

- (void)dismisss:(id)sender
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
    
    [self.codeTextField resignFirstResponder];

    [SMSSDKUIProcessHUD showProcessHUDWithInfo:SMSLocalized(@"commitingCode")];
    
    [SMSSDK commitVerificationCode:_codeTextField.text phoneNumber:_phone zone:_zone result:^(NSError *error) {
        
        NSString *msg = SMSLocalized(@"verifycodeerrortitle");
        if (error)
        {
            
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSSDKUIProcessHUD showMsgHUDWithInfo:SMSLocalized(@"nonetwork")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            else
            {
                [SMSSDKUIProcessHUD dismiss];
                //SMSSDKAlert(@"%@:%@",msg,[SMSSDKUIHelper errorTextWithError:error]);
                SMSSDKAlert(@"%@",[SMSSDKUIHelper errorTextWithError:error]);

            }

        }
        else
        {
            __weak typeof(self) weakSelf = self;
            
            [[SMSGlobalManager sharedManager] saveUserInfo:self.phone zone:self.zone];
            
            SMSUILog(@"commit code success !");
            [SMSSDKUIProcessHUD dismiss];
            
            _i = 0;
            [self startCount];
            self.otherChoiceLabel.hidden = YES;
            [_timer invalidate];
            [self showCheckSucess];
        }
    }];
}

- (void)showCheckSucess
{
    __weak typeof(self) weakSelf = self;

    NSString *message = SMSLocalized(@"phoneverifyrightmsg");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *send = SMSLocalized(@"sure");
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:send style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(self.codeBusiness == SMSCheckCodeBusinessBindInfo)
        {
            SMSSDKUIBindUserInfoViewController *vc = [SMSSDKUIBindUserInfoViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
    _hasResend = YES;
}

- (void)sendVoiceCode:(id)sender
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:_phone zone:_zone result:^(NSError *error) {
        if (error)
        {
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSSDKUIProcessHUD showMsgHUDWithInfo:SMSLocalized(@"nonetwork")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            else
            {
                //NSString *msg = SMSLocalized(@"codesenderrtitle");
                //SMSSDKAlert(@"%@:%@",msg,[SMSSDKUIHelper errorTextWithError:error]);
                SMSSDKAlert(@"%@",[SMSSDKUIHelper errorTextWithError:error]);

            }

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
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSSDKUIProcessHUD showMsgHUDWithInfo:SMSLocalized(@"nonetwork")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            else
            {
                [SMSSDKUIProcessHUD dismiss];
                //NSString *msg = SMSLocalized(@"codesenderrtitle");
                //SMSSDKAlert(@"%@:%@",msg,[SMSSDKUIHelper errorTextWithError:error]);
                SMSSDKAlert(@"%@",[SMSSDKUIHelper errorTextWithError:error]);
            }

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
    NSString *text = [NSString stringWithFormat:@"%@(%zd)",SMSLocalized(@"resendmsg"),_i] ;
    
    //[@[MsgPre,[NSString stringWithFormat:@"%zd",_i],MsgLast] componentsJoinedByString:@""];
    
    _timeAlert.text = text;
    
    if (!_i--)
    {
        
        _timeAlert.text = SMSLocalized(@"resendmsg");
        _timeAlert.textColor = SMSCommonColor();
        [_timer invalidate];
        
        _timeAlert.userInteractionEnabled = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"voicecall"]) {
        
        [self tryOtherChoice:nil];
        
        return NO;
    }
    return YES;
}

@end
