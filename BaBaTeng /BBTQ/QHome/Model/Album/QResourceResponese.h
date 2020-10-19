//
//  ResourceResponese.h
//  BaBaTeng
//
//  Created by liu on 17/3/3.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface QResourceResponese :  NSObject<MJKeyValue>

/***
 *	result
 */
@property (nonatomic, strong) NSArray *result;

/***
 *价格
 */
@property (nonatomic, copy) NSString *errcode;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *errinfo;

@end
