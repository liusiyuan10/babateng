//
//  QMPanelData.m
//  BaBaTeng
//
//  Created by liu on 17/8/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QMPanelData.h"
#import "QMPanelList.h"

@implementation QMPanelData

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [QMPanelList class]};
}


@end
