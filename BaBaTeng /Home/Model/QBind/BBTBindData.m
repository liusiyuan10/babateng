//
//  BBTBindData.m
//  BaBaTeng
//
//  Created by liu on 17/6/8.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBindData.h"
#import "BBTBindDataList.h"

@implementation BBTBindData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [BBTBindDataList class]};
}


@end
