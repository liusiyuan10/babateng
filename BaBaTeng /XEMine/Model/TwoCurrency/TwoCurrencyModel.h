//
//  TwoCurrencyModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwoCurrencyDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwoCurrencyModel : NSObject

@property (nonatomic, strong) TwoCurrencyDataModel *data;

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
