//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "SMS_MBProgressHUD.h"

@interface SMS_MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (SMS_MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end
