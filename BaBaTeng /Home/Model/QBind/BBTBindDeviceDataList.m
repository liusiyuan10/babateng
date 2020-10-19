//
//  BBTBindDeviceList.m
//  BaBaTeng
//
//  Created by liu on 17/8/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBindDeviceDataList.h"
#import "BBTBindFamily.h"

@implementation BBTBindDeviceDataList

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"familys" : [BBTBindFamily class]};
}

@end
