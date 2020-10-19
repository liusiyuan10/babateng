//
//  BBTBind.h
//  BaBaTeng
//
//  Created by liu on 17/6/8.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTBindData.h"

@interface BBTBind : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;
@property(nonatomic, copy) NSString *success;
@property(nonatomic, strong) BBTBindData *data;

@end
