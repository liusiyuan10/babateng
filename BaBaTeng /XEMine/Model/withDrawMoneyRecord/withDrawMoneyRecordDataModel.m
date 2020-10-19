//
//  withDrawMoneyRecordDataModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/10.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "withDrawMoneyRecordDataModel.h"
#import "withDrawMoneyRecordListModel.h"

@implementation withDrawMoneyRecordDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [withDrawMoneyRecordListModel class]};
}

@end
