//
//  SyncEnglishRequest.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "SyncEnglishRequest.h"

#import "Header.h"

#import "TMCache.h"
#import "BBTHttpTool.h"

#import "SyncEnglishModel.h"
#import "MyEnglishModel.h"

#import "EnglishCommon.h"


@implementation SyncEnglishRequest

#pragma mark --查询英语学习专辑 /bbt-phone/trackLists/englishList
+ (void)getEnglishListParameter:(NSDictionary *)parameter success:(void(^)(SyncEnglishModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/englishList/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    NSLog(@"查询英语学习专辑%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);

    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        SyncEnglishModel *respone = [SyncEnglishModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

#pragma mark --查询英语点读 bbt-phone/getEnglish/{deviceId}
+ (void)getMyEnglishListParameter:(NSDictionary *)parameter success:(void(^)(MyEnglishModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/getEnglish/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    NSLog(@"查询英语点读%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        MyEnglishModel *respone = [MyEnglishModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}


#pragma mark --添加英语点读 bbt-phone/trackLists/addEnglish/{trackListId}/{deviceId}
+ (void)AddmyEnglishListParameter:(NSDictionary *)parameter success:(void(^)(EnglishCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/addEnglish/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"trackListId"],[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    NSLog(@"添加英语点读%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        EnglishCommon *respone = [EnglishCommon mj_objectWithKeyValues:result];
        
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
