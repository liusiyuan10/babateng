//
//  QChatRequestTool.h
//  BaBaTeng
//
//  Created by liu on 17/8/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QChat,QMessageCommon,QSXMessage;

@interface QChatRequestTool : UIView

/*****************获取聊天信息****************************/
#pragma mark --http://192.168.1.17:8080/ /bbt-phone/families/devices/:deviceId/familyChatRecords

+ (void)GetChatInfo:(NSDictionary *)parameter success:(void(^)(QChat *respone))success failure:(void(^)(NSError *error))failure;

/*****************上传文本消息****************************/
+ (void)PostChatMessageText:(NSDictionary *)parameter success:(void(^)(QChat *respone))success failure:(void(^)(NSError *error))failure;

/*****************查询常用的回答消息****************************/
#pragma mark -- /bbt-phone/timelyMessages/commonInformations

+ (void)GetTimelyMessages:(NSDictionary *)parameter success:(void(^)(QSXMessage *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 给设备推送消息
//请求类型 post
//请求Url  /bbt-phone/timelyMessages/devices/{deviceId}

/*****************上传文本消息****************************/
+ (void)PostTimelyMessagesText:(NSDictionary *)parameter success:(void(^)(QMessageCommon *respone))success failure:(void(^)(NSError *error))failure;

@end
