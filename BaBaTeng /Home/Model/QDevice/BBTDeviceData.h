//
//  BBTDeviceData.h
//  BaBaTeng
//
//  Created by liu on 17/6/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BBTDeviceData : NSObject

@property(nonatomic, copy) NSString *pages;

@property(nonatomic, copy) NSString *total;
@property(nonatomic, strong) NSArray *list;

@end
