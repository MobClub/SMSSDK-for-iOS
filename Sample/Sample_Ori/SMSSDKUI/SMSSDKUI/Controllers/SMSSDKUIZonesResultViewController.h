//
//  SMSSDKUIZonesResultViewController.h
//  SMSSDKUI
//
//  Created by hower on 2018/3/12.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SMSSDKUIZonesResultItemSelectedBlock)(NSString *countryName,NSString *zone);


@interface SMSSDKUIZonesResultViewController : UIViewController<UISearchResultsUpdating>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) NSDictionary *localList;

@property (nonatomic, copy) SMSSDKUIZonesResultItemSelectedBlock itemSeletectedBlock;

@end
