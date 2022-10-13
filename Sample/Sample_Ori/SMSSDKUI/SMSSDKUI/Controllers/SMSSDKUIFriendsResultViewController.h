//
//  SMSSDKUIFriendsResultViewController.h
//  SMSSDKUI
//
//  Created by hower on 2018/3/12.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SMSSDKUIFriendsResultItemSelectedBlock)(id info);


@interface SMSSDKUIFriendsResultViewController : UIViewController<UISearchResultsUpdating>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *contactList;// 获取到的所有联系人

@property (nonatomic, strong) NSMutableArray *contactFriends;//获取到所有的通讯录好友


@property (nonatomic, copy) SMSSDKUIFriendsResultItemSelectedBlock itemSeletectedBlock;

@end
