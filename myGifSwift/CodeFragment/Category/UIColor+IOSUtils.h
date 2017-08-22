//
//  UIColor+IOSUtils.h
//  Toos
//
//  Created by xiaoming on 15/12/24.
//  Copyright © 2015年 shandandan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IOSUtils)

/**
 Creates a Color from a Hex representation string
 @param hexString   Hex string that looks like @"#FF0000" or @"FF0000"
 @return    Color
 */
+ (instancetype)colorFromHexString:(NSString *)hexString;

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  RGBA Helper method
 *
 *  @param red   红色的值 0 -- 255.0f
 *  @param green 绿色的值 0 -- 255.0f
 *  @param blue  蓝色的值 0 -- 255.0f
 *  @param alpha 透明度   0 -- 1.0f
 *
 *  @return UIColor
 */
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

/**
 获取主题色 23aefe
 
 */
+ (UIColor *)getMainColor;

/**
 获取背景色 #fafafa
 
 */
+ (UIColor *)getBackgroundColor;
/**
 获取表格分割线的颜色 ececec
 
 */
+ (UIColor *)getSeparatorColor;
/**
 获取标题的字体颜色 333333 - 粗体
 
 */
+ (UIColor *)getTitleColor;
/**
 获取内容的字体颜色 6b6b6b
 
 */
+ (UIColor *)getContentColor;
/**
 获取次级内容的字体颜色 aaaaaa - 最浅的黑  ----- 也可以作为按钮不可点击的颜色
 
 */
+ (UIColor *)getContentSecondColor;
/**
 获取红色的颜色 FF5906
 
 */
+ (UIColor *)getRedColor;

/**
 获取浅红色的颜色 ff8989
 
 */
+ (UIColor *)getLightRedColor;

@end
