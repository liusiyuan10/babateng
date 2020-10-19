//
//  QClock.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClock.h"
#import "QClockData.h"

@implementation QClock

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{ @"data" : [QClockData class] };
}

@end
