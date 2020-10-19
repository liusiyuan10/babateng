//
//  QMPanelData.h
//  BaBaTeng
//
//  Created by liu on 17/8/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface QMPanelData : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray *list;

/***
 *价格
 */
@property (nonatomic, copy) NSString * pages;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *total;

@end
