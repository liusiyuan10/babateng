//
//  BBTCustomViewRequestTool.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTCustomViewRequestTool.h"
#import "QCustom.h"
#import "BBTHttpTool.h"
#import "Header.h"

#import "TMCache.h"
#import "QAddSong.h"

@implementation BBTCustomViewRequestTool

+(void)getCurrentPlayingParameter:(NSDictionary *)parameter  success:(void (^)(QCustom *respone))success failure:(void (^)(NSError *error))failure{

    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playingTracks/current/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"请求链接%@",urlStr);
    
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"]};
    
    NSLog(@"请求参数%@",params);

    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
            NSLog(@"获取当前播放歌曲=====%@",result);
        
            QCustom *respone = [QCustom mj_objectWithKeyValues:result];

            if (success) {

                success(respone);
            }
        
    } failure:^(NSError *error) {
        
            if (failure) {
    
                failure(error);
    
            }
    }];
    
}

#pragma mark --获取当前播放歌曲列表
+(void)getCurrentPlayingTracksParameter:(NSDictionary *)parameter  success:(void (^)(QCustom *respone))success failure:(void (^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playingTracks/devices/%@?orderBy=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"orderBy"]];
    
    NSLog(@"请求链接2333333%@",urlStr);
    
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"]};
    
    

    
   // NSDictionary *bodyDic = @{@"orderBy" : @"0"};

    
// 
//      [BBTHttpTool getNewHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
//          
//          NSLog(@"获取当前播放歌曲列表=====%@",result);
//          
//          QCustom *respone = [QCustom mj_objectWithKeyValues:result];
//          
//          if (success) {
//              
//              success(respone);
//          }
//
//          
//      } failure:^(NSError *error) {
//          if (failure) {
//              
//              failure(error);
//          }
//          
//        }];

    
   
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"获取当前播放歌曲列表1111111111111111111111=====%@",result);
        
        QCustom *respone = [QCustom mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
}


//接口名称 设备控制命令MQTT
//请求类型 put
//请求Url  /bbt-phone/devices/:deviceId/control
+(void)PutDevicesControlMQTTParameter:(NSDictionary *)parameter BodyDic:(NSDictionary *)bodydic  success:(void (^)(QAddSong *respone))success failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/%@/control",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    NSLog(@"urlStr=====%@", urlStr);//

    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);

    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"mqttdedaodododood=====%@",result);
        
        QAddSong *respone = [QAddSong mj_objectWithKeyValues:result];
        
        
        
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
