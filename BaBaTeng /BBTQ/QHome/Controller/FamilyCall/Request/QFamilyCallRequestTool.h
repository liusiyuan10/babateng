//
//  QFamilyCallRequestTool.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QFamilyCall,familyPhoneRecordC,QFamilyPhone,QFamilyContact,QFamilyPhoneNickName,QFamilyEditContact,QFamilyCommon;

@interface QFamilyCallRequestTool : NSObject

/*****************亲情电话相关信息获取****************************/
#pragma mark --根据设备码亲情电话相关信息获取
+ (void)GetfamilyPhoneInfoParameter:(NSDictionary *)parameter success:(void(^)(QFamilyCall *response))success failure:(void(^)(NSError *error))failure;

/*****************统计设备下面的宝贝通话记录****************************/
#pragma mark --统计设备下面的宝贝通话记录
+ (void)GetfamilyPhoneRecordParameter:(NSDictionary *)parameter success:(void(^)(QFamilyPhone *response))success failure:(void(^)(NSError *error))failure;

/*****************查询设备下面某个联系人的通话记录详情****************************/
#pragma mark --查询设备下面某个联系人的通话记录详情
+ (void)GetfamilyPhoneRecordContactsIdParameter:(NSDictionary *)parameter success:(void(^)(familyPhoneRecordC *response))success failure:(void(^)(NSError *error))failure;

/*****************宝贝通讯录联系人列表****************************/
#pragma mark --宝贝通讯录联系人列表
+ (void)GetfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyContact *response))success failure:(void(^)(NSError *error))failure;


/*****************查询联系人称呼列表****************************/
#pragma mark --查询联系人称呼列表
+ (void)GetfamilyPhoneNicknameParameter:(NSDictionary *)parameter success:(void(^)(QFamilyPhoneNickName *response))success failure:(void(^)(NSError *error))failure;

/*****************编辑联系人****************************/
#pragma mark --编辑联系人
+ (void)EditfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyEditContact *response))success failure:(void(^)(NSError *error))failure;

/*****************添加联系人****************************/
#pragma mark --添加联系人
+ (void)AddfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyEditContact *response))success failure:(void(^)(NSError *error))failure;

/*****************删除联系人****************************/
#pragma mark --删除联系人
+ (void)DeletefamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyCommon *response))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 修改设备手机号码
+ (void)updateFamilyPhoneNumdeviceId:(NSString *)deviceId  Phonenum:(NSString *)phonenum  upload:(void(^)(QFamilyCommon *respone))success failure:(void(^)(NSError *error))failure;




@end
