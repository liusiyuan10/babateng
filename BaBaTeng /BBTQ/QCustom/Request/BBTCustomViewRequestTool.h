//
//  BBTCustomViewRequestTool.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCustom,QAddSong;
@interface BBTCustomViewRequestTool : NSObject
#pragma mark --获取当前播放歌曲
+(void)getCurrentPlayingParameter:(NSDictionary *)parameter  success:(void (^)(QCustom *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --获取当前播放歌曲列表
+(void)getCurrentPlayingTracksParameter:(NSDictionary *)parameter  success:(void (^)(QCustom *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 设备控制命令
//请求类型 put
//请求Url  /bbt-phone/devices/:deviceId/control
+(void)PutDevicesControlMQTTParameter:(NSDictionary *)parameter BodyDic:(NSDictionary *)bodydic  success:(void (^)(QAddSong *respone))success failure:(void (^)(NSError *error))failure;
@end
