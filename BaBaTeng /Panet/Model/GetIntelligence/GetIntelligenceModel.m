//
//  GetIntelligenceModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "GetIntelligenceModel.h"
#import "GetIntelligenceDataModel.h"


@implementation GetIntelligenceModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [GetIntelligenceDataModel class]};
}

@end
