//
//  SMSSDKUIGetCodeViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIGetCodeViewController.h"
#import "SMSSDKUIHelper.h"
#import "SMSSDKUIZonesViewController.h"
#import "SMSSDKUICommitCodeViewController.h"
#import "SMSSDKUIProcessHUD.h"
#import "SMSSDKUIBindUserInfoViewController.h"
#import "SMSSDKAvatarSelectViewController.h"
#import "SMSSDKUICommitCodeViewController_Private.h"

@interface SMSSDKUIGetCodeViewController()<UIAlertViewDelegate>

@property (nonatomic, assign) SMSGetCodeMethod methodType;


@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *topAlertLabel;
@property (nonatomic, strong) UIView *zoneSelectBar;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UIView *phoneEditView;

@property (nonatomic, strong) UILabel *zone;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *nextStep;
@property (nonatomic, strong) UILabel *unitedStateLabel;

@property (nonatomic, assign) SMSCheckCodeBusiness codeBusiness;
@property (nonatomic, strong) NSString *tempCode;

@end

@implementation SMSSDKUIGetCodeViewController

- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType
{
    if (self = [super init])
    {
        _methodType = methodType;
    }
    return self;
}

- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType codeBusiness:(SMSCheckCodeBusiness)codeBusiness template:(NSString *)tempCode
{
    if (self = [super init])
    {
        _methodType = methodType;
        _codeBusiness = codeBusiness;
        _tempCode = tempCode;
    }
    return self;
}

- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType template:(NSString *)tempCode
{
    if (self = [super init])
    {
        _methodType = methodType;
        _tempCode = tempCode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
//    self.title = SMSLocalized(@"register");
    
    
    [self configUI];
}

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgView];
    
    
    float offset = 20;
    
    self.topAlertLabel =
    ({
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(offset, 56 + StatusBarHeight, self.view.frame.size.width - 2*offset, 50);
        label.text = [NSString stringWithFormat:SMSLocalized(@"labelnotice")];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:26];
        label.textColor = SMSRGB(0x2A2B30);
        [self.bgView addSubview:label];
        label;
    });

    
    
    self.zoneSelectBar =
    ({
        /*
        UITableViewCell *zoneSelectBar = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        zoneSelectBar.backgroundColor = [UIColor redColor];
        zoneSelectBar.textLabel.backgroundColor = [UIColor blueColor];

        zoneSelectBar.frame = CGRectMake(offset, 106 + StatusBarHeight, self.view.frame.size.width - 2*offset, 45);
        
        zoneSelectBar.textLabel.text = SMSLocalized(@"countrylable");
        zoneSelectBar.textLabel.textColor = [UIColor darkGrayColor];
        zoneSelectBar.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         */
        UIView *zoneSelectBar = [[UIView alloc] initWithFrame:CGRectMake(offset, 106 + StatusBarHeight, self.view.frame.size.width - 2*offset, 45)];
        
        self.countryLabel =
        ({
            UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, (self.view.frame.size.width - 30)/4, 40 + StatusBarHeight/4)];
            countryLabel.text = SMSLocalized(@"countrylable");
            countryLabel.textAlignment = NSTextAlignmentLeft;
            countryLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            [zoneSelectBar addSubview:countryLabel];
            countryLabel;
        });
        
        //United States
        self.unitedStateLabel =
        ({
            
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake((self.view.frame.size.width - 30)/4 + 1 + offset, 0, self.view.frame.size.width - (self.view.frame.size.width - 2*offset)/2, zoneSelectBar.frame.size.height);
            label.text =  [SMSSDKUIHelper currentCountryName];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont fontWithName:@"Helvetica" size:14];
            label.textColor = [UIColor blackColor];
            [zoneSelectBar addSubview:label];
            label;
        });
        
        UIButton *directionBtn = [[UIButton alloc] init];
        directionBtn.frame = CGRectMake(self.view.frame.size.width - 75, 0, 45, 45);
        NSString *path = [SMSSDKUIBundle pathForResource:@"right_direction" ofType:@"png"];
        [directionBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        
        [zoneSelectBar addSubview:directionBtn];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectZone:)];
        
        [zoneSelectBar addGestureRecognizer:tap];
        
        [self.bgView addSubview:zoneSelectBar];
        
        zoneSelectBar ;
    });
    
    self.phoneEditView =
    ({
        UIView *phoneEditView = [[UIView alloc] initWithFrame:CGRectMake(offset, 154 + StatusBarHeight, self.view.frame.size.width - 2*offset, 42 + StatusBarHeight/4)];

        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneEditView.frame.size.width, 1)];
        lineTop.backgroundColor = SMSRGB(0xE0E0E6);
        [phoneEditView addSubview:lineTop];
        
        self.zone =
        ({
            UILabel *zone = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, (self.view.frame.size.width - 30)/4, 40 + StatusBarHeight/4)];
            //zone.text = @"+86";
            zone.text = [SMSSDKUIHelper currentZone];
            zone.textAlignment = NSTextAlignmentLeft;
            zone.font = [UIFont fontWithName:@"Helvetica" size:14];
            [phoneEditView addSubview:zone];
            zone;
        });

        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zone.frame)+1, 1, 1, _zone.frame.size.height)];
        verticalLine.backgroundColor = SMSRGB(0xE0E0E6);
        verticalLine.hidden = YES;
        [phoneEditView addSubview:verticalLine];
        
        self.phoneTextField =
        ({
            UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame)+offset, 1, (self.view.frame.size.width - 2*offset)*3/4 - 20, verticalLine.frame.size.height)];
            phoneTextField.placeholder = SMSLocalized(@"telfield");
            phoneTextField.keyboardType = UIKeyboardTypePhonePad;
            phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            phoneTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
            [phoneEditView addSubview:phoneTextField];
            
            phoneTextField;
        });

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, phoneEditView.frame.size.height-1, phoneEditView.frame.size.width, 1)];
        bottomLine.backgroundColor = SMSRGB(0xE0E0E6);
        [phoneEditView addSubview:bottomLine];
        
        [self.bgView addSubview:phoneEditView];
        phoneEditView ;
    });
    
    self.nextStep =
    ({
        UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeSystem];
        [nextStep setTitle:SMSLocalized(@"nextbtn") forState:UIControlStateNormal];
        [nextStep setBackgroundColor:SMSRGB(0x00D69C)];
        nextStep.layer.cornerRadius = 4;
        nextStep.frame = CGRectMake(offset, CGRectGetMaxY(self.phoneEditView.frame) + 29, self.view.frame.size.width - 2*offset, 42);
        [nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextStep addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:nextStep];
        nextStep;
    });
    
}


- (void)dismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextStep:(id)sender
{

    
    [self.phoneTextField resignFirstResponder];
    
    NSString *zone = _zone.text;
    NSString *phone = _phoneTextField.text;
    
    NSString *alertText = [SMSLocalized(@"willsendthecodeto") stringByAppendingFormat:@":%@ %@",zone,phone];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:SMSLocalized(@"surephonenumber") message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:SMSLocalized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:SMSLocalized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    NSString *template = self.tempCode;
#ifdef MOB_SMSSDK_Test
        if(template && template.length == 0)
        {
            //template = @"14100540";
            template = nil;
        }
#else
        if(template && template.length == 0)
        {
            //template = @"1319972";
            template = nil;
        }

#endif

        [SMSSDK getVerificationCodeByMethod:_methodType phoneNumber:phone zone:zone template:template result:^(NSError *error) {
            if (error)
            {
                if(error.code == NSURLErrorNotConnectedToInternet)
                {
                    [SMSSDKUIProcessHUD showMsgHUDWithInfo:SMSLocalized(@"nonetwork")];
                    [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                        
                    }];
                }
                else if(error.code == 300255)
                {
                    SMSSDKTitleAlert(SMSLocalized(@"errorphonenumber"),@"%@",SMSLocalized(@"errorphonenumberenter"));
                }
                else if(error.code == 300462)
                {
                    SMSSDKAlert(@"%@",SMSLocalized(@"codetoooftenmsg"));
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
                [SMSSDKUIProcessHUD showSuccessInfo:SMSLocalized(@"requestSuccess")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{

                    SMSSDKUICommitCodeViewController *vc = [[SMSSDKUICommitCodeViewController alloc] initWithPhoneNumber:phone zone:zone methodType:_methodType codeBusiness:self.codeBusiness];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }];
    
        
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectZone:(id)sender
{
    __weak typeof(self) weakSelf = self;
    SMSSDKUIZonesViewController *vc = [[SMSSDKUIZonesViewController alloc] initWithResult:^(BOOL cancel, NSString *zone, NSString *countryName) {
        
        if (!cancel && zone && countryName)
        {
            weakSelf.unitedStateLabel.text = countryName;
            weakSelf.zone.text = zone;
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


@end
