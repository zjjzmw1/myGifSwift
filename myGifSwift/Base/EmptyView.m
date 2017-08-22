//
//  EmptyView.m
//  Vodka
//
//  Created by xiaoming on 15/11/30.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "EmptyView.h"
#import <Masonry/Masonry.h>
#import "mysuper-Swift.h"
#import "UIColor+IOSUtils.h"

@interface EmptyView ()

@end

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        __weak typeof(self) wSelf = self;
        //默认图。
        _imageV = [[UIImageView alloc]init];
        [self addSubview:_imageV];
        _imageV.frame = CGRectMake(0, 0, 110, 110);
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110, 110));
            make.centerX.mas_equalTo(wSelf.mas_centerX).with.offset(0);
            make.centerY.mas_equalTo(wSelf.mas_centerY).with.offset(-20);
        }];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.image = [UIImage imageNamed:@"all_default_no_data_img"];
        //默认文字。
        _label = [[UILabel alloc]init];
        [self addSubview:_label];
        _label.backgroundColor = [UIColor clearColor];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(80);
            make.right.equalTo(wSelf.mas_right).with.offset(-80);
            make.top.equalTo(_imageV.mas_bottom).with.offset(20);
        }];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor getContentColor];
        
        // 三行的情况，下面一行文字
        _lastLabel = [[UILabel alloc]init];
        [self addSubview:_lastLabel];
        _lastLabel.backgroundColor = [UIColor clearColor];
        [_lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(80);
            make.right.equalTo(wSelf.mas_right).with.offset(-80);
            make.top.equalTo(_label.mas_bottom).with.offset(10);
        }];
        _lastLabel.numberOfLines = 0;
        _lastLabel.font = [UIFont systemFontOfSize:12];
        _lastLabel.textAlignment = NSTextAlignmentCenter;
        _lastLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        self.backgroundColor = [UIColor getBackgroundColor];

    }
    
    return self;
}

#pragma mark - 常用的方法
- (void)image:(UIImage *)image labelString:(NSString *)labelString {
    if (image) {
        self.imageV.image = image;
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
        }];
    }
    self.label.text = labelString;
    self.label.textColor = [UIColor getContentSecondColor];
}

#pragma mark - 三行的情况下
- (void)image:(UIImage *)image labelString:(NSString *)labelString lastString:(NSString *) lastString {
    if (image) {
        self.imageV.image = image;
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
        }];
    }
    self.label.text = labelString;
    self.label.textColor = [UIColor getContentSecondColor];
    self.lastLabel.text = lastString;
    self.lastLabel.textColor = [UIColor getMainColor];
}
//
//#pragma mark 上面UILabel 下面 UIButton 的默认页面
//- (void)getButtonWithTitle:(NSString *)title labelString:(NSString *)labelString {
//    self.imageV.hidden = NO;
//    [self.label removeFromSuperview];
//    
//    __weak typeof(self) wSelf = self;
//    //默认文字。
//    _label = [[UILabel alloc]init];
//    [self addSubview:_label];
//    _label.backgroundColor = [UIColor clearColor];
//    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(wSelf.mas_left).with.offset(40);
//        make.right.equalTo(wSelf.mas_right).with.offset(-40);
//        make.top.equalTo(wSelf.mas_top).with.offset(150);
//    }];
//    _label.numberOfLines = 0;
//    _label.font = FONT_Helvetica(12);
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.textColor = [UIColor colorFromHexString:@"#EBEBEB"];
//    _label.text = labelString;
//    
//    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
//    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    //    [paragraphStyle setLineSpacing:4];//调整行间距
//    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelString length])];
//    //    _label.attributedText = attributedString;
//    
//    //默认Button
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_button];
//    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(wSelf.mas_left).with.offset(80);
//        make.right.equalTo(wSelf.mas_right).with.offset(-80);
//        make.top.equalTo(wSelf.label.mas_bottom).with.offset(30);
//        make.height.mas_equalTo(40);
//    }];
//    _button.layer.borderColor = [UIColor colorFromHexString:@"FF3B3B"].CGColor;
//    _button.layer.borderWidth = 0.5;
//    _button.layer.cornerRadius = 2;
//    _button.layer.masksToBounds = YES;
//    [_button setTitle:title forState:UIControlStateNormal];
//    [_button setTitleColor:[UIColor colorFromHexString:@"FF3B3B"] forState:UIControlStateNormal];
//    _button.titleLabel.font = FONT_Helvetica(17);
//}
//
//- (void)imageStringBottom:(NSString *)imageString labelString:(NSString *)labelString {
//    self.imageV.image = [UIImage imageNamed:imageString];
//    
//    __weak typeof(self) wSelf = self;
//    [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo((wSelf.width - 66) / 2);
//        make.top.mas_equalTo(200);
//        make.size.mas_equalTo(CGSizeMake(66, 66));
//    }];
//    
//    [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(wSelf.mas_left).with.offset(80);
//        make.right.equalTo(wSelf.mas_right).with.offset(-80);
//        make.top.equalTo(_imageV.mas_bottom).with.offset(30);
//    }];
//    self.label.font = FONT_Helvetica(15);
//    self.label.textColor = [UIColor colorFromHexString:@"666666"];
//    self.label.text = labelString;
//    [self.label sizeToFit];
//}

@end
