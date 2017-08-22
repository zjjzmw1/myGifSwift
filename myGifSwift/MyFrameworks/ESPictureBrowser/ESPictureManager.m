//
//  ESPictureManager.m
//  niaoyutong
//
//  Created by zhangmingwei on 2017/4/7.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

#import "ESPictureManager.h"
#import "UIView+Utils.h"

@implementation ESPictureManager

+ (instancetype)defaultManager
{
    static ESPictureManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 只能执行一次：这里是单利属性的初始化。
        
    }
    return self;
}

#pragma mark - 图片浏览器相关代理
/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    //    return [self.pictureImageNodes objectAtIndex:index].view;
//    return self.headerView.headerImageView;
    return self.smallImageV;
}

/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    
    //    ESPictureModel *model = self.pictureModels[index];
    //    CGSize size = CGSizeMake(model.width, model.height);
    //    return size;
    return CGSizeMake(self.smallImageV.width, self.smallImageV.height);
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    //    UIImage *image;
    //    ASNetworkImageNode *imageNode =  [self.pictureImageNodes objectAtIndex:index];
    //    if (imageNode.view.subviews.count == 1) {
    //        image = ((YYAnimatedImageView *)imageNode.view.subviews.firstObject).image;
    //    }else {
    //        image = imageNode.image;
    //    }
    //    return image;
    return self.smallImageV.image;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    //    ESPictureModel *model = self.pictureModels[index];
    //    return model.picUrl;
    if (self.bigImageUrlArray.count > 0) {
        return self.bigImageUrlArray[index];
    }
    return self.bigImageUrlString;
}

@end
