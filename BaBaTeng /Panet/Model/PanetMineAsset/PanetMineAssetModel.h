//
//  PanetMineAssetModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanetMineAssetDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAssetModel : NSObject

@property (nonatomic, strong) PanetMineAssetDataModel *data;

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
