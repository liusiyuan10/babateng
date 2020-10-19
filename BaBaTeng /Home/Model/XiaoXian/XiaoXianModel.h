//
//  XiaoXianModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XiaoXianDataModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface XiaoXianModel : NSObject

@property (nonatomic, strong) XiaoXianDataModel *data;

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
