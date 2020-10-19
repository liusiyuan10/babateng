//
//  TwoCurrencyPageInfo.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwoCurrencyPageInfo : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray  *list;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *total;

@end

NS_ASSUME_NONNULL_END