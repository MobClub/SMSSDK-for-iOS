//
//  SMSDemoPolicyVC.h
//  SMSSDKDemo
//
//  Created by Brilance on 2020/2/7.
//  Copyright © 2020年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMSDemoPolicyAcceptHandler)(BOOL accept);


@interface SMSDemoPolicyManager : NSObject


+(void)show:(NSString *)url compeletion:(nullable SMSDemoPolicyAcceptHandler)acceptBlock;

@end
