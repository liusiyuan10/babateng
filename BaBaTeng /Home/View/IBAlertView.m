//
//  IBAlertView.m
//  IBAlertView
//
//  Created by iBlocker on 2017/8/7.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBAlertView.h"

@interface IBAlertView () {
    CGFloat _viewHeight;
}
@property (nonatomic, strong) IBConfigration *configration;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) IBAlertBlock alertBlock;
@end

@implementation IBAlertView

+ (instancetype)alertWithConfigration:(IBConfigration *)configration block:(IBAlertBlock)block {
    
    IBAlertView *alertView = [[IBAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    alertView.configration = configration;
    alertView.alertBlock = block;
    [alertView handleSubviews];
    
    return alertView;
}

- (void)setConfigration:(IBConfigration *)configration {
    if (!configration) {
        configration.title = @"title";
        configration.message = @"message";
        configration.cancelTitle = @"Cancel";
        configration.confirmTitle = @"Confirm";
        configration.messageAlignment = NSTextAlignmentLeft;
    }
    
    CGRect rect = [self getHeightOfText:configration.message width:kScreenWidth - 100 font:[UIFont systemFontOfSize:14]];
    _viewHeight = rect.size.height + 39 + 15 + 50 + 22;
    self.messageLab.text = configration.message;
    self.messageLab.textAlignment = configration.messageAlignment;
    self.messageLab.frame = (CGRect){20, self.lineView.frame.origin.y + 8, kScreenWidth - 100, rect.size.height};
    
    self.titleLab.text = configration.title;
    self.titleLab.textColor =[UIColor  orangeColor];
   
    [self.cancelButton setTitle:configration.cancelTitle forState:UIControlStateNormal];
    [self.confirmButton setTitle:configration.confirmTitle forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = configration.tintColor;
    
    _configration = configration;
}

- (void)handleSubviews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.messageLab];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.confirmButton];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [keyWindow bringSubviewToFront:self];
}

#pragma mark - Method
- (CGRect)getHeightOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

- (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

#pragma mark - Subviews
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.center = self.center;
        _bgView.bounds = (CGRect){0, 0, kScreenWidth - 60, _viewHeight};
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.frame = CGRectMake(20, 15, kScreenWidth - 100, 24);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:17];
    }
    return _titleLab;
}
- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [UIImageView new];
        _lineView.frame = CGRectMake(20, 45, kScreenWidth - 100, 1);
        _lineView.backgroundColor = [UIColor orangeColor];
    }
    return _lineView;
}
- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel new];
        _messageLab.font = [UIFont systemFontOfSize:14];
        _messageLab.numberOfLines = 0;
        _messageLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _messageLab;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = (CGRect){0, _viewHeight - 50, (kScreenWidth - 60) / 2.0, 50};
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.tag = 1;
        [_cancelButton setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
//        //  点击选中按钮再移出按钮范围
//        [_cancelButton addTarget:self action:@selector(touchDragOut:) forControlEvents:UIControlEventTouchDragOutside];
//        //  修改点击选中按钮的背景色
//        [_cancelButton addTarget:self action:@selector(touchDownClick:) forControlEvents:UIControlEventTouchDown];
        //  点击方法
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmButton.frame = (CGRect){(kScreenWidth - 60) / 2.0, _viewHeight - 50, (kScreenWidth - 60) / 2.0, 50};
        _confirmButton.tag = 2;
        [_confirmButton setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
//        //  点击选中按钮再移出按钮范围
//        [_confirmButton addTarget:self action:@selector(touchDragOut:) forControlEvents:UIControlEventTouchDragOutside];
//        //  修改点击选中按钮的背景色
//        [_confirmButton addTarget:self action:@selector(touchDownClick:) forControlEvents:UIControlEventTouchDown];
        //  点击方法
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - Action
- (void)touchDragOut:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.backgroundColor = [UIColor whiteColor];
    } else {
        sender.backgroundColor = self.configration.tintColor;
    }
}
- (void)touchDownClick:(UIButton *)sender {
    //  修改点击选中按钮,修改背景色
    if (sender.tag == 1) {
        sender.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
    } else {
        //  获取原有背景景色的RGBA值
        NSArray *colorArr = [self getRGBWithColor:self.configration.tintColor];
        //  根据RGBA值获取新的Color
        UIColor *touchDownColor = [UIColor colorWithRed:[colorArr[0] floatValue] * 0.7 green:[colorArr[1] floatValue] * 0.7 blue:[colorArr[2] floatValue] * 0.7 alpha:[colorArr[3] floatValue] * 0.7];
        sender.backgroundColor = touchDownColor;
    }
}
- (void)buttonClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
}

@end
