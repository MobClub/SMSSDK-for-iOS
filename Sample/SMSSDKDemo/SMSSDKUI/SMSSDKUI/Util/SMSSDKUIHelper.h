//
//  SMSSDKUIHelper.h
//  SMSSDKUI
//
//  Created by youzu_Max on 2017/5/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSSDKUIHelper : NSObject

+ (NSString *)currentZone;

+ (NSString *)currentCountryName;

+ (void)readContacts:(void(^)(BOOL authorized,NSMutableArray *contacts))result;

+ (NSString *)errorTextWithError:(NSError *)error;

@end
