//
//  LCPlatformDataModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "LCPlatformDataModel.h"
#import "LCPlatformListModel.h"

@implementation LCPlatformDataModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [LCPlatformListModel class]};
}


@end
