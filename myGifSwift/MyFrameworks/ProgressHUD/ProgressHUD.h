//
//  ProgressHUD.h
//  ZMWJokeOC
//
//  Created by zhangmingwei on 2017/3/9.
//  Copyright © 2017年 speedx. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#define kHud_Default_Delay      1.5

@interface ProgressHUD : NSObject

/// 当前HUD
@property (nonatomic, strong) MBProgressHUD         *hud;
/// 当前HUD的父视图
@property (nonatomic, strong) UIView                *hudSuperView;
/// 自定义动画的imageView
@property (nonatomic, strong) UIImageView           *imageView;

+ (ProgressHUD *)defaultManager;

/**
 弹出loading + title
 
 @param superView hud的父视图 - nil的话，默认是window
 @param title loading文字
 */
+ (void)showWith:(UIView *)superView title:(NSString *)title;


/**
 弹出自定义HUD: 显示 loading + title 方式
 
 @param superView hud的父视图
 @param title loading文字
 */
+ (void)showCustomLoad:(UIView *)superView title:(NSString *)title;

/**
 弹出自定义HUD: 显示 loading + title 方式
 
 @param superView hud的父视图
 @param title loading文字
 */
+ (void)showCustomLoadListening:(UIView *)superView title:(NSString *)title;

/**
 弹出HUD: 只显示：title 方法

 @param title 提示文字
 */
+ (void)showTitle:(NSString *)title;

/**
 弹出成功提示

 @param title 提示文字
 */
+ (void)showSuccess:(NSString *)title;

/**
 弹出错误提示
 
 @param title 提示文字
 */
+ (void)showError:(NSString *)title;


/**
 弹出自定义图片的提示 1秒后消失

 @param title 提示文字
 */
+ (void)showInfo:(NSString *)title;

/**
 弹出警告图片的提示 1秒后消失
 
 @param title 提示文字
 */
+ (void)showWarn:(NSString *)title;

/**
 弹出自定义图片的提示 - 1秒后消失
 
 @param title 提示文字
 @param image 提示图片
 */
+ (void)showCustom:(NSString *)title image:(UIImage *)image;

/**
 隐藏HUD

 @param delay 隐藏几秒后隐藏
 */
+ (void)dismissDelay:(NSTimeInterval)delay;

/// 自定义的loading 样式

@end
