//
//  ChargeModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChargeModel : NSObject

@property (nonatomic, strong) ChargeDataModel *data;

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
