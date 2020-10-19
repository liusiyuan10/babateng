//
//  TmallModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TmallDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TmallModel : NSObject

@property (nonatomic, strong) TmallDataModel *data;

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
