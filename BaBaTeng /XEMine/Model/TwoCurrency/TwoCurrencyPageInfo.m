//
//  TwoCurrencyPageInfo.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "TwoCurrencyPageInfo.h"
#import "TwoCurrencyListModel.h"

@implementation TwoCurrencyPageInfo

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [TwoCurrencyListModel class]};
}

@end
