//
//  QSXMessage.h
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface QSXMessage : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@property(nonatomic, strong) NSArray *data;
@end
