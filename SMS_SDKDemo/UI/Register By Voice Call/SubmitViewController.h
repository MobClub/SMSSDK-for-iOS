//
//  SubmitViewController.h
//  SMS_SDKDemo
//
//  Created by ljh on 2/4/15.
//  Copyright (c) 2015 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMSSDKUserInfo.h>

@interface SubmitViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic,strong)  UILabel* telLabel;
@property(nonatomic,strong)  UITextField* verifyCodeField;
@property(nonatomic,strong)  UILabel* timeLabel;
@property(nonatomic,strong)  UIButton* repeatSMSBtn;
@property(nonatomic,strong)  UIButton* submitBtn;
@property(nonatomic,assign) NSString* isVerify;

-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode;
-(void)submit;
-(void)CannotGetSMS;

@end
