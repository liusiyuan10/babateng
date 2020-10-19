//
//  QAlbumResponse.m
//  BaBaTeng
//
//  Created by liu on 17/5/23.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"

@implementation QAlbumResponse

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [QAlbumListResponse class]};
}

@end
