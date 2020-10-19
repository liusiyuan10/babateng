//
//  HDMyFriendDataModel.m
//  BaBaTeng
//
//  Created by xyj on 2019/5/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "HDMyFriendDataModel.h"
#import "HDMyFriendListModel.h"

@implementation HDMyFriendDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [HDMyFriendListModel class]};
}


@end
