//
//  ECGOHttpTool.h
//  integral
//
//  Created by liu on 16/1/25.
//  Copyright © 2016年 ecg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTHttpTool : NSObject

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)GETHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)GETNewHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)POSTHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)POSTNewHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


+ (void)POSTTokenHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)PUTHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


+ (void)PUTDeviceNameHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)PUTNewHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id ))success failure:(void (^)(NSError *))failure;


+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

//+ (void)POSTYJ263:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)DELETEHead:(NSString *)URLString parameters:(id)parameters bodyArr:(NSArray *)bodyarr success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)DELETEHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)POSTEnHead:(NSString *)URLString parameters:(id)parameters bodyArr:(NSArray *)bodyarr success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)POSTUserTokenHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)GETAoguqi:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


+ (void)POSTPanetHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//+ (void)postJsonToServer;

@end
