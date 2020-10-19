//
//  HomeRequestTool.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bulletin,CoursePackage,ForeignDetailModel,XEGoodModel,XEGoodDetailModel,PanetKnInetlCommon,SaveOrderModel,GoodCategoryModel,PayCourseOrder;

NS_ASSUME_NONNULL_BEGIN

@interface HomeRequestTool : NSObject

#pragma mark - 获取广告列表
+ (void)GetBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(Bulletin *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --查询套餐列表/bbt-phone/coursePackage
+(void)getCoursePackageParameter:(NSDictionary *)parameter PackageType:(NSString *)packageType success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 查询套餐详情
//请求类型 get
//请求Url  /bbt-phone/coursePackage/{packageId}
#pragma mark - 查询套餐详情
+ (void)GetcoursePackageDetailPackageId:(NSString *)packageId success:(void(^)(ForeignDetailModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 商品列表
//请求类型 get
//请求Url  /bbt-phone/goods/goodsList
#pragma mark - 接口名称 商品列表
+ (void)getGoodsGoodsListpageNum:(NSString *)pageNum success:(void(^)(XEGoodModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 商品列表
//请求类型 get
//请求Url  /bbt-phone/goods/goodsList
#pragma mark - 接口名称 商品列表
+ (void)getGoodsGoodsListCategoryId:(NSString *)categoryId pageNum:(NSString *)pageNum success:(void(^)(XEGoodModel *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 商品详细
//请求类型 get
//请求Url  /bbt-phone/goods/detail/{goodsId}
#pragma mark - 接口名称 商品详细
+ (void)GetGoodsDetailGoodsId:(NSString *)goodsId success:(void(^)(XEGoodDetailModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 生成订单信息
//请求类型 post
//请求Url  /bbt-phone/mallOrder/saveMallOrderInfo
#pragma mark - 接口名称 生成订单信息
+ (void)PostMallOrderSaveMallOrderInfoParameter:(NSDictionary *)parameter success:(void(^)(SaveOrderModel *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 支付订单
//请求类型 post
//请求Url  /bbt-phone/mallOrder/payMallOrder
#pragma mark - 接口名称 支付订单
+ (void)PostMallOrderPayMallOrderParameter:(NSDictionary *)parameter success:(void(^)(PayCourseOrder *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 查询商品一级分类
//请求类型 get
//请求Url  /bbt-phone/goods/category GoodCategory
+ (void)getGoodsGoodsCategorysuccess:(void(^)(GoodCategoryModel *respone))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
