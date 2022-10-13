//
//  SMSSDKUIBindUserInfoViewController.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/7.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSSDKUIBindUserInfoViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import "SMSSDKUIProcessHUD.h"
#import "SMSGlobalManager.h"
#import "SMSSDKAvatarSelectViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "SMSSDKUIHelper.h"


@interface SMSSDKUIBindUserInfoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *iconDesLabel;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *nickNameDesLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView *nickNameEditView;
@property (nonatomic, strong) UITextField *nickNameTextField;

@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic, assign) BOOL willShow;

@end

@implementation SMSSDKUIBindUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(self.willShow == NO)
    {
        CGRect rect = self.headView.frame;
        
        [UIView animateWithDuration:duration animations:^{
            
            self.headView.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);

        }];
    }
    else
    {
        CGRect rect = self.headView.frame;
        [UIView animateWithDuration:duration animations:^{
            
            self.headView.frame = CGRectMake(rect.origin.x, -frame.size.height / 2.0, rect.size.width, rect.size.height);
            
        }];
    }

}


- (void)configUI
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    

    
    
    
    self.headView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_headView];
    
    self.titleLabel =
    ({
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 26)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = SMSLocalized(@"fillyourinfo");
        [self.headView addSubview:titleLabel];
        
        titleLabel;
    });

    self.iconImageView =
    ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake((self.view.frame.size.width - 120)/2.0, CGRectGetMaxY(self.titleLabel.frame) + 30, 120, 120);
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2.0;
        imageView.clipsToBounds = YES;
        
        NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        [self.headView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAvatar:)];
        
        [imageView addGestureRecognizer:tap];
        
        
        self.iconDesLabel =
        ({
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,50 , imageView.frame.size.width, 14)];
            titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = SMSRGB(0xC7C7C7);
            titleLabel.text = SMSLocalized(@"avatarchoose");
            [imageView addSubview:titleLabel];
            
            titleLabel;
        });

        
        imageView;
    });
    
    
    
    
    UIView *lastLine = nil;
    self.nickNameEditView =
    ({
        UIView *nickNameEditView = [[UIView alloc] initWithFrame:CGRectMake(20,  CGRectGetMaxY(self.iconImageView.frame) + 45 , self.view.frame.size.width - 40, 42 + StatusBarHeight/4)];
        
        
        self.nickNameDesLabel =
        ({
            UILabel *zone = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, (self.view.frame.size.width - 30)/4, 40 + StatusBarHeight/4)];
            zone.text = SMSLocalized(@"nickname");
            zone.textAlignment = NSTextAlignmentLeft;
            zone.font = [UIFont fontWithName:@"Helvetica" size:14];
            [nickNameEditView addSubview:zone];
            zone;
        });
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameDesLabel.frame)+1, 1, 1, _nickNameDesLabel.frame.size.height)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        verticalLine.hidden = YES;
        [nickNameEditView addSubview:verticalLine];
        
        self.nickNameTextField =
        ({
            UITextField *nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame)+15, 1, (self.view.frame.size.width - 30)*3/4 - 20, verticalLine.frame.size.height)];
            nickNameTextField.placeholder = SMSLocalized(@"nicknamefield");
            nickNameTextField.keyboardType = UIKeyboardTypeDefault;
            nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [nickNameTextField setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [nickNameEditView addSubview:nickNameTextField];
            nickNameTextField.delegate = self;
            
            nickNameTextField;
        });
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, nickNameEditView.frame.size.height-1, nickNameEditView.frame.size.width, 1)];
        bottomLine.backgroundColor = SMSRGB(0xE0E0E6);
        [nickNameEditView addSubview:bottomLine];
        
        [self.headView addSubview:nickNameEditView];
        nickNameEditView ;
    });
    
    
    
    UIButton *sendInvite = [UIButton buttonWithType:UIButtonTypeSystem];
    sendInvite.frame = CGRectMake(20, CGRectGetMaxY(self.nickNameEditView.frame)+25, self.view.frame.size.width - 40, 44);
    [sendInvite setTitle:SMSLocalized(@"submitinfo") forState:UIControlStateNormal];
    [sendInvite setBackgroundColor:SMSRGB(0x00D69C)];
    sendInvite.layer.cornerRadius = 4;
    [sendInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendInvite addTarget:self action:@selector(submitUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [sendInvite.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [self.headView addSubview:sendInvite];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked:)];
    
    [self.headView addGestureRecognizer:tap];
    
}

- (void)dismiss:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAvatar:(id)sender
{
    self.willShow = NO;
    [self.nickNameTextField resignFirstResponder];

    __weak typeof(self) weakSelf = self;
    SMSSDKAvatarSelectViewController *vc = [SMSSDKAvatarSelectViewController new];
    
    [vc setItemSeletectedBlock:^(NSString *avatarPath) {
        weakSelf.avatarUrl = avatarPath;
        
        
        [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:avatarPath] result:^(UIImage *image, NSError *error) {
            if (image && !error)
            {
                weakSelf.iconImageView.image = image;
                weakSelf.iconDesLabel.hidden = YES;
            }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bgClicked:(id)sender
{
    self.willShow = NO;

    [self.nickNameTextField resignFirstResponder];
}

- (void)submitUserInfo:(id)sender
{
    
    

    NSString *nickanme = nil;

//    if(self.nickNameTextField.text.length == 0)
//    {
//        [SMSSDKUIProcessHUD showFailInfo:SMSLocalized(@"empty")];
//        [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
//
//        }];
//        return;
//    }
    
    self.willShow = NO;
    [self.nickNameTextField resignFirstResponder];

    
    if (self.nickNameTextField.text.length > self.nameLimitLength) {
        self.nickNameTextField.text = [self.nickNameTextField.text substringToIndex:self.nameLimitLength];
    }
    
    //nickanme
    nickanme = self.nickNameTextField.text;
    
    __weak typeof(self) weakSelf = self;
    SMSSDKUserInfo *userInfo = [[SMSGlobalManager sharedManager] copyUserInfo];
    userInfo.avatar = self.avatarUrl;
    userInfo.nickname = nickanme;
    
    [SMSSDK submitUserInfo:userInfo result:^(NSError *error) {
        if (!error)
        {
            SMSSDKAlert(@"提交成功");
            
            SMSSDKUserInfo *curUserInfo = [[SMSGlobalManager sharedManager] curUserInfo];
            curUserInfo.avatar = self.avatarUrl;
            curUserInfo.nickname = nickanme;
            [[SMSGlobalManager sharedManager] saveUserInfo];
            
            //返回上一级
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            if(error.code == NSURLErrorNotConnectedToInternet)
            {
                [SMSSDKUIProcessHUD showMsgHUDWithInfo:SMSLocalized(@"nonetwork")];
                [SMSSDKUIProcessHUD dismissWithDelay:1.5 result:^{
                    
                }];
            }
            else
            {
                //SMSSDKAlert(@"提交失败:%@",[SMSSDKUIHelper errorTextWithError:error]);
                SMSSDKAlert(@"%@",[SMSSDKUIHelper errorTextWithError:error]);
            }
        }
        

        
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

- (int)nameLimitLength
{
    return 7;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickNameTextField)
    {
        if (textField.text.length > self.nameLimitLength) {
            textField.text = [textField.text substringToIndex:self.nameLimitLength];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.willShow = YES;
    return YES;
}

@end
