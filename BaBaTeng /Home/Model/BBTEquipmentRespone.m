//
//  BBTEquipmentRespone.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTEquipmentRespone.h"
#import "BBTResultRespone.h"
@implementation BBTEquipmentRespone
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [BBTResultRespone class]};
}

@end
