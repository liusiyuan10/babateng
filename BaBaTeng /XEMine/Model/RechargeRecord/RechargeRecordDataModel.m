//
//  RechargeRecordDataModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "RechargeRecordDataModel.h"
#import "RechargeRecordListModel.h"


@implementation RechargeRecordDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [RechargeRecordListModel class]};
}

@end
