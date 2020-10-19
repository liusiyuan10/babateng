//
//  QClockRequestTool.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QClockBell,QClockCommon,QClock;

@interface QClockRequestTool : NSObject

/*****************查询所有闹钟铃声****************************/
#pragma mark --查询所有闹钟铃声 /bbt-phone/clock/getSounds
+ (void)getclockSoundsParameter:(NSDictionary *)parameter success:(void(^)(QClockBell *response))success failure:(void(^)(NSError *error))failure;


/*****************添加闹钟****************************/
#pragma mark --添加闹钟/bbt-phone/clock/addClock
+ (void)AddclockaddClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure;


/*****************编辑闹钟****************************/
#pragma mark --编辑闹钟 /bbt-phone/updateClock/{clockId}
+ (void)EditclockupdateClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure;

/*****************查询闹钟****************************/
#pragma mark --查询闹钟 /bbt-phone/clock/getClocks/{deviceId}
+ (void)getclockGetClocksParameter:(NSDictionary *)parameter success:(void(^)(QClock *response))success failure:(void(^)(NSError *error))failure;



/*****************删除闹钟****************************/
#pragma mark --删除闹钟
+ (void)DeleteclockdeleteClockParameter:(NSDictionary *)parameter success:(void(^)(QClockCommon *response))success failure:(void(^)(NSError *error))failure;

@end
