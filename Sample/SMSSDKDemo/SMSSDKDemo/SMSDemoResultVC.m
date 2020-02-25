//
//  SMSDemoResultVC.m
//  SMSSDKDemo
//
//  Created by hower on 2020/1/3.
//  Copyright © 2020 youzu. All rights reserved.
//

#import "SMSDemoResultVC.h"
#import "SMSDemoDefines.h"

@interface SMSDemoResultVC ()
//图标
@property (nonatomic, strong) UIImageView *topImageView;
//图标
@property (nonatomic, strong) UIImageView *iconImageView;
//状态
@property (nonatomic, strong) UILabel *statusLbl;
//耗时
//@property (nonatomic, strong) UILabel *timerOffsetLbl;
//号码
@property (nonatomic, strong) UILabel *phoneLbl;
//描述
@property (nonatomic, strong) UILabel *desLbl;
//再次验证
@property (nonatomic, strong) UIButton *reVerifyBtn;
//客服电话
@property (nonatomic, strong) UILabel *servicePhoneLbl;
//咨询客服
@property (nonatomic, strong) UILabel *serviceDesLbl;
//电话btn
@property (nonatomic, strong) UIButton *phoneBtn;
//qq btn
@property (nonatomic, strong) UIButton *qqBtn;


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *des;

@end

@implementation SMSDemoResultVC


- (id)initWithType:(NSInteger)type phone:(NSString *)phone des:(NSString *)des
{
    if(self = [super init])
    {
        _type = type;
        _phone = phone;
        _des = des;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = SMSDemoRGBA(236,236,236, 1);

    
    [self loadCustomView];
    [self loadCustomLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//加载视图
-(void)loadCustomView
{
    
    self.topImageView =
    ({
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.view addSubview:imgView];
        imgView;
    });
    
    self.iconImageView =
    ({
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.view addSubview:imgView];
        imgView;
    });
    
    self.statusLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Helvetica" size:18];
        lbl.userInteractionEnabled = YES;
        [self.view addSubview:lbl];
        lbl;
    });
    
    
    self.desLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = SMSDemoRGBA(133, 133, 133, 1);
        lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
        lbl.userInteractionEnabled = YES;
        [self.view addSubview:lbl];
        lbl;
    });
    
    
    self.reVerifyBtn =
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:SMSDemoLocalized(@"Revalidation") forState:UIControlStateNormal];
        [btn setBackgroundColor:SMSDemoCommonBgColor()];
        btn.layer.cornerRadius = 4;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(reverify:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    self.servicePhoneLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = SMSDemoRGBA(133, 133, 133, 1);
        lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
        lbl.userInteractionEnabled = YES;
        [self.view addSubview:lbl];
        lbl;
    });
    
    self.serviceDesLbl =
    ({
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = SMSDemoRGBA(133, 133, 133, 1);
        lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
        lbl.userInteractionEnabled = YES;
        [self.view addSubview:lbl];
        lbl;
    });
    
    self.phoneBtn =
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    self.qqBtn =
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(qqAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    

    //客服电话
    NSString *path = [SMSDemoUIBundle pathForResource:@"done_icon_phone@3x" ofType:@"png"];
    [self.phoneBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    path = [SMSDemoUIBundle pathForResource:@"done_icon_qq@3x" ofType:@"png"];
    [self.qqBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];

    
    self.serviceDesLbl.text = SMSDemoLocalized(@"ConsultationCustomerService");

    //导航title属性文字
    NSString *curPhoneText = [NSString stringWithFormat:@"%@：400-685-2216",SMSDemoLocalized(@"CustomerServiceTelephone")];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:curPhoneText];
    NSRange range = [curPhoneText rangeOfString:@"400-685-2216"];
    if(range.location != NSNotFound)
    {
        
        [attStr addAttributes:@{
                                NSForegroundColorAttributeName : SMSDemoCommonBgColor()
                                }
                        range:range];
        self.servicePhoneLbl.attributedText = attStr;
    }

    //配置数据
    if(self.type == 0)
    {
        
//        self.timerOffsetLbl =
//        ({
//            UILabel *lbl = [[UILabel alloc] init];
//            lbl.textAlignment = NSTextAlignmentCenter;
//            lbl.textColor = [UIColor whiteColor];
//            lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
//            lbl.userInteractionEnabled = YES;
//            [self.view addSubview:lbl];
//            lbl;
//        });
        
        
        self.phoneLbl =
        ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = [UIColor blackColor];
            lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
            [self.view addSubview:lbl];
            lbl;
        });
        self.phoneLbl.hidden = NO;
        
        NSString *path = [SMSDemoUIBundle pathForResource:@"icon_successful@3x" ofType:@"png"];
        self.iconImageView.image = [UIImage imageWithContentsOfFile:path];
        
        self.statusLbl.text = SMSDemoLocalized(@"loginsucess");
        
        self.desLbl.text = SMSDemoLocalized(@"byMobTechSDK");
        self.phoneLbl.text = _phone;
        
        
        path = [SMSDemoUIBundle pathForResource:@"done_bg_successful@3x" ofType:@"png"];
        _topImageView.image = [UIImage imageWithContentsOfFile:path];
        
//        _timerOffsetLbl.text = [NSString stringWithFormat:@"%@%.1f",SMSDemoLocalized(@"timeconsuming"),1.5];
    }
    else
    {
        NSString *path = [SMSDemoUIBundle pathForResource:@"done_icon_fail@3x" ofType:@"png"];
        self.iconImageView.image = [UIImage imageWithContentsOfFile:path];
        self.statusLbl.text = SMSDemoLocalized(@"loginfail");

        path = [SMSDemoUIBundle pathForResource:@"done_bg_fail@3x" ofType:@"png"];
        _topImageView.image = [UIImage imageWithContentsOfFile:path];
        [_reVerifyBtn setBackgroundColor:[UIColor redColor]];
        
        _desLbl.text = _des;
    }
    
}


//加载布局
-(void)loadCustomLayout
{
    
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.topImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.desLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.reVerifyBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.servicePhoneLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.serviceDesLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.qqBtn.translatesAutoresizingMaskIntoConstraints = NO;

    
    UIView *bgView = self.view;
    float topOffset = 90;
    
    
    //bg imageview
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.topImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.topImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.topImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];

        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.topImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.topImageView attribute:NSLayoutAttributeWidth multiplier:(618/750.0) constant:1.0];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:leftConstraint];
        [bgView addConstraint:rightConstraint];
        [_topImageView addConstraint:heigtConstraint];
    }
    
    //icon
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topOffset];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_iconImageView addConstraint:widthConstraint];
        [_iconImageView addConstraint:heigtConstraint];
    }
    
    //status
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.statusLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topOffset+84];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.statusLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.statusLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.statusLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_statusLbl addConstraint:widthConstraint];
        [_statusLbl addConstraint:heigtConstraint];
    }
    
    
    if(self.type == 0)
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_phoneLbl addConstraint:widthConstraint];
        [_phoneLbl addConstraint:heigtConstraint];
        
        
    }
    
//    if(self.type == 0)
//    {
//        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.timerOffsetLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_statusLbl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5];
//
//        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.timerOffsetLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//
//
//        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.timerOffsetLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
//
//        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.timerOffsetLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
//
//        [bgView addConstraint:topConstraint];
//        [bgView addConstraint:centerXConstraint];
//        [_timerOffsetLbl addConstraint:widthConstraint];
//        [_timerOffsetLbl addConstraint:heigtConstraint];
//
//
//    }
    
    if(self.type == 0)
    {
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:60];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_desLbl addConstraint:widthConstraint];
        [_desLbl addConstraint:heigtConstraint];
        
    }
    else
    {
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:40];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.desLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_desLbl addConstraint:widthConstraint];
        [_desLbl addConstraint:heigtConstraint];
    }
    
    
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.reVerifyBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:120];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.reVerifyBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.reVerifyBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:260];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.reVerifyBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_reVerifyBtn addConstraint:widthConstraint];
        [_reVerifyBtn addConstraint:heigtConstraint];
    }
    
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.servicePhoneLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:178];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.servicePhoneLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.servicePhoneLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.servicePhoneLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_servicePhoneLbl addConstraint:widthConstraint];
        [_servicePhoneLbl addConstraint:heigtConstraint];
    }
    
    {
        //适配小屏幕
        float top = 250;
        if([UIScreen mainScreen].bounds.size.height <= 710)
        {
            top = 220;
        }
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.serviceDesLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:top];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.serviceDesLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.serviceDesLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.serviceDesLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_serviceDesLbl addConstraint:widthConstraint];
        [_serviceDesLbl addConstraint:heigtConstraint];
    }
    
    
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.phoneBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_serviceDesLbl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.phoneBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-50];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.phoneBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.phoneBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_phoneBtn addConstraint:widthConstraint];
        [_phoneBtn addConstraint:heigtConstraint];
    }
    
    
    {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.qqBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_serviceDesLbl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.qqBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:50];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.qqBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        
        NSLayoutConstraint *heigtConstraint = [NSLayoutConstraint constraintWithItem:self.qqBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        
        [bgView addConstraint:topConstraint];
        [bgView addConstraint:centerXConstraint];
        [_qqBtn addConstraint:widthConstraint];
        [_qqBtn addConstraint:heigtConstraint];
    }
    
    [bgView updateConstraints];
}

-(void)phoneAction:(UIButton*)btn
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-685-2216"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    //复制
    [[UIPasteboard generalPasteboard] setString:@"400-685-2216"];
    
}

-(void)qqAction:(UIButton*)btn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://url.cn/58ilGpI?_type=wpa&qidian=true"]];
}

-(void)reverify:(UIButton*)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
