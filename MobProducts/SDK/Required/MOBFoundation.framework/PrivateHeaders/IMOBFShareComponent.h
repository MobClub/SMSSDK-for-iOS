//
//  IMOBFShareComponent.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/2/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOBFServiceComponent.h"

@protocol IMOBFSocialUser;

/**
 分享组件
 */
@protocol IMOBFShareComponent <IMOBFServiceComponent>

/**
 *  分享平台授权
 *
 *  @param platformType       平台类型
 *  @param @param settings    授权设置,目前只接受SSDKAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 *  @param stateChangeHandler 授权状态变更回调处理
 */
+ (void)authorize:(NSInteger)platformType
         settings:(NSDictionary *)settings
   onStateChanged:(void (^) (NSInteger state, id<IMOBFSocialUser> user, NSError *error))stateChangedHandler;

/**
 *  获取授权用户信息
 *
 *  @param platformType       平台类型
 *  @param stateChangeHandler 状态变更回调处理
 */
+ (void)getUserInfo:(NSInteger)platformType
     onStateChanged:(void (^) (NSInteger state, id<IMOBFSocialUser> user, NSError *error))stateChangedHandler;

/**
 *  取消分享平台授权
 *
 *  @param platformType  平台类型
 */
+ (void)cancelAuthorize:(NSInteger)platformType;

@end
