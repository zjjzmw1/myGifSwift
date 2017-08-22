//
//  ProgressHUD.m
//  ZMWJokeOC
//
//  Created by zhangmingwei on 2017/3/9.
//  Copyright © 2017年 speedx. All rights reserved.
//

#import "ProgressHUD.h"

@interface ProgressHUD()

@end

@implementation ProgressHUD

+ (ProgressHUD *)defaultManager {
    static dispatch_once_t once = 0;
    static ProgressHUD *progressHUD;
    
    dispatch_once(&once, ^{
        progressHUD = [[ProgressHUD alloc] init];
        
    });
    return progressHUD;
}

+ (void)setHudStyle {
    [ProgressHUD defaultManager].hud.bezelView.backgroundColor = [UIColor blackColor];
    [ProgressHUD defaultManager].hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    [ProgressHUD defaultManager].hud.label.textColor = [UIColor whiteColor];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
}

/**
 弹出loading + title
 
 @param superView hud的父视图 - nil的话，默认是window
 @param title loading文字
 */
+ (void)showWith:(UIView *)superView title:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    if (!superView) {
        [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    } else {
        [ProgressHUD defaultManager].hudSuperView = superView;
    }
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeIndeterminate;
    [ProgressHUD defaultManager].hud.label.text = title;
//    [ProgressHUD defaultManager].hud.labelText = title;
    [ProgressHUD setHudStyle];
}

/**
 弹出自定义HUD: 显示 loading + title 方式
 
 @param superView hud的父视图
 @param title loading文字
 */
+ (void)showCustomLoad:(UIView *)superView title:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    if (!superView) {
        [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    } else {
        [ProgressHUD defaultManager].hudSuperView = superView;
    }
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    // 自定义View - 图片需要大小合适，hud的大小是根据图片的大小设置的
    if (![ProgressHUD defaultManager].imageView) {
        [ProgressHUD defaultManager].imageView = [[UIImageView alloc] init];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 0; i < 14; i++) {
//            UIImage *aImage = [UIImage imageNamed:[NSString stringWithFormat:@"pull_refresh_white_%d", i + 1]];
//            [imageArr addObject:aImage];
        }
        [ProgressHUD defaultManager].imageView.animationRepeatCount = -1;
        [ProgressHUD defaultManager].imageView.animationDuration = 0.4;
        [[ProgressHUD defaultManager].imageView setAnimationImages:imageArr];
        [[ProgressHUD defaultManager].hud addSubview:[ProgressHUD defaultManager].imageView];
    }
    [ProgressHUD defaultManager].hud.customView = [ProgressHUD defaultManager].imageView;
    [[ProgressHUD defaultManager].imageView startAnimating];
    [ProgressHUD defaultManager].hud.label.text = title;
//    [ProgressHUD defaultManager].hud.labelText = title;

    [ProgressHUD setHudStyle];
}

/**
 弹出自定义HUD: 显示 loading + title 方式
 
 @param superView hud的父视图
 @param title loading文字
 */
+ (void)showCustomLoadListening:(UIView *)superView title:(NSString *)title {
    if ([ProgressHUD defaultManager].imageView.animationImages.count > 0) {
        [ProgressHUD defaultManager].hud.label.text = title;
        return;
    }
    [ProgressHUD dismissDelay:0];
    // 设置父视图
    if (!superView) {
        [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    } else {
        [ProgressHUD defaultManager].hudSuperView = superView;
    }
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    // 自定义View - 图片需要大小合适，hud的大小是根据图片的大小设置的
    if (![ProgressHUD defaultManager].imageView) {
        [ProgressHUD defaultManager].imageView = [[UIImageView alloc] init];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *aImage = [UIImage imageNamed:[NSString stringWithFormat:@"listening_%d", i]];
            [imageArr addObject:aImage];
        }
        [ProgressHUD defaultManager].imageView.animationRepeatCount = -1;
        [ProgressHUD defaultManager].imageView.animationDuration = 0.4;
        [[ProgressHUD defaultManager].imageView setAnimationImages:imageArr];
        [[ProgressHUD defaultManager].hud addSubview:[ProgressHUD defaultManager].imageView];
    }
    [ProgressHUD defaultManager].hud.customView = [ProgressHUD defaultManager].imageView;
    [[ProgressHUD defaultManager].imageView startAnimating];
    [ProgressHUD defaultManager].hud.label.text = title;

    [ProgressHUD setHudStyle];
}

/**
 弹出HUD: title 方法
 
 @param title 展示的文字
 */
+ (void)showTitle:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeText;
    [ProgressHUD defaultManager].hud.label.text = title;
    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 弹出成功提示
 
 @param title 提示文字
 */
+ (void)showSuccess:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    [ProgressHUD defaultManager].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
    [ProgressHUD defaultManager].hud.label.text = title;
//    [ProgressHUD defaultManager].hud.labelText = title;
    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 弹出错误提示
 
 @param title 提示文字
 */
+ (void)showError:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    [ProgressHUD defaultManager].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
    [ProgressHUD defaultManager].hud.label.text = title;
    [ProgressHUD defaultManager].hud.label.font = [UIFont systemFontOfSize:14];
//    [ProgressHUD defaultManager].hud.labelText = title;
//    [ProgressHUD defaultManager].hud.labelFont = [UIFont systemFontOfSize:14];

    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 弹出详情图片的提示 1秒后消失
 
 @param title 提示文字
 */
+ (void)showInfo:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    [ProgressHUD defaultManager].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_info"]];
    [ProgressHUD defaultManager].hud.label.text = title;
//    [ProgressHUD defaultManager].hud.labelText = title;

    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 弹出警告图片的提示 1秒后消失
 
 @param title 提示文字
 */
+ (void)showWarn:(NSString *)title {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    [ProgressHUD defaultManager].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBHUD_Warn"]];
    [ProgressHUD defaultManager].hud.label.text = title;
    //    [ProgressHUD defaultManager].hud.labelText = title;
    
    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 弹出自定义图片的提示 - 1秒后消失
 
 @param title 提示文字
 @param image 提示图片
 */
+ (void)showCustom:(NSString *)title image:(UIImage *)image {
    [[ProgressHUD defaultManager].hud hideAnimated:YES];
    // 设置父视图
    [ProgressHUD defaultManager].hudSuperView = [UIApplication sharedApplication].keyWindow;
    // 设置hud文字和类型
    [ProgressHUD defaultManager].hud = [MBProgressHUD showHUDAddedTo:[ProgressHUD defaultManager].hudSuperView animated:YES];
    [ProgressHUD defaultManager].hud.mode = MBProgressHUDModeCustomView;
    [ProgressHUD defaultManager].hud.customView = [[UIImageView alloc] initWithImage:image];
    [ProgressHUD defaultManager].hud.label.text = title;
    //    [ProgressHUD defaultManager].hud.labelText = title;
    
    [ProgressHUD dismissDelay:kHud_Default_Delay];
    [ProgressHUD setHudStyle];
}

/**
 隐藏HUD
 
 @param delay 隐藏几秒后隐藏
 */
+ (void)dismissDelay:(NSTimeInterval)delay {
    if (delay == 0) {
        [ProgressHUD defaultManager].imageView.animationImages = nil;
        [[ProgressHUD defaultManager].imageView stopAnimating];
        [[ProgressHUD defaultManager].imageView removeFromSuperview];
        [ProgressHUD defaultManager].imageView = nil;
        [[ProgressHUD defaultManager].hud hideAnimated:NO];
        [MBProgressHUD hideHUDForView:[ProgressHUD defaultManager].hudSuperView animated:NO];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD defaultManager].imageView.animationImages = nil;
        [[ProgressHUD defaultManager].imageView stopAnimating];
        [ProgressHUD defaultManager].imageView = nil;
        [[ProgressHUD defaultManager].hud hideAnimated:YES afterDelay:delay];
        [MBProgressHUD hideHUDForView:[ProgressHUD defaultManager].hudSuperView animated:YES];
    });
}

@end
