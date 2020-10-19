//
//  MineRequestTool.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PanetKnInetlCommon,PanetMineAddressModel,MemberModel,XEOrderModel,OrderDetailModel,RulesModel,WalletAdressModel,MemberLevellModel,WalletDetailModel,RechargeRecordModel,TwoCurrencyModel,WalletModel,UpdateLevelModel,ExchangeRateModel,HDMyFriendModel,withDrawMoneyRecordModel,LCPlatformModel,StudyCardShowModel;


NS_ASSUME_NONNULL_BEGIN

@interface MineRequestTool : NSObject


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


//接口名称 查询小二会员级别
//请求类型 get
//请求Url  /bbt-phone/member/allLevel
//+ (void)getMemberallLevelsuccess:(void(^)(MemberModel *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 查询会员信息
//请求类型 get
//请求Url  /bbt-phone/member
+ (void)getMembersuccess:(void(^)(MemberModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询订单列表
//请求类型 get
//请求Url  /bbt-phone/mallOrder
#pragma mark - 查询全部订单列表
+ (void)GetAllmallOrderpageNum:(NSString *)pageNum success:(void(^)(XEOrderModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 查询订单列表
//请求类型 get
//请求Url  /bbt-phone/mallOrder
#pragma mark - 查询订单列表
+ (void)GetAllmallOrderOrderStatus:(NSString *)orderstatus pageNum:(NSString *)pageNum success:(void(^)(XEOrderModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 查询订单详情
//请求类型 get
//请求Url  /bbt-phone/mallOrder/detail/{orderId}
#pragma mark - 查询订单详情
+ (void)GetMallOrderDetailOrderId:(NSString *)orderid success:(void(^)(OrderDetailModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 取消订单
//请求类型 put
//请求Url  /bbt-phone/mallOrder/cancel{orderId}
#pragma mark - 取消订单
+ (void)PutMallOrderCancelOrderId:(NSString *)orderid success:(void(^)(PanetKnInetlCommon *response))success failure:(void(^)(NSError *error))failure;


//接口名称 确订收货
//请求类型 put
//请求Url  /bbt-phone/mallOrder/confirm/{orderId}
#pragma mark - 确订收货
+ (void)PutMallOrderConfirmOrderId:(NSString *)orderid success:(void(^)(PanetKnInetlCommon *response))success failure:(void(^)(NSError *error))failure;

//接口名称 查询规则
//请求类型 get
//请求Url  /bbt-phone/wallet/rules/{rulesType}
#pragma mark - 查询规则
+ (void)GetWalletRulesRulesType:(NSString *)rulesType success:(void(^)(RulesModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 查询商城钱包地址
//请求类型 get
//请求Url  /bbt-phone/wallet/adress/{appName}
#pragma mark - 查询商城钱包地址
+ (void)GetWalletadressAppName:(NSString *)appName success:(void(^)(WalletAdressModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 查询小二会员级别
//请求类型 get
//请求Url  /bbt-phone/member/allLevel

#pragma mark - 查询小二会员级别
+ (void)GetMemberAllLevelsuccess:(void(^)(MemberLevellModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 see-收支明细
//请求类型 get
//请求Url  /bbt-phone/wallet/detail
#pragma mark - see-收支明细
+ (void)GetWalletDetailpageNum:(NSString *)pageNum success:(void(^)(WalletDetailModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 会员充值
//请求类型 post
//请求Url  /bbt-phone/wallet/recharge
#pragma mark - 会员充值
+ (void)PostWalletRechargeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 会员升级
//请求类型 post
//请求Url  /bbt-phone/member/upgrade
#pragma mark - 会员升级
+ (void)PostMemberUpgradeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 充值记录
//请求类型 get
//请求Url  /bbt-phone/wallet/recharge/record
#pragma mark - 充值记录
+ (void)GetWalletreChargeRecordpageNum:(NSString *)pageNum success:(void(^)(RechargeRecordModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 小二币收支明细
//请求类型 get
//请求Url  /bbt-phone/wallet/twoCurrency
#pragma mark - 小二币收支明细
+ (void)GetWalletTwoCurrencypageNum:(NSString *)pageNum success:(void(^)(TwoCurrencyModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 钱包首页
//请求类型 get
//请求Url  /bbt-phone/wallet
#pragma mark - 钱包首页
+ (void)GetWalletsuccess:(void(^)(WalletModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 查询需要升级的级别
//请求类型 get
//请求Url  /bbt-phone/updateLevel
#pragma mark - 查询需要升级的级别
+ (void)GetUpdateLevelsuccess:(void(^)(UpdateLevelModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 积分兑换(充值)
//请求类型 post
//请求Url  /cz-phone/pointWallet/exchange
#pragma mark - 积分兑换(充值)
+ (void)PostpointWalletExchangeParameter:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 积分兑换(充值)记录
//请求类型 get
//请求Url  /cz-phone/pointWallet/rechargeRecord
#pragma mark - 积分兑换(充值)记录
+ (void)GetpointWalletRechargeRecordpageNum:(NSString *)pageNum success:(void(^)(RechargeRecordModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 获取积分兑换汇率
//请求类型 get
//请求Url  /cz-phone/pointWallet/exchangeRate
#pragma mark - 获取积分兑换汇率
+ (void)GetpointWalletExchangesuccess:(void(^)(ExchangeRateModel *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 查询用户好友列表
//请求类型 get
//请求Url  /cz-phone/users/friends/{userId}
#pragma mark -- 查询用户好友列表
+ (void)GetUsersFriendsUserId:(NSString *)userId pageNum:(NSString *)pageNum success:(void(^)(HDMyFriendModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 提现
//请求类型 post
//请求Url  /bbt-phone/withDrawMoney/apply
#pragma mark - 提现
+ (void)PostwithDrawMoneyapply:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;

//接口名称 提现记录
//请求类型 get
//请求Url  /bbt-phone/withDrawMoney/record
+ (void)GetwithDrawMoneyRecordpageNum:(NSString *)pageNum success:(void(^)(withDrawMoneyRecordModel *response))success failure:(void(^)(NSError *error))failure;


//接口名称 代理商查询学习卡列表
//请求类型 get
//请求Url  bbt-phone/studyCard
#pragma mark - 查询全部代理商查询学习卡列表
+ (void)GetAlstudyCardType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(LCPlatformModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 代理商查询学习卡列表
//请求类型 get
//请求Url  bbt-phone/studyCard
#pragma mark - 查询代理商查询学习卡列表
+ (void)GetAlstudyCardStatus:(NSString *)cardStatus CardType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(LCPlatformModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 激活学习卡
//请求类型 post
//请求Url  bbt-phone/studyCard/active
#pragma mark -  激活学习卡
+ (void)PoststudyCardactive:(NSDictionary *)parameter success:(void(^)(PanetKnInetlCommon *respone))success failure:(void(^)(NSError *error))failure;


////接口名称 用户查询学习卡列表
////请求类型 get
////请求Url  bbt-phone/studyCard
//#pragma mark - 查询代理商查询学习卡列表
//+ (void)GetUserstudyCardCardType:(NSString *)type pageNum:(NSString *)pageNum success:(void(^)(LCPlatformModel *response))success failure:(void(^)(NSError *error))failure;
 
+ (void)GetStudyCardShowsuccess:(void(^)(StudyCardShowModel *response))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
