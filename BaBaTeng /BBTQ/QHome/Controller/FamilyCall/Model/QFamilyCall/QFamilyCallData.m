//
//  QFamilyCallData.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyCallData.h"
#import "QFamilytopContactData.h"


#import "QFamilyAllContact.h"



@implementation QFamilyCallData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
//    return @{@"topContacts" : [QFamilytopContactData class]};
    
    return @{@"topContacts" : [QFamilyAllContact class]};
}

@end
