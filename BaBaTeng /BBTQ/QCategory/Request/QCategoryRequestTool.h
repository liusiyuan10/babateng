//
//  QCategoryRequestTool.h
//  BaBaTeng
//
//  Created by liu on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSourceTag,QSongDetails,QMPanel;

@interface QCategoryRequestTool : NSObject

#pragma mark --根据标签编号获取歌曲列表
+ (void)getDeviceSourceTagsName:(NSString *)name Parameter:(NSDictionary *)parameter  success:(void(^)(QSourceTag *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --点播标签列表里的歌曲http://192.168.1.17:8080/bbt-phone/tracks/demand/sourceTags/1/2/3
+ (void)PostDemandSourceTags:(NSDictionary *)parameter success:(void(^)(QSongDetails *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --根据标专辑标签获取专辑/bbt-phone/trackLists/getByTag/{tagId}
+ (void)getAlbumTagsName:(NSString *)name Parameter:(NSDictionary *)parameter PageNum:(NSString *)pagenum PageSize:(NSString *)pagesize  success:(void(^)(QMPanel *response))success failure:(void(^)(NSError *error))failure;

@end

