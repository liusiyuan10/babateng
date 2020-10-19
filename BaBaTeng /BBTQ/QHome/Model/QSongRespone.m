//
//  QSongRespone.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSongRespone.h"
#import "QSongListResponse.h"

@implementation QSongRespone


// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"tracks" : [QSongListResponse class]};
}


@end
