//
//  DeviceControl.h
//  BaBaTeng
//
//  Created by liu on 17/8/3.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface DeviceControl : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end
