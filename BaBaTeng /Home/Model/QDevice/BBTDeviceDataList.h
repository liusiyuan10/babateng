//
//  BBTDeviceList.h
//  BaBaTeng
//
//  Created by liu on 17/6/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTDeviceDataList : NSObject

//deviceTypeId = 010000;
//deviceTypeName = "A1\U5c0f\U817e\U673a\U5668\U4eba";
//iconUrl = "";

@property (nonatomic, copy) NSString *deviceTypeId;
@property (nonatomic, copy) NSString *deviceTypeName;
@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *deivceProgramId;

@end
