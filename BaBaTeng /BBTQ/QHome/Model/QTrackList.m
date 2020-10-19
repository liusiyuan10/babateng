//
//  Q3TrackList.m
//  XZ_WeChat
//
//  Created by liu on 17/3/30.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "QTrackList.h"
#import "QTrackListResponse.h"

@implementation QTrackList

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"result" : [QTrackListResponse class]};
}

@end
