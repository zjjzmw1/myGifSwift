//
//  PSVisualCell.h
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/23.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSVisualCell : UITableViewCell

- (void)reloadBackgroundImage:(UIImage *)image description:(NSString *)des;

- (void)reloadBackgroundImageUrl:(NSString *)urlStr description:(NSString *)des;

- (void)reloadWithScrollView:(UIScrollView *)scrollView totalView:(UIView *)totalView;
    
@end
