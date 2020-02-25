//
//  SMSDemoZonesVC.h
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SMSDZonesResultHanler)(BOOL cancel,NSString *zone,NSString *countryName);


@interface SMSDemoZonesVC : UIViewController

- (instancetype)initWithResult:(SMSDZonesResultHanler) result;


@end

NS_ASSUME_NONNULL_END
