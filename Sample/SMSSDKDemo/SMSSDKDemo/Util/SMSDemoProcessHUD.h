//
//  BBSUIProcessHUD.h
//  BBSSDKUI
//
//  Created by youzu_Max on 2017/4/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSDemoProcessHUD : NSObject

+ (void) showSuccessInfo:(NSString *)info;

+ (void) showFailInfo:(NSString *)info;

+ (void) showProcessHUDWithInfo:(NSString *)info;

+ (void) showMsgHUDWithInfo:(NSString *)info;


+ (void) dismiss;

+ (void) dismissWithResult:(void (^)())result;

+ (void) dismissWithDelay:(NSTimeInterval)second result:(void(^)())result;

@end
