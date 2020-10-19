//
//  ClassroomPlayback.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "ClassroomPlayback.h"
#import "ClassroomPlaybackData.h"

@implementation ClassroomPlayback

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [ClassroomPlaybackData class] };
}




@end
