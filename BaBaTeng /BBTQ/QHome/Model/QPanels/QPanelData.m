//
//  QPanelData.m
//  BaBaTeng
//
//  Created by liu on 17/7/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QPanelData.h"

#import "QPanelDataTrackList.h"

@implementation QPanelData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"trackLists" : [QPanelDataTrackList class]};
}


@end
