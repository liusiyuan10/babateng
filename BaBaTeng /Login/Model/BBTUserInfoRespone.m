//
//  LoginRespone.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/30.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTUserInfoRespone.h"
#import "BBTResultRespone.h"
@implementation BBTUserInfoRespone

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [BBTResultRespone class]};
}

@end
