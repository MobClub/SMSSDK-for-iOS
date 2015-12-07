//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "SMS_MBProgressHUD+Add.h"

@implementation SMS_MBProgressHUD (Add)
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    // 快速显示一个提示信息
    SMS_MBProgressHUD *hud = [SMS_MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = error;
    // 设置图片
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_failed_icon.png"]] autorelease];
    // 再设置模式
    hud.mode = SMS_MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark 显示一些信息
+ (SMS_MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    // 快速显示一个提示信息
    SMS_MBProgressHUD *hud = [SMS_MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    //hud.dimBackground = YES;
    
    // 3秒之后再消失
    [hud hide:YES afterDelay:3];
    
    return hud;
}
@end
