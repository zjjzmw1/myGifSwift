//
//  EmptyView.h
//  Vodka
//
//  Created by xiaoming on 15/11/30.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property (nonatomic, strong) UIImageView   *imageV;      //    默认图。
@property (nonatomic, strong) UILabel       *label;       //    默认文字。
@property (nonatomic, strong) UILabel       *lastLabel;   //    两行文字的情况 下面一行的文字
//@property (nonatomic, strong) UIButton      *button;      //    默认的按钮

///  第一种情况: 上面一张图片，下面一行文字
- (void)image:(UIImage *)image labelString:(NSString *)labelString;

/////  第二种情况: 上面一张图片，下面两行文字
- (void)image:(UIImage *)image labelString:(NSString *)labelString lastString:(NSString *) lastString;
/////  第三种情况: 上面一行文字，下面一个按钮
//- (void)getButtonWithTitle:(NSString *)title labelString:(NSString *)labelString;
/////  第四种情况: 离线地图需要。
//- (void)imageStringBottom:(NSString *)imageString labelString:(NSString *)labelString;

@end
