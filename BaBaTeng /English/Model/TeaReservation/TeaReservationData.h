//
//  TeaReservationData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface TeaReservationData : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *reservations;
@property (nonatomic, copy) NSString *toBeReservedTimes;


@end
