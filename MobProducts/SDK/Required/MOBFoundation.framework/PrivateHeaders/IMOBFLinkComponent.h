//
//  IMOBFLinkComponent.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 2017/4/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOBFServiceComponent.h"

@protocol IMOBFScene;

/**
 MobLink产品组件
 */
@protocol IMOBFLinkComponent <IMOBFServiceComponent>

/**
 获取mobId

 @param scene 当前场景信息
 @param result 回调处理，返回mobId
 */
+ (void)getMobId:(id<IMOBFScene>)scene result:(void (^)(NSString *mobId))result;

/**
 设置委托

 @param delegate 委托对象
 */
+ (void)setDelegate:(id)delegate;

@end
