//
//  PanetMineAddressDataAddressModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineAddressDataAddressModel.h"
#import "PanetMineAddressListModel.h"



@implementation PanetMineAddressDataAddressModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [PanetMineAddressListModel class]};
}


@end
