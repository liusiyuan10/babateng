//
//  DeviceControlData.h
//  BaBaTeng
//
//  Created by liu on 17/8/3.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceControlData : NSObject

//"controlId": 1,
//"deviceControlName": "音量控制",
//"deviceTypeId": "010000"
@property (nonatomic, copy) NSString *controlId;

@property (nonatomic, copy) NSString *deviceControlName;

@property (nonatomic, copy) NSString *deviceTypeId;


@end
