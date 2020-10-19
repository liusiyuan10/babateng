//
//  SaveOrderModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/12.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveOrderDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveOrderModel : NSObject

@property (nonatomic, strong) SaveOrderDataModel *data;

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
