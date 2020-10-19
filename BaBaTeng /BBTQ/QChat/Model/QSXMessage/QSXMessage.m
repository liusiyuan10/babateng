//
//  QSXMessage.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QSXMessage.h"

#import "QSXMessageData.h"

@implementation QSXMessage

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [QSXMessageData class]};
}


@end
