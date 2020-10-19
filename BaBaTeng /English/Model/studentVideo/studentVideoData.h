//
//  studentVideoData.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface studentVideoData :  NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray  *list;


@property (nonatomic, copy) NSString   *pages;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString   *total;

@end

NS_ASSUME_NONNULL_END
