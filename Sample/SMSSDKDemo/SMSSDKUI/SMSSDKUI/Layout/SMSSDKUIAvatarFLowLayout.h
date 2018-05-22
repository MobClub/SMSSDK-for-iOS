//
//  SMSSDKUIAvatarFLowLayout.h
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SMSSDKUIAvatarFLowLayout;

@protocol SMSSDKUIAvatarFLowLayoutDelegate <NSObject>

@required

@optional
- (CGFloat)flowLayout:(SMSSDKUIAvatarFLowLayout *)SMSSDKUIAvatarFLowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;
- (CGFloat)columnCountInFLowLayout:(SMSSDKUIAvatarFLowLayout *) SMSSDKUIAvatarFLowLayout;
- (CGFloat)columnMarginInFLowLayout:(SMSSDKUIAvatarFLowLayout *) SMSSDKUIAvatarFLowLayout;
- (CGFloat)rowMarginInFLowLayout:(SMSSDKUIAvatarFLowLayout *) SMSSDKUIAvatarFLowLayout;
- (UIEdgeInsets)edgeInsetsInFLowLayout:(SMSSDKUIAvatarFLowLayout *) SMSSDKUIAvatarFLowLayout;

@end


@interface SMSSDKUIAvatarFLowLayout : UICollectionViewLayout

@property (nonatomic , weak) id<SMSSDKUIAvatarFLowLayoutDelegate> delegate;

+ (float)CellWidthWithViewWidth:(float)width;

@end
