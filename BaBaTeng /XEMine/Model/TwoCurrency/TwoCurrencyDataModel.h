//
//  TwoCurrencyDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwoCurrencyPageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwoCurrencyDataModel : NSObject

@property (nonatomic, strong) TwoCurrencyPageInfo *pageInfo;

/***
 *价格
 */
@property (nonatomic, assign) CGFloat lockedRebateValue;

/***
 *是否成功
 */
@property (nonatomic, assign) CGFloat rebateValue;

@end

NS_ASSUME_NONNULL_END
