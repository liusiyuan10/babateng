//
//  BVoiceDataModel.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/29.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BVoiceDataModel.h"

#import "QAlbumDataTrackList.h"

@implementation BVoiceDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"QAlbumDataTrackList" : [QAlbumDataTrackList class] };
}


@end
