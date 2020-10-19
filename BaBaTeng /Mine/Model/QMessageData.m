//
//  QMessageData.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QMessageData.h"
#import "QMessageDataList.h"
@implementation QMessageData
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [QMessageDataList class]};
}
@end
