//
//  BBTEquipmentRequestTool.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBTEquipmentRespone,BBTDevice,BBTBind,Bulletin,QDevice,NewBulletin,TmallModel,XiaoXianModel;
@interface BBTEquipmentRequestTool : NSObject

#pragma mark --获取设备分类列表
+(void)getDevicetypeListParameter:(NSDictionary *)parameter success:(void (^)(BBTDevice *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --扫码绑定
+(void)getScanbindcode:(NSString *)urlORCode  Parameter:(NSDictionary *)parameter  success:(void (^)(BBTDevice *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --设备获取绑定验证码
+(void)getDevgetbindcode:(NSString *)uimei uapsn:(NSString *)uapsn utype:(NSString *)utype success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --APP获取要绑定设备信息
+(void)getAppgetbinddevice:(NSString *)ucode success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark -- 提交绑定设备
+(void)getSumitbinddevice:(NSString *)code DeviceTypeId:(NSString*)deviceTypeId success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark -- 删除绑定设备
+(void)getDeletebinddevice:(NSString *)uid  deviceId:(NSString *)deviceId success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --获取绑定设备列表
+(void)getBinddevice:(NSDictionary *)parameter  success:(void (^)(BBTBind *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --获取专辑列表
+(void)getAlbumlist:(NSString *)ualbumId  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --获取专辑内容
+(void)getTracklist:(NSString *)ualbumId upagenum:(NSString *)upagenum   upagecount:(NSString *)upagecount  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark --获取APP列表
+(void)getApplist:(NSString *)uitemtype   upagenum:(NSString *)upagenum   upagecount:(NSString *)upagecount  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark - 增加app下载次数
+(void)updateApploadtimes:(NSString *)uid success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark - 获取app分类
+(void)getApptype:(NSString *)utype success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark - 获取广告列表
+ (void)GetBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(Bulletin *response))success failure:(void(^)(NSError *error))failure;

#pragma mark - 获取新需求广告列表
+ (void)GetNewBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(NewBulletin *response))success failure:(void(^)(NSError *error))failure;

#pragma mark - 获取设备类型列表http://domain/bbt-phone/deviceTypes
+ (void)GETEquipmentData:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure;



#pragma mark - 获取设备的绑定说明http://domain/bbt-phone/deviceBindGuidances/deviceTypes/{deviceTypeId}
+ (void)GETdeviceBindGuidances:(NSString *)deviceTypeId  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark - 获取使用帮助列表 http://domain/bbt-phone/helps/deviceTypes/{deviceTypeId}

+ (void)GETdevicehelps:(NSString *)deviceTypeId  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark - 检测app版本
+ (void)checkAppVersionupload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark - 检查环信是否注册 http://localhost/api/app/huanxin/user/6901060000000135

+ (void)GETHuanxinPhoneNum:(NSString *)phonenumstr  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark - 奥古奇热点配网
+ (void)GetAoguqiHotNetworkParameter:(NSDictionary *)parameter  success:(void(^)(NSString *response))success failure:(void(^)(NSError *error))failure;


//接口名称 获取token
//请求类型 post
//请求Url  /bbt-phone/tmall/{deviceId}
+ (void)GetTmallDeviceId:(NSString *)deviceId success:(void(^)(TmallModel *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark - 获取小先登录token

+ (void)GETXiaoXianDeviceId:(NSString *)deviceId  success:(void(^)(XiaoXianModel *registerRespone))success failure:(void(^)(NSError *error))failure;

@end
