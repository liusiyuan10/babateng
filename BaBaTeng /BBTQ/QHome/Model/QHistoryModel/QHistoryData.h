//
//  QHistoryData.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface QHistoryData : NSObject
@property (nonatomic, strong) NSMutableArray  *list;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *total;
@end
