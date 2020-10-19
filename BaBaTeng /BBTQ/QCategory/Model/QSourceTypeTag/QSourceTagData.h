//
//  QSourceTagData.h
//  BaBaTeng
//
//  Created by liu on 17/7/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface QSourceTagData : NSObject<MJKeyValue>

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, copy) NSString *pages;

@property (nonatomic, copy) NSString *total;

@end
