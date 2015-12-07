//
//  RegisterByVoiceCallViewController.h
//  SMS_SDKDemo
//
//  Created by ljh on 1/24/15.
//  Copyright (c) 2015 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"

@protocol SecondViewControllerDelegate;

@interface RegisterByVoiceCallViewController : UIViewController
<
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
SecondViewControllerDelegate,
UITextFieldDelegate
>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UITextField* telField;
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong) UIButton* next;

-(void)nextStep;

@end
