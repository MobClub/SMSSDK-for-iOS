//
//  SMSSDKUISelectAvatarCell.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSSDKUISelectAvatarCell.h"
#import "SMSSDKUIAvatarFLowLayout.h"

@interface SMSSDKUISelectAvatarCell()

@property (nonatomic, strong) UIImageView *checkedView;


@end

@implementation SMSSDKUISelectAvatarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    
    self.avatarImageView =
    ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 60, 60);
        
        NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
//    self.checkedView =
//    ({
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.frame = CGRectMake(0, 0, 20, 20);
//        imageView.hidden = YES;
//
//        NSString *path = [SMSSDKUIBundle pathForResource:@"sms_ui_default_avatar" ofType:@"png"];
//        imageView.image = [UIImage imageWithContentsOfFile:path];
//        [self.contentView addSubview:imageView];
//        imageView;
//    });
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarImageView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.avatarImageView.layer.cornerRadius = self.frame.size.width/2.0;
    self.avatarImageView.clipsToBounds = YES;
    
//    self.checkedView.frame =CGRectMake(self.avatarImageView.frame.size.width - 30, self.avatarImageView.frame.size.height - 30, 20, 20);

}
@end
