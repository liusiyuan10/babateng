//
//  SyncEnglishRequest.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SyncEnglishModel,MyEnglishModel,EnglishCommon;

@interface SyncEnglishRequest : NSObject
/*****************接口名称 查询英语学习专辑
 请求类型 get
 请求Url  /bbt-phone/trackLists/englishList
 ****************************/
#pragma mark --查询英语学习专辑 /bbt-phone/trackLists/englishList
+ (void)getEnglishListParameter:(NSDictionary *)parameter success:(void(^)(SyncEnglishModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 查询英语点读
//请求类型 get
//请求Url  bbt-phone/getEnglish/{deviceId}
#pragma mark --查询英语点读 bbt-phone/getEnglish/{deviceId}
+ (void)getMyEnglishListParameter:(NSDictionary *)parameter success:(void(^)(MyEnglishModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 添加英语点读
//请求类型 get
//请求Url  bbt-phone/trackLists/addEnglish/{trackListId}/{deviceId}

#pragma mark --添加英语点读 bbt-phone/trackLists/addEnglish/{trackListId}/{deviceId}
+ (void)AddmyEnglishListParameter:(NSDictionary *)parameter success:(void(^)(EnglishCommon *response))success failure:(void(^)(NSError *error))failure;

@end
