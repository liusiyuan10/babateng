//
//  PanetRequestTool.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetRequestTool.h"
#import "Header.h"
#import "BBTHttpTool.h"
#import "MJExtension.h"
#import "TMCache.h"
#import "PanetKnIntelModel.h"
#import "PanetKnInetlCommon.h"
#import "ChargeModel.h"
#import "KnowledgeModel.h"
#import "GetIntelligenceModel.h"

#import "CoursePackage.h"
#import "QueryPayCourseOrder.h"

#import "RealNameModel.h"
#import "ForeignDetailModel.h"
#import "PanetMineAddressModel.h"
#import "PanetMineAssetModel.h"
#import "BeansModel.h"
#import "SaveCourseOrder.h"
#import "PanetMineModel.h"


@implementation PanetRequestTool


//接口名称 获取可收取的知识豆与英豆
//请求类型 get
//请求Url  /bbt-phone/userScore/{produceWay}
+ (void)getuserScoreproduceWay:(NSString *)produceway success:(void(^)(PanetKnIntelModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/%@",BBT_HTTP_URL,PROJECT_NAME_APP,produceway];

    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"xingiqiuresult=====%@",result);
        
        PanetKnIntelModel *respone = [PanetKnIntelModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 收取知识豆与英豆
//请求类型 post
//请求Url  /bbt-phone/userScore/{produceId}
+ (void)GetUserScoreProduceId:(NSString *)produceId success:(void(^)(ChargeModel *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/collect/%@",BBT_HTTP_URL,PROJECT_NAME_APP,produceId];
    NSLog(@"收取知识豆与英豆urlStr=====%@", urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
//    NSLog(@"点播歌单里的歌曲params====%@", params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"xingiqiuresult=====%@",result);
        
        ChargeModel *respone = [ChargeModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 查询智力与知识豆记录
//请求类型 get
//请求Url  /bbt-phone/userScore/record/{type}
+ (void)GetUserScorerecordType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(KnowledgeModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/record/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,type,pageNum,@"20"];
    
    
     NSLog(@"查询智力与知识豆记录请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"查询智力与知识豆记录result=====%@",result);
        
        KnowledgeModel *respone = [KnowledgeModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 获取任务列表
//请求类型 get
//请求Url  bbt-phone/userScore/task
//接口名称 获取任务列表
//请求类型 get
//请求Url  bbt-phone/userScore/task
+ (void)GetUserScoretasksuccess:(void(^)(GetIntelligenceModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/task",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"xingiqiuresult=====%@",result);
        
        GetIntelligenceModel *respone = [GetIntelligenceModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 今日签到
//请求类型 get
//请求Url  /bbt-phone/signIn
+ (void)GetUsersignInsuccess:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/signIn",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"xingiqiuresult=====%@",result);
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 兑换智力接口
//请求类型 post
//请求Url  /bbt-phone/concerned
+ (void)PostConcernedcheckCode:(NSString *)checkcode success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/concerned",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    NSDictionary *bodydic = @{@"checkCode" : checkcode };

    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        NSLog(@"concernedresult=====%@",result);

        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];

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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/coursePackage?packageType=%@",BBT_HTTP_URL,PROJECT_NAME_APP,packageType];
    
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

//接口名称 查询实名认证信息
//请求类型 get
//请求Url  /bbt-phone/authentication
+ (void)Getauthenticationsuccess:(void(^)(RealNameModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/authentication",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        RealNameModel *respone = [RealNameModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 保存实名认证信息
//请求类型 post
//请求Url  /bbt-phone/authentication
+ (void)PostsaveauthenticationParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/authentication",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    

    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"保存实名认证信息=====%@",result);
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        
        
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

//接口名称 添加收货地址
//请求类型 post
//请求Url  /bbt-phone/address
+ (void)PostPanetMineaddressnParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/address",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"添加收货地址信息=====%@",result);
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

//接口名称 查询收货地址列表
//请求类型 get
//请求Url  /bbt-phone/address
+ (void)getPanetMineaddressnParameter:(NSDictionary *)parameter pageNum:(NSString *)pageNum success:(void(^)(PanetMineAddressModel *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/address?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        PanetMineAddressModel *respone = [PanetMineAddressModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 编辑收货地址
//请求类型 put
//请求Url  /bbt-phone/address/{addressId}
+ (void)PutPanetMineaddressnParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/address/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"addressId"]];
    
    NSLog(@"编辑收货地址请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"编辑联系人=====%@",result);
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

//接口名称 删除收货地址
//请求类型 delete
//请求Url  /bbt-phone/address/{addressId}

+ (void)DeletePanetMineaddressnAddressId:(NSString *)addressId success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/address/%@",BBT_HTTP_URL,PROJECT_NAME_APP,addressId];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"删除联系人result=====%@",result);
        
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

//接口名称 查询我的资产
//请求类型 get
//请求Url  /bbt-phone/userScore/assets
+ (void)getUserScoreAssetssuccess:(void(^)(PanetMineAssetModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/assets",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        PanetMineAssetModel *respone = [PanetMineAssetModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询英豆记录
//请求类型 get
//请求Url   /bbt-phone/userScore/enPeas
+ (void)getUserScoreEnPeapageNum:(NSString *)pageNum success:(void(^)(BeansModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/enPeas?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"authenticationxingiqiuresult=====%@",result);
        
        BeansModel *respone = [BeansModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

#pragma mark --保存套餐订单  /bbt-phone/courseOrder
+ (void)PostSaveCourseOrder:(NSDictionary *)parameter OrderFlag:(NSString *)orderFlag success:(void(^)(SaveCourseOrder *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/courseOrder",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"保存套餐订单请求链接%@",urlStr);
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    

    
    NSDictionary *bodydic = @{@"packageId":[parameter objectForKey:@"packageId"], @"phoneNumber":[parameter objectForKey:@"phoneNumber"],@"orderFlag":@"2" };
    NSLog(@"apppayparams===%@",params);
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"zhifuresult=====%@",result);
        
        SaveCourseOrder *respone = [SaveCourseOrder mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --查询用用支付列表 /bbt-phone/courseOrder
+(void)getQueryPayCourseOrderParameter:(NSDictionary *)parameter OrderFlag:(NSString *)orderFlag success:(void (^)(QueryPayCourseOrder *respone))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/courseOrder?orderFlag=%@",BBT_HTTP_URL,PROJECT_NAME_APP,@"2"];
    
    NSLog(@"查询用用支付列表请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询用用支付列表=====%@",result);
        
        QueryPayCourseOrder *respone = [QueryPayCourseOrder mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

//接口名称 判断实名认证与收货地址设置
//请求类型 get
//请求Url  /bbt-phone/userScore/center PanetMineModel
+ (void)getUserScoreCentersuccess:(void(^)(PanetMineModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userScore/center",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"判断实名认证与收货地址设置请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询用用支付列表=====%@",result);
        
        PanetMineModel *respone = [PanetMineModel mj_objectWithKeyValues:result];
        
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
