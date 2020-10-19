//
//  PanetMineAddressModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanetMineAddressDataAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAddressModel : NSObject

@property (nonatomic, strong) PanetMineAddressDataAddressModel *data;

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
