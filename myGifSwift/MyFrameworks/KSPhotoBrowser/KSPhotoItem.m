//
//  KSPhotoItem.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoItem.h"

#import "UIImage+YCHUD.h"

@interface KSPhotoItem ()

@property (nonatomic, strong, readwrite) UIView *sourceView;
@property (nonatomic, strong, readwrite) UIImage *thumbImage;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSURL *imageUrl;

@end

@implementation KSPhotoItem

- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = image;
        _imageUrl = url;
    }
    return self;
}

- (instancetype)initWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url
{
    return [self initWithSourceView:view
                         thumbImage:view.image
                           imageUrl:url];
}

- (instancetype)initWithSourceView:(UIImageView *)view
                             image:(UIImage *)image {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = image;
        _imageUrl = nil;
        _image = image;
    }
    return self;
}

/// 新添加的 PHAsset
- (instancetype)initWithSourceView:(UIImageView *)view thumbImage: (UIImage *)thumbImg
                             imagePHasset:(PHAsset *)phAsset {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = thumbImg;
        _imageUrl = nil;
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        [option setSynchronous:YES];
        [option setVersion:PHImageRequestOptionsVersionOriginal];
        
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:phAsset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            _image = [UIImage YCHUDImageWithSmallGIFData:imageData scale:1.0];
        }];
        
    }
    return self;
}


+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                    thumbImage:image
                                      imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                          imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                             image:image];
}

@end
