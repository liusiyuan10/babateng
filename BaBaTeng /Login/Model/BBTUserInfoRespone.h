//
//  LoginRespone.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/30.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "BBTUserInfo.h"

@interface BBTUserInfoRespone : NSObject

@property(nonatomic, copy) NSString *errcode;

@property(nonatomic, copy) NSString *errinfo;

@property (nonatomic, strong) NSArray *result;

@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *statusCode;
@property(nonatomic, copy) NSString *success;
@property(nonatomic, strong) BBTUserInfo *data;



@end
