//
//  BBlockRequestTool.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BStoreModel,BBlockCommon;

@interface BBlockRequestTool : NSObject


//接口名称 查询程序列表
//请求类型 get
//请求Url  /bbt-phone/programming/listShares
/*****************查询程序列表****************************/
#pragma mark --/bbt-phone/programming/listShares
+ (void)GetProgrammingParameter:(NSDictionary *)parameter success:(void(^)(BStoreModel *response))success failure:(void(^)(NSError *error))failure;

//接口名称 下载程序
//请求类型 put
//请求Url  /bbt-phone/programming/download/{shareId}

#pragma mark --下载程序 /bbt-phone/programming/download/{shareId}
+(void)PutProgrammingDownloadParameter:(NSDictionary *)parameter success:(void (^)(BBlockCommon *respone))success failure:(void (^)(NSError *error))failure;

@end
