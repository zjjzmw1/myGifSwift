//
//  Tooles.m
//  Vodka
//
//  Created by xiaoming on 14-9-4.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "Tooles.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"
#import "NSString+IOSUtils.h"
//#import "NSObject+CodeFragments.h"
//#import "UtilMacro.h"
#import "ESPictureBrowser.h"
#import "ESPictureManager.h"

//#import "EMAudioPlayerUtil.h"
//#import <AVFoundation/AVFoundation.h>   // 获取音频时长
//#import "UserManager.h"

// 解析域名用的
#include <netdb.h>
#include <arpa/inet.h>

//#import "AppDelegate.h"

@interface Tooles ()

@end

@implementation Tooles

+ (BOOL)removeImageWithName:(NSString *)imageName {
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    return [[NSFileManager defaultManager] removeItemAtPath:fullPathToFile error:nil];
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 下面两个方法可以存储自定义的对象---TMCache就不行。
+ (BOOL)removeLoc:(NSString *)fileName {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filename]) {
        if ([fileManager removeItemAtPath:filename error:nil]) {
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filename]) {
        if (![fileManager createFileAtPath:filename contents:nil attributes:nil]) {
            NSLog(@"createFile error occurred");
        }
    }
    
    return [file writeToFile:filename atomically:YES];
}

// 是否是自定义的model
+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file isModel:(BOOL)isModel {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filename]) {
        if (![fileManager createFileAtPath:filename contents:nil attributes:nil]) {
            NSLog(@"createFile error occurred");
        }
    }
    if (isModel) {
        return [NSKeyedArchiver archiveRootObject:file toFile:filename];
    }
    return [file writeToFile:filename atomically:YES];
}

+ (BOOL)getFileFromLoc:(NSString *)filePath into:(id)file {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    
    if ([file isKindOfClass:[NSMutableDictionary class]]) {
        [file setDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:filename]];
        
        if ([file count] == 0) {
            return NO;
        }
    } else if ([file isKindOfClass:[NSMutableArray class]]) {
        [file addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:filename]];
        
        if ([file count] == 0) {
            return NO;
        }
    } else if ([file isKindOfClass:[NSData class]]) {
        file = [NSData dataWithContentsOfFile:filename];
        
        if ([file length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

// 是否是自定义model
+ (BOOL)getFileFromLoc:(NSString *)filePath into:(id)file isModel:(BOOL)isModel {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    
    if ([file isKindOfClass:[NSMutableDictionary class]]) {
        if (isModel) {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            [file setDictionary:dict];
        } else {
            [file setDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:filename]];
        }
        if ([file count] == 0) {
            return NO;
        }
    } else if ([file isKindOfClass:[NSMutableArray class]]) {
        if (isModel) {
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            [file addObjectsFromArray:array];
        } else {
            [file addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:filename]];
        }
        if ([file count] == 0) {
            return NO;
        }
    } else if ([file isKindOfClass:[NSData class]]) {
        if (isModel) {
            file = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        } else {
            file = [NSData dataWithContentsOfFile:filename];
        }
        if ([file length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSData *)getDataFileFromLoc:(NSString *)filePath into:(id)file {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CachePath = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    
    if ([file isKindOfClass:[NSData class]]) {
        file = [NSData dataWithContentsOfFile:filename];
        
        if ([file length] == 0) {
            return nil;
        }
        
        return file;
    }
    
    return nil;
}

#pragma mark - 去除所有空格
+ (NSString *)removeAllBlank:(NSString *)string {
    ///去所有的空格。
    ///string 是输入框里面的text。
    NSString *resultString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resultString;
}

#pragma mark - 根据色值 获取渐变 UIImage

+ (UIImage *)getImageFromColors:(NSArray *)colors ByGradientType:(GradientType)gradientType frame:(CGRect)frame {
    NSMutableArray *ar = [NSMutableArray array];
    
    for (UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef refColorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(refColorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, frame.size.height);
            break;
            
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(frame.size.width, 0.0);
            break;
            
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(frame.size.width, frame.size.height);
            break;
            
        case 3:
            start = CGPointMake(frame.size.width, 0.0);
            end = CGPointMake(0.0, frame.size.height);
            break;
            
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  获取本地路径url 或者 网络url
 *
 *  @param folderName 文件夹名称  本地路径的时候用，否则传 nil
 *  @param fileName   文件名字 本地路径的时候用，否则传 nil
 *  @param urlString  网络urlString
 *
 *  @return NSURL（网络或者本地）
 */
//+ (NSURL *)getURLWithFolderName:(NSString *)folderName fileName:(NSString *)fileName urlString:(NSString *)urlString {
//    if ([NSString isEmptyString:fileName]) {
//        folderName = @"Cycling_Record_Road_Images";
//    }
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *path = [self absolutePath:[NSString stringWithFormat:@"%@/%@.png", folderName, fileName] systemPath:kPathLibrary];
//    
//    if ([fileManager fileExistsAtPath:path]) {
//        return [NSURL fileURLWithPath:path];
//    } else {
//        return [NSURL URLWithString:urlString];
//    }
//}

#pragma mark - 判断时区 是否在中国
+ (BOOL)isInChina {
    BOOL result = NO;
    
    //NSString* localeStr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Chongqing"].location == 0 ||
        [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Harbin"].location == 0 ||
        [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Hong_Kong"].location == 0 ||
        [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Macau"].location == 0 ||
        [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Shanghai"].location == 0 ||
        [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Taipei"].location == 0) {
        result = YES;
    }
    
    return result;
}

/**
 *  textFild 限制字数的方法  在这里用 self.textField rac_signalForControlEvents:UIControlEventEditingChanged
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textField.text 的值
 *  @param textField     textField 对象
 *
 *  @return 输入后的结果字符串
 */
+ (NSString *)textFieldLimtWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textField:(UITextField *)textField {
    NSString *toBeString = textField.text;
    
    resultString = textField.text;//业务逻辑
    NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            //业务逻辑
            if (toBeString.length > maxTextLength) {
                textField.text = [toBeString substringToIndex:maxTextLength];
                resultString = [textField.text substringToIndex:maxTextLength];
            } else {
                resultString = textField.text;
            }
        }
        
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        //业务逻辑
        if (toBeString.length > maxTextLength) {
            textField.text = [toBeString substringToIndex:maxTextLength];
            resultString = [textField.text substringToIndex:maxTextLength];
        } else {
            resultString = textField.text;
        }
    }
    
    return resultString;
}

/**
 *  textView 限制字数的方法  在这里用 self.textView rac_textSignal
 *
 *  @param maxTextLength 最大长度
 *  @param resultString  返回的textView.text 的值 可以传空
 *  @param textView     textView 对象
 *
 *  @return 输入后的结果字符串
 */
+ (NSString *)textViewLimtWithMaxLength:(int)maxTextLength resultString:(NSString *)resultString textView:(UITextView *)textView {
    NSString *toBeString = textView.text;
    
    resultString = textView.text;//业务逻辑
//    NSString *lang = textView.textInputMode.primaryLanguage; // 键盘输入模式
    
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textView markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
//        
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            //业务逻辑
//            if (toBeString.length > maxTextLength) {
//                textView.text = [toBeString substringToIndex:maxTextLength];
//                resultString = [textView.text substringToIndex:maxTextLength];
//            } else {
//                resultString = textView.text;
//            }
//        } else {
////            if (toBeString.length > maxTextLength) {
////                textView.text = [toBeString substringToIndex:maxTextLength];
////                resultString = [textView.text substringToIndex:maxTextLength];
////            } else {
////                resultString = textView.text;
////            }
//        }
//        
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else {
        //业务逻辑
        if (toBeString.length > maxTextLength) {
            textView.text = [toBeString substringToIndex:maxTextLength];
            resultString = [textView.text substringToIndex:maxTextLength];
        } else {
            resultString = textView.text;
        }
//    }
    
    return resultString;
}

#pragma mark - 获取国家编号
+ (NSString *)getCountryCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)getLanguageCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

#pragma mark - 国家code列表
+ (NSDictionary *)countryCodeDict {
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    return dictCodes;
}

+ (NSString *)quKongGe:(NSString *)sender {
    ///去除两端空格
    ///sender 是输入框里面的text。
    NSString *temp = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return temp;
}

+ (NSString *)quKongGeAndEnder:(NSString *)sender {
    /// 去除两端空格和回车
    NSString *text = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    return text;
}

#pragma mark 删除多余的SSDWindow   Tool 通用的方法  分享登录 卡死页面 用的
+ (void)removeSSDWindowAction {
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        if ([[[UIApplication sharedApplication].windows objectAtIndex:i]isKindOfClass:NSClassFromString(@"SSDKWindow")] || [[[UIApplication sharedApplication].windows objectAtIndex:i]isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            [[UIApplication sharedApplication].windows objectAtIndex:i].frame = CGRectZero;
            [[[UIApplication sharedApplication].windows objectAtIndex:i]removeFromSuperview];
            [[UIApplication sharedApplication].windows objectAtIndex:i].layer.masksToBounds = YES;
        }
    }
}

#pragma mark  解码 url 字符串
+ (NSString *)URLDecodedString:(NSString *)stringURL {
    NSString *result = [stringURL stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

/**
 *  设置statusBar颜色是否是白色的
 *
 *  @param isWhiteColor YES:白色、NO:黑色
 */
+ (void)setStatusBarTitleColorIsWhiteColor:(BOOL)isWhiteColor {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (isWhiteColor) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

#pragma mark - masonry 布局的控件的便利方法 --------------------BEGIN---------------

/**
 *  获取常用的UILabel
 *
 *  @param font      UIFont
 *  @param alignment NSTextAlignment
 *  @param textColor UIColor
 *
 *  @return UILabel
 */
+ (UILabel *)getLabelWithFont:(UIFont *)font alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc]init];
    if (font) {
        label.font = font;
    }
    label.textAlignment = alignment;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

/**
 *  获取常用的 UIButton
 *
 *  @param title      按钮文字
 *  @param titleColor 文字颜色
 *  @param font       字体
 *
 *  @return UIButton
 */
+ (UIButton *)getButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 去掉按钮按下变灰的效果
    [button setAdjustsImageWhenHighlighted:NO];
    [button setBackgroundColor:[UIColor clearColor]];
    if (![NSString isEmptyString:title]) {
        [button setTitle:title forState:UIControlStateNormal];
//        [button setTitle:title forState:UIControlStateHighlighted];
    }
    if (!titleColor) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return button;
}

/**
 *  获取常用的 UIImageView
 *
 *  @param frame 设置圆角的时候需要
 *
 *  @return UIImageView
 */
+ (UIImageView *)getImageViewFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;     ///这个是取中间的一部分。。不压缩的。
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

/**
 *  获取带 image/title 的按钮 (左右排列)
 *
 *  @param image      image
 *  @param title      title
 *  @param titleColor 字体颜色
 *  @param font       font
 *  @param spacing    image和title的间隔
 *  @param type       排列方式
 *
 *  @return UIButton
 */
+ (UIButton *)getButtonImageTitleWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor spacing:(float)spacing alignmentType:(ButtonImageTitleType)type aFont:(UIFont *)aFont {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    if (aFont) {
        button.titleLabel.font = aFont;
    }
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        float imageWidth = image.size.width;
        float titleWidth = 0;
        if (title && ![title isEqualToString:@""]) {
            NSDictionary *attrs = @{NSFontAttributeName:button.titleLabel.font};
            titleWidth = [[button currentTitle]sizeWithAttributes:attrs].width;
        }
        if (type == 0) { // 图片左 整体居中
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -spacing/2.0f, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing/2.0f, 0, 0)];
        }else if (type == 1){ // 图片左 整体居左
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing, 0, 0)];
        }else if (type == 2){ // 图片左 整体居右
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, spacing)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }else if (type == 3){ // 图片右 整体居中
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
        }else if (type == 4){ // 图片右 整体居左
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
        }else if (type == 5){ // 图片右 整体居右
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
            
        }
    }
    
    return button;
}
#pragma mark - masonry 布局的控件的便利方法 --------------------END---------------

#pragma mark - 获取UILabel的多行的size
+ (CGSize)getLabelSize:(UILabel *)label labelWidth:(float)width {
//    // 把UILabel放到ScrollView的上面的时候需要这个属性
//    self.bigTextLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20*2;
    NSString *contentString = [label.text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(width, width * 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: label.font } context:nil].size;
    return size;
}

#pragma mark - 判断当前页面是否正在显示
+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController {
    return (viewController.isViewLoaded && viewController.view.window);
}

#pragma mark - 跳转到指定页面
+ (void)jumpToVC:(NSString *)vcNameString fromVC:(UIViewController *)vc {
    for (int i = 0; i < vc.navigationController.viewControllers.count; i++) {
        if ([vc.navigationController.viewControllers[i]
             isKindOfClass:NSClassFromString(vcNameString)]) {
            [vc.navigationController popToViewController:vc.navigationController.viewControllers[i] animated:YES];
            return;
        }
    }
    [vc.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取当前navigationController.viewControllers里面的某一个VC
+ (UIViewController *)getViewControllerWithName:(NSString *)vcNameString fromVC:(UIViewController *)vc {
    for (int i = 0; i < vc.navigationController.viewControllers.count; i++) {
        if ([vc.navigationController.viewControllers[i]
             isKindOfClass:NSClassFromString(vcNameString)]) {
            return vc.navigationController.viewControllers[i];
        }
    }
    return nil;
}
/// 展示或隐藏悬浮框
+ (void)isShowMyFloatView:(BOOL)isShow {
//    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (isShow) {
//        del.myFloatView.hidden = NO;
//    } else {
//        del.myFloatView.hidden = YES;
//    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [Tooles getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [Tooles getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [Tooles getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

/*
 邮箱隐藏规则，
 1. 字符>5 位就隐藏@符中间的4位字符 例如：zhaoweiyu@speedx.com 隐藏后 zha****yu@speedx.com
 2. 字符=5位隐藏@后前4位     例如：weiyu@speedx.com 隐藏后 w****@speedx.com
 3. 字符<=4位就隐藏@符号前的全部字符 例如：eiyu@speedx.com  隐藏后 ****@speedx.com
 */
#pragma mark - 手机、邮箱添加 * 显示
+ (NSString *)getStarString:(NSString *)oldString {
    NSString *newString = nil;
    if ([NSString isEmptyString:oldString]) {
        return @"";
    }
    if ([oldString containsString:@"@"]) { // 邮箱
        NSString *leftString = [oldString componentsSeparatedByString:@"@"][0];
        if (leftString.length > 4) { // @符号前长度大于4个字符
            if (leftString.length == 5) {
                newString = [NSString stringWithFormat:@"%@****%@",[leftString substringToIndex:leftString.length - 4],[oldString substringFromIndex:[oldString rangeOfString:@"@"].location]];
            } else { // 大于5的情况
                newString = [NSString stringWithFormat:@"%@****%@",[leftString substringToIndex:(leftString.length - 3)/2],[oldString substringFromIndex:(leftString.length - 3)/2 + 4]];
            }
        } else { // @符号前长度小于4个字符
            NSString *star = @"*";
            if (leftString.length == 2) {
                star = @"**";
            } else if (leftString.length == 3) {
                star = @"***";
            } else if (leftString.length == 4) {
                star = @"****";
            }
            newString = [NSString stringWithFormat:@"%@%@",star,[oldString substringFromIndex:[oldString rangeOfString:@"@"].location]];
        }
    } else { // 手机号
        if (oldString.length > 7) {
            newString = [NSString stringWithFormat:@"%@****%@",[oldString substringToIndex:oldString.length - 8],[oldString substringFromIndex:oldString.length - 4]];
        } else {
            newString = oldString;
        }
    }
    return newString;
}

#pragma mark - 图片浏览器的类方法
+ (void)showBigImage:(UIImageView *)smallImageV bigImageUrl:(NSString *)bigImageUrl bigImageUrlArray:(NSArray *)bigImageUrlArray pictureCount:(int)pictureCount currentIndex:(int)index {
    // 登录后，放大头像
    ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
    if (pictureCount == 1) {
        browser.pageTextFont = [UIFont systemFontOfSize:0];
    } else {
        browser.pageTextFont = [UIFont systemFontOfSize:16];
    }
    ESPictureManager *picManager = [ESPictureManager defaultManager];
    picManager.smallImageV = smallImageV;
    picManager.bigImageUrlString = bigImageUrl;
    if (bigImageUrlArray.count > 0) {
        picManager.bigImageUrlArray = [NSArray arrayWithArray:bigImageUrlArray];
    }
    [browser setDelegate:picManager];
    [browser setLongPressBlock:^(NSInteger index) {
//        DDLogDebug(@"长按图片的下标是：%zd", index);
    }];
    [browser showFromView:smallImageV picturesCount:pictureCount currentPictureIndex:index];
}


/**
 停止语音播放的类方法
 */
+ (void)stopSoundAction {
    // 停止语音播放
//    [EMAudioPlayerUtil asyncPlayingWithPath:nil completion:^(NSError *error) {
//        
//    }];
//    if ([EMAudioPlayerUtil isPlaying]) {
//        [EMAudioPlayerUtil stopCurrentPlaying];
//    }
}

/**
 获取音频URL的时间长度 - 单位的秒

 @param voiceUrl 音频的 URL
 @return 秒
 */
+ (NSUInteger)getVoiceTime:(NSURL *)voiceUrl {
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:voiceUrl options:opts]; // 初始化视频媒体文件
//    NSUInteger second = 0;
//    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
//    return second;
    return  "";
}


/**
 获取音频的时间

 @param voiceUrl 音频URL
 @param masterId 达人id
 @return
 */
+ (NSInteger)saveVoiceTimeUrl:(NSURL *)voiceUrl masterId:(NSString *)masterId row:(NSInteger)row {

//    if ([UserManager defaultManager].masterSoundSuccessedDict && [[[UserManager defaultManager].masterSoundSuccessedDict objectForKey:masterId] integerValue] > 0) { // 有个获取成功的标识
//        return 1000;
//    }
//    /// YES的话，表示提供精准的值
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:voiceUrl options:opts]; // 初始化视频媒体文件
//    NSUInteger second = 0;
//    if (urlAsset.duration.timescale == 0) {
//        return 0;
//    }
//    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
//    [[UserManager defaultManager].masterSoundDict setObject:@(second) forKey:masterId];
//    [[UserManager defaultManager].masterSoundSuccessedDict setObject:@(1) forKey:masterId]; // 获取成功的标识
//    return row;
    return 0;
}

/// 播放震动
+ (void)playVibration {
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 播放震动
}
/// 停止震动
+ (void)stopVibration {
//    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate); // 停止震动
}

/// 设置声音变小 - 录音的时候需要小
+ (void)volumeLittle {
//    AVAudioSession *session = [AVAudioSession sharedInstance]; // 小
//    if(![session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord]){
//        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        [session setActive:YES error:nil];
//    }
}

/// 设置声音变大 - 播放声音的时候需要大
+ (void)volumeBig {
//    AVAudioSession *session = [AVAudioSession sharedInstance]; // 大
//    if(![session.category isEqualToString:AVAudioSessionCategoryPlayback]){
//        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [session setActive:YES error:nil];
//    }
}

/// 跳转到系统的设置页面
+ (void)goSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

/// 开始监听网络状态
+ (void)startListeningNetworkStatus {
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

/// 开始监听网络状态
+ (void)stopListeningNetworkStatus {
//    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

/// 保证一个方法在0.5秒内不能重复调用
+ (BOOL)repeatCallAction:(NSString *)funcName {
    static NSDate *now = nil;
    static NSString *funcStr = nil;
    if (![funcStr isEqualToString:funcName]) { // 如果调用的方法不是一个，就重写给now赋值
        now = nil;
    }
    if (!now) {
        now = [NSDate dateWithTimeIntervalSinceNow:-0.6]; // 第一次赋值当然是不能被拦截的。
    }
    if ([[NSDate dateWithTimeIntervalSinceNow:-0.5] compare:now] != kCFCompareGreaterThan) { // 比之前保存的时候小就拦截
//        DDLogDebug(@"频繁调用%@被拦截了",funcName);
        return YES; // 0.5秒内不能重复调用这个方法
    }
//    DDLogDebug(@"调用%@",funcName);
    now = [NSDate date];
    funcStr = funcName;
    return NO;
}

///根据域名获取ip地址 - 可以用于控制APP的开关某一个入口，比接口方式速度快的多
+ (NSString*)getIPWithHostName:(const NSString*)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(hostN);
    } @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    if (phot == NULL) {
        NSLog(@"获取失败");
        return nil;
    }
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0}; inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    NSLog(@"ip=====%@",strIPAddress);
    return strIPAddress;
}

/// 统计进入页面的方法
+ (void)beginLogPageView:(NSString *)title {
    // 友盟统计页面进入
    [MobClick beginLogPageView:title];
}
/// 统计离开页面的方法
+ (void)endLogPageView:(NSString *)title {
    // 友盟统计页面离开
    [MobClick endLogPageView:title];
}

/// 友盟的点击事件
+ (void)event:(NSString *)eventId {
    // 友盟的事件点击按钮
    [MobClick event:eventId];
}

/// 友盟的点击事件-带Label的
+ (void)event:(NSString *)eventId label:(NSString *)labelString {
    // 友盟的事件点击按钮
    [MobClick event:eventId label:labelString];
}

@end
