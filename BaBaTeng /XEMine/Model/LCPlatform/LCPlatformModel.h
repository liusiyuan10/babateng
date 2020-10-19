//
//  LCPlatformModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPlatformDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCPlatformModel : NSObject

@property (nonatomic, strong) LCPlatformDataModel *data;

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
