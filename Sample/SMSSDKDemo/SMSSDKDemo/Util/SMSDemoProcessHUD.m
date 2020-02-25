//
//  BBSUIProcessHUD.m
//  BBSSDKUI
//
//  Created by youzu_Max on 2017/4/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "SMSDemoProcessHUD.h"
#import "SMSDemoDefines.h"

typedef NS_ENUM(NSUInteger, SMSDemoProcessHUDStyle)
{
    SMSDemoProcessHUDStyleDefault = 0,  //默认
    SMSDemoProcessHUDStyleMsg = 1 //文本显示
};

@interface SMSDemoProcessHUD()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIImageView *processView;
@property (nonatomic, strong) UIImage *failedImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIActivityIndicatorView *inditorView;

@end

@implementation SMSDemoProcessHUD

+ (instancetype)shareInstance
{
    static SMSDemoProcessHUD *shareInstance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SMSDemoProcessHUD alloc] init];
    });
    return shareInstance ;
}

- (void)setup
{
    self.window =
    ({
        NSArray *windows = [UIApplication sharedApplication].windows;
        int level = 0;
//        for (UIWindow *window in windows) {
//            level = window.windowLevel>level?window.windowLevel:level;
//        }
        
        level = [UIApplication sharedApplication].keyWindow.windowLevel;
        
        CGSize size = [UIScreen mainScreen].bounds.size ;
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake((size.width-179)/2.0,size.height/2.0-109,179, 109)];
        window.backgroundColor = [UIColor clearColor];
        window.windowLevel = level + 1 ;
        window;
    });

    self.backgroundView =
    ({
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIView *effectview = [[UIView alloc] init];
        effectview.backgroundColor = SMSDemoRGBA(234, 245, 246, 0.8);
        effectview.frame = CGRectMake(0, 0, 179, 109);
        effectview.layer.cornerRadius = 12;
        effectview.layer.masksToBounds = YES;
        effectview.alpha = 1;
        [_window addSubview:effectview];
        effectview;
    });
    
    self.successImage =
    ({
        NSString *successImagePath = [SMSDemoUIBundle pathForResource:@"success@3x" ofType:@"png"];
        UIImage *successImage = [[UIImage alloc] initWithContentsOfFile:successImagePath];
        successImage ;
    });

    self.failedImage =
    ({
        NSString *errorImagePath = [SMSDemoUIBundle pathForResource:@"error@3x" ofType:@"png"];
        UIImage *failedImage = [[UIImage alloc] initWithContentsOfFile:errorImagePath];
        failedImage;
    });
    
    self.processView =
    ({
        UIImageView *processView = [[UIImageView alloc] initWithImage:_successImage];
//        processView.center = _backgroundView.center;
        [_backgroundView addSubview:processView];
        
        CGPoint point = _backgroundView.center;
        processView.center = CGPointMake(point.x, _backgroundView.frame.size.height / 4.0);

        
        processView;
    });

    self.alertLabel =
    ({
        UILabel *alertLabel = [[UILabel alloc] init];
        alertLabel.text = @"" ;
        alertLabel.textColor = SMSDemoRGBA(59, 151, 157, 1);
        alertLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        alertLabel.frame = CGRectMake(0, 0, 155, 44);
        alertLabel.center = CGPointMake(90,88);
        alertLabel.numberOfLines = 0;
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView addSubview:alertLabel];;
        alertLabel;
    });
    
    self.inditorView =
    ({
        UIActivityIndicatorView *inditorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        inditorView.center = _processView.center;
        inditorView.color = [UIColor blackColor];
        
        [_backgroundView addSubview:inditorView];
        inditorView;
    });
}

+ (void) showSuccessInfo:(NSString *)info
{
    SMSDemoProcessHUD *hud = [SMSDemoProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }

    hud.alertLabel.text = info;
//    hud.alertLabel.center = CGPointMake(90,88);

    hud.alertLabel.center = CGPointMake(hud.backgroundView.frame.size.width/2.0,hud.backgroundView.frame.size.height/2.0 + 10);

    
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
    SMSDemoProcessHUD *hud = [SMSDemoProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(90,88);
    
    
    hud.alertLabel.center = CGPointMake(hud.backgroundView.frame.size.width/2.0,hud.backgroundView.frame.size.height/2.0 + 10);

    
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
    SMSDemoProcessHUD *hud = [SMSDemoProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(90,88);
    hud.alertLabel.center = CGPointMake(hud.backgroundView.frame.size.width/2.0,hud.backgroundView.frame.size.height/2.0 + 10);

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
    SMSDemoProcessHUD *hud = [SMSDemoProcessHUD shareInstance];
    
    if(!hud.window)
    {
        [hud setup];
    }
    
    [self resetViewFrame:hud style:SMSDemoProcessHUDStyleMsg];
    
    hud.alertLabel.text = info;
    hud.alertLabel.center = CGPointMake(hud.backgroundView.frame.size.width/2.0,hud.backgroundView.frame.size.height/2.0);
    hud.processView.hidden = YES;
    hud.inditorView.hidden = YES;
    [hud.window makeKeyAndVisible];

}

+ (void) dismiss
{
    [[SMSDemoProcessHUD shareInstance].window resignKeyWindow];
    [SMSDemoProcessHUD shareInstance].window = nil;
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

+ (void)resetViewFrame:(SMSDemoProcessHUD *)hud style:(SMSDemoProcessHUDStyle)style
{
    CGSize size = [UIScreen mainScreen].bounds.size ;
    if(style == SMSDemoProcessHUDStyleDefault)
    {
        hud.window.frame = CGRectMake((size.width-179)/2.0,size.height/2.0-109,179, 109);
        hud.backgroundView.frame = CGRectMake(0, 0, 179, 109);
        hud.processView.center = hud.backgroundView.center;
        hud.alertLabel.frame = CGRectMake(0, 0, 155, 44);
        
        CGPoint point = hud.backgroundView.center;
        hud.processView.center = CGPointMake(point.x, hud.backgroundView.frame.size.height / 4.0);

    }
    else if(style == SMSDemoProcessHUDStyleMsg)
    {
        hud.window.frame = CGRectMake((size.width-261)/2.0,size.height/2.0-55,261, 55);
        hud.backgroundView.frame = CGRectMake(0, 0, 261, 55);
//        hud.processView.center = hud.backgroundView.center;
        hud.alertLabel.frame = CGRectMake(0, 0, 261, 55);
        
        CGPoint point = hud.backgroundView.center;
        hud.processView.center = CGPointMake(point.x, hud.backgroundView.frame.size.height / 4.0);
    }
    
}

@end
