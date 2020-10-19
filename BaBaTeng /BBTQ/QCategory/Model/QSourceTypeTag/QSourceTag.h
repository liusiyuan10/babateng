//
//  QSourceTag.h
//  BaBaTeng
//
//  Created by liu on 17/7/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QSourceTagData.h"

@interface QSourceTag : NSObject

@property (nonatomic, strong) QSourceTagData *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end
