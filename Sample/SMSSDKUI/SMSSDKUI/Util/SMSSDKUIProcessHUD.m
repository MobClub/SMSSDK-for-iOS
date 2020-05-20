//
//  BBSUIProcessHUD.m
//  BBSSDKUI
//
//  Created by youzu_Max on 2017/4/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "SMSSDKUIProcessHUD.h"

typedef NS_ENUM(NSUInteger, SMSSDKUIProcessHUDStyle)
{
    SMSSDKUIProcessHUDStyleDefault = 0,  //默认
    SMSSDKUIProcessHUDStyleMsg = 1 //文本显示
};

@interface SMSSDKUIProcessHUD()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIImageView *processView;
@property (nonatomic, strong) UIImage *failedImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIActivityIndicatorView *inditorView;

@end

@implementation SMSSDKUIProcessHUD

+ (instancetype)shareInstance
{
    static SMSSDKUIProcessHUD *shareInstance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SMSSDKUIProcessHUD alloc] init];
    });
    return shareInstance ;
}

- (void)setup
{
    self.window =
    ({
        NSArray *windows = [UIApplication sharedApplication].windows;
        int level = 0;
        for (UIWindow *window in windows) {
            level = window.windowLevel>level?window.windowLevel:level;
        }
        
//        level = [UIApplication sharedApplication].keyWindow.windowLevel;
        
        CGSize size = [UIScreen mainScreen].bounds.size ;
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake((size.width-179)/2.0,size.height/2.0-109,179, 109)];
        window.backgroundColor = [UIColor clearColor];
        window.windowLevel = level + 1 ;
//        window.windowLevel = UIWindowLevelAlert + 1 ;

        window;
    });

    self.backgroundView =
    ({
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, 179, 109);
        effectview.layer.cornerRadius = 12;
        effectview.layer.masksToBounds = YES;
        effectview.alpha = 0.75;
        [_window addSubview:effectview];
        effectview;
    });
    
    self.successImage =
    ({
        NSString *successImagePath = [SMSSDKUIBundle pathForResource:@"success@3x" ofType:@"png"];
        UIImage *successImage = [[UIImage alloc] initWithContentsOfFile:successImagePath];
        successImage ;
    });

    self.failedImage =
    ({
        NSString *errorImagePath = [SMSSDKUIBundle pathForResource:@"error@3x" ofType:@"png"];
        UIImage *failedImage = [[UIImage alloc] initWithContentsOfFile:errorImagePath];
        failedImage;
    });
    
    self.processView =
    ({
        UIImageView *processView = [[UIImageView alloc] initWithImage:_successImage];
        processView.center = _backgroundView.center;
        [_backgroundView.contentView addSubview:processView];
        processView;
    });

    self.alertLabel =
    ({
        UILabel *alertLabel = [[UILabel alloc] init];
        alertLabel.text = @"" ;
        alertLabel.textColor = [UIColor blackColor];
        alertLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        alertLabel.frame = CGRectMake(0, 0, 155, 44);
        alertLabel.center = CGPointMake(90,88);
        alertLabel.numberOfLines = 0;
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView.contentView addSubview:alertLabel];;
        alertLabel;
    });
    
    self.inditorView =
    ({
        UIActivityIndicatorView *inditorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        inditorView.center = _processView.center;
        inditorView.color = [UIColor blackColor];
        
        [_backgroundView.contentView addSubview:inditorView];
        inditorView;
    });
}

+ (void) showSuccessInfo:(NSString *)info
{
    SMSSDKUIProcessHUD *hud = [SMSSDKUIProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }

    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(90,88);
    
    hud.processView.image = hud.successImage;
    
    if (hud.processView.isHidden)
    {
        hud.processView.hidden = NO;
    }
    
    if (!hud.inditorView.isHidden)
    {
        hud.inditorView.hidden = YES;
    }
    
    if (hud.inditorView.isAnimating)
    {
         [hud.inditorView stopAnimating];
    }
    
    [hud.window makeKeyAndVisible];
}

+ (void) showFailInfo:(NSString *)info
{
    SMSSDKUIProcessHUD *hud = [SMSSDKUIProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(90,88);
    
    hud.processView.image = hud.failedImage;
    
    if (hud.processView.isHidden)
    {
        hud.processView.hidden = NO;
    }
    
    if (!hud.inditorView.isHidden)
    {
        hud.inditorView.hidden = YES;
    }
    
    if (hud.inditorView.isAnimating)
    {
        [hud.inditorView stopAnimating];
    }
    
    [hud.window makeKeyAndVisible];
}

+ (void) showProcessHUDWithInfo:(NSString *)info
{
    SMSSDKUIProcessHUD *hud = [SMSSDKUIProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(90,88);
    
    if (!hud.processView.isHidden)
    {
        hud.processView.hidden = YES;
    }
    
    if (hud.inditorView.isHidden)
    {
        hud.inditorView.hidden = NO;
    }
    
    if (!hud.inditorView.isAnimating)
    {
        [hud.inditorView startAnimating];
    }
    
    [hud.window makeKeyAndVisible];
}

+ (void) showMsgHUDWithInfo:(NSString *)info
{
    SMSSDKUIProcessHUD *hud = [SMSSDKUIProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    [self resetViewFrame:hud style:SMSSDKUIProcessHUDStyleMsg];
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(hud.backgroundView.frame.size.width/2.0,hud.backgroundView.frame.size.height/2.0);
    hud.processView.hidden = YES;
    hud.inditorView.hidden = YES;
    [hud.window makeKeyAndVisible];

}

+ (void) dismiss
{
    [[SMSSDKUIProcessHUD shareInstance].window resignKeyWindow];
    [SMSSDKUIProcessHUD shareInstance].window = nil;
}

+ (void)dismissWithResult:(void (^)())result
{
    [self dismiss];
    if (result)
    {
        result();
    }
}

+ (void)dismissWithDelay:(NSTimeInterval)second result:(void (^)())result
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismissWithResult:result];
    });
}

+ (void)resetViewFrame:(SMSSDKUIProcessHUD *)hud style:(SMSSDKUIProcessHUDStyle)style
{
    CGSize size = [UIScreen mainScreen].bounds.size ;
    if(style == SMSSDKUIProcessHUDStyleDefault)
    {
        hud.window.frame = CGRectMake((size.width-179)/2.0,size.height/2.0-109,179, 109);
        hud.backgroundView.frame = CGRectMake(0, 0, 179, 109);
        hud.processView.center = hud.backgroundView.center;
        hud.alertLabel.frame = CGRectMake(0, 0, 155, 44);
        
    }
    else if(style == SMSSDKUIProcessHUDStyleMsg)
    {
        hud.window.frame = CGRectMake((size.width-261)/2.0,size.height/2.0-55,261, 55);
        hud.backgroundView.frame = CGRectMake(0, 0, 261, 55);
        hud.processView.center = hud.backgroundView.center;
        hud.alertLabel.frame = CGRectMake(0, 0, 261, 55);
    }
    
}

@end
