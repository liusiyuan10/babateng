//
//  MineRequestTool.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MineRequestTool.h"
#import "Header.h"
#import "BBTHttpTool.h"
#import "MJExtension.h"
#import "NSString+MD5String.h"
#import "TMCache.h"

#import "PanetKnInetlCommon.h"
#import "PanetMineAddressModel.h"

#import "MemberModel.h"

#import "XEOrderModel.h"
#import "OrderDetailModel.h"
#import "RulesModel.h"
#import "WalletAdressModel.h"
#import "MemberLevellModel.h"
#import "WalletDetailModel.h"
#import "RechargeRecordModel.h"
#import "TwoCurrencyModel.h"
#import "WalletModel.h"
#import "UpdateLevelModel.h"
#import "ExchangeRateModel.h"
#import "HDMyFriendModel.h"
#import "withDrawMoneyRecordModel.h"
#import "LCPlatformModel.h"

#import "StudyCardShowModel.h"


@implementation MineRequestTool

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

//接口名称 查询会员信息
//请求类型 get
//请求Url  /bbt-phone/member
+ (void)getMembersuccess:(void(^)(MemberModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/member",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        MemberModel *respone = [MemberModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询订单列表
//请求类型 get
//请求Url  /bbt-phone/mallOrder
#pragma mark - 查询全部订单列表

+ (void)GetAllmallOrderpageNum:(NSString *)pageNum success:(void(^)(XEOrderModel *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询全部订单列表列表result=====%@",result);
        
        XEOrderModel *respone = [XEOrderModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询订单列表
//请求类型 get
//请求Url  /bbt-phone/mallOrder
#pragma mark - 查询订单列表
+ (void)GetAllmallOrderOrderStatus:(NSString *)orderstatus pageNum:(NSString *)pageNum success:(void(^)(XEOrderModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder?orderStatus=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,orderstatus,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询全部订单列表列表result=====%@",result);
        
        XEOrderModel *respone = [XEOrderModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询订单详情
//请求类型 get
//请求Url  /bbt-phone/mallOrder/detail/{orderId}
#pragma mark - 查询订单详情
+ (void)GetMallOrderDetailOrderId:(NSString *)orderid success:(void(^)(OrderDetailModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder/detail/%@",BBT_HTTP_URL,PROJECT_NAME_APP,orderid];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        OrderDetailModel *respone = [OrderDetailModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 取消订单
//请求类型 put
//请求Url  /bbt-phone/mallOrder/cancel{orderId}
#pragma mark - 取消订单
+ (void)PutMallOrderCancelOrderId:(NSString *)orderid success:(void(^)(PanetKnInetlCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder/cancel/%@",BBT_HTTP_URL,PROJECT_NAME_APP,orderid];
    
    NSLog(@"取消订单请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        NSLog(@"result取消订单=====%@",result);
        
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

//接口名称 确订收货
//请求类型 put
//请求Url  /bbt-phone/mallOrder/confirm/{orderId}
#pragma mark - 确订收货
+ (void)PutMallOrderConfirmOrderId:(NSString *)orderid success:(void(^)(PanetKnInetlCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mallOrder/confirm/%@",BBT_HTTP_URL,PROJECT_NAME_APP,orderid];
    
    NSLog(@"确订收货请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        NSLog(@"result确订收货=====%@",result);
        
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

//接口名称 查询规则
//请求类型 get
//请求Url  /bbt-phone/wallet/rules/{rulesType}
#pragma mark - 查询规则
+ (void)GetWalletRulesRulesType:(NSString *)rulesType success:(void(^)(RulesModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/rules/%@",BBT_HTTP_URL,PROJECT_NAME_APP,rulesType];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        RulesModel *respone = [RulesModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询商城钱包地址
//请求类型 get
//请求Url  /bbt-phone/wallet/adress/{appName}
#pragma mark - 查询商城钱包地址
+ (void)GetWalletadressAppName:(NSString *)appName success:(void(^)(WalletAdressModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/adress/%@",BBT_HTTP_URL,PROJECT_NAME_APP,BBT_APP_TYPE];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        WalletAdressModel *respone = [WalletAdressModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 查询小二会员级别
//请求类型 get
//请求Url  /bbt-phone/member/allLevel

#pragma mark - 查询小二会员级别
+ (void)GetMemberAllLevelsuccess:(void(^)(MemberLevellModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/member/allLevel",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        MemberLevellModel *respone = [MemberLevellModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 see-收支明细
//请求类型 get
//请求Url  /bbt-phone/wallet/detail
#pragma mark - see-收支明细
+ (void)GetWalletDetailpageNum:(NSString *)pageNum success:(void(^)(WalletDetailModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/detail?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        WalletDetailModel *respone = [WalletDetailModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 会员充值
//请求类型 post
//请求Url  /bbt-phone/wallet/recharge
#pragma mark - 会员充值
+ (void)PostWalletRechargeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/recharge",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"会员充值urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"会员充值=====%@",result);
        
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

//接口名称 会员升级
//请求类型 post
//请求Url  /bbt-phone/member/upgrade
#pragma mark - 会员升级
+ (void)PostMemberUpgradeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/member/upgrade",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"会员升级urlStr=====%@", urlStr);//
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
//    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
//
//    NSLog(@"params====%@", params);
//
//    NSLog(@"bodyDic====%@", parameter);
//
//
//    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
//
//        NSLog(@"会员升级=====%@",result);
//
//        PanetKnInetlCommon *respone = [PanetKnInetlCommon mj_objectWithKeyValues:result];
//
//
//
//        if (success) {
//
//            success(respone);
//        }
//
//
//
//
//    } failure:^(NSError *error) {
//
//        if (failure) {
//
//            failure(error);
//
//        }
//
//    }];
    
    
    
}

//接口名称 充值记录
//请求类型 get
//请求Url  /bbt-phone/wallet/recharge/record
#pragma mark - 充值记录
+ (void)GetWalletreChargeRecordpageNum:(NSString *)pageNum success:(void(^)(RechargeRecordModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/recharge/record?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        RechargeRecordModel *respone = [RechargeRecordModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 小二币收支明细
//请求类型 get
//请求Url  /bbt-phone/wallet/twoCurrency
#pragma mark - 小二币收支明细
+ (void)GetWalletTwoCurrencypageNum:(NSString *)pageNum success:(void(^)(TwoCurrencyModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/twoCurrency?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"小二币收支明细result=====%@",result);
        
        TwoCurrencyModel *respone = [TwoCurrencyModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 钱包首页
//请求类型 get
//请求Url  /bbt-phone/wallet
#pragma mark - 钱包首页
+ (void)GetWalletsuccess:(void(^)(WalletModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"钱包首页result=====%@",result);
        
        WalletModel *respone = [WalletModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 查询需要升级的级别
//请求类型 get
//请求Url  /bbt-phone/updateLevel
#pragma mark - 查询需要升级的级别
+ (void)GetUpdateLevelsuccess:(void(^)(UpdateLevelModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/member/updateLevel",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"钱包首页result=====%@",result);
        
        UpdateLevelModel *respone = [UpdateLevelModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 积分兑换(充值)
//请求类型 post
//请求Url  /cz-phone/pointWallet/exchange
#pragma mark - 积分兑换(充值)
+ (void)PostpointWalletExchangeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/pointWallet/exchange",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"会员充值urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"会员充值=====%@",result);
        
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


//接口名称 积分兑换(充值)记录
//请求类型 get
//请求Url  /cz-phone/pointWallet/rechargeRecord
#pragma mark - 积分兑换(充值)记录
+ (void)GetpointWalletRechargeRecordpageNum:(NSString *)pageNum success:(void(^)(RechargeRecordModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/pointWallet/rechargeRecord?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@" 积分兑换(充值)记录result=====%@",result);
        
        RechargeRecordModel *respone = [RechargeRecordModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//请求类型 get
//请求Url  /cz-phone/pointWallet/exchangeRate
#pragma mark - 获取积分兑换汇率
+ (void)GetpointWalletExchangesuccess:(void(^)(ExchangeRateModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/pointWallet/exchangeRate",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@" 积分兑换(充值)记录result=====%@",result);
        
        ExchangeRateModel *respone = [ExchangeRateModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//请求类型 get
//请求Url  /cz-phone/users/friends/{userId}
#pragma mark -- 查询用户好友列表
+ (void)GetUsersFriendsUserId:(NSString *)userId pageNum:(NSString *)pageNum success:(void(^)(HDMyFriendModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/friends/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP, userId,pageNum,@"20"];
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        HDMyFriendModel *respone = [HDMyFriendModel mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
}

//接口名称 提现
//请求类型 post
//请求Url  /bbt-phone/withDrawMoney/apply
#pragma mark - 提现
+ (void)PostwithDrawMoneyapply:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/withDrawMoney/apply",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"会员充值urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"提现=====%@",result);
        
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

//接口名称 提现记录
//请求类型 get
//请求Url  /bbt-phone/withDrawMoney/record
+ (void)GetwithDrawMoneyRecordpageNum:(NSString *)pageNum success:(void(^)(withDrawMoneyRecordModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/withDrawMoney/record?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@" 积分兑换(充值)记录result=====%@",result);
        
        withDrawMoneyRecordModel *respone = [withDrawMoneyRecordModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 代理商查询学习卡列表
//请求类型 get
//请求Url  bbt-phone/studyCard
#pragma mark - 查询全部代理商查询学习卡列表
+ (void)GetAlstudyCardType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(LCPlatformModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studyCard?type=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,type,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询全部订单列表列表result=====%@",result);
        
        LCPlatformModel *respone = [LCPlatformModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

#pragma mark - 查询代理商查询学习卡列表
+ (void)GetAlstudyCardStatus:(NSString *)cardStatus CardType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(LCPlatformModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studyCard?cardStatus=%@&type=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,cardStatus,type,pageNum,@"20"];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询代理商查询学习卡列表result=====%@",result);
        
        LCPlatformModel *respone = [LCPlatformModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 激活学习卡
//请求类型 post
//请求Url  bbt-phone/studyCard/active
#pragma mark -  激活学习卡
+ (void)PoststudyCardactive:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studyCard/active",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"会员充值urlStr=====%@", urlStr);//
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", parameter);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"提现=====%@",result);
        
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

+ (void)GetStudyCardShowsuccess:(void(^)(StudyCardShowModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studyCard/isShow",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"-------%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"查询收货地址列表result=====%@",result);
        
        StudyCardShowModel *respone = [StudyCardShowModel mj_objectWithKeyValues:result];
        
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
