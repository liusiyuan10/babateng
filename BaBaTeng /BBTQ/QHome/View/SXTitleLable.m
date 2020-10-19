//
//  SXTitleLable.m
//  85 - 网易滑动分页
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTitleLable.h"

@implementation SXTitleLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:13];
        //self.backgroundColor = [UIColor orangeColor];
        self.textColor = [UIColor colorWithRed:255/255.0 green:209/255.0 blue:172/255.0 alpha:1];
        
        //        self.textColor = [UIColor redColor];
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.textColor = [UIColor whiteColor];
    // self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-0.9)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}


///** 通过scale的改变改变多种参数 */
//- (void)setScale:(CGFloat)scale
//{
//    _scale = scale;
//
//    //self.textColor = [UIColor whiteColor];
//    self.font = [UIFont systemFontOfSize:20];
//    self.textColor = [UIColor colorWithWhite:scale alpha:1.0];
//    CGFloat minScale = 0.7;
//    CGFloat trueScale = minScale + (1-0.9)*scale;
//    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
//}

//-(UIView*)line{
//
//
//       _line.backgroundColor = [UIColor purpleColor];
//
//
//
//    return _line;
//}
@end
