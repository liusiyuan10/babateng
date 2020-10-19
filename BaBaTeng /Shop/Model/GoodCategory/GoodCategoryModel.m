//
//  GoodCategoryModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/19.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "GoodCategoryModel.h"
#import "GoodCategoryDataModel.h"

@implementation GoodCategoryModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [GoodCategoryDataModel class]};
}


@end
