//
//  QSourceTagData.m
//  BaBaTeng
//
//  Created by liu on 17/7/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSourceTagData.h"
#import "QSourceTagList.h"
#import "QAlbumDataTrackList.h"
@implementation QSourceTagData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [QAlbumDataTrackList class]};
}


@end
