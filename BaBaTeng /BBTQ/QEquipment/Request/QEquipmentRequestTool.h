//
//  QEquipmentRequestTool.h
//  BaBaTeng
//
//  Created by liu on 17/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QDevice;

@interface QEquipmentRequestTool : NSObject

/*****************获取设备信息****************************/
#pragma mark --获取设备信息http://192.168.1.17:8080/ /bbt-phone/devices/:deviceId
+ (void)GetdeviceInfo:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark --设置设备信息http://192.168.1.17:8080/ /bbt-phone/devices/:deviceId
+ (void)PutdeviceInfoDic:(NSDictionary *)infodic Parameter:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;



#pragma mark --查询设备所属公司信息http://192.168.1.17:8080/  /bbt-phone/devices/:deviceId/company
+ (void)GetdeviceCompanyInfoDic:(NSString *)deviceId  Parameter:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 修改设备昵称
+ (void)updateDeviceId :(NSString *)deviceId  DeviceName:(NSString *)deviceName  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 修改群名片
+ (void)updateMembersId :(NSString *)familyMemberId  FamilyId :(NSString *)familyId  DeviceName:(NSString *)deviceName  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;



#pragma mark -- 命令设备升级到最新版本
+ (void)upgrade :(NSString *)deviceId   upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;
#pragma mark -- 检测设备版本
+ (void)checkDeviceVersion :(NSString *)deviceId  Version:(NSString *)version  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;

@end
