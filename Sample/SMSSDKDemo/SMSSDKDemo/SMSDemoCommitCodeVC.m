//
//  SMSDemoCommitCodeVC.m
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import "SMSDemoCommitCodeVC.h"
#import "SMSDemoDefines.h"
#import "SMSDemoZonesVC.h"
#import "SMSDemoHelper.h"

#import "SMSDemoProcessHUD.h"

#define KSMSDNeedMoveMaxHeight 570

@interface SMSDemoCommitCodeVC ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    NSInteger _i;
    BOOL _hasResend;
    BOOL _isShowZoneVC;
    BOOL _hasFirstGetCode;
    CGFloat _needMoveHeight;
}

//背景图
@property (nonatomic, strong) UIView *bgView;

//文本
@property (nonatomic, strong) UILabel *textTitleLbl;
//语音
@property (nonatomic, strong) UILabel *voiceTitleLbl;
//游标
@property (nonatomic, strong) UILabel *cursorLbl;
//区号背景视图
@property (nonatomic, strong) UIView *zoneSelectBar;
//地区
@property (nonatomic, strong) UILabel *countryZoneLbl;
//地区横线
@property (nonatomic, strong) UILabel *zoneLineLbl;
//箭头
@property (nonatomic, strong) UIButton *directionBtn;
//手机号背景视图
@property (nonatomic, strong) UIView *phoneEditView;
//手机号标题
@property (nonatomic, strong) UILabel *phoneTitleLbl;
//手机号标题
@property (nonatomic, strong) UITextField *phoneTf;
//地区横线
@property (nonatomic, strong) UILabel *phoneLineLbl;
//验证码背景视图
@property (nonatomic, strong) UIView *codeEditView;
//手机号标题
@property (nonatomic, strong) UILabel *codeTitleLbl;
//手机号标题
@property (nonatomic, strong) UITextField *codeTf;
//地区横线
@property (nonatomic, strong) UILabel *codeLineLbl;

//获取验证码背景视图
@property (nonatomic, strong) UILabel *timeAlert;

//获取验证码
@property (nonatomic, strong) UIButton *getCodeBtn;

//验证按钮
@property (nonatomic, strong) UIButton *verifyBtn;



@property (nonatomic, assign) SMSGetCodeMethod methodType;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *zone;

//游标
@property (nonatomic, strong) NSLayoutConstraint *cusorCenterXConstraint;
//号码top
@property (nonatomic, strong) NSLayoutConstraint *phoneTopConstraint;

//验证码top
@property (nonatomic, strong) NSLayoutConstraint *codeTopConstraint;

//result
@property (nonatomic, copy) SMSDCommitCodeResultHanler result;

//模板
@property (nonatomic, strong) NSString *tempCode;

@end

@implementation SMSDemoCommitCodeVC

- (instancetype)initWithMethod:(SMSGetCodeMethod)methodType template:(NSString *)tempCode result:(SMSDCommitCodeResultHanler)result
{
    if(self = [super init])
    {
        self.result = result;
        self.methodType = methodType;
        self.tempCode = tempCode;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认短信验证
    _methodType = SMSGetCodeMethodSMS;
    
    [self registerKeyboradNotification];
    
    [self loadCustomView];
    [self loadCustomLayout];
    

    if(_phoneTf.text.length > 0 && _codeTf.text.length>0)
    {
        _verifyBtn.enabled= YES;
    }
    else
    {
        _verifyBtn.enabled= NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _isShowZoneVC = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(_timer && [_timer isValid] && !_isShowZoneVC)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
     if(!_isShowZoneVC)
     {
         self.codeTf.delegate = nil;
         self.phoneTf.delegate = nil;
         [[NSNotificationCenter defaultCenter] removeObserver:self];
     }
}



#pragma mark - 键盘通知
- (void)registerKeyboradNotification
{
    if(self.view.frame.size.height < KSMSDNeedMoveMaxHeight)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat maxTextFieldY = self.bgView.frame.origin.y;
    if(fabs(maxTextFieldY) < _needMoveHeight)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = - _needMoveHeight;
            self.bgView.frame = viewFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        self.bgView.frame = viewFrame;
    }];
}


#pragma mark - 键盘方法
- (CGFloat)minKeyboardY:(NSNotification *)notification
{
    NSDictionary *infoDict = [notification userInfo];
    NSValue *value = [infoDict objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    
    return ([UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

- (void)configBack
{
    NSString *path = [SMSDemoUIBundle pathForResource:@"login_icon_back@3x" ofType:@"png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)dismiss:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



//加载视图
-(void)loadCustomView
{
    self.view.backgroundColor = SMSDemoRGBA(74,159,163, 1);

    [self configBack];

    self.bgView =
    ({
        UIView *bgView = [[UIView alloc] init];
        [self.view addSubview:bgView];
        
        bgView;
    });
    
    self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    
    self.textTitleLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = SMSDemoLocalized(@"textverify");
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Helvetica" size:18];
        lbl.userInteractionEnabled = YES;
        [self.bgView addSubview:lbl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSmsType:)];
        [lbl addGestureRecognizer:tap];
        lbl;
    });
    
    self.voiceTitleLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = SMSDemoLocalized(@"voiceverify");
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = SMSDemoGrayTextColor();
        lbl.font = [UIFont fontWithName:@"Helvetica" size:18];
        lbl.userInteractionEnabled = YES;
        [self.bgView addSubview:lbl];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVoiceType:)];
        [lbl addGestureRecognizer:tap];
        
        lbl;
    });
    
    //width 100
    self.cursorLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:lbl];
        lbl;
    });
    
    self.zoneSelectBar =
    ({
        UIView *zoneSelectBar = [[UIView alloc] init];
        
        self.countryZoneLbl =
        ({
            UILabel *countryLabel = [[UILabel alloc] init];
            countryLabel.text = [NSString stringWithFormat:@"%@    %@",[SMSDemoHelper currentCountryName],[SMSDemoHelper currentZone]];
            //[SMSSDKUIHelper currentCountryName];
            countryLabel.textColor = [UIColor whiteColor];
            countryLabel.textAlignment = NSTextAlignmentLeft;
            countryLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            [zoneSelectBar addSubview:countryLabel];
            countryLabel;
        });
        
        _zone = [SMSDemoHelper currentZone];
        if([_zone containsString:@"+"])
        {
            _zone = [_zone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        }
        
        
        self.directionBtn =
        ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            NSString *path = [SMSDemoUIBundle pathForResource:@"right_direction@3x" ofType:@"png"];
            [btn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
            
            [zoneSelectBar addSubview:btn];
            btn;
        });
        
        self.zoneLineLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.backgroundColor = SMSDemoGrayTextColor();
            [zoneSelectBar addSubview:lbl];
            lbl;
        });
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectZone:)];
        [zoneSelectBar addGestureRecognizer:tap];
        [self.bgView addSubview:zoneSelectBar];
        
        if([SMSDemoHelper currentCountryName] && [SMSDemoHelper currentZone])
        {
            NSString *secdemo_country = [[NSUserDefaults standardUserDefaults] objectForKey:@"secdemo_country"];
            NSString *secdemo_zone = [[NSUserDefaults standardUserDefaults] objectForKey:@"secdemo_zone"];
            if(!secdemo_zone && !secdemo_country)
            {
               
                [[NSUserDefaults standardUserDefaults] setObject:[SMSDemoHelper currentCountryName] forKey:@"secdemo_country"];
                [[NSUserDefaults standardUserDefaults] setObject:[SMSDemoHelper currentZone] forKey:@"secdemo_zone"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

        }

        
        zoneSelectBar ;
    });
    
    
    self.phoneEditView =
    ({
        UIView *editView = [[UIView alloc] init];
        
        self.phoneTitleLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.text = SMSDemoLocalized(@"phonecode");
            lbl.textAlignment = NSTextAlignmentLeft;
            lbl.textColor = SMSDemoGrayTextColor();
            lbl.font = [UIFont fontWithName:@"Helvetica" size:18];
            [editView addSubview:lbl];
            lbl;
        });
        
        
        self.phoneTf =
        ({
            UITextField *textFiled = [[UITextField alloc] init];
            textFiled.textColor = [UIColor whiteColor];
//            textFiled.placeholder = SMSDemoLocalized(@"phonecode");
            textFiled.keyboardType = UIKeyboardTypePhonePad;
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.font = [UIFont fontWithName:@"Helvetica" size:14];
            textFiled.delegate = self;
            [editView addSubview:textFiled];
            textFiled;
            
        });
        
        self.phoneLineLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.backgroundColor = SMSDemoGrayTextColor();
            [editView addSubview:lbl];
            lbl;
        });
        [self.bgView addSubview:editView];

        editView;
    });
    
    self.codeEditView =
    ({
        UIView *editView = [[UIView alloc] init];
        
        self.codeTitleLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.text = SMSDemoLocalized(@"Code");
            lbl.textAlignment = NSTextAlignmentLeft;
            lbl.textColor = SMSDemoGrayTextColor();
            lbl.font = [UIFont fontWithName:@"Helvetica" size:18];
            [editView addSubview:lbl];
            lbl;
        });
        
        self.codeTf =
        ({
            UITextField *textFiled = [[UITextField alloc] init];
//            textFiled.placeholder = SMSDemoLocalized(@"Code");
            textFiled.keyboardType = UIKeyboardTypePhonePad;
            textFiled.textColor = [UIColor whiteColor];
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.font = [UIFont fontWithName:@"Helvetica" size:14];
            textFiled.delegate = self;
            [editView addSubview:textFiled];
            textFiled;
            
        });
        
        self.getCodeBtn =
        ({
            UIButton *btn = [[UIButton alloc] init];
//            btn.titleLabel.textColor = [UIColor lightGrayColor];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitle:SMSDemoLocalized(@"getcode") forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            btn.enabled = NO;
            [editView addSubview:btn];
            [btn addTarget:self action:@selector(startTimeLbl) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        self.timeAlert =
        ({
            UILabel *timeAlert = [[UILabel alloc] init];
            timeAlert.numberOfLines = 0;
            timeAlert.textColor = [UIColor lightGrayColor];
            timeAlert.textAlignment = NSTextAlignmentRight;
            timeAlert.font = [UIFont fontWithName:@"Helvetica" size:14];
                        
            [editView addSubview:timeAlert];
            timeAlert.userInteractionEnabled = NO;
//            timeAlert.enabled = NO;

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retrySend:)];
            
            [timeAlert addGestureRecognizer:tap];
            
            timeAlert;
        });
        
        
        
        self.codeLineLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.backgroundColor = SMSDemoGrayTextColor();
            [editView addSubview:lbl];
            lbl;
        });
        [self.bgView addSubview:editView];

        editView;
    });
    
    
    self.verifyBtn =
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:SMSDemoLocalized(@"verify") forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius = 4;
        [btn setTitleColor:SMSDemoCommonBgColor() forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        btn;
    });
    
}


//加载布局
-(void)loadCustomLayout
{
    
    self.textTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.cursorLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.zoneSelectBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryZoneLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.zoneLineLbl.translatesAutoresizingMaskIntoConstraints = NO;

    self.phoneEditView.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneTf.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneLineLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.codeEditView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeTf.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeLineLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;

    self.getCodeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeAlert.translatesAutoresizingMaskIntoConstraints = NO;

    self.verifyBtn.translatesAutoresizingMaskIntoConstraints = NO;


    UIView *bgView = self.bgView;
    float topOffset = 44+20 + SMSDemoStatusBarHeight;
    
    //短信验证码
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topOffset];

        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textTitleLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];


        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.textTitleLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];

        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.textTitleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];

        [bgView addConstraint:topConstraint];
        [bgView addConstraint:leftConstraint];
        [bgView addConstraint:widthConstraint];
        [self.textTitleLbl addConstraint:heigtConstraint];

    }
    
    //语音
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.voiceTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topOffset];
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceTitleLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.voiceTitleLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.voiceTitleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:rightConstraint];
        [bgView addConstraint:widthConstraint];
        [self.voiceTitleLbl addConstraint:heigtConstraint];

    }
    
    //游标
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.cursorLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:(topOffset+40)];
        
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.cursorLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-[UIScreen mainScreen].bounds.size.width/4.0];
        self.cusorCenterXConstraint = centerXConstraint;
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.cursorLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.cursorLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:2];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [self.cursorLbl addConstraint:widthConstraint];
        [self.cursorLbl addConstraint:heigtConstraint];

    }
    
    //zone bg
    {
           NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.zoneSelectBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:(topOffset + 80)];
           
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.zoneSelectBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.zoneSelectBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.zoneSelectBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
           
           [bgView addConstraint:topConstraint];
           [bgView addConstraint:leftConstraint];
           [bgView addConstraint:rightConstraint];
           [self.zoneSelectBar addConstraint:heigtConstraint];

       }
    
    //zones
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.countryZoneLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.countryZoneLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.countryZoneLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:-30];

        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.countryZoneLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

        [self.zoneSelectBar addConstraint:topConstraint];
        [self.zoneSelectBar addConstraint:leftConstraint];
        [self.zoneSelectBar addConstraint:rightConstraint];
        [self.zoneSelectBar addConstraint:bottomConstraint];

    }
    
    //direction
    {
        NSLayoutConstraint *centeryYConstraint = [NSLayoutConstraint constraintWithItem:self.directionBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.directionBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];


        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.directionBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];

        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.directionBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];


        [self.directionBtn addConstraint:widthConstraint];
        [self.directionBtn addConstraint:heigtConstraint];
        [self.zoneSelectBar addConstraint:centeryYConstraint];
        [self.zoneSelectBar addConstraint:rightConstraint];
    }
    
    //zoneline
    {
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.zoneLineLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5];
        
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.zoneLineLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.zoneLineLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.zoneLineLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        
        [self.zoneSelectBar addConstraint:bottomConstraint];
        [self.zoneSelectBar addConstraint:leftConstraint];
        [self.zoneSelectBar addConstraint:rightConstraint];
        [self.zoneLineLbl addConstraint:heigtConstraint];
        
    }
//    self.zoneSelectBar.backgroundColor = [UIColor lightTextColor];
//    self.phoneEditView.backgroundColor = [UIColor yellowColor];
    
    //phone bg
    {
           NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneEditView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.zoneSelectBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1];
           
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.phoneEditView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneEditView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.phoneEditView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:72];
           
           [bgView addConstraint:topConstraint];
           [bgView addConstraint:leftConstraint];
           [bgView addConstraint:rightConstraint];
           [self.phoneEditView addConstraint:heigtConstraint];

        
       }
    
    //phone title
    {
//           NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15];

        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40];

        
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTitleLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTitleLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-100];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTitleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
           
           [self.phoneEditView addConstraint:topConstraint];
           [self.phoneEditView addConstraint:leftConstraint];
           [self.phoneEditView addConstraint:rightConstraint];
           [self.phoneTitleLbl addConstraint:heigtConstraint];

        _phoneTopConstraint = topConstraint;
       }
    
    //phone tf
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTf attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:32];

        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTf attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTf attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-30];

        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.phoneTf attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

        [self.phoneEditView addConstraint:topConstraint];
        [self.phoneEditView addConstraint:leftConstraint];
        [self.phoneEditView addConstraint:rightConstraint];
        [self.phoneEditView addConstraint:bottomConstraint];

    }
    
    
    //phone line
    {
           NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLineLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5];
           
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLineLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLineLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.phoneEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLineLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
           
           [self.phoneEditView addConstraint:bottomConstraint];
           [self.phoneEditView addConstraint:leftConstraint];
           [self.phoneEditView addConstraint:rightConstraint];
           [self.phoneLineLbl addConstraint:heigtConstraint];

       }
    
    
    //code bg
    {
           NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.codeEditView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:(topOffset + 192)];
           
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.codeEditView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.codeEditView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.codeEditView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:72];
           
           [bgView addConstraint:topConstraint];
           [bgView addConstraint:leftConstraint];
           [bgView addConstraint:rightConstraint];
           [self.codeEditView addConstraint:heigtConstraint];

       }
    
    //code title
    {
//           NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.codeTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15];

        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.codeTitleLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40];

           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.codeTitleLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.codeTitleLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-100];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.codeTitleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
           
           [self.codeEditView addConstraint:topConstraint];
           [self.codeEditView addConstraint:leftConstraint];
           [self.codeEditView addConstraint:rightConstraint];
           [self.codeTitleLbl addConstraint:heigtConstraint];
        
            _codeTopConstraint = topConstraint;
       }
    
    //code tf
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.codeTf attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:32];

        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.codeTf attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.codeTf attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-130];

        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.codeTf attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

        [self.codeEditView addConstraint:topConstraint];
        [self.codeEditView addConstraint:leftConstraint];
        [self.codeEditView addConstraint:rightConstraint];
        [self.codeEditView addConstraint:bottomConstraint];

    }
    
    
    //code line
    {
           NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.codeLineLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5];
           
           NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.codeLineLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
           
           
           NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.codeLineLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
           
           NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.codeLineLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
           
           [self.codeEditView addConstraint:bottomConstraint];
           [self.codeEditView addConstraint:leftConstraint];
           [self.codeEditView addConstraint:rightConstraint];
           [self.codeLineLbl addConstraint:heigtConstraint];

       }
    
    
    //get code
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.getCodeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:32];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.getCodeBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8];


        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.getCodeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];

        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.getCodeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];


        [self.getCodeBtn addConstraint:widthConstraint];
        [self.getCodeBtn addConstraint:heigtConstraint];
        [self.codeEditView addConstraint:topConstraint];
        [self.codeEditView addConstraint:rightConstraint];
    }
    
    //resend code
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.timeAlert attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:32];


        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.timeAlert attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];


        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.timeAlert attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];

        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.timeAlert attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];


        [self.timeAlert addConstraint:widthConstraint];
        [self.timeAlert addConstraint:heigtConstraint];
        [self.codeEditView addConstraint:topConstraint];
        [self.codeEditView addConstraint:rightConstraint];
    }
    
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.verifyBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.codeEditView attribute:NSLayoutAttributeTop multiplier:1.0 constant:112];

        NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.verifyBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.verifyBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0];


        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.verifyBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45];


        [bgView addConstraint:centerConstraint];
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:widthConstraint];
        [self.verifyBtn addConstraint:heigtConstraint];
    }
    
}

//选择国家地区
- (void)selectZone:(id)sender
{
    
    _isShowZoneVC = YES;
    
    __weak typeof(self) weakSelf = self;
    SMSDemoZonesVC *vc = [[SMSDemoZonesVC alloc] initWithResult:^(BOOL cancel, NSString *zone, NSString *countryName) {
        
        if (!cancel && zone && countryName)
        {
            weakSelf.zone = zone;
            weakSelf.countryZoneLbl.text = [NSString stringWithFormat:@"%@ %@",countryName,zone];
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#define MsgPre SMSDemoLocalized(@"timelablemsg")
#define MsgLast SMSDemoLocalized(@"second")

- (void)startTimeLbl
{
    [self.codeTf resignFirstResponder];
    [self.phoneTf resignFirstResponder];
    
    self.getCodeBtn.userInteractionEnabled = NO;
    self.textTitleLbl.userInteractionEnabled = NO;
    self.voiceTitleLbl.userInteractionEnabled = NO;
    self.timeAlert.userInteractionEnabled = NO;
    
    
    self.phone = _phoneTf.text;
    
    if (_methodType == SMSGetCodeMethodVoice) {
        
        [self sendVoiceCode];
    }
    else
    {
        [self sendTextCode];
    }
    
}


- (void)startCount
{
    if(!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _i = 60;
    }

    NSString *text = [NSString stringWithFormat:@"%@(%zd)",SMSDemoLocalized(@"getcode"),_i] ;
    
    //[@[MsgPre,[NSString stringWithFormat:@"%zd",_i],MsgLast] componentsJoinedByString:@""];
    
    _timeAlert.text = text;
    _timeAlert.textColor = SMSDemoRGBA(153, 212, 213, 1);

    if (!_i--)
    {
        
        _timeAlert.text = SMSDemoLocalized(@"getcode");
        [_timer invalidate];
        
        _timeAlert.userInteractionEnabled = YES;
        self.textTitleLbl.userInteractionEnabled = YES;
        self.voiceTitleLbl.userInteractionEnabled = YES;
        
        _timeAlert.textColor = [UIColor whiteColor];

    }
}

- (void)retrySend:(id)sender
{
    if (_methodType == SMSGetCodeMethodVoice) {
        
        [self sendVoiceCode];
    }
    else
    {
        [self sendTextCode];
    }
    
//    NSString *title = SMSDemoLocalized(@"surephonenumber");
//    NSString *message = [SMSDemoLocalized(@"cannotgetsmsmsg") stringByAppendingFormat:@":%@",_phoneTf.text];
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//
//    NSString *back = SMSDemoLocalized(@"cancel");
//    UIAlertAction *backAction = [UIAlertAction actionWithTitle:back style:UIAlertActionStyleCancel handler:nil];
//    NSString *send = SMSDemoLocalized(@"sure");
//    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:send style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //[self sendTextCode];
//        if (_methodType == SMSGetCodeMethodVoice) {
//
//            [self sendVoiceCode];
//        }
//        else
//        {
//            [self sendTextCode];
//        }
//    }];
//
//    [alert addAction:backAction];
//    [alert addAction:sureAction];
//
//    [self presentViewController:alert animated:YES completion:nil];
//
//    _hasResend = YES;
}

- (void)changeSmsType:(UITapGestureRecognizer*)sender
{
    _methodType = SMSGetCodeMethodSMS;
    [_voiceTitleLbl setTextColor:SMSDemoGrayTextColor()];
    [_textTitleLbl setTextColor:[UIColor whiteColor]];
    
    _cusorCenterXConstraint.constant = -[UIScreen mainScreen].bounds.size.width/4.0;
    [self.view updateConstraints];
}

- (void)changeVoiceType:(UITapGestureRecognizer*)sender
{
    _methodType = SMSGetCodeMethodVoice;
    [_textTitleLbl setTextColor:SMSDemoGrayTextColor()];
    [_voiceTitleLbl setTextColor:[UIColor whiteColor]];
    _cusorCenterXConstraint.constant = [UIScreen mainScreen].bounds.size.width/4.0;
    [self.view updateConstraints];
}

- (void)handleSendCodeRst:(BOOL)sucess
{
    if(sucess)
    {
        self.timeAlert.hidden = NO;
        self.getCodeBtn.hidden = YES;
        self.textTitleLbl.userInteractionEnabled = NO;
        self.voiceTitleLbl.userInteractionEnabled = NO;
        self.timeAlert.userInteractionEnabled = NO;
        self.getCodeBtn.userInteractionEnabled = YES;
        
        if(_timer && [_timer isValid])
        {
            [_timer invalidate];
        }
        _timer = nil;
        [self startCount];
        
    }
    else
    {
        if(_hasFirstGetCode)
        {
            self.timeAlert.hidden = NO;
            self.getCodeBtn.hidden = YES;

            self.timeAlert.userInteractionEnabled = YES;
            self.getCodeBtn.userInteractionEnabled = NO;
        }
        else
        {
            self.timeAlert.hidden = YES;
            self.getCodeBtn.hidden = NO;
            self.timeAlert.userInteractionEnabled = NO;
            self.getCodeBtn.userInteractionEnabled = YES;


        }
        self.textTitleLbl.userInteractionEnabled = YES;
        self.voiceTitleLbl.userInteractionEnabled = YES;
    }
}

- (void)sendVoiceCode
{
    [SMSDemoProcessHUD showProcessHUDWithInfo:SMSDemoLocalized(@"sendingRequest")];

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice phoneNumber:_phone zone:_zone template:self.tempCode result:^(NSError *error) {
        if (error)
        {
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSDemoProcessHUD showFailInfo:SMSDemoLocalized(@"nonetwork")];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            else
            {
                
                [SMSDemoProcessHUD showFailInfo:[SMSDemoHelper errorTextWithError:error]];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            [self handleSendCodeRst:NO];
        }
        
        else
        {
            [SMSDemoProcessHUD showSuccessInfo:SMSDemoLocalized(@"requestSuccess")];
            [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                
            }];
            
            _hasFirstGetCode = YES;
            [self handleSendCodeRst:YES];
        }
    }];
}

- (void)sendTextCode
{
    [SMSDemoProcessHUD showProcessHUDWithInfo:SMSDemoLocalized(@"sendingRequest")];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone zone:_zone template:self.tempCode result:^(NSError *error) {
        if (error)
        {
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSDemoProcessHUD showFailInfo:SMSDemoLocalized(@"nonetwork")];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{

                }];
            }
            else
            {
                [SMSDemoProcessHUD showFailInfo:[SMSDemoHelper errorTextWithError:error]];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            [self handleSendCodeRst:NO];

        }

        else
        {
            [SMSDemoProcessHUD showSuccessInfo:SMSDemoLocalized(@"requestSuccess")];
            [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                
            }];
            
            _hasFirstGetCode = YES;
            [self handleSendCodeRst:YES];
        }
    }];
}


-(void)verify:(UIButton*)btn
{
//    if(1==1)
//    {
//        [SMSDemoProcessHUD showSuccessInfo:@"women来了安安啊!"];
//        return;
//    }
    [self.codeTf resignFirstResponder];
    [self.phoneTf resignFirstResponder];
    
//    self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);


    [SMSDemoProcessHUD showProcessHUDWithInfo:SMSDemoLocalized(@"commitingCode")];
    [SMSSDK commitVerificationCode:_codeTf.text phoneNumber:_phone zone:_zone result:^(NSError *error) {
    
        if (error)
        {

            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSDemoProcessHUD showMsgHUDWithInfo:SMSDemoLocalized(@"nonetwork")];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{

                }];
            }
            else
            {
                [SMSDemoProcessHUD showFailInfo:[SMSDemoHelper errorTextWithError:error]];
                [SMSDemoProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }

        }
        else
        {
            [SMSDemoProcessHUD dismiss];
            _i = 0;
            [_timer invalidate];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                if(self.result)
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    dict[@"phone"] = _phoneTf.text;
                    dict[@"zone"] = _zone;
                    
                    self.result(dict, nil);
                }
                
            }];

        }
    }];
}

#pragma mark - UITextFieldDelegate



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
//    self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.codeTf resignFirstResponder];
    [self.phoneTf resignFirstResponder];
    

    if(self.codeTf.text.length == 0)
    {
        _codeTopConstraint.constant = 40;
        _codeTitleLbl.font = [UIFont systemFontOfSize:18];
        
    }
    else
    {
        _codeTopConstraint.constant = 15;
        _codeTitleLbl.font = [UIFont systemFontOfSize:14];
    }

    if(self.phoneTf.text.length == 0)
    {
        _phoneTopConstraint.constant = 40;
        _phoneTitleLbl.font = [UIFont systemFontOfSize:18];
        
    }
    else
    {
        _phoneTopConstraint.constant = 15;
        _phoneTitleLbl.font = [UIFont systemFontOfSize:14];
    }
    [self updateViewConstraints];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.view.frame.size.height < KSMSDNeedMoveMaxHeight)
    {
        _needMoveHeight = 120;
    }
    
    if(textField == self.phoneTf)
    {
        _phoneTopConstraint.constant = 15;
        _phoneTitleLbl.font = [UIFont systemFontOfSize:14];
        if(self.codeTf.text.length == 0)
        {
            _codeTopConstraint.constant = 40;
            _codeTitleLbl.font = [UIFont systemFontOfSize:18];
            
        }
        [self updateViewConstraints];
    }
    else if(textField == self.codeTf)
    {
        _codeTopConstraint.constant = 15;
        _codeTitleLbl.font = [UIFont systemFontOfSize:14];
        if(self.phoneTf.text.length == 0)
        {
            _phoneTopConstraint.constant = 40;
            _phoneTitleLbl.font = [UIFont systemFontOfSize:18];
            
        }
        [self updateViewConstraints];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _verifyBtn.enabled= NO;
    if(textField == self.phoneTf)
    {
        self.timeAlert.userInteractionEnabled = NO;
        self.getCodeBtn.enabled = NO;
        
        _timeAlert.textColor = [UIColor lightGrayColor];
        [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *lastStr = textField.text;
    if(string && string.length > 0)
    {
        lastStr = [lastStr stringByAppendingString:string];
    }
    else
    {
        NSInteger len = textField.text.length;
        lastStr = [lastStr substringToIndex:(len - range.length)];
    }
    
    

    
    if(textField == self.phoneTf)
    {
        
        if(lastStr.length > 0 && _codeTf.text.length >= 4)
        {
            _verifyBtn.enabled= YES;
        }
        else
        {
            _verifyBtn.enabled= NO;
        }
        
        //高亮逻辑
        if(lastStr && lastStr.length >= 5)
        {
            if(_hasFirstGetCode)
            {
                self.timeAlert.userInteractionEnabled = YES;
            }
            else
            {
                self.getCodeBtn.enabled = YES;
            }
            
            
            _timeAlert.textColor = [UIColor whiteColor];
            [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else
        {
            self.timeAlert.userInteractionEnabled = NO;
            self.getCodeBtn.enabled = NO;
            
            _timeAlert.textColor = [UIColor lightGrayColor];
            [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        //限制输入
        if(lastStr && lastStr.length > 11)
        {
            return NO;
        }
    }
    
    if(textField == self.codeTf)
    {
        
        if(lastStr.length >= 4 && _phoneTf.text.length > 0)
        {
            _verifyBtn.enabled= YES;
        }
        else
        {
            _verifyBtn.enabled= NO;
        }
        
        //限制输入
        if(lastStr && lastStr.length > 6)
        {
            return NO;
        }
    }

    return YES;
}

@end
