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
    
    self.title = SMSLocalized(@"invitefriends");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SMSLocalized(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.view.frame.size.width-40, 36)];
    nameLabel.text = _contact.name;
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:36];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = SMSCommonColor();
    [self.view addSubview:nameLabel];
    
    UILabel *lastPhoneLabel;
    UIView *lastLine;
    for (NSInteger i=0; i<_contact.phonesEx.count; i++)
    {
        
        UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(nameLabel.frame)+(5+45)*i+20, self.view.frame.size.width-40, 45)];
        phoneTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [self.view addSubview:phoneTitle];
        
        if(i ==0)
        {
            phoneTitle.text = SMSLocalized(@"phonecode");
        }
        else
        {
            phoneTitle.text = [NSString stringWithFormat:@"%@%zd",SMSLocalized(@"phonecode"),i+1];
        }
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200 - 15,CGRectGetMinY(phoneTitle.frame), 200, 45)];
        phoneLabel.text = _contact.phones;
        phoneLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        phoneLabel.textColor = SMSRGB(0xC7C7C7);
        phoneLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:phoneLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneLabel.frame) - 1, self.view.frame.size.width-30, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5;
        [self.view addSubview:line];
        
        if (i==_contact.phonesEx.count-1)
        {
            lastPhoneLabel = phoneLabel;
            lastLine = line;
        }
        

    }
    
    
    UIButton *sendInvite = [UIButton buttonWithType:UIButtonTypeSystem];
    sendInvite.frame = CGRectMake(20, CGRectGetMaxY(lastLine.frame)+25, self.view.frame.size.width - 40, 44);
    [sendInvite setTitle:SMSLocalized(@"sendinvite") forState:UIControlStateNormal];
    [sendInvite setBackgroundColor:SMSRGB(0x00D69C)];
    [sendInvite.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    sendInvite.layer.cornerRadius = 4;
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
    if (!phone)
    {
        SMSSDKAlert(@"phone is nil");
        return;
    }
    
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

- (void)dismiss:(id)sender
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
