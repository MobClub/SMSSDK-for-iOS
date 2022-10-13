//
//  SMSDemoDefines.h
//  SMSSDKDemo
//
//  Created by hower on 2020/1/2.
//  Copyright © 2020 youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SMSDemoStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define SMSDemoUIBundle [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SMSDemoUI" ofType:@"bundle"]]

#define SMSDemoLocalized(_S_) NSLocalizedStringFromTableInBundle((_S_), @"Localizable", SMSDemoUIBundle, nil)


#define SMSDemoRGB(colorHex) [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 255.0 green:((float)((colorHex & 0xFF00) >> 8)) / 255.0 blue:((float)(colorHex & 0xFF)) / 255.0 alpha:1.0]

#define SMSDemoRGBA(r,g,b,a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#define SMSDemoCommonColor() [UIColor colorWithRed:0 green:215/255.0 blue:159/255.0 alpha:1]
#define SMSDemoCommonBgColor() [UIColor colorWithRed:88/255.0 green:179/255.0 blue:181/255.0 alpha:1]

#define SMSDemoGrayTextColor() [UIColor colorWithRed:143/255.0 green:203/255.0 blue:205/255.0 alpha:1]


NS_ASSUME_NONNULL_END
