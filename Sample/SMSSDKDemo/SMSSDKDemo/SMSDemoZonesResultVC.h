//
//  SMSDemoZonesResultVC.h
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SMSDemoZonesResultItemSelectedBlock)(NSString *countryName,NSString *zone);

@interface SMSDemoZonesResultVC : UIViewController<UISearchResultsUpdating>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) NSDictionary *localList;

@property (nonatomic, copy) SMSDemoZonesResultItemSelectedBlock itemSeletectedBlock;
@end

NS_ASSUME_NONNULL_END
