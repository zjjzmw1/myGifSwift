//
//  PSVisualCell.m
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/23.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

#import "PSVisualCell.h"
#import "UIView+Utils.h"
#import <YYKit/YYKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

static CGFloat const kImageViewHeight = 300;

@interface PSVisualCell ()
    
@end

@implementation PSVisualCell
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.label];
    }
    return self;
}
    
#pragma mark -
#pragma mark - external calling methods
- (void)reloadBackgroundImage:(UIImage *)image description:(NSString *)des {
    _backgroundImageView.image = image;
    _label.text = des;
}

- (void)reloadBackgroundImageUrl:(NSString *)urlStr description:(NSString *)des {
    [ _backgroundImageView setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur];
    _label.text = des;
}
    
    /**
     * 需要注意的有一下几点：
     *  1、需要将self.clipsToBounds = YES
     *  2、kImageViewHeight 设置的值一定要大于cell的高度
     *  3、需要设置imageView的top初始值为0
     *  4、需要在 - (void)scrollViewDidScroll:(UIScrollView *)scrollView 中调用
     - (void)reloadWithScrollView:(UIScrollView *)scrollView totalView:(UIView *)totalView 方法，可以查看 "ViewController.m" 文件
     */
    
    /**
     * 主要思路如下：
     *  当cell在最顶部的时候，imageView的底部（bottom）刚好和cell的底部重合（也和totalView的底部重合）
     *  当cell在最底部的时候，imageView的顶部（top）刚好和cell的顶部重合（也和totalView的顶部重合）
     *  我们假如cell从底部向上滚动，从完全不可见到可见，再到完全消失，这个过程中cell的偏移量是totalView.height + cell.height
     *  而这期间imageView的偏移量恰好是不可见部分的高度，即imageView.height - cell.height
     *  而我们需要知道的就是scrollView每移动一像素imageView移动的距离，可得如下算式：
     *  // 这是每一像素image对应移动的距离
     imageHidePartHeight / (scrollView.height + cell.height)
     *  // 可知相对于中心的移动距离为
     CGFloat imageOffsetY = imageHidePartHeight / (scrollView.height + self.height) * distance
     *  当cell在正中心的时候，top为imageHidePartHeight / 2
     *  可知移动之后的top值应为 imageOffsetY - imageHidePartHeight / 2
     */
- (void)reloadWithScrollView:(UIScrollView *)scrollView totalView:(UIView *)totalView {
    // 获取 cell 在 scrollView 父视图中的 frame
    CGRect rect = [scrollView convertRect:self.frame toView:totalView];
    // cell的顶部到self.parentView的中心距离
    CGFloat distance = totalView.height / 2 - rect.origin.y;
    // imageView 在cell之外部分的高度（即imageView隐藏部分的高度）
    CGFloat imageHidePartHeight = self.backgroundImageView.height - self.height;
    // imageView应有的偏移距离
    CGFloat imageOffsetY = imageHidePartHeight / (scrollView.height + self.height) * distance;
    // 当cell在正中心的时候，top为imageHidePartHeight / 2
    // 可知移动之后的top值应为 imageOffsetY - imageHidePartHeight / 2
    self.backgroundImageView.top = imageOffsetY - imageHidePartHeight / 2;
}
    
#pragma mark -
#pragma mark - getter methods
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, kImageViewHeight);
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}
    
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(0, 0, 150, 20);
        _label.center = CGPointMake(kScreenWidth / 2, 200 / 2);
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = 1;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:20];
    }
    return _label;
}
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
    

@end
