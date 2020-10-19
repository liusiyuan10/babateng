//
//  NewBulletin.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewBulletin : NSObject<MJKeyValue>

@property(nonatomic, strong) NSString *message;

@property(nonatomic, strong) NSString *statusCode;

@property(nonatomic, strong) NSArray *data;


@end

NS_ASSUME_NONNULL_END


