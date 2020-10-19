//
//  BBTDevice.h
//  BaBaTeng
//
//  Created by liu on 17/6/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTDeviceData.h"

@interface BBTDevice : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;
@property(nonatomic, copy) NSString *success;
@property(nonatomic, strong) BBTDeviceData *data;

@end
