//
//  Q2FavoriteRespone.m
//  XZ_WeChat
//
//  Created by liu on 17/3/17.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "QFavoriteRespone.h"
#import "QFavoriteResultRespone.h"

@implementation QFavoriteRespone
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [QFavoriteResultRespone class]};
}

@end
