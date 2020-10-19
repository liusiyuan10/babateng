//
//  ExchangeRateModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/5/6.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeRateDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeRateModel : NSObject

@property (nonatomic, strong) ExchangeRateDataModel *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

NS_ASSUME_NONNULL_END
