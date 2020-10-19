//
//  ExchangeRateDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/5/6.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeRateDataModel : NSObject


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *peasRate;
@property (nonatomic, copy) NSString *setId;

@end

NS_ASSUME_NONNULL_END
