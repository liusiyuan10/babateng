//
//  XEGoodDataModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEGoodDataModel.h"
#import "XEGoodListModel.h"

@implementation XEGoodDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [XEGoodListModel class]};
}

@end
