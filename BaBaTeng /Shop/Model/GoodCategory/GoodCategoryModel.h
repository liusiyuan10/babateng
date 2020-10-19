//
//  GoodCategoryModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/19.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodCategoryModel : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray  *data;

@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

NS_ASSUME_NONNULL_END
