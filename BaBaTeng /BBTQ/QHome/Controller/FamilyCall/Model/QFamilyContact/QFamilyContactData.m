//
//  QFamilyContactData.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyContactData.h"

#import "QFamilyAllContact.h"

@implementation QFamilyContactData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"contacts" : [QFamilyAllContact class] ,@"topContacts" : [QFamilyAllContact class]};
}

@end
