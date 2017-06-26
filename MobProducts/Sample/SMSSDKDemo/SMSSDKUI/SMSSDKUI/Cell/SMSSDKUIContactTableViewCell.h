//
//  SMSSDKUIContactTableViewCell.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/6/7.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSSDKAddressBook;

typedef enum : NSUInteger {
    SMSSDKUIContactActionTypeInvite,
    SMSSDKUIContactActionTypeAddFriend,
} SMSSDKUIContactActionType;

@protocol SMSSDKUIContactTableViewCellDelegate <NSObject>

- (void) didClickButtonWithInfo:(id)info;

@end

@interface SMSSDKUIContactTableViewCell : UITableViewCell

@property (nonatomic, strong) SMSSDKAddressBook *contact;

@property (nonatomic, assign) SMSSDKUIContactActionType actionType;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, weak) id<SMSSDKUIContactTableViewCellDelegate> delegate;

@end
