//
//  QHistoryData.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QHistoryData.h"
#import "QHistoryDataList.h"
#import "QAlbumDataTrackList.h"
@implementation QHistoryData
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [QAlbumDataTrackList class]};
}

@end
