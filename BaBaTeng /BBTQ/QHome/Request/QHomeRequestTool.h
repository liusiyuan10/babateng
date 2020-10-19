//
//  QHomeRequestTool.h
//  BaBaTeng
//
//  Created by liu on 17/7/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QAddSong,QFavorite,QSongDetails,QPlayingTrack,NEWAlbum;




@interface QHomeRequestTool : NSObject

/*****************宝贝最爱****************************/
#pragma mark --根据设备码获取宝贝最爱歌曲列表
+ (void)GetFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QFavorite *response))success failure:(void(^)(NSError *error))failure;


#pragma mark --删除选中收藏http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1
+ (void)DeleteFavoriteParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --收藏单首歌曲http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/tracks/2
+ (void)AddSingleFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --收藏整个专辑歌曲http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/trackLists/2
+ (void)AddAllFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --取消收藏http://192.168.1.17:8080/bbt-phone/deviceFavorites/devices/1/tracks/2
+ (void)CancelFavoriteParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

/*****************宝贝歌单****************************/
#pragma mark --添加歌曲到宝贝歌单http://192.168.1.17:8080/bbt-phone/deviceSongLists/1/tracks/2
+ (void)AddSingledeviceSongListParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --添加整个专辑歌曲到宝贝歌单http://192.168.1.17:8080/bbt-phone/deviceSongLists/1/trackLists/2
+ (void)AddAlldeviceSongListParameter:(NSDictionary *)parameter success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --删除选中宝贝歌单http://192.168.1.17:8080/bbt-phone/deviceSongLists/1
+ (void)DeletedeviceSongListParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

/*****************点播历史****************************/
#pragma mark --删除点播历史
+ (void)DeletePlayHistoryParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(QAddSong *response))success failure:(void(^)(NSError *error))failure;

/*****************点播****************************/
#pragma mark --点播点播历史的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceSongLists/1/2/3
+ (void)PostDemandPlayHistory:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --点播宝贝最爱的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceFavorites/1/2
+ (void)PostDemanddeviceFavorite:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

/*****************获取当前播放歌曲****************************/
#pragma mark --获取当前播放歌曲http://192.168.1.17:8080/bbt-phone/playingTracks/current/devices/:deviceId
+ (void)GetplayingTrackId:(NSDictionary *)parameter success:(void(^)(QPlayingTrack *respone))success failure:(void(^)(NSError *error))failure;


#pragma mark --当前播放列表切换歌曲http://192.168.1.17:8080/bbt-phone/playingTracks/current/devices/:deviceId
+ (void)PutCurrentDemandPlaySwitchParameter:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;



@end
