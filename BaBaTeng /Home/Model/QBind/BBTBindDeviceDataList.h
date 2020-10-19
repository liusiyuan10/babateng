//
//  BBTBindDeviceList.h
//  BaBaTeng
//
//  Created by liu on 17/8/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTDeviceDataList.h"
#import "QDeviceBoxinfo.h"

@interface BBTBindDeviceDataList : NSObject

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, copy) NSString *deviceName;
@property(nonatomic, copy) NSString *deviceStatus;
@property(nonatomic, strong) BBTDeviceDataList *deviceType;
@property (nonatomic, strong) QDeviceBoxinfo * boxinfo;


@end
