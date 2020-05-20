//
//  SMSSDKUIBaseViewController.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/13.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSSDKUIBaseViewController.h"

@interface SMSSDKUIBaseViewController ()

@end

@implementation SMSSDKUIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBack
{
    NSString *path = [SMSSDKUIBundle pathForResource:@"back" ofType:@"png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)dismiss:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
