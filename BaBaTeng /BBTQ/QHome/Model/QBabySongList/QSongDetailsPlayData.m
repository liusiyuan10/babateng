//
//  QSongDetailsPlayData.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSongDetailsPlayData.h"
#import "QAlbumDataTrackList.h"
@implementation QSongDetailsPlayData
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"tracks" : [QAlbumDataTrackList class]};
}

@end
