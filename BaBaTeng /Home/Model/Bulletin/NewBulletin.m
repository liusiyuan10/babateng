//
//  NewBulletin.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "NewBulletin.h"
#import "NewBulletinData.h"

@implementation NewBulletin

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [NewBulletinData class]};
}

@end
