//
//  IMOBFContentComponent.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/2/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOBFServiceComponent.h"

@protocol IMOBFUser;
@protocol IMOBFArticleType;
@protocol IMOBFArticle;

/**
 资讯组件
 */
@protocol IMOBFContentComponent <IMOBFServiceComponent>

/**
 *  获取文章类型列表
 *
 *  @param result 回调结果
 */
+ (void)getArticleTypes:(void (^) (NSArray *typeList, NSError *error))result;

/**
 *  获取某种类型的文章列表
 *
 *  @param articleType      文章类型
 *  @param offset           文章页码
 *  @param size             文章数量
 *  @param fields           文章内容字段
 *  @param result           回调结果
 */
+ (void)getArticleList:(id<IMOBFArticleType>)articleType
                pageNo:(NSInteger)pageNo
              pageSize:(NSInteger)pageSize
                result:(void (^) (NSArray *articleList, NSError *error))result;

/**
 *  获取文章详情
 *
 *  @param articleID 文章ID
 *  @param result    回调结果
 */
+ (void)getArticleDetail:(NSString *)articleID
                  result:(void (^) (id<IMOBFArticle> article, NSError *error))result;

/**
 *  获取推荐相关文章列表
 *
 *  @param articleID 目标文章ID
 *  @param offset    文章页码
 *  @param size      文章数量
 *  @param result    回调结果
 */
+ (void)getRecommendArticles:(NSString *)articleID
                      pageNo:(NSInteger)pageNo
                    pageSize:(NSInteger)pageSize
                      result:(void (^) (NSArray *articleList, NSError *error))result;

/**
 *  获取文章的评论列表
 *
 *  @param article  文章对象
 *  @param result   回调结果
 */
+ (void)getCommentsList:(id<IMOBFArticle>)article
                 pageNo:(NSInteger)pageNo
               pageSize:(NSInteger)pageSize
                 result:(void (^) (NSArray *commentsList, NSError *error))result;

/**
 *  给某篇文章添加评论
 *
 *  @param comment   评论内容
 *  @param user      评论者用户。 用户信息可选择三种方式:1.传入nil,即为使用匿名用户
 2.传入自行构建的user对象,详细请查看<MOBFoundation/MOBFUser.h>
 3.传入 UMSSDK 中获得的user对象
 *  @param article   文章对象
 *  @param result    回调结果
 */
+ (void)addComment:(NSString *)comment
            byUser:(id<IMOBFUser>)user
         toArticle:(id<IMOBFArticle>)article
            result:(void (^) (id newComment, NSError *error))result;

/**
 *  给某篇文章点赞
 *  @param airticle   文章对象
 *  @param user       点赞者    用户信息可选择三种方式:1.传入nil,即为使用匿名用户
 2.传入自行构建的user对象,详细请查看<MOBFoundation/MOBFUser.h>
 3.传入 UMSSDK 中获得的user对象
 *  @param result     回调结果
 */
+ (void)praiseArticle:(id<IMOBFArticle>)article
               byUser:(id<IMOBFUser>)user
               result:(void (^) (NSError *error))result;

/**
 *  获取某篇文章对于某个用户的点赞状态
 *
 *  @param artile 文章对象
 *  @param user   被检测的用户 用户信息可选择三种方式:1.传入nil,即为使用匿名用户
 2.传入自行构建的user对象,详细请查看<MOBFoundation/MOBFUser.h>
 3.传入 UMSSDK 中获得的user对象
 *  @param result 回调结果
 */
+ (void)checkArticlePraiseStatus:(id<IMOBFArticle>)article
                          byUser:(id<IMOBFUser>)user
                          result:(void (^) (BOOL isPraised, NSError *error))result;

@end
