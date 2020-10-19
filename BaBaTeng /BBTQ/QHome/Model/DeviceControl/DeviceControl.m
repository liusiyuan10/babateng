//
//  DeviceControl.m
//  BaBaTeng
//
//  Created by liu on 17/8/3.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "DeviceControl.h"

#import "DeviceControlData.h"

@implementation DeviceControl

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [DeviceControlData class]};
}

@end
