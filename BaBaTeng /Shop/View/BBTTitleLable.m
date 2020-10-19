//
//  SXTitleLable.m
//  85 - 网易滑动分页
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "BBTTitleLable.h"
#import "Header.h"

@implementation BBTTitleLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:21];
        //self.backgroundColor = MNavBackgroundColor;
        self.textColor = MNavBackgroundColor;
        
        //        self.textColor = [UIColor redColor];
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
//    NSLog(@"---22-------%f",scale);
    
    self.textColor =[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0];//[UIColor colorWithRed:247.0/255 green:65.0/255 blue:78.0/255 alpha:1.0f];// [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0];
    

    

    CGFloat minScale = 0.9;
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
