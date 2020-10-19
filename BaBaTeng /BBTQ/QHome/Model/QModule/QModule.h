//
//  QModule.h
//  BaBaTeng
//
//  Created by liu on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface QModule : NSObject<MJKeyValue>

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
