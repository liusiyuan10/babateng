//
//  QSearchCount.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSearchCountData.h"


NS_ASSUME_NONNULL_BEGIN

@interface QSearchCount : NSObject

@property (nonatomic, strong) QSearchCountData *data;

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
