//
//  KSPhotoItem.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPhotoItem : NSObject

@property (nonatomic, strong, readonly) UIView *sourceView;
@property (nonatomic, strong, readonly) UIImage *thumbImage;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSURL *imageUrl;
@property (nonatomic, assign) BOOL finished;

- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                             image:(UIImage *)image;

/// 新添加的 PHAsset
- (instancetype)initWithSourceView:(UIImageView *)view thumbImage: (UIImage *)thumbImg
                      imagePHasset:(PHAsset *)phAsset;

+ (instancetype)itemWithSourceView:(UIView *)view
                         thumbImage:(UIImage *)image
                           imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                           imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                              image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
