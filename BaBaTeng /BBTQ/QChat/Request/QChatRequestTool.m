//
//  QChatRequestTool.m
//  BaBaTeng
//
//  Created by liu on 17/8/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QChatRequestTool.h"
#import "BBTHttpTool.h"
#import "Header.h"
#import "QChat.h"
#import "QSXMessage.h"
#import "QMessageCommon.h"


@implementation QChatRequestTool

+ (void)GetChatInfo:(NSDictionary *)parameter success:(void(^)(QChat *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/devices/%@/familyChatRecords?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"]];
    
        NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
//        NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
     
        
        QChat *respone = [QChat mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    

    
}

/*****************上传文本消息****************************/
+ (void)PostChatMessageText:(NSDictionary *)parameter success:(void(^)(QChat *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/devices/%@/familyChatRecords/text",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *bodyDic = @{@"message" : [parameter objectForKey:@"message"] };
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
   
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {

        

        QChat *respone = [QChat mj_objectWithKeyValues:result];

            if (success) {

                success(respone);
            }
        
    } failure:^(NSError *error) {
        
            if (failure) {
                failure(error);
            }
        
    }];
    

    
//    [BBTHttpTool PostHead:urlStr parameters:params success:^(id result) {
//        
//        
//        
//        NSLog(@"result正在播放=====%@",result);
//        
//        QChat *respone = [QChat mj_objectWithKeyValues:result];
//        
//        if (success) {
//            
//            success(respone);
//        }
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            failure(error);
//        }
//        
//        
//    }];
    
}

/*****************查询常用的回答消息****************************/
#pragma mark -- /bbt-phone/timelyMessages/commonInformations

+ (void)GetTimelyMessages:(NSDictionary *)parameter success:(void(^)(QSXMessage *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/timelyMessages/commonInformations",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //        NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询常用的回答消息=====%@",result);
        QSXMessage *respone = [QSXMessage mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
    
}

//接口名称 给设备推送消息
//请求类型 post
//请求Url  /bbt-phone/timelyMessages/devices/{deviceId}

/*****************上传文本消息****************************/
+ (void)PostTimelyMessagesText:(NSDictionary *)parameter success:(void(^)(QMessageCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/timelyMessages/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *bodyDic = @{@"message" : [parameter objectForKey:@"message"] };
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        
        
        QMessageCommon *respone = [QMessageCommon mj_objectWithKeyValues:result];
        
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
