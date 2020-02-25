//
//  SMSDemoPolicyManager.m
//  SecVerifyDemo
//
//  Created by hower on 2019/12/5.
//  Copyright © 2019 mob. All rights reserved.
//

#import "SMSDemoPolicyManager.h"
#import "SMSDemoHelper.h"
#import <MOBFoundation/MOBFDevice.h>
#import "SMSDemoPolicyWebVC.h"

static UIWindow *window = nil;
static UIButton *refuseView = nil;
static UIButton *acceptView = nil;


#define KRefuseBtnTag 19991
#define KAcceptBtnTag 19992


@interface SMSSDKDemoDialogVC : UIViewController<UITextViewDelegate>

@property (nonatomic, assign)BOOL isPortait;
@property (nonatomic, copy)SMSDemoPolicyAcceptHandler acceptBlock;
@property (nonatomic, strong)NSString *url;



@end

@implementation SMSSDKDemoDialogVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



- (void)refuseAction:(UIButton *)btn
{
    
    
    acceptView.selected = NO;
    refuseView.selected = YES;
    acceptView.backgroundColor = [UIColor whiteColor];
    refuseView.backgroundColor = [UIColor colorWithRed:8/255.0 green:151/255.0 blue:156/255.0 alpha:1];
    
    
    if(window)
    {
        window.hidden = YES;
        [window resignKeyWindow];
    }
    
    dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC));
    dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
        
        if (window) {
            window = nil;
        }
    });
    
    //存储
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"smsdemo_accept_policy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.acceptBlock)
    {
        self.acceptBlock(NO);
    }
    
}

- (void)acceptAction:(UIButton *)btn
{
    
    acceptView.selected = YES;
    refuseView.selected = NO;
    refuseView.backgroundColor = [UIColor whiteColor];
    acceptView.backgroundColor = [UIColor colorWithRed:8/255.0 green:151/255.0 blue:156/255.0 alpha:1];
    
    
    if(window)
    {
        window.hidden = YES;
    }
    
    dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC));
    dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
        
        if (window) {
            window = nil;
        }
    });
    
    //存储
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"smsdemo_accept_policy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(self.acceptBlock)
    {
        self.acceptBlock(YES);
    }
}


+(NSString *)getTitle
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"Terms of Use";
    }
    return @"服务授权";
}

+(NSString *)getUpdateDate
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"update date: 2019-10-12";
    }
    return @"最近更新日期：2019年10月12日";
}

+(NSString *)getEffectiveDate
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"effective date: 2019-10-19";
    }
    return @"版本生效日期：2019年10月19日";
}

-(NSString *)getContent
{
    if(self.url)
    {
        if(![SMSDemoHelper isZhHans])
        {
            return [NSString stringWithFormat:@"You are welcome to use demo provided by mobtech. Smssdk provides developers with a free SMS verification code service. The top channel is issued in 3 seconds, which is suitable for login, password retrieval, payment authentication and other scenarios. We will use mobtech's privacy policy to help you understand what data we need to collect. Please refer to our privacy policy at %@ for details",self.url];
        }
        return  [NSString stringWithFormat:@"   欢迎您使用MobTech提供的演示DEMO，SMSSDK为开发者提供完全免费的短信验证码服务，顶级通道3秒下发，适用于登录注册、找回密码、支付认证等场景。我们将依据MobTech的《隐私政策》来帮助你了解我们需要收集哪些数据。请您详细查看我们的隐私政策，详见：%@",self.url];
    }
    if(![SMSDemoHelper isZhHans])
    {
        return @"You are welcome to use demo provided by mobtech. Smssdk provides developers with a free SMS verification code service. The top channel is issued in 3 seconds, which is suitable for login, password retrieval, payment authentication and other scenarios. We will use mobtech's privacy policy to help you understand what data we need to collect. Please refer to our privacy policy at http://www.mob.com/about/policy for details";
    }
    return @"   欢迎您使用MobTech提供的演示DEMO，SMSSDK为开发者提供完全免费的短信验证码服务，顶级通道3秒下发，适用于登录注册、找回密码、支付认证等场景。我们将依据MobTech的《隐私政策》来帮助你了解我们需要收集哪些数据。请您详细查看我们的隐私政策，详见：http://www.mob.com/about/policy";
}


-(NSString *)getContentPre
{
    if(self.url)
        return self.url;
    return @"http://www.mob.com/about/policy";
}

+(NSString *)getRefuseTitle
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"Disagree";
    }
    return @"拒绝";
}

+(NSString *)getAcceptTitle
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"Agree";
    }
    return @"同意";
}

+(NSString *)getNoQueryTitle
{
    if(![SMSDemoHelper isZhHans])
    {
        return @"Don't show again";
    }
    return @"不再询问";
}

- (void)loadUI
{
    //背景
    UIView *containtView = [[UIView alloc] init];
    containtView.layer.masksToBounds = YES;
    containtView.layer.cornerRadius = 17;
    containtView.translatesAutoresizingMaskIntoConstraints = NO;
    containtView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containtView];
    
    
    //标题
    UILabel * titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = [SMSSDKDemoDialogVC getTitle];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [containtView addSubview:titleLabel];
    
    
    //update date
    UILabel * updateLabel = [UILabel new];
    updateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    updateLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    updateLabel.textAlignment = NSTextAlignmentCenter;
    updateLabel.backgroundColor = [UIColor clearColor];
    updateLabel.font = [UIFont systemFontOfSize:14];
    updateLabel.text = [SMSSDKDemoDialogVC getUpdateDate];
    [containtView addSubview:updateLabel];
    
    //effectiveDate
    UILabel *effectiveLabel = [UILabel new];
    effectiveLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    effectiveLabel.textAlignment = NSTextAlignmentCenter;
    effectiveLabel.translatesAutoresizingMaskIntoConstraints = NO;
    effectiveLabel.backgroundColor = [UIColor whiteColor];
    effectiveLabel.font = [UIFont systemFontOfSize:14];
    effectiveLabel.text = [SMSSDKDemoDialogVC getEffectiveDate];
    [containtView addSubview:effectiveLabel];
    
    //内容
    UITextView * contentLabel = [UITextView new];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.delegate = self;
    contentLabel.editable = NO;
    [containtView addSubview:contentLabel];
    
    UIButton *refuseBtn = [[UIButton alloc] init];
    refuseBtn.layer.masksToBounds = YES;
    refuseBtn.layer.cornerRadius = 17;
    refuseBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [refuseBtn setTitle:[SMSSDKDemoDialogVC getRefuseTitle] forState:UIControlStateNormal];
    [refuseBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [refuseBtn addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [containtView addSubview:refuseBtn];
    
    refuseView = refuseBtn;
    
    
    UIButton *acceptBtn = [[UIButton alloc] init];
    acceptBtn.layer.masksToBounds = YES;
    acceptBtn.layer.cornerRadius = 17;
    acceptBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [acceptBtn setTitle:[SMSSDKDemoDialogVC getAcceptTitle] forState:UIControlStateNormal];
    [acceptBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    acceptBtn.backgroundColor = [UIColor colorWithRed:8/255.0 green:151/255.0 blue:156/255.0 alpha:1];
    acceptBtn.selected = YES;
    [acceptBtn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [containtView addSubview:acceptBtn];
    
    acceptView = acceptBtn;
    
    
    if(window.frame.size.width > window.frame.size.height)
    {
        
    }
    else
    {
        //竖屏
        float widthMut = [MOBFDevice isPad]?0.4f:0.86f;
        
        //计算 string 的高度
        float contentheight = [[self generateAttStr:self.url] boundingRectWithSize:CGSizeMake(widthMut*([UIScreen mainScreen].bounds.size.width-40), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height+5;
        
        contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:8/255.0 green:151/255.0 blue:156/255.0 alpha:1]};

        
        //背景layout
        {
            NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:containtView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
            NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:containtView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:containtView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:widthMut constant:0];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:containtView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200+contentheight];
            
            [self.view addConstraint:centerX];
            [self.view addConstraint:centerY];
            [self.view addConstraint:width];
            [containtView addConstraint:height];
        }
        
        {
            NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeTop multiplier:1.0f constant:15];
            NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
            
            
            [containtView addConstraint:top];
            [containtView addConstraint:left];
            [containtView addConstraint:width];
            [containtView addConstraint:right];
        }
        
        //updateLabel
        {
            
            NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:updateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeTop multiplier:1.0f constant:50];
            NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:updateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint * right= [NSLayoutConstraint constraintWithItem:updateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:updateLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
            
            
            [containtView addConstraint:top];
            [containtView addConstraint:right];
            [containtView addConstraint:left];
            [updateLabel addConstraint:height];
        }
        
        //effectiveLabel
        {
            NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:effectiveLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeTop multiplier:1.0f constant:75];
            NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:effectiveLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint * right= [NSLayoutConstraint constraintWithItem:effectiveLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:effectiveLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
            
            
            [containtView addConstraint:top];
            [containtView addConstraint:right];
            [containtView addConstraint:left];
            [effectiveLabel addConstraint:height];
        }
        
        //content
        {
            contentLabel.attributedText = [self generateAttStr:self.url];
            
            NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
            NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
            NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:contentheight+26];
            
            
            [containtView addConstraint:top];
            [containtView addConstraint:left];
            [containtView addConstraint:right];
            [contentLabel addConstraint:height];
        }
        
        {
            refuseBtn.backgroundColor = [UIColor colorWithRed:235/255.0 green:234/255.0 blue:236/255.0 alpha:1];

            NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:refuseBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-15];
            NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:refuseBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:refuseBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:38];
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:refuseBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0];
            
            
            [containtView addConstraint:bottom];
            [containtView addConstraint:centerX];
            [containtView addConstraint:width];
            [refuseBtn addConstraint:height];
        }
        
        {
            NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:acceptBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-15];
            NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:acceptBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:acceptBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:38];
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:acceptBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0];

            
            [containtView addConstraint:bottom];
            [containtView addConstraint:centerX];
            [containtView addConstraint:width];
            [acceptBtn addConstraint:height];
        }
        
        
    }
}


-(NSMutableAttributedString *)generateAttStr:(NSString *)url
{
    NSString *content = [self getContent];
    NSString *contentPre = [self getContentPre];
    
    NSRange range =  [content rangeOfString:contentPre];
    
    float fontSize = 14.0;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    if(range.location !=NSNotFound)
    {
        
        //段落样式
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        paraStyle.lineSpacing = 5.0;
        
        
        [attr addAttributes:@{
                              NSParagraphStyleAttributeName:paraStyle,
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:fontSize]
                              } range:NSMakeRange(0, content.length)];
        
        [attr addAttributes:@{
                              NSForegroundColorAttributeName:[UIColor colorWithRed:8/255.0 green:151/255.0 blue:156/255.0 alpha:1],
                              NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize],
                              NSLinkAttributeName:contentPre
                              } range:range];

    }
    
    return attr;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if([URL.absoluteString isEqualToString:[self getContentPre]])
    {
        SMSDemoPolicyWebVC *vc = [[SMSDemoPolicyWebVC alloc] init];
        vc.url = URL.absoluteString;
        [self.navigationController pushViewController:vc animated:YES];
        vc.title = [SMSSDKDemoDialogVC getTitle];
        return NO;
    }
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return _isPortait?UIInterfaceOrientationMaskPortrait:UIInterfaceOrientationMaskLandscape;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return _isPortait?UIInterfaceOrientationPortrait:UIInterfaceOrientationLandscapeLeft;
}

@end

@interface SMSDemoPolicyManager ()

@property (nonatomic, weak) UIViewController *curVC;
@property (nonatomic, copy)SMSDemoPolicyAcceptHandler acceptBlock;


@end

@implementation SMSDemoPolicyManager



+ (instancetype)defaultManager
{
    static SMSDemoPolicyManager *_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[SMSDemoPolicyManager alloc] init];
    });
    return _instance;
}




+(void)show:(NSString *)url compeletion:(nullable SMSDemoPolicyAcceptHandler)acceptBlock
{
    BOOL accept = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smsdemo_accept_policy"] boolValue];
    if(accept)
    {
        return;
    }
    
    [[SMSDemoPolicyManager defaultManager] show:url compeletion:acceptBlock];
}

-(void)show:(NSString *)url compeletion:(nullable SMSDemoPolicyAcceptHandler)acceptBlock
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(window != nil)
        {
            window.hidden = YES;
            window = nil;
        }
        
        SMSSDKDemoDialogVC *vc = [[SMSSDKDemoDialogVC alloc] init];
        vc.acceptBlock = acceptBlock;
        vc.url = url;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
        {
            vc.isPortait = NO;
        }
        else
        {
            vc.isPortait = YES;
        }
        
        self.curVC = vc;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        navVC.navigationBarHidden = YES;
        
        //弹窗
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        window.rootViewController = navVC;
        window.windowLevel = UIWindowLevelAlert+10;
        window.hidden = NO;
        
    });
}




@end
