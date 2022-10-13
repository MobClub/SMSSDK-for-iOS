//
//  SMSSDKAvatarSelectViewController.h
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"

typedef void (^SMSSDKUIAvatarSelectItemSelectedBlock)(NSString *avatarPath);


@interface SMSSDKAvatarSelectViewController : SMSSDKUIBaseViewController

@property (nonatomic, copy) SMSSDKUIAvatarSelectItemSelectedBlock itemSeletectedBlock;

@end
