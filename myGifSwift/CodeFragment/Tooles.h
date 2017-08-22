//
//  Tooles.h
//  Vodka
//
//  Created by xiaoming on 14-9-4.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProgressHUD.h"
#import <UMMobClick/MobClick.h>
//#import "WJToolManager.h"

@interface Tooles : NSObject

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

/// 获取带 image/title 的按钮 (左右排列) 排序方式
typedef enum {
    imageLeft_wholeCenter   =   0,      // 图片居左，整体居中
    imageLeft_wholeLeft     =   1,      // 图片居左，整体居左
    imageleft_wholeRight    =   2,      // 图片居左，整体居右
    imageRight_wholeCenter  =   3,      // 图片居右，整体居中
    imageRight_wholeLeft    =   4,      // 图片居右，整体居左
    imageRight_wholeRight   =   5,      // 图片居右，整体居右
    
}ButtonImageTitleType;

+ (BOOL)removeImageWithName:(NSString *)imageName;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

///下面两个方法可以存储自定义的对象---TMCache就不行。
+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file;
+ (BOOL)getFileFromLoc:(NSString *)filePath into:(id)dic;
+ (BOOL)removeLoc:(NSString *)fileName;//删除。
// 是否是自定义的model
+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file isModel:(BOOL)isModel;
// 是否是自定义model
+ (BOOL)getFileFromLoc:(NSString *)filePath into:(id)file isModel:(BOOL)isModel;

//自定义对象的时候用的。
+ (NSData *)getDataFileFromLoc:(NSString *)filePath into:(id)file;
///获取pathForResource 本地的图片。代替 imageNamed 的方法。--------除非是cell 的重复很多的默认图用imageNamed 否则都不建议用。
///去除所有空格。
+ (NSString *)removeAllBlank:(NSString *)string;
///根据色值 获取渐变 UIImage
+ (UIImage *)getImageFromColors:(NSArray *)colors ByGradientType:(GradientType)gradientType frame:(CGRect)frame;

/**
 *  获取本地路径url 或者 网络url
 *
 *  @param folderName 文件夹名称  本地路径的时候用，否则传 nil
 *  @param fileName   文件名字 本地路径的时候用，否则传 nil
 *  @param urlString  网络urlString
 *
 *  @return NSURL（网络或者本地）
 */
+ (NSURL *)getURLWithFolderName:(NSString *)folderName fileName:(NSString *)fileName urlString:(NSString *)urlString;
///判断时区是否在中国
+ (BOOL)          isInChina;

/**
 *  textFild 限制字数的方法
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textField.text 的值 可以传空
 *  @param textField     textField 对象
 *
 *  @return 输入后的结果字符串
 */
+ (NSString *)textFieldLimtWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textField:(UITextField *)textField;

/**
 *  textView 限制字数的方法
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textView.text 的值 可以传空
 *  @param textView     textView 对象
 *
 *  @return 输入后的结果字符串
 */
+ (NSString *)textViewLimtWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textView:(UITextView *)textView;

/// 获取国家编号
+ (NSString *)    getCountryCode;
+ (NSString *)    getLanguageCode;
/// 获取国家编号的字典。
+ (NSDictionary *)countryCodeDict;

+ (NSString *)quKongGe:(NSString *)sender;
+ (NSString *)quKongGeAndEnder:(NSString *)sender;

/// 删除多余的SSDWindow   Tool 通用的方法  分享登录 卡死页面 用的
+ (void)          removeSSDWindowAction;

///  解码 url 字符串
+ (NSString *)URLDecodedString:(NSString *)stringURL;

/**
 *  设置statusBar颜色是否是白色的
 *
 *  @param isWhiteColor YES:白色、NO:黑色
 */
+ (void)setStatusBarTitleColorIsWhiteColor:(BOOL)isWhiteColor;

/**
 *  获取常用的 UILabel
 *
 *  @param font      UIFont
 *  @param alignment NSTextAlignment
 *  @param textColor UIColor
 *
 *  @return UILabel
 */
+ (UILabel *)getLabelWithFont:(UIFont *)font alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor;

/**
 *  获取常用的 UIButton
 *
 *  @param title      按钮文字
 *  @param titleColor 文字颜色
 *  @param font       字体
 *
 *  @return UIButton
 */
+ (UIButton *)getButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

/**
 *  获取常用的 UIImageView
 *
 *  @param frame 设置圆角的时候需要
 *
 *  @return UIImageView
 */
+ (UIImageView *)getImageViewFrame:(CGRect)frame;

/**
 *  获取带 image/title 的按钮 (左右排列)
 *
 *  @param image      image
 *  @param title      title
 *  @param titleColor 字体颜色
 *  @param aFont       font
 *  @param spacing    image和title的间隔
 *  @param type       排列方式
 *
 *  @return UIButton
 */
+ (UIButton *)getButtonImageTitleWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor spacing:(float)spacing alignmentType:(ButtonImageTitleType)type aFont:(UIFont *)aFont;

/// - 获取UILabel的多行的size
+ (CGSize)getLabelSize:(UILabel *)label labelWidth:(float)width;

/// 判断当前页面是否正在显示
+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

/// - 跳转到指定页面
+ (void)jumpToVC:(NSString *)vcNameString fromVC:(UIViewController *)vc;

/// - 获取当前navigationController.viewControllers里面的某一个VC
+ (UIViewController *)getViewControllerWithName:(NSString *)vcNameString fromVC:(UIViewController *)vc;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
/// 展示或隐藏悬浮框
+ (void)isShowMyFloatView:(BOOL)isShow;

/// - 图片浏览器的类方法
+ (void)showBigImage:(UIImageView *)smallImageV bigImageUrl:(NSString *)bigImageUrl bigImageUrlArray:(NSArray *)bigImageUrlArray pictureCount:(int)pictureCount currentIndex:(int)index;

/**
 给手机号或者邮箱加*

 @param oldString 原手机号或邮箱
 @return 加星后的手机号或邮箱
 */
+ (NSString *)getStarString:(NSString *)oldString;

/**
 停止语音播放的类方法
 */
+ (void)stopSoundAction;

/**
 获取音频URL的时间长度 - 单位的秒
 
 @param voiceUrl 音频的 URL
 @return 秒
 */
+ (NSUInteger)getVoiceTime:(NSURL *)voiceUrl;

/**
 保存音频的时间
 
 @param voiceUrl 音频URL
 @param masterId 达人id
 @return
 */
+ (NSInteger)saveVoiceTimeUrl:(NSURL *)voiceUrl masterId:(NSString *)masterId row:(NSInteger)row;

/// 播放震动
+ (void)playVibration;
/// 停止震动
+ (void)stopVibration;
/// 设置声音变小 - 录音的时候需要小
+ (void)volumeLittle;
/// 设置声音变大 - 播放声音的时候需要大
+ (void)volumeBig;
/// 跳转到系统的设置页面
+ (void)goSetting;
/// 开始监听网络状态
+ (void)startListeningNetworkStatus;
/// 开始监听网络状态
+ (void)stopListeningNetworkStatus;
/// 保证一个方法在0.5秒内不能重复调用
+ (BOOL)repeatCallAction:(NSString *)funcName;

///根据域名获取ip地址 - 可以用于控制APP的开关某一个入口，比接口方式速度快的多
+ (NSString*)getIPWithHostName:(const NSString*)hostName;

/// 统计进入页面的方法
+ (void)beginLogPageView:(NSString *)title;
/// 统计离开页面的方法
+ (void)endLogPageView:(NSString *)title;
/// 友盟的点击事件
+ (void)event:(NSString *)eventId;
/// 友盟的点击事件-带Label的
+ (void)event:(NSString *)eventId label:(NSString *)labelString;

@end
