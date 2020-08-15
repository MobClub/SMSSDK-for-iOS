//
//  HomeVC.m
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import "HomeVC.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import "SMSDemoCommitCodeVC.h"
#import "SMSDemoDefines.h"
#import "SMSDemoResultVC.h"
#import "SMSDemoPolicyManager.h"
#import <MOBFoundation/MobSDK+Privacy.h>

@interface HomeVC ()

@property (nonatomic,weak) IBOutlet UIButton *startBtn;

//版本号
@property (nonatomic, strong) IBOutlet UILabel *versionLbl;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.navigationController.navigationBar setHidden:YES];
    
    _startBtn.layer.cornerRadius = 20;
    _startBtn.layer.masksToBounds = YES;
    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:149/255.0 blue:152/255.0 alpha:1]];
    
    _versionLbl.text = [NSString stringWithFormat:@"%@ %@",SMSDemoLocalized(@"curversion"),[SMSSDK sdkVersion]];
    
    [_startBtn setTitle:SMSDemoLocalized(@"startverify") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


static BOOL hasShow = NO;
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!hasShow)
    {
        hasShow = YES;

        //获取隐私协议
        [MobSDK getPrivacyPolicy:@"1" language:@"zh" compeletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {

            NSString *url = data[@"content"];
            if(url)
            {
                [SMSDemoPolicyManager show:url compeletion:^(BOOL accept) {
                    //是否接受隐私协议
                    [MobSDK uploadPrivacyPermissionStatus:accept onResult:^(BOOL success) {

                    }];

                }];
            }

        }];

    }
}

-(IBAction)start:(id)sender
{
    SMSDemoCommitCodeVC *vc = [[SMSDemoCommitCodeVC alloc] initWithMethod:SMSGetCodeMethodSMS template:nil result:^(NSDictionary * _Nonnull dict, NSError * _Nonnull error) {
        
        if(!error)
        {
            NSString *rstPhone = [NSString stringWithFormat:@"+%@ %@",dict[@"zone"],dict[@"phone"]];
            SMSDemoResultVC *vc = [[SMSDemoResultVC alloc] initWithType:0 phone:rstPhone des:nil];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
            
            //提交用户信息
            SMSSDKUserInfo *user = [[SMSSDKUserInfo alloc] init];
            user.phone = dict[@"phone"];
            user.zone = dict[@"zone"];
            [SMSSDK submitUserInfo:user result:^(NSError *error) {
                
            }];
        }
        
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];

}


-(IBAction)swithUIStyle:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"smsdemo_oldui"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
