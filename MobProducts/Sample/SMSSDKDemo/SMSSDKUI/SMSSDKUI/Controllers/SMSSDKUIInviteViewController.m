//
//  SMSSDKUIInviteViewController.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/8.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIInviteViewController.h"
#import <SMS_SDK/SMSSDKAddressBook.h>
#import <MessageUI/MessageUI.h>

@interface SMSSDKUIInviteViewController ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) SMSSDKAddressBook *contact;

@end

@implementation SMSSDKUIInviteViewController

- (instancetype)initWithContact:(SMSSDKAddressBook *)contact
{
    if (self = [super init])
    {
        _contact = contact;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 0, 0)];
    nameLabel.text = _contact.name;
    nameLabel.font = [UIFont systemFontOfSize:17];
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    UILabel *lastPhoneLabel;
    for (NSInteger i=0; i<_contact.phonesEx.count; i++)
    {
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(nameLabel.frame)+(5+15)*i+5, self.view.frame.size.width-40, 15)];
        phoneLabel.text = [NSString stringWithFormat:@"%@:%@",SMSLocalized(@"phonecode"),_contact.phones];
        phoneLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:phoneLabel];
        if (i==_contact.phonesEx.count-1)
        {
            lastPhoneLabel = phoneLabel;
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lastPhoneLabel.frame)+20, self.view.frame.size.width-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    [self.view addSubview:line];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = [UIFont systemFontOfSize:14];
    alertLabel.text = [_contact.name stringByAppendingFormat:@" %@",SMSLocalized(@"notjoined")];
    [alertLabel sizeToFit];
    alertLabel.center = CGPointMake(self.view.center.x, CGRectGetMaxY(line.frame)+33);
    [self.view addSubview:alertLabel];
    
    
    UIButton *sendInvite = [UIButton buttonWithType:UIButtonTypeSystem];
    sendInvite.frame = CGRectMake(20, CGRectGetMaxY(alertLabel.frame)+33, self.view.frame.size.width - 40, 44);
    [sendInvite setTitle:SMSLocalized(@"sendinvite") forState:UIControlStateNormal];
    NSString *path = [SMSSDKUIBundle pathForResource:@"button4" ofType:@"png"];
    [sendInvite setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:path] forState:UIControlStateNormal];

    [sendInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendInvite addTarget:self action:@selector(sendInvite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendInvite];

}

- (void)sendInvite:(id)sender
{
    if (_contact.phonesEx.count > 1)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:SMSLocalized(@"notice") message:SMSLocalized(@"choosephonenumber") preferredStyle:UIAlertControllerStyleAlert];
        
        for (NSInteger i=0; i<_contact.phonesEx.count; i++)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:_contact.phonesEx[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self sendMessageTo:_contact.phonesEx[i]];
            }];
            [alert addAction:action];
        }
        
        UIAlertAction *cancel  = [UIAlertAction actionWithTitle:SMSLocalized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self sendMessageTo:_contact.phones];
    }
}

- (void)sendMessageTo:(NSString *)phone
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        messageVC.recipients = @[phone];
        messageVC.body = SMSLocalized(@"smsmessage");
        [self.navigationController presentViewController:messageVC animated:YES completion:nil];
    }
    else
    {
        SMSSDKAlert(@"%@",SMSLocalized(@"deviceFoundation"));
    }
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            SMSUILog(@"Send the invitation to cancel !");
            break;
        case MessageComposeResultSent:
            SMSUILog(@"Already send the invitation !");
            break;
        case MessageComposeResultFailed:
            SMSUILog(@"Send the invitation failure !");
            break;
            
        default:
            break;
    }
}

@end
