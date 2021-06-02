//
//  TBCityIconFont.h
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

// 0x3439 转换后为：\U00003439 就是将 0x 替换为 \U 中间用 0 填补满长度为 8 个字符

#import "UIImage+TBCityIconFont.h"
#import "TBCityIconInfo.h"

#define TBCityIconInfoMake(text, imageSize, imageColor) [TBCityIconInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface TBCityIconFont : NSObject

+ (UIFont *)fontWithSize: (CGFloat)size;
+ (void)setFontName:(NSString *)fontName;

@end
