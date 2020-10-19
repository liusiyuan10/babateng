//
//  BBTStudentProgressView.m
//  JGProgressView
//
//  Created by xyj on 2019/9/10.
//  Copyright © 2019 ZJNY. All rights reserved.
//

#import "BBTStudentProgressView.h"


#define KProgressColor [UIColor colorWithRed:253.0/255 green:143.0/255 blue:45.0/255 alpha:1.0f]

@interface BBTStudentProgressView ()

@property (nonatomic, weak) UIView *tView;

@property (nonatomic, strong) UIButton *tBtn;

@end

@implementation BBTStudentProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self LoadChildView];
    }
    
    return self;
}

- (void)LoadChildView
{
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width- 18, 10)];
    borderView.layer.cornerRadius = 5;
    borderView.layer.masksToBounds = YES;
    borderView.backgroundColor = [UIColor colorWithRed:247/255.0 green:240/255.0 blue:233/255.0 alpha:1.0];
    //        borderView.layer.borderColor = [KProgressColor CGColor];
    //        borderView.layer.borderWidth = KProgressBorderWidth;
    [self addSubview:borderView];
    
    //进度
    UIView *tView = [[UIView alloc] init];
    tView.backgroundColor = KProgressColor;
    tView.layer.cornerRadius = 5;
    tView.layer.masksToBounds = YES;
    [self addSubview:tView];
    self.tView = tView;
    
    self.tBtn = [[UIButton alloc] init];
    
    [self.tBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.tBtn.backgroundColor = [UIColor redColor];
    [self.tBtn setBackgroundImage:[UIImage imageNamed:@"studentstyle_score"] forState:UIControlStateNormal];
    self.tBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [self addSubview:self.tBtn];
    
   
    
}
    

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat maxWidth = self.bounds.size.width - 18;
//    CGFloat heigth = self.bounds.size.height;
    
    _tView.frame = CGRectMake(0, 0, maxWidth * progress, 10);
    
    NSInteger num =_progress*10;
    [_tBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    
    _tBtn.frame = CGRectMake(maxWidth * progress, 15, 18, 15);
}


@end

