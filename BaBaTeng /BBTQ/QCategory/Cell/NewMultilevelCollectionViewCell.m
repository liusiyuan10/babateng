//
//  NewMultilevelCollectionViewCell.m
//  YijietongBuy
//
//  Created by YangGH on 15/11/19.
//  Copyright © 2015年 YangGH. All rights reserved.
//

#import "NewMultilevelCollectionViewCell.h"
#import "Header.h"
@implementation NewMultilevelCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        // change to our custom selected background view
        self.imageView = [[UIImageView alloc]init];
//        [self.imageView setFrame:CGRectMake(0,0,(kDeviceWidth-120)/3,80)];
        [self.imageView setFrame:CGRectMake(10,0,60,60)];
//        [self.imageView setBackgroundColor:[UIColor redColor]];
//        self.myImageView.layer.cornerRadius = 2.0;//（该值到一定的程度，就为圆形了。）
        
        self.imageView.layer.borderWidth = 0.5;
        self.imageView.layer.borderColor =[[UIColor alloc] initWithWhite:0.9 alpha:1].CGColor;
        self.imageView.clipsToBounds = YES;//去除边界
        
        self.imageView.layer.masksToBounds=YES; // 隐藏边界
        [self addSubview:self.imageView];
        
        self.titile = [[UILabel alloc]init];
        [self.titile setFrame:CGRectMake(0,60, (kDeviceWidth-100)/3,20)];
        [self.titile setBackgroundColor:[UIColor clearColor]];
        self.titile.textAlignment = NSTextAlignmentCenter;
//        self.titile.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.titile.font = [UIFont systemFontOfSize:11.0];
   
//        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.titile];

        
    }
    return self;
    
}
@end
