//
//  FamilyData.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "FamilyData.h"

#import "FamilyDataList.h"

@implementation FamilyData
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"familyMembers" : [FamilyDataList class]};
}
@end
