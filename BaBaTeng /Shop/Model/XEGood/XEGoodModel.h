//
//  XEGoodModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEGoodDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XEGoodModel : NSObject

@property (nonatomic, strong) XEGoodDataModel *data;

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
