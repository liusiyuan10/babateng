//
//  QCategoryRequestTool.m
//  BaBaTeng
//
//  Created by liu on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCategoryRequestTool.h"
#import "TMCache.h"
#import "Header.h"
#import "BBTHttpTool.h"
#import "QSourceTag.h"
#import "QSongDetails.h"
#import "QMPanel.h"

@implementation QCategoryRequestTool

#pragma mark --根据标签编号获取歌曲列表
+ (void)getDeviceSourceTagsName:(NSString *)name Parameter:(NSDictionary *)parameter  success:(void(^)(QSourceTag *response))success failure:(void(^)(NSError *error))failure
{
    

    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/sourceTags/%@/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,name,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"]];

    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        QSourceTag *respone = [QSourceTag mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}


#pragma mark --点播标签列表里的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/sourceTags/1/2/3
+ (void)PostDemandSourceTags:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/sourceTags/%@/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"tagId"],[parameter objectForKey:@"trackId"],[parameter objectForKey:@"deviceId"]];
    NSLog(@"urlStr=====%@", urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"宝贝歌单列表详情result=====%@",result);
        
        QSongDetails *respone = [QSongDetails mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --根据标专辑标签获取专辑/bbt-phone/trackLists/getByTag/{tagId}
+ (void)getAlbumTagsName:(NSString *)name Parameter:(NSDictionary *)parameter PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize  success:(void(^)(QMPanel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/getByTag/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,name,pagenum,pagesize];
    
    NSLog(@"urlStr=====%@", urlStr);
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        QMPanel *respone = [QMPanel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

@end
