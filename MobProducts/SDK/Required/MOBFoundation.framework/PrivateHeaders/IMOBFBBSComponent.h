//
//  IMOBFDzComponent.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/2/15.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOBFServiceComponent.h"

@protocol IMOBFForumSection;
@protocol IMOBFForumNote;
@protocol IMOBFForumNoteComment;

/**
 论坛SDK组件
 */
@protocol IMOBFBBSComponent <IMOBFServiceComponent>

/**
 获取版块列表
 
 @param fup 上级论坛id 预留字段，暂时不用
 @param result 回调
 */
+ (void)getForumListWithFup:(NSInteger)fup
                     result:(void (^)(NSArray<id<IMOBFForumSection>> *forumsList, NSError *error))result;

/**
 获取帖子列表
 
 @param fid 板块id
 @param pageIndex 页索引
 @param pageSize 每页请求大小
 @param result 回调
 */
+ (void)getThreadListWithFid:(NSInteger)fid
                   pageIndex:(NSInteger)pageIndex
                    pageSize:(NSInteger)pageSize
                      result:(void (^)(NSArray<id<IMOBFForumNote>> *threadList, NSError *error))result;

/**
 获取评论列表
 
 @param fid 板块id
 @param tid 帖子id
 @param pageIndex 页索引
 @param pageSize 页大小
 @param result 回调
 */
+ (void)getPostListWithFid:(NSInteger)fid
                       tid:(NSInteger)tid
                 pageIndex:(NSInteger)pageIndex
                  pageSize:(NSInteger)pageSize
                    result:(void (^)(NSArray<id<IMOBFForumNoteComment>> *postList, NSError *error))result;

@end
