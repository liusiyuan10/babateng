//
//  QNewSongDetailsData.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QNewSongDetailsData.h"
#import "QAlbumDataTrackList.h"
@implementation QNewSongDetailsData
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [QAlbumDataTrackList class]};
}

@end
