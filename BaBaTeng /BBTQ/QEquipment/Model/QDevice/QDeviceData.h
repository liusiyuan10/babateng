//
//  QDeviceData.h
//  BaBaTeng
//
//  Created by liu on 17/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDeviceBoxinfo.h"

#import "BBTDeviceDataList.h"

@interface QDeviceData : NSObject

@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, copy) NSString *deviceStatus;

@property (nonatomic, strong) QDeviceBoxinfo * boxinfo;

@property (nonatomic, strong) BBTDeviceDataList * deviceType;


//以下是公司信息

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, copy) NSString *companyIntroduction;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *companyPhone;

@property (nonatomic, copy) NSString *companyStatus;

@property (nonatomic, copy) NSString *contactEmail;

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, copy) NSString *createTime;


//以下是检测设备版本
@property (nonatomic, copy) NSString *firmwareName;
@property (nonatomic, copy) NSString *firmwareUrl;
@property (nonatomic, copy) NSString *isForceUpgradeMode;
@property (nonatomic, copy) NSString *isLatestVersion;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *versionDescription;

@end
