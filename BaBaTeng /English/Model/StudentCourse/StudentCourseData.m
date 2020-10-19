//
//  StudentCourseData.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "StudentCourseData.h"
#import "StudentCourseList.h"

@implementation StudentCourseData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [StudentCourseList class] };
}

@end
