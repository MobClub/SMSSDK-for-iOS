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

@interface SMSSDKUIGetCodeViewController()<UIAlertViewDelegate>

@property (nonatomic, assign) SMSGetCodeMethod methodType;
@property (nonatomic, strong) UILabel *topAlertLabel;
@property (nonatomic, strong) UITableViewCell *zoneSelectBar;
@property (nonatomic, strong) UIView *phoneEditView;
@property (nonatomic, strong) UILabel *zone;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *nextStep;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = SMSLocalized(@"register");
    
    [self configUI];
}

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    
    self.topAlertLabel =
    ({
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 56 + StatusBarHeight, self.view.frame.size.width - 30, 50);
        label.text = [NSString stringWithFormat:SMSLocalized(@"labelnotice")];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:16];
        label.textColor = [UIColor darkGrayColor];
        [self.view addSubview:label];
        label;
    });

    self.zoneSelectBar =
    ({
        UITableViewCell *zoneSelectBar = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        zoneSelectBar.frame = CGRectMake(10, 106 + StatusBarHeight, self.view.frame.size.width - 20, 45);
        
        zoneSelectBar.textLabel.text = SMSLocalized(@"countrylable");
        zoneSelectBar.textLabel.textColor = [UIColor darkGrayColor];
        
        zoneSelectBar.detailTextLabel.text = [SMSSDKUIHelper currentCountryName];
        zoneSelectBar.detailTextLabel.textColor = [UIColor blackColor];
        
        zoneSelectBar.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectZone:)];
        
        [zoneSelectBar addGestureRecognizer:tap];
        
        [self.view addSubview:zoneSelectBar];
        
        zoneSelectBar ;
    });
    
    self.phoneEditView =
    ({
        UIView *phoneEditView = [[UIView alloc] initWithFrame:CGRectMake(10, 154 + StatusBarHeight, self.view.frame.size.width - 20, 42 + StatusBarHeight/4)];

        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneEditView.frame.size.width, 1)];
        lineTop.backgroundColor = [UIColor lightGrayColor];
        [phoneEditView addSubview:lineTop];
        
        self.zone =
        ({
            UILabel *zone = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, (self.view.frame.size.width - 30)/4, 40 + StatusBarHeight/4)];
            zone.text = @"+86";
            zone.textAlignment = NSTextAlignmentCenter;
            zone.font = [UIFont fontWithName:@"Helvetica" size:18];
            [phoneEditView addSubview:zone];
            zone;
        });

        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zone.frame)+1, 1, 1, _zone.frame.size.height)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        [phoneEditView addSubview:verticalLine];
        
        self.phoneTextField =
        ({
            UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame)+15, 1, (self.view.frame.size.width - 30)*3/4, verticalLine.frame.size.height)];
            phoneTextField.placeholder = SMSLocalized(@"telfield");
            phoneTextField.keyboardType = UIKeyboardTypePhonePad;
            phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [phoneEditView addSubview:phoneTextField];
            
            phoneTextField;
        });

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, phoneEditView.frame.size.height-1, phoneEditView.frame.size.width, 1)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [phoneEditView addSubview:bottomLine];
        
        [self.view addSubview:phoneEditView];
        phoneEditView ;
    });
    
    self.nextStep =
    ({
        UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeSystem];
        [nextStep setTitle:SMSLocalized(@"nextbtn") forState:UIControlStateNormal];
        
        NSString *imageName = [SMSSDKUIBundle pathForResource:@"button4" ofType:@"png"];
        
        [nextStep setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:imageName] forState:UIControlStateNormal];
        nextStep.frame = CGRectMake(10, 220 + StatusBarHeight, self.view.frame.size.width - 20, 42);
        [nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextStep addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextStep];
        nextStep;
    });
}

- (void)dismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextStep:(id)sender
{
    NSString *zone = _zone.text;
    NSString *phone = _phoneTextField.text;
    
    NSString *alertText = [SMSLocalized(@"willsendthecodeto") stringByAppendingFormat:@":%@ %@",zone,phone];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:SMSLocalized(@"surephonenumber") message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:SMSLocalized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:SMSLocalized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SMSSDKUIProcessHUD showProcessHUDWithInfo:SMSLocalized(@"sendingRequest")];
        
        NSString *template = @"1319972";
        
        [SMSSDK getVerificationCodeByMethod:_methodType phoneNumber:phone zone:zone template:template result:^(NSError *error) {
            if (error)
            {
                [SMSSDKUIProcessHUD dismiss];
                NSString *msg = SMSLocalized(@"codesenderrtitle");
                SMSSDKAlert(@"%@:%@",msg,error);
            }
            else
            {
                [SMSSDKUIProcessHUD showSuccessInfo:SMSLocalized(@"requestSuccess")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                    
                    SMSSDKUICommitCodeViewController *vc = [[SMSSDKUICommitCodeViewController alloc] initWithPhoneNumber:phone zone:zone methodType:_methodType];
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
            weakSelf.zoneSelectBar.detailTextLabel.text = countryName;
            weakSelf.zone.text = zone;
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


@end
