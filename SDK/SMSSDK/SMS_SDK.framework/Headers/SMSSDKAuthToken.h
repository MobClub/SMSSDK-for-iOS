//
//  SMSSDKAuthToken.h
//  SMS_SDK
//
//  Created by Junjie Pang on 2020/10/28.
//  Copyright © 2020 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSSDKAuthToken : NSObject

/**
 * @brief 运营商返回的Token
 */
@property (nonatomic, copy) NSString *opToken;

/**
 * @brief MobToken
 */
@property (nonatomic, copy) NSString *token;

/**
 * @brief 运营商类型 CMCC:中国移动通信, CUCC:中国联通通讯, CTCC:中国电信
 */
@property (nonatomic, copy) NSString *operatorType;

@end
