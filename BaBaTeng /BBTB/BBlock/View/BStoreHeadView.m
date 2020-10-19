//
//  BStoreHeadView.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import "BStoreHeadView.h"
//
//@implementation BStoreHeadView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end


#import "BStoreHeadView.h"
#import "Header.h"



@implementation BStoreHeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        
        
        UIView *headView = [self BgView];
        
        UITapGestureRecognizer *headViewtapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelected)];
        [headView addGestureRecognizer:headViewtapGesture];
        
        [self addSubview:headView];
        
        
    }
    return self;
}

-(UIView*)BgView{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,71)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 50, 50)];


    _leftImage.layer.cornerRadius = 25.0;
    //将多余的部分切掉
    _leftImage.layer.masksToBounds = YES;
    _leftImage.image = [UIImage imageNamed:@"Teacher"];
    _leftImage.backgroundColor = [UIColor redColor];
    
    [bgView addSubview:_leftImage];
    

    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 9, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 16)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor =  [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, CGRectGetMaxY(_nameLabel.frame) + 6, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 14)];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.backgroundColor = [UIColor clearColor];
    _authorLabel.textAlignment = NSTextAlignmentLeft;
    _authorLabel.textColor =[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    [bgView addSubview:_authorLabel];

    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, CGRectGetMaxY(_authorLabel.frame)+ 6, 200, 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;

    _timeLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    [bgView addSubview:_timeLabel];
    
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 40, 17, 32, 32)];

    
    [self.addBtn setImage:[UIImage imageNamed:@"icon_bblockstore_nor"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_bblockstore_pre"] forState:UIControlStateDisabled];
    
    [self.addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:self.addBtn];
    
    
    return bgView;
}

- (void)addBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(BStoreHeadViewAddBtnClicked:)]){
        [_delegate BStoreHeadViewAddBtnClicked:self];
    }
}


-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
        [_delegate selectedWith:self];
    }
}
@end
