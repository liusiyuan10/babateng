//
//  BBlockRequestTool.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BBlockRequestTool.h"
#import "TMCache.h"
#import "Header.h"
#import "BBTHttpTool.h"
#import "BStoreModel.h"
#import "BBlockCommon.h"

@implementation BBlockRequestTool

/*****************查询程序列表****************************/
#pragma mark --/bbt-phone/programming/listShares

+ (void)GetProgrammingParameter:(NSDictionary *)parameter success:(void(^)(BStoreModel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/programming/listShares?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result查询程序列表=====%@",result);
        
        BStoreModel *respone = [BStoreModel mj_objectWithKeyValues:result];

        if (success) {

            success(respone);
        }

        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
    
}


//接口名称 下载程序
//请求类型 put
//请求Url  /bbt-phone/programming/download/{shareId}

#pragma mark --下载程序 /bbt-phone/programming/download/{shareId}
+(void)PutProgrammingDownloadParameter:(NSDictionary *)parameter success:(void (^)(BBlockCommon *respone))success failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/programming/download/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"shareId"]];
    
    NSLog(@"下载程序请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        NSLog(@"result下载程序=====%@",result);
        
        BBlockCommon *respone = [BBlockCommon mj_objectWithKeyValues:result];
        
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
