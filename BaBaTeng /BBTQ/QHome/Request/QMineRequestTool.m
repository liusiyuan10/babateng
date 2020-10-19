//
//  Q2MineRequestTool.m
//  XZ_WeChat
//
//  Created by liu on 17/3/17.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "QMineRequestTool.h"
#import "QFavoriteRespone.h"
#import "BBTHttpTool.h"
#import "MJExtension.h"

#import "QSongRespone.h"
#import "QAlbumResponse.h"
#import "QResourceResponese.h"
#import "Header.h"
#import "TMCache.h"
#import "QDeviceInfoRespone.h"

#import "QPanel.h"
#import "QAlbum.h"
#import "QSourceType.h"

#import "QHistory.h"
#import "QSong.h"
#import "QSongDetails.h"
#import "QMPanel.h"
#import "QSongDevicePlayData.h"
#import "QModule.h"
#import "DeviceControl.h"
#import "QAlbumDetial.h"
#import "QNewSongDetails.h"
#import "QSearchCount.h"


@implementation QMineRequestTool

// http://120.76.102.88:9080/httprequst_api/postAPI/user_getalbumtype_proc


#pragma mark --搜索列表
+ (void)GetSearchListParameter:(NSDictionary *)parameter success:(void(^)(QHistory *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *str = [[parameter objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
     NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/%@?pageNum=%@&pageSize=%@&keyword=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"],str1];
    

     NSLog(@"搜索列表请求链接===%@",urlStr);
    
    
    NSDictionary *parames = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parames success:^(id result) {
        
        
        
        NSLog(@"11111搜索列表result=====%@",result);
        
        QHistory *respone = [QHistory mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}








#pragma mark --获取设备类型拥有的设备控制功能:音量调整、灯光控制、定时关机等
+ (void)getDeviceControllersName:(NSString *)name success:(void(^)(DeviceControl *response))success failure:(void(^)(NSError *error))failure
{
//http://192.168.1.17:8080/bbt-phone/deviceTypes/1/controllers
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes/%@/controllers",BBT_HTTP_URL,PROJECT_NAME_APP,name];
    
//    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
//    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        DeviceControl *respone = [DeviceControl mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
}

#pragma mark --获取设备的资源分类
+ (void)getDeviceSourceTypesName:(NSString *)name success:(void(^)(QSourceType *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes/%@/sourceTypes?version=%@",BBT_HTTP_URL,PROJECT_NAME_APP,name,@"1"];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        QSourceType *respone = [QSourceType mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
}

#pragma mark --获取设备类型拥有的模块:点播历史、宝贝说说等
+ (void)getDeviceModulesName:(NSString *)name success:(void(^)(QModule *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes/%@/modules",BBT_HTTP_URL,PROJECT_NAME_APP,name];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        QModule *respone = [QModule mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

#pragma mark --获取设备类型拥有的板块:精品推荐、听故事、学英语等
+ (void)getDevicePanelsName:(NSString *)name success:(void(^)(QPanel *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes/%@/panels",BBT_HTTP_URL,PROJECT_NAME_APP,name];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
        QPanel *respone = [QPanel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
        
    }];
}

#pragma mark --根据专辑编号获取歌曲列表
+(void)gettrackListsId:(NSString *)trackListId Parameter:(NSDictionary *)parameter  success:(void (^)(QAlbumDetial *respone))success failure:(void (^)(NSError *error))failure
{
//    http://192.168.1.17:8080/bbt-phone/trackLists/1
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,trackListId,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result8888=====%@",result);
        
        QAlbumDetial *respone = [QAlbumDetial mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    

    
}

#pragma mark --根据专辑编号分页获取歌曲列表
+(void)getpagetrackListsId:(NSString *)trackListId PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize Parameter:(NSDictionary *)parameter  success:(void (^)(QAlbum *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/trackLists/%@/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,trackListId,[parameter objectForKey:@"deviceId"],pagenum,pagesize];
    
    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result1234565656565=====%@",result);
        
        QAlbum *respone = [QAlbum mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --搜索歌曲
+(void)getSearchListParameter:(NSDictionary *)parameter  success:(void (^)(QAlbum *respone))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/tracks/%@?pageNum=%@&pageSize=%@keyword=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"],[parameter objectForKey:@"keyword"]];
   
    NSLog(@"搜索歌曲请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"搜索歌曲请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"搜索歌曲result=====%@",result);
        
        QAlbum *respone = [QAlbum mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --根据设备码获取点播历史列表
+ (void)GetPlayHistoriesDevice:(NSString *)deviceId pageNum:(NSString *)pageNum success:(void(^)(QHistory *respone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playHistories/devices/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId,pageNum,@"20"];

    
    // NSLog(@"点播历史列表请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"点播历史列表result=====%@",result);
        
        QHistory *respone = [QHistory mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}


#pragma mark --根据设备码获取宝贝歌单列表 GET /deviceSongLists/devices/{deviceId}
+ (void)GetDeviceSongLists:(NSString *)deviceId pageNum:(NSString *)pageNum  success:(void(^)(QSong *respone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceSongLists/devices/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId,pageNum,@"20"];
    
    NSLog(@"宝贝歌单列表===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSLog(@"宝贝歌单列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"宝贝歌单列表result=====%@",result);
        
        QSong *respone = [QSong mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        //
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

#pragma mark --获取宝贝歌单详情 GET /deviceSongLists/{songListId
+ (void)GetDeviceSongListsDetails:(NSString *)songListId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize success:(void(^)(QNewSongDetails *respone))success failure:(void(^)(NSError *error))failure{
    
    
    //GET /tracks/songLists/{songListId}/{deviceId
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/songLists/%@/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,songListId, [[TMCache sharedCache] objectForKey:@"deviceId"],pageNum,pageSize];
    
    NSLog(@"宝贝歌单列表详情===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSLog(@"宝贝歌单列表详情请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"宝贝歌单列表详情result=====%@",result);
        
        QNewSongDetails *respone = [QNewSongDetails mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        //
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --点播专辑里的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/trackLists/1/2/3
+ (void)PostDemandTrackLists:(NSDictionary *)parameter success:(void(^)(QSongDevicePlayData *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/trackLists/%@/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"trackListId"],[parameter objectForKey:@"trackId"],[parameter objectForKey:@"deviceId"]];
    NSLog(@"urlStr=====%@", urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"宝贝歌单列表详情result=====%@",result);
        
        QSongDevicePlayData *respone = [QSongDevicePlayData mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];

    
}

#pragma mark --点播歌单里的歌曲http://192.168.1.17:8080/bbt-phone/trackLists/deviceTypes/1/panels/1
+ (void)PostDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/deviceSongLists/%@/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"songListId"],[parameter objectForKey:@"trackId"],[parameter objectForKey:@"deviceId"]];
    NSLog(@"点播歌单里的歌曲urlStr=====%@", urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    NSLog(@"点播歌单里的歌曲params====%@", params);
    
    
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

#pragma mark --根据设备类型编号和资源板块编号获取更多专辑
+ (void)GetPanelTrackLists:(NSDictionary *)parameter PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/deviceTypes/%@/panels/%@?orderBy=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceTypeId"],[parameter objectForKey:@"panelId"],[parameter objectForKey:@"orderBy"],pagenum,pagesize];
//     NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/deviceTypes/%@/panels/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"panelId"],[parameter objectForKey:@"deviceTypeId"],pagenum,pagesize];
    NSLog(@"urlStr=====%@", urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"宝贝歌单列表详情result=====%@",result);
        
        QMPanel *respone = [QMPanel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];

    
}


//+ (void)GetPanelTrackLists:(NSDictionary *)parameter success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure
//{
//
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/deviceTypes/%@/panels/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceTypeId"],[parameter objectForKey:@"panelId"]];
//    NSLog(@"urlStr=====%@", urlStr);
//
//    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
//
//    NSLog(@"params====%@", params);
//
//
//    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
//
//
//
//        NSLog(@"宝贝歌单列表详情result=====%@",result);
//
//        QMPanel *respone = [QMPanel mj_objectWithKeyValues:result];
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
//
//            failure(error);
//
//        }
//
//    }];
//
//
//}



+ (void)PostGeneralDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    NSLog(@"urlStr=====%@", urlStr);
    
    NSDictionary *bodyDic = @{@"listId" : [parameter objectForKey:@"listId"], @"trackId":[parameter objectForKey:@"trackId"], @"type":[parameter objectForKey:@"type"] };
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    [BBTHttpTool POSTNewHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"通用点播接口result=====%@",result);
        
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


+ (void)PostSeachGeneralDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    NSLog(@"urlStr=====%@", urlStr);
//    @"keyword"
    NSDictionary *bodyDic = @{@"listId" : [parameter objectForKey:@"listId"], @"trackId":[parameter objectForKey:@"trackId"], @"type":[parameter objectForKey:@"type"],@"keyword": [parameter objectForKey:@"keyword"]};
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    [BBTHttpTool POSTNewHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"seach通用点播接口result=====%@",result);
        
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

#pragma mark --搜索专辑列表  /bbt-phone/trackLists/search/{deviceTypeId}
+ (void)GetSearchAlbumListParameter:(NSDictionary *)parameter success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure
{
    
    
    NSString *str = [[parameter objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/search/%@?pageNum=%@&pageSize=%@&keyword=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceTypeId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"],str1];
    
    
    NSLog(@"搜索列表请求链接===%@",urlStr);
    
    
    NSDictionary *parames = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parames success:^(id result) {
        
        
        
        NSLog(@"11111搜索列表result=====%@",result);
        
        QMPanel *respone = [QMPanel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}

#pragma mark --获取搜索的歌曲数目与专辑数目 bbt-phone/trackLists/getCountBySearch/{deviceTypeId}
+ (void)GetSearchCountListParameter:(NSDictionary *)parameter success:(void(^)(QSearchCount *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *str = [[parameter objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/getCountBySearch/%@?pageNum=%@&pageSize=%@&keyword=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceTypeId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"],str1];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/trackLists/getCountBySearch/%@?keyword=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceTypeId"],str1];
    
    NSLog(@"搜索列表请求链接===%@",urlStr);
    
    
    NSDictionary *parames = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parames success:^(id result) {
        
        
        
        NSLog(@"11111搜索列表result=====%@",result);
        
        QSearchCount *respone = [QSearchCount mj_objectWithKeyValues:result];
        
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
