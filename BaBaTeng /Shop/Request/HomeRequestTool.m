//
//  HomeRequestTool.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "HomeRequestTool.h"

#import "Header.h"
#import "BBTHttpTool.h"
#import "MJExtension.h"
#import "NSString+MD5String.h"
#import "TMCache.h"

#import "Bulletin.h"
#import "CoursePackage.h"

#import "ForeignDetailModel.h"

#import "XEGoodModel.h"

#import "XEGoodDetailModel.h"
#import "PanetKnInetlCommon.h"
#import "SaveOrderModel.h"
#import "GoodCategoryModel.h"


#import "PayCourseOrder.h"

@implementation HomeRequestTool

#pragma mark - 获取广告列表http://192.168.1.17:8080/bbt-phone/bulletins/deviceTypes/12
+ (void)GetBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(Bulletin *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallBulletins?appName=%@",BBT_HTTP_URL,PROJECT_NAME_APP,BBT_APP_TYPE];
    
    NSLog(@"bulletins请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        //        NSLog(@"resultbuuuuu=====%@",result);
        
        Bulletin *respone = [Bulletin mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}


#pragma mark --查询套餐列表/bbt-phone/coursePackage
+(void)getCoursePackageParameter:(NSDictionary *)parameter PackageType:(NSString *)packageType success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure;
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/coursePackage?packageType=%@&appName=%@",BBT_HTTP_URL,PROJECT_NAME_APP,packageType,BBT_APP_TYPE];
    
    NSLog(@"查询套餐列表请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询套餐列表=====%@",result);
        
        CoursePackage *respone = [CoursePackage mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

//接口名称 查询套餐详情
//请求类型 get
//请求Url  /bbt-phone/coursePackage/{packageId}
#pragma mark - 查询套餐详情
+ (void)GetcoursePackageDetailPackageId:(NSString *)packageId success:(void(^)(ForeignDetailModel *respone))success failure:(void(^)(NSError *error))failure
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/coursePackage/%@",BBT_HTTP_URL,PROJECT_NAME_APP,packageId];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        ForeignDetailModel *respone = [ForeignDetailModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 商品列表
//请求类型 get
//请求Url  /bbt-phone/goods/goodsList
#pragma mark - 接口名称 商品列表
+ (void)getGoodsGoodsListpageNum:(NSString *)pageNum success:(void(^)(XEGoodModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/goods/goodsList?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        XEGoodModel *respone = [XEGoodModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 商品列表
//请求类型 get
//请求Url  /bbt-phone/goods/goodsList
#pragma mark - 接口名称 商品列表
+ (void)getGoodsGoodsListCategoryId:(NSString *)categoryId pageNum:(NSString *)pageNum success:(void(^)(XEGoodModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/goods/goodsList?categoryId=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,categoryId,pageNum,@"20"];
    
    NSLog(@"urlStr1111111=====%@",urlStr);
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        XEGoodModel *respone = [XEGoodModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 商品详细
//请求类型 get
//请求Url  /bbt-phone/goods/detail/{goodsId}
#pragma mark - 接口名称 商品详细
+ (void)GetGoodsDetailGoodsId:(NSString *)goodsId success:(void(^)(XEGoodDetailModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/goods/detail/%@?userId=%@",BBT_HTTP_URL,PROJECT_NAME_APP,goodsId,[[TMCache sharedCache] objectForKey:@"userId"]];
    
    NSLog(@"urlStr======%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
        NSLog(@"请求参数%@",params);

    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        XEGoodDetailModel *respone = [XEGoodDetailModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 生成订单信息
//请求类型 post
//请求Url  /bbt-phone/mallOrder/saveMallOrderInfo
#pragma mark - 接口名称 生成订单信息
+ (void)PostMallOrderSaveMallOrderInfoParameter:(NSDictionary *)parameter success:(void(^)(SaveOrderModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder/saveMallOrderInfo",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"添加收货地址信息=====%@",result);
        
        SaveOrderModel *respone = [SaveOrderModel mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];

}

//接口名称 支付订单
//请求类型 post
//请求Url  /bbt-phone/mallOrder/payMallOrder mallOrder/saveMallOrderInfo
#pragma mark - 接口名称 支付订单
+ (void)PostMallOrderPayMallOrderParameter:(NSDictionary *)parameter success:(void(^)(PayCourseOrder *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder/pay",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"支付订单=====%@",result);
        
        PayCourseOrder *respone = [PayCourseOrder mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询商品一级分类
//请求类型 get
//请求Url  /bbt-phone/goods/category GoodCategory
+ (void)getGoodsGoodsCategorysuccess:(void(^)(GoodCategoryModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/goods/category",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        GoodCategoryModel *respone = [GoodCategoryModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}
@end
