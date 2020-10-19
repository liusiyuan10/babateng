//
//  PanetKnIntelModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetKnIntelModel.h"
#import "PanetKnIntelDataModel.h"

@implementation PanetKnIntelModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [PanetKnIntelDataModel class]};
}


@end
