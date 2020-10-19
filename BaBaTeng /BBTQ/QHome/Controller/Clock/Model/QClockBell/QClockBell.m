//
//  QClockBell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockBell.h"
#import "QClockBellData.h"

@implementation QClockBell

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{ @"data" : [QClockBellData class] };
}

@end
