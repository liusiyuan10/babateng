//
//  BBTLoginRequestTool.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/30.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBTUserInfoRespone;
@interface BBTLoginRequestTool : NSObject

#pragma mark --登陆
+(void)postLoginUserName:(NSString *)userName Password:(NSString *)password newLoginsuccess:(void (^)(BBTUserInfoRespone *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark --注册
+ (void)registerUserName:(NSString *)userName Password:(NSString *)password Code:(NSString *)code inviteCode:(NSString *)invitecode uploadPhoneNum:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark --用户注册获取注册验证码
+ (void)verifyPhoneNumber:(NSString *)phoneNumber upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark --用户忘记密码请求验证码
+ (void)verifyPhoneforgetPassword:(NSString *)phoneNumber upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark --获取用户信息
+ (void)getuserinfo:(NSString *)phone uploadPhone:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


 #pragma mark --更新用户头像
+ (void)updateuserhead:(NSString *)phone uhead:(NSString *)uhead  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


 #pragma mark --  更新用户邮箱
+ (void)updateemail:(NSString *)uphone  uemail:(NSString *)uemail  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


 #pragma mark --  更新用户昵称
+ (void)updatenickname:(NSString *)uphone  unickname:(NSString *)unickname   upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- APP用户修改密码
+ (void)updatepwd:(NSString *)userId  uoldpwd:(NSString *)uoldpwd   unewpwd:(NSString *)unewpwd    upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

+ (void)POSTTokenHeadNowTimeTimestamp:(NSString*)timestamp  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;

#pragma mark -- 忘记用户密码
+ (void)forgetpwd:(NSString *)uphone  unewpwd:(NSString *)unewpwd Code:(NSString *)code  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 更新用户信息
+ (void)updateuserinfo:(NSString *)uphone  unickname:(NSString *)unickname usex:(NSString *)usex  ubirthday:(NSString *)ubirthday   uemail:(NSString *)uemail  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 反馈意见
+ (void)sumitfeedback:(NSString *)uphone  uquestion:(NSString *)uquestion  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark -- 获取反馈意见
+ (void)getfeedback:(NSString *)uphone  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;


#pragma mark --退出登陆
+(void)GetloginOutParameter:(NSDictionary *)parameter success:(void (^)(BBTUserInfoRespone *respone))success failure:(void (^)(NSError *error))failure;


@end
