//
//  QSourceTypeData.m
//  BaBaTeng
//
//  Created by liu on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSourceTypeData.h"
#import "QSourceTypeDataTag.h"


@implementation QSourceTypeData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"sourceTags" : [QSourceTypeDataTag class]};
}

@end
