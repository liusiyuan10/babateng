//
//  BBTBindDataList.h
//  BaBaTeng
//
//  Created by liu on 17/6/8.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTBindDeviceDataList.h"

#import "MJExtension.h"

@interface BBTBindDataList : NSObject

@property(nonatomic, strong) BBTBindDeviceDataList *device;

@property(nonatomic, strong) NSArray *familys;


@end
