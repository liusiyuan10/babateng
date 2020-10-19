//
//  BBTEquipmentRespone.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface BBTEquipmentRespone : NSObject

@property(nonatomic, copy) NSString *errcode;

@property(nonatomic, copy) NSString *errinfo;

@property (nonatomic, strong) NSArray *result;

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;
@property(nonatomic, copy) NSString *success;




@end
