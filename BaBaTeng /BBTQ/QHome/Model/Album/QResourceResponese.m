//
//  ResourceResponese.m
//  BaBaTeng
//
//  Created by liu on 17/3/3.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QResourceResponese.h"
#import "QResourceListResponese.h"

@implementation QResourceResponese

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [QResourceListResponese class]};
}

@end
