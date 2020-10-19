//
//  QClockRequestTool.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockRequestTool.h"

#import "QClockBell.h"

#import "Header.h"

#import "TMCache.h"

#import "BBTHttpTool.h"

#import "QClockCommon.h"

#import "QClock.h"

@implementation QClockRequestTool

#pragma mark --查询所有闹钟铃声 /bbt-phone/clock/getSounds
+ (void)getclockSoundsParameter:(NSDictionary *)parameter success:(void(^)(QClockBell *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/clock/getSounds",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"亲情电话获取信息请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result亲情电话获取信息=====%@",result);
        
        QClockBell *respone = [QClockBell mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

/*****************添加闹钟****************************/
#pragma mark --添加闹钟/bbt-phone/clock/addClock
+ (void)AddclockaddClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/clock/addClock",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    
//    NSDictionary *parameter = @{@"enable" : @"1", @"deviceId": [[TMCache sharedCache] objectForKey:@"deviceId"], @"repeat": self.repeatStr,@"songname": self.clockClueStr,@"soundId":self.clockBellId,@"time":self.timeStr};
    
    NSDictionary *bodyDic = @{@"enable" : [parameter objectForKey:@"enable"], @"deviceId":[parameter objectForKey:@"deviceId"], @"repeat":[parameter objectForKey:@"repeat"],@"songname":[parameter objectForKey:@"songname"],@"soundId":[parameter objectForKey:@"soundId"],@"time":[parameter objectForKey:@"time"]};
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"添加联系人=====%@",result);
        
        QClockCommon *respone = [QClockCommon mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

/*****************编辑闹钟****************************/
#pragma mark --编辑闹钟 /bbt-phone/updateClock/{clockId}
+ (void)EditclockupdateClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/clock/updateClock/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"clockId"]];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    NSDictionary *bodyDic = @{@"enable" : [parameter objectForKey:@"enable"],@"deviceId":[parameter objectForKey:@"deviceId"], @"repeat":[parameter objectForKey:@"repeat"],@"songname":[parameter objectForKey:@"songname"],@"soundId":[parameter objectForKey:@"soundId"],@"time":[parameter objectForKey:@"time"]};
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"编辑联系人=====%@",result);
        
        QClockCommon *respone = [QClockCommon mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
    
}

/*****************查询闹钟****************************/
#pragma mark --查询闹钟  /bbt-phone/clock/getClocks/{deviceId}
+ (void)getclockGetClocksParameter:(NSDictionary *)parameter success:(void(^)(QClock *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/clock/getClocks/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"查询闹钟请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询闹钟信息=====%@",result);
        
        QClock *respone = [QClock mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

/*****************删除闹钟****************************/
#pragma mark --删除闹钟/bbt-phone/clock/deleteClock/{clockId}
+ (void)DeleteclockdeleteClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/clock/deleteClock/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"clockId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"删除闹钟result=====%@",result);
        
        
        QClockCommon *respone = [QClockCommon mj_objectWithKeyValues:result];
        
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
