//
//  TeaReservationRes.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface TeaReservationRes : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *dateMd;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSMutableArray *timeSlots;


@end
