//
//  InvitationViewControllerEx.m
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-7-15.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "InvitationViewControllerEx.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>

@interface InvitationViewControllerEx ()
{
    NSString* _name;
    NSString* _phone;
    NSString* _phone2;
}

@end

@implementation InvitationViewControllerEx

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

-(void)setData:(NSString *)name
{
    _name = name;
}

-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2
{
    _phone = phone;
    _phone2 = phone2;
}

-(void)sendInvite
{
    //发送短信
    NSLog(@"send invitational message");
    if ([_phone2 length]>0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:NSLocalizedString(@"choosephonenumber", nil)
                                                     delegate:self
                                            cancelButtonTitle:_phone
                                            otherButtonTitles:_phone2, nil];
        [alert show];
    }
    else
    {
        [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
    if (0 == buttonIndex)
    {
        [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _name;
    cell.imageView.image = [UIImage imageNamed:@"2.png"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"phonecode", nil),_phone?_phone:@"",_phone2?_phone2:@""];
    
    return cell;
}

#pragma mark TableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0 + statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + statusBarHeight, self.view.frame.size.width, 80) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:NSLocalizedString(@"sendinvite", nil) forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.frame = CGRectMake(15, 198 + statusBarHeight, self.view.frame.size.width - 30, 42);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 146 + statusBarHeight, self.view.frame.size.width, 27);
    label.text = [NSString stringWithFormat:@"%@%@",_name,NSLocalizedString(@"notjoined", nil)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:13];
    [self.view addSubview:label];

}
@end
