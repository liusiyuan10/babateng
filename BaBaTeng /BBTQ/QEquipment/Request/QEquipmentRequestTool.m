//
//  QEquipmentRequestTool.m
//  BaBaTeng
//
//  Created by liu on 17/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QEquipmentRequestTool.h"
#import "BBTHttpTool.h"
#import "QDevice.h"
#import "Header.h"
#import "TMCache.h"
@implementation QEquipmentRequestTool

/*****************获取设备信息****************************/
#pragma mark --获取设备信息http://192.168.1.17:8080/ /bbt-phone/devices/:deviceId
+ (void)GetdeviceInfo:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result==%@",result);
   
        
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];

}


#pragma mark --设置设备信息http://192.168.1.17:8080/ /bbt-phone/devices/:deviceId
+ (void)PutdeviceInfoDic:(NSDictionary *)infodic Parameter:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/devices/%@/boxinfo",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    

    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"] , @"token":[parameter objectForKey:@"token"] };
    
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:infodic success:^(id result) {
        
        NSLog(@"====%@",result);
        
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    

    
}

#pragma mark --查询设备所属公司信息http://192.168.1.17:8080/  /bbt-phone/devices/:deviceId/company
+ (void)GetdeviceCompanyInfoDic:(NSString *)deviceId  Parameter:(NSDictionary *)parameter success:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/devices/%@/company",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId];
    

    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"] , @"token":[parameter objectForKey:@"token"] };
    
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}

#pragma mark -- 修改设备昵称
+ (void)updateDeviceId:(NSString *)deviceId  DeviceName:(NSString *)deviceName  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP, deviceId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    //NSDictionary *bodydic = @{@"name" :deviceName };
     NSDictionary *bodyDic = @{@"name" :deviceName};
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    NSLog(@"bodydic====%@", bodyDic);
    [BBTHttpTool PUTDeviceNameHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"修改设备昵称=====%@", result);
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
}

#pragma mark -- 修改群名片
+ (void)updateMembersId :(NSString *)familyMemberId  FamilyId :(NSString *)familyId  DeviceName:(NSString *)deviceName  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/%@/familyMembers/%@",BBT_HTTP_URL,PROJECT_NAME_APP, familyId,familyMemberId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    //NSDictionary *bodydic = @{@"name" :deviceName };
    NSDictionary *bodyDic = @{@"name" :deviceName};
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    NSLog(@"bodydic====%@", bodyDic);
    [BBTHttpTool PUTDeviceNameHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"修改群名片=====%@", result);
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        if (failure) {
            
            failure(error);
            
        }
    }];
}

#pragma mark -- 检测设备版本
+ (void)checkDeviceVersion :(NSString *)deviceId  Version:(NSString *)version  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/firmwareDevice/checkVersion/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    // NSDictionary *bodyDic = @{@"deviceId" :deviceId,@"version" :version};
    NSLog(@"888===%@",urlStr);
    NSLog(@"params===%@",params);
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"检测设备版本=====%@", result);
        
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}


#pragma mark -- 命令设备升级到最新版本
+ (void)upgrade :(NSString *)deviceId  upload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/firmwareDevice/upgrade/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"命令设备升级到最新版本=====%@", result);
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
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
