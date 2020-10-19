//
//  Q2MineRequestTool.h
//  XZ_WeChat
//
//  Created by liu on 17/3/17.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QFavoriteRespone,QSongRespone,QAlbumResponse,QResourceResponese,QDeviceInfoRespone,QPanel,QAlbum,QSourceType,QHistory,QSong,QSongDetails,QMPanel,QSongDevicePlayData,QModule,DeviceControl,QAlbumDetial,QNewSongDetails,QSearchCount;

@interface QMineRequestTool : NSObject




#pragma mark --搜索列表
+ (void)GetSearchListParameter:(NSDictionary *)parameter success:(void(^)(QHistory *respone))success failure:(void(^)(NSError *error))failure;



#pragma mark --获取设备类型拥有的设备控制功能:音量调整、灯光控制、定时关机等
+ (void)getDeviceControllersName:(NSString *)name success:(void(^)(DeviceControl *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --获取设备的资源分类
+ (void)getDeviceSourceTypesName:(NSString *)name success:(void(^)(QSourceType *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --获取设备类型拥有的模块:点播历史、宝贝说说等
+ (void)getDeviceModulesName:(NSString *)name success:(void(^)(QModule *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --获取设备类型拥有的板块:精品推荐、听故事、学英语等
+ (void)getDevicePanelsName:(NSString *)name success:(void(^)(QPanel *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --根据专辑编号获取歌曲列表
+(void)gettrackListsId:(NSString *)trackListId Parameter:(NSDictionary *)parameter  success:(void (^)(QAlbumDetial *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --根据专辑编号分页获取歌曲列表
+(void)getpagetrackListsId:(NSString *)trackListId PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize Parameter:(NSDictionary *)parameter  success:(void (^)(QAlbum *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --根据设备码获取点播历史列表
+ (void)GetPlayHistoriesDevice:(NSString *)deviceId pageNum:(NSString *)pageNum success:(void(^)(QHistory *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --根据设备码获取宝贝歌单列表
+ (void)GetDeviceSongLists:(NSString *)deviceId pageNum:(NSString *)pageNum  success:(void(^)(QSong *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --获取宝贝歌单详情 GET /deviceSongLists/{songListId
+ (void)GetDeviceSongListsDetails:(NSString *)songListId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize success:(void(^)(QNewSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --点播专辑的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/trackLists/1/2/3
+ (void)PostDemandTrackLists:(NSDictionary *)parameter success:(void(^)(QSongDevicePlayData *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --点播专歌单的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceSongLists/1/2/3
+ (void)PostDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --根据设备类型编号和资源板块编号获取更多专辑
//+ (void)GetPanelTrackLists:(NSDictionary *)parameter success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure;
+ (void)GetPanelTrackLists:(NSDictionary *)parameter PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --通用的点播接口http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceSongLists/1/2/3
+ (void)PostGeneralDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --通用的点播接口搜索接口不太一样有关键字单独写一个函数http://192.168.1.17:8080/bbt-phone/tracks/demand/deviceSongLists/1/2/3
+ (void)PostSeachGeneralDemandTracks:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --搜索专辑列表
+ (void)GetSearchAlbumListParameter:(NSDictionary *)parameter success:(void(^)(QMPanel *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --获取搜索的歌曲数目与专辑数目
+ (void)GetSearchCountListParameter:(NSDictionary *)parameter success:(void(^)(QSearchCount *respone))success failure:(void(^)(NSError *error))failure;

@end
