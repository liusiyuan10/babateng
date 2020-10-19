//
//  ClassroomPlayback.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassroomPlayback : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;



@end

NS_ASSUME_NONNULL_END
