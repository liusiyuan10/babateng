//
//  QHomeRequestTool.m
//  BaBaTeng
//
//  Created by liu on 17/7/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QHomeRequestTool.h"
#import "TMCache.h"
#import "Header.h"
#import "BBTHttpTool.h"

#import "QAddSong.h"

#import "QFavorite.h"

#import "QSongDetails.h"

#import "QPlayingTrack.h"

#import "QPlayingTrackList.h"

#import "TMCache.h"


@implementation QHomeRequestTool

+ (void)GetFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QFavorite *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceFavorites/devices/%@?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
    
    
    
        NSLog(@"result宝宝最爱=====%@",result);
    
        QFavorite *respone = [QFavorite mj_objectWithKeyValues:result];
    
        if (success) {
    
            success(respone);
        }
    
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];

    
}

#pragma mark --收藏单首歌曲http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/tracks/2
+ (void)AddSingleFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceFavorites/devices/%@/tracks/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"], [parameter objectForKey:@"trackId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        
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


#pragma mark --删除选中收藏http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1
+ (void)DeleteFavoriteParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceFavorites/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params bodyArr:bodyarr success:^(id result) {
        
//        NSLog(@"result=====%@",result);
        
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

#pragma mark --收藏整个专辑歌曲http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/trackLists/2
+ (void)AddAllFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceFavorites/devices/%@/trackLists/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"], [parameter objectForKey:@"trackListId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        

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

//取消收藏
#pragma mark --取消选中收藏http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/tracks/2
+ (void)CancelFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceFavorites/devices/%@/tracks/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"],[parameter objectForKey:@"trackId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params success:^(id result) {
        
//        NSLog(@"result=====%@",result);
        
        
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


#pragma mark --添加歌曲到宝贝歌单http://192.168.1.17:8080/bbt-phone/deviceSongLists/1/tracks/2
+ (void)AddSingledeviceSongListParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceSongLists/%@/tracks/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"songListId"], [parameter objectForKey:@"trackId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
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

#pragma mark --添加整个专辑歌曲到宝贝歌单http://192.168.1.17:8080/bbt-phone/deviceSongLists/1/trackLists/2
+ (void)AddAlldeviceSongListParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceSongLists/%@/trackLists/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"songListId"], [parameter objectForKey:@"trackListId"]];
    
    //    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool POSTHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result=====%@",result);
        
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

#pragma mark --删除选中收藏http://192.168.1.17:8080/bbt-phone/deviceSongLists/1
+ (void)DeletedeviceSongListParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
//    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceSongLists/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"songListId"]];
    
        NSLog(@"请求链接%@",urlStr);
    
    NSLog(@"bod%@",bodyarr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params bodyArr:bodyarr success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        QAddSong *respone = [QAddSong mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
        
    }];
//
//    
//    
//    
//    
//    [BBTHttpTool DELETEHead:urlStr parameters:params bodyArr:bodyarr success:^(id result) {
//        
//        NSLog(@"result=====%@",result);
// 
//        QAddSong *respone = [QAddSong mj_objectWithKeyValues:result];
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
//    }];
//    
//    [BBTHttpTool postJsonToServer];
    
}

#pragma mark --删除点播历史
+ (void)DeletePlayHistoryParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playHistories/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
    NSLog(@"请求链接%@",urlStr);
    
    NSLog(@"bod%@",bodyarr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool DELETEHead:urlStr parameters:params bodyArr:bodyarr success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
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


/*****************点播****************************/
#pragma mark --点播点播历史的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/playHistories/1/2
+ (void)PostDemandPlayHistory:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/playHistories/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"trackId"],[parameter objectForKey:@"deviceId"]];
  
    NSLog(@"urlStr====%@",urlStr);
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    
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

#pragma mark --当前播放列表切换歌曲http://192.168.1.17:8080/bbt-phone/playingTracks/current/devices/:deviceId
+ (void)PutCurrentDemandPlaySwitchParameter:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playingTracks/current/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];

    
    NSDictionary *bodyDic = @{@"listId" : [parameter objectForKey:@"listId"], @"trackId": [parameter objectForKey:@"trackId"], @"type": [parameter objectForKey:@"type"] };
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"当前播放列表切换歌曲=====%@",result);
        
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

#pragma mark --点播宝贝最爱的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceFavorites/1/2
+ (void)PostDemanddeviceFavorite:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tracks/demand/deviceFavorites/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"trackId"],[parameter objectForKey:@"deviceId"]];
    
//    bbt-phone/tracks/demand/playHistories/
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    
    
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

/*****************获取当前播放歌曲****************************/
#pragma mark --获取当前播放歌曲http://192.168.1.17:8080/bbt-phone/playingTracks/current/devices/:deviceId
+ (void)GetplayingTrackId:(NSDictionary *)parameter success:(void(^)(QPlayingTrack *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/playingTracks/current/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"deviceId"]];
    
       NSLog(@"1111222获取当前播放歌曲请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        NSLog(@"result正在播放88888=====%@",result);
        
        QPlayingTrack *respone = [QPlayingTrack mj_objectWithKeyValues:result];
        if (respone.data.tracks.count>0) {
            
             QPlayingTrackList*qPlayingTrackList = respone.data.tracks[0];
            
            NSLog(@"qPlayingTrackList.trackIcon===%@",qPlayingTrackList.trackIcon);
            
            [[TMCache sharedCache]setObject:qPlayingTrackList.trackIcon forKey:@"currentTrackIcon"];
        }
       
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


