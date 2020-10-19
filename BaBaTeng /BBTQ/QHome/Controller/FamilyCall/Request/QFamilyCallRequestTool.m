//
//  QFamilyCallRequestTool.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyCallRequestTool.h"
#import "TMCache.h"
#import "BBTHttpTool.h"
#import "Header.h"
#import "QFamilyCall.h"
#import "familyPhoneRecordC.h"
#import "QFamilyPhone.h"
#import "QFamilyContact.h"
#import "QFamilyPhoneNickName.h"
#import "QFamilyEditContact.h"
#import "QFamilyCommon.h"

@implementation QFamilyCallRequestTool

+ (void)GetfamilyPhoneInfoParameter:(NSDictionary *)parameter success:(void(^)(QFamilyCall *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyPhoneInfo/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
        NSLog(@"亲情电话获取信息请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {

        NSLog(@"result亲情电话获取信息=====%@",result);
        
        QFamilyCall *respone = [QFamilyCall mj_objectWithKeyValues:result];

        if (success) {

            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

/*****************统计设备下面的宝贝通话记录****************************/
+ (void)GetfamilyPhoneRecordParameter:(NSDictionary *)parameter success:(void(^)(QFamilyPhone *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyPhoneRecord/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"统计设备下面的宝贝通话记录%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result统计设备下面的宝贝通话记录=====%@",result);
        
        QFamilyPhone *respone = [QFamilyPhone mj_objectWithKeyValues:result];

        if (success) {

            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

/*****************查询设备下面某个联系人的通话记录详情****************************/
#pragma mark --查询设备下面某个联系人的通话记录详情
+ (void)GetfamilyPhoneRecordContactsIdParameter:(NSDictionary *)parameter success:(void(^)(familyPhoneRecordC *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyPhoneRecord/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"contactsId"]];
    
    NSLog(@"查询设备下面某个联系人的通话记录详情%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询设备下面某个联系人的通话记录详情=====%@",result);
        
                familyPhoneRecordC *respone = [familyPhoneRecordC mj_objectWithKeyValues:result];
        
                if (success) {
        
                    success(respone);
                }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

/*****************宝贝通讯录联系人列表****************************/
#pragma mark --宝贝通讯录联系人列表
+ (void)GetfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyContact *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyContacts/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"宝贝通讯录联系人列表%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result宝贝通讯录联系人列表=====%@",result);
        
        QFamilyContact *respone = [QFamilyContact mj_objectWithKeyValues:result];

        if (success) {

            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}



/*****************查询联系人称呼列表****************************/
#pragma mark --查询联系人称呼列表
+ (void)GetfamilyPhoneNicknameParameter:(NSDictionary *)parameter success:(void(^)(QFamilyPhoneNickName *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyPhoneNickname",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询联系人称呼列表%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询联系人称呼列表=====%@",result);
        
        QFamilyPhoneNickName *respone = [QFamilyPhoneNickName mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

/*****************编辑联系人****************************/
#pragma mark --编辑联系人
+ (void)EditfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyEditContact *response))success failure:(void(^)(NSError *error))failure;
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyContacts/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"contactsId"]];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
//    NSDictionary *bodyDic = @{@"phoneNumber" : [parameter objectForKey:@"phoneNumber"], @"deviceId":[parameter objectForKey:@"deviceId"], @"icon":[parameter objectForKey:@"icon"],@"isCommon":[parameter objectForKey:@"isCommon"],@"nickName":[parameter objectForKey:@"nickName"],@"nicknameId":[parameter objectForKey:@"nicknameId"]};
    
    NSDictionary *bodyDic = @{@"phoneNumber" : [parameter objectForKey:@"phoneNumber"], @"deviceId":[parameter objectForKey:@"deviceId"], @"icon":[parameter objectForKey:@"icon"],@"isCommon":[parameter objectForKey:@"isCommon"],@"nicknameId":[parameter objectForKey:@"nicknameId"]};
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"编辑联系人=====%@",result);
        
        QFamilyEditContact *respone = [QFamilyEditContact mj_objectWithKeyValues:result];



        if (success) {

            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
    
}


/*****************添加联系人****************************/
#pragma mark --添加联系人
+ (void)AddfamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyEditContact *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyContacts",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    NSDictionary *bodyDic = @{@"phoneNumber" : [parameter objectForKey:@"phoneNumber"], @"deviceId":[parameter objectForKey:@"deviceId"], @"icon":[parameter objectForKey:@"icon"],@"isCommon":[parameter objectForKey:@"isCommon"],@"nicknameId":[parameter objectForKey:@"nicknameId"]};
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"添加联系人=====%@",result);

        QFamilyEditContact *respone = [QFamilyEditContact mj_objectWithKeyValues:result];



        if (success) {

            success(respone);
        }


        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
//    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
//
//        NSLog(@"编辑联系人=====%@",result);
//
//        QFamilyEditContact *respone = [QFamilyEditContact mj_objectWithKeyValues:result];
//
//
//
//        if (success) {
//
//            success(respone);
//        }
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


#pragma mark -- 修改设备手机号码  /bbt-phone/devices/:deviceId/:phoneNumber
+ (void)updateFamilyPhoneNumdeviceId:(NSString *)deviceId  Phonenum:(NSString *)phonenum  upload:(void(^)(QFamilyCommon *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP, deviceId,phonenum];
    
    NSLog(@"修改设备手机号码请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"修改设备手机号码=====%@",result);
        
        QFamilyCommon *respone = [QFamilyCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

/*****************删除联系人****************************/
#pragma mark --删除联系人
// /bbt-phone/familyContacts/{contactsId}
+ (void)DeletefamilyContactsParameter:(NSDictionary *)parameter success:(void(^)(QFamilyCommon *response))success failure:(void(^)(NSError *error))failure
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/familyContacts/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"contactsId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params success:^(id result) {
    
        NSLog(@"删除联系人result=====%@",result);
    
    
        QFamilyCommon *respone = [QFamilyCommon mj_objectWithKeyValues:result];
    
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
