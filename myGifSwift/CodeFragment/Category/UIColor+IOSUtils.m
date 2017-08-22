//
//  UIColor+IOSUtils.m
//  Toos
//
//  Created by xiaoming on 15/12/24.
//  Copyright © 2015年 shandandan. All rights reserved.
//

#import "UIColor+IOSUtils.h"

@implementation UIColor (IOSUtils)

#pragma mark - Color from Hex
+ (instancetype)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1.0];
}

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:alpha];
}

#pragma mark - RGBA Helper method
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

/**
 获取主题色 23aefe - 蓝色

 @return
 */
+ (UIColor *)getMainColor {
    return [UIColor colorFromHexString:@"23aefe"];
}

/**
 获取背景色 #fafafa - 浅黑

 @return
 */
+ (UIColor *)getBackgroundColor {
    return [UIColor colorFromHexString:@"fafafa"];
}

/**
 获取表格分割线的颜色 ececec - 淡淡的黑

 @return
 */
+ (UIColor *)getSeparatorColor {
    return [UIColor colorFromHexString:@"ececec"];
}

/**
 获取标题的字体颜色 333333 - 黑

 @return
 */
+ (UIColor *)getTitleColor {
    return [UIColor colorFromHexString:@"333333"];
}
/**
 获取内容的字体颜色 6b6b6b - 二级黑
 
 @return
 */
+ (UIColor *)getContentColor {
    return [UIColor colorFromHexString:@"6b6b6b"];
}
/**
 获取次级内容的字体颜色 aaaaaa - 最浅的黑  ----- 也可以作为按钮不可点击的颜色
 
 @return
 */
+ (UIColor *)getContentSecondColor {
    return [UIColor colorFromHexString:@"aaaaaa"];
}

/**
 获取红色的颜色 FF5906

 @return
 */
+ (UIColor *)getRedColor {
    return [UIColor colorFromHexString:@"FF5906"];
}

/**
 获取浅红色的颜色 ff8989
 
 @return
 */
+ (UIColor *)getLightRedColor {
    return [UIColor colorFromHexString:@"ff8989"];
}
@end
