//
//  SMSSDKUIZonesViewController.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSSDKUIBaseViewController.h"

typedef void(^ResultHanler)(BOOL cancel,NSString *zone,NSString *countryName);

@interface SMSSDKUIZonesViewController : SMSSDKUIBaseViewController

- (instancetype)initWithResult:(ResultHanler) result;

@end
