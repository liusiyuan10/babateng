//
//  withDrawMoneyRecordModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/10.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "withDrawMoneyRecordDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface withDrawMoneyRecordModel : NSObject

@property (nonatomic, strong) withDrawMoneyRecordDataModel *data;

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
