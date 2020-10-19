//
//  Bulletin.h
//  BaBaTeng
//
//  Created by liu on 17/7/25.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface Bulletin : NSObject<MJKeyValue>

@property(nonatomic, strong) NSString *message;

@property(nonatomic, strong) NSString *statusCode;

@property(nonatomic, strong) NSArray *data;

@end
