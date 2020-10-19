//
//  QFamilyAllPhone.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyAllPhone.h"
#import "QFamilyPPhone.h"

@implementation QFamilyAllPhone


// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"phones" : [QFamilyPPhone class] };
}


@end
