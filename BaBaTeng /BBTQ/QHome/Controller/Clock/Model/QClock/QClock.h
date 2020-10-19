//
//  QClock.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface QClock : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end
