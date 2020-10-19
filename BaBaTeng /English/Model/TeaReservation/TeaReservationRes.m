//
//  TeaReservationRes.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "TeaReservationRes.h"

#import "TeaReservationTime.h"

@implementation TeaReservationRes

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"timeSlots" : [TeaReservationTime class] };
}


@end
