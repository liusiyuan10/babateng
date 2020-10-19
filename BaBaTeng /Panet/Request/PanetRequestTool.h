//
//  PanetRequestTool.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PanetKnIntelModel,PanetKnInetlCommon,ChargeModel,KnowledgeModel,GetIntelligenceModel,CoursePackage,QueryPayCourseOrder,RealNameModel,ForeignDetailModel,PanetMineAddressModel,PanetMineAssetModel,BeansModel,SaveCourseOrder,PanetMineModel;

NS_ASSUME_NONNULL_BEGIN

@interface PanetRequestTool : NSObject

//接口名称 获取可收取的知识豆与英豆
//请求类型 get
//请求Url  /bbt-phone/userScore/{produceWay}

+ (void)getuserScoreproduceWay:(NSString *)produceway success:(void(^)(PanetKnIntelModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 收取知识豆与英豆
//请求类型 post
//请求Url  /bbt-phone/userScore/{produceId}
+ (void)GetUserScoreProduceId:(NSString *)produceId success:(void(^)(ChargeModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询智力与知识豆记录
//请求类型 get
//请求Url  /bbt-phone/userScore/record/{type}
+ (void)GetUserScorerecordType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(KnowledgeModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 获取任务列表
//请求类型 get
//请求Url  bbt-phone/userScore/task
+ (void)GetUserScoretasksuccess:(void(^)(GetIntelligenceModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 今日签到
//请求类型 get
//请求Url  /bbt-phone/signIn
+ (void)GetUsersignInsuccess:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 兑换智力接口
//请求类型 post
//请求Url  /bbt-phone/concerned
+ (void)PostConcernedcheckCode:(NSString *)checkcode success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark --查询套餐列表/bbt-phone/coursePackage
+(void)getCoursePackageParameter:(NSDictionary *)parameter PackageType:(NSString *)packageType success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --保存套餐订单  /bbt-phone/courseOrder
+ (void)PostSaveCourseOrder:(NSDictionary *)parameter OrderFlag:(NSString *)orderFlag success:(void(^)(SaveCourseOrder *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --查询用用支付列表 /bbt-phone/courseOrder
+(void)getQueryPayCourseOrderParameter:(NSDictionary *)parameter OrderFlag:(NSString *)orderFlag success:(void (^)(QueryPayCourseOrder *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 保存实名认证信息
//请求类型 post
//请求Url  /bbt-phone/authentication
+ (void)PostsaveauthenticationParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询实名认证信息
//请求类型 get
//请求Url  /bbt-phone/authentication
+ (void)Getauthenticationsuccess:(void(^)(RealNameModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询套餐详情
//请求类型 get
//请求Url  /bbt-phone/coursePackage/{packageId}
+ (void)GetcoursePackageDetailPackageId:(NSString *)packageId success:(void(^)(ForeignDetailModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 添加收货地址
//请求类型 post
//请求Url  /bbt-phone/address
+ (void)PostPanetMineaddressnParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询收货地址列表
//请求类型 get
//请求Url  /bbt-phone/address
+ (void)getPanetMineaddressnParameter:(NSDictionary *)parameter pageNum:(NSString *)pageNum success:(void(^)(PanetMineAddressModel *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 删除收货地址
//请求类型 delete
//请求Url  /bbt-phone/address/{addressId}

+ (void)DeletePanetMineaddressnAddressId:(NSString *)addressId success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 编辑收货地址
//请求类型 put
//请求Url  /bbt-phone/address/{addressId}
+ (void)PutPanetMineaddressnParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询我的资产
//请求类型 get
//请求Url  /bbt-phone/userScore/assets
+ (void)getUserScoreAssetssuccess:(void(^)(PanetMineAssetModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询英豆记录
//请求类型 get
//请求Url   /bbt-phone/userScore/enPeas
+ (void)getUserScoreEnPeapageNum:(NSString *)pageNum success:(void(^)(BeansModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 判断实名认证与收货地址设置
//请求类型 get
//请求Url  /bbt-phone/userScore/center PanetMineModel
+ (void)getUserScoreCentersuccess:(void(^)(PanetMineModel *respone))success failure:(void(^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
