//
//  BBTMineRequestTool.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/25.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBTUserInfoRespone,BBTUserInfo,QMessage,Family;
@interface BBTMineRequestTool : NSObject

#pragma mark -- APP用户修改个人资料
+ (void)PUTResetPersonalData:(BBTUserInfo *)bbtUserInfo  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- APP用户修改所在地
+ (void)PUTResetPersonalAddressData:(NSString *)address  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- APP用户查询个人资料
+ (void)GETPersonalData:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 分页获取系统消息列表
+ (void)GETsystemNoticesbodyDic:(NSDictionary *)bodydic upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 查询设备通知列表
+ (void)GETDeviceNoticespageNum:(NSString *)pageNum pageSize:(NSString *)pageSize upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 查询查询家人邀请列表
+ (void)GETFamilyNoticesspageNum:(NSString *)pageNum pageSize:(NSString *)pageSize upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;
#pragma mark -- 查询系统消息详情
+ (void)GETsystemNoticeId:(NSString *)bbtId  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --查询家人邀请消息详情
+ (void)GETFamilyMessageDetailID:(NSString *)bbtId  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --处理家人邀请-接受或者拒绝
+ (void)PUTFamilyInvitations:(NSString *)invitations Status:(NSString *)status  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --家庭圈之添加用户界面 查询手机号是否注册
+ (void)GETFamilyPhoneNumber:(NSString *)phoneNumber  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 发起家人邀请
+(void)POSTReceiverId:(NSString *)receiverId FamilyId:(NSString *)familyId  Message:(NSString*)message upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 查询家庭圈及所有成员
+(void)GETFamilys:(NSString *)deviceId  upload:(void(^)(Family *respone))success failure:(void(^)(NSError *error))failure;



#pragma mark -- 提交意见反馈接口
+(void)POSTFeedback:(NSString *)deviceId Feedback:(NSString*)content upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure;

@end
