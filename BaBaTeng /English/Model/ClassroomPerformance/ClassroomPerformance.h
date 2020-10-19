//
//  ClassroomPerformance.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassroomPerformanceData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassroomPerformance : NSObject

@property (nonatomic, strong) ClassroomPerformanceData *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end

NS_ASSUME_NONNULL_END
