//
//  ESPictureManager.h
//  niaoyutong
//
//  Created by zhangmingwei on 2017/4/7.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESPictureBrowser.h"        // 照片浏览器

@interface ESPictureManager : NSObject<ESPictureBrowserDelegate>

+ (instancetype)defaultManager;

// ----------- 单张图的时候 -----------
@property (nonatomic, strong) UIImageView   *smallImageV;       // 小图的view
@property (nonatomic, strong) NSString      *bigImageUrlString; // 大图的url
// ----------- 多张图的时候 -----------
@property (nonatomic, strong) NSArray       *bigImageUrlArray;  // 大图的URL数组

@end
