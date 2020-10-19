//
//  BBTStartPageCell.m
//  BaBaTeng
//
//  Created by liu on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTStartPageCell.h"
#import "Header.h"
#import "IphoneType.h"

@interface BBTStartPageCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *iconView;




@end



@implementation BBTStartPageCell

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 143, 74)];
        _iconView.image = [UIImage imageNamed:@"logo_bai"];
        
        [self.contentView addSubview:_iconView];
        
    }
    
    return _iconView;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        

        
        btn.frame = CGRectMake(0, 0, kDeviceWidth - 150, 50);
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius=25.0f;
    
        
        
        [self.contentView addSubview:btn];
        
        _loginButton = btn;
        
    }
    
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil)
    {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [startBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        
//        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];

        
        startBtn.frame = CGRectMake(0, 0, kDeviceWidth - 150, 50);
        startBtn.backgroundColor = [UIColor clearColor];
        startBtn.layer.cornerRadius= 25.0f;
        
        startBtn.layer.borderWidth = 1.2;
        startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        startBtn.clipsToBounds = YES;//去除边界
        [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
//        [startBtn sizeToFit];
        
//        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:startBtn];
        
        _registerButton = startBtn;
        
        
        
    }
    
    return _registerButton;
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        
        
        
        // 注意一定要加到contentView上
        [self.contentView addSubview:imageV];
        
    }
    
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    self.iconView.center =  CGPointMake(self.width * 0.5, self.height * 0.3);
    
    // 分享按钮
    
    CGFloat loginY;
    
    if ([IphoneType IFChangeCoordinates]) {
        
        loginY = self.height * 0.65;
        
    }else{
        
        loginY = self.height * 0.7;
    }
    self.loginButton.center = CGPointMake(self.width * 0.5, loginY);
    
    // 开始按钮
    self.registerButton.center = CGPointMake(self.width * 0.5, self.height * 0.8);
    
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) {// 最后一页，显示分享和开始按钮
        
        self.iconView.hidden = NO;
        self.loginButton.hidden = NO;
        self.registerButton.hidden = NO;
        
    }
    else
    {// 非最后一页，隐藏分享和开始按钮
        
        self.iconView.hidden = YES;
        self.loginButton.hidden = YES;
        self.registerButton.hidden = YES;
    }
}

//// 点击开始微博的时候调用
//- (void)start
//{
//    
//}

@end
