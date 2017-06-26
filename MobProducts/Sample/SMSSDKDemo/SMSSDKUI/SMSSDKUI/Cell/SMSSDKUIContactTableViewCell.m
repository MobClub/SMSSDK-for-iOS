//
//  SMSSDKUIContactTableViewCell.m
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/7.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SMSSDKUIContactTableViewCell.h"
#import <SMS_SDK/SMSSDKAddressBook.h>
#import <MOBFoundation/MOBFoundation.h>

@interface SMSSDKUIContactTableViewCell()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nameDescLabel;
@property (nonatomic, strong) UIButton *inviteBtn;

@end

@implementation SMSSDKUIContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.headIcon =
    ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(15, 5, 50, 50);
        
        NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    self.nameLabel =
    ({
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(73, 19, 200, 20);
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.contentView addSubview:nameLabel];
        nameLabel;
    });
    
    self.nameDescLabel =
    ({
        UILabel *nameDescLabel = [[UILabel alloc] init];
        nameDescLabel.frame = CGRectMake(73, 40, 200, 15);
        nameDescLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self.contentView addSubview:nameDescLabel];
        nameDescLabel;
    });
    
    self.inviteBtn =
    ({
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        inviteBtn.frame = CGRectMake(screenWidth-80, 15, 65, 30);
        [inviteBtn addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [inviteBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[SMSSDKUIBundle pathForResource:@"button3" ofType:@"png"]] forState:UIControlStateNormal];
        [inviteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:inviteBtn];
        inviteBtn;
    });
}

- (void)invite:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickButtonWithInfo:)])
    {
        [_delegate didClickButtonWithInfo:_userInfo ? _userInfo:_contact];
    }
}

- (void)setContact:(SMSSDKAddressBook *)contact
{
    _contact = contact;
    _nameLabel.text = contact.name;
    _nameDescLabel.text = @"";
    _userInfo = nil;
}

- (void)setActionType:(SMSSDKUIContactActionType)actionType
{
    [self updateFrameWithDescExist:NO];
    
    NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
    _headIcon.image = [[UIImage alloc] initWithContentsOfFile:path];
    
    if (actionType == SMSSDKUIContactActionTypeInvite)
    {
        [_inviteBtn setTitle:SMSLocalized(@"invitefriends") forState:UIControlStateNormal];
    }
    else
    {
        [_inviteBtn setTitle:SMSLocalized(@"addfriends") forState:UIControlStateNormal];
    }
}

- (void) setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    
    NSString *avatar = userInfo[@"avatar"];
    if ([avatar isKindOfClass:NSString.class])
    {
        [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:avatar] result:^(UIImage *image, NSError *error) {
            if (image && !error)
            {
                _headIcon.image = image;
            }
        }];
    }
    
    NSString *nickname = userInfo[@"nickname"];
    if ([nickname isKindOfClass:NSString.class])
    {
        _nameLabel.text = nickname;
        _nameDescLabel.text = _contact.name;
        [self updateFrameWithDescExist:YES];
    }
}

- (void)updateFrameWithDescExist:(BOOL)exist
{
    if (exist)
    {
        _nameLabel.frame = CGRectMake(73, 13, 200, 20);
        _nameDescLabel.frame = CGRectMake(73, 33, 200, 15);
    }
    else
    {
        _nameLabel.frame = CGRectMake(73, 19, 200, 20);
        _nameDescLabel.frame = CGRectMake(73, 40, 200, 15);
    }
}

@end
