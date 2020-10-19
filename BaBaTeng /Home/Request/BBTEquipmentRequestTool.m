//
//  BBTEquipmentRequestTool.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTEquipmentRequestTool.h"
#import "BBTHttpTool.h"
#import "Header.h"
#import "BBTEquipmentRespone.h"
#import "BBTDevice.h"
#import "BBTBind.h"
#import "Bulletin.h"
#import "QDevice.h"
#import "TMCache.h"
#import "NewBulletin.h"
#import "TmallModel.h"
#import "XiaoXianModel.h"

@implementation BBTEquipmentRequestTool


#pragma mark --获取设备分类
/***
 *  1.utype 某设备型号，为0时获取所有设备型号
 */

+(void)getDevicetypeListParameter:(NSDictionary *)parameter success:(void (^)(BBTDevice *respone))success failure:(void (^)(NSError *error))failure
{
    

    
     NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes?pageNum=%@&pageSize=%@&type=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"],[parameter objectForKey:@"type"]];
    
    
    
    NSLog(@"请求链接%@",urlStr);
    
     NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
    
        
        NSLog(@"result=====%@",result);

        BBTDevice *respone = [BBTDevice mj_objectWithKeyValues:result];

        if (success) {

            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {

            failure(error);

        }
        
    }];

    
    
}

#pragma mark --扫码绑定
+(void)getScanbindcode:(NSString *)urlORCode  Parameter:(NSDictionary *)parameter  success:(void (^)(BBTDevice *respone))success failure:(void (^)(NSError *error))failure;{
    
   
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlORCode parameters:params success:^(id result) {
        
        
        NSLog(@"扫码绑定result=====%@",result);
        
        BBTDevice *respone = [BBTDevice mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}


//
//+(void)getDevicetype:(NSString *)utype success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@user_getdevicetype_proc",BaseURLString];
//    
//    NSString *name = [NSString stringWithFormat:@"utype=%@",utype];
//    
//    NSDictionary *params = @{@"params" : name };
//    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
//        
//        
//        NSLog(@"result=====%@",result);
//        
//        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
//        
//        if (success) {
//            
//            success(respone);
//        }
//        
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            
//            failure(error);
//            
//        }
//    }];
//
//    
//}


#pragma mark --设备获取绑定验证码
/***
 *   uimei:设备imei地址  uapsn:设备在业务服务注册的ID utype:设备型号
 */
+(void)getDevgetbindcode:(NSString *)uimei uapsn:(NSString *)uapsn utype:(NSString *)utype success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@user_devgetbindcode_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uimei=%@&uapsn=%@&utype=%@",uimei,uapsn,utype];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
}

#pragma mark --APP获取要绑定设备信息

/***
 *   ucode:设备获取到的验证马
 */

+(void)getAppgetbinddevice:(NSString *)ucode success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@user_appgetbinddevice_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"ucode=%@",ucode];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}


#pragma mark -- 提交绑定设备
/***
 *  uphone: 手机号  uimei:设备imei地址  uapsn:设备在业务服务注册的ID utype:设备型号
 */
+(void)getSumitbinddevice:(NSString *)code DeviceTypeId:(NSString*)deviceTypeId success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/onbind/deviceTypes/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceTypeId,code];
    
     NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlStr%@",urlStr);
    [BBTHttpTool POSTHead:encodedString parameters:nil success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}

#pragma mark -- 删除绑定设备
/***
 *  uphone: 手机号  uimei:设备imei地址  uapsn:设备在业务服务注册的ID utype:设备型号 uid deviceId
 */
+(void)getDeletebinddevice:(NSString *)uid  deviceId:(NSString *)deviceId success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices/offbind/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,uid,deviceId];
    

    NSLog(@"urlStr%@",urlStr);
    [BBTHttpTool POSTHead:urlStr parameters:nil success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
//    NSDictionary *params = @{@"params" : name };
//    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
//        
//        
//        NSLog(@"result=====%@",result);
//        
//        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
//        
//        if (success) {
//            
//            success(respone);
//        }
//        
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            
//            failure(error);
//            
//        }
//    }];

}

#pragma mark --获取绑定设备列表
/***
 *  uphone: 手机号
 */
+(void)getBinddevice:(NSDictionary *)parameter  success:(void (^)(BBTBind *respone))success failure:(void (^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/devices?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"pageNum"],[parameter objectForKey:@"pageSize"]];
    
    NSLog(@"请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" : [parameter objectForKey:@"userId"], @"token":[parameter objectForKey:@"token"] };
    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        

        
        NSLog(@"result=====%@",result);
        
        BBTBind *respone = [BBTBind mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
                if (failure) {
        
                    failure(error);
        
                }
        
    }];


}

#pragma mark --获取专辑列表

/***
 *  ualbumId:  某专辑id，为0时获取所有专辑
 */

+(void)getAlbumlist:(NSString *)ualbumId  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@user_getalbumlist_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"ualbumId=%@",ualbumId];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark --获取专辑内容
/***
 *  1.ualbumId 某专辑id 2.upagenum 第几页 3. upagecount 每页多少条
 */
+(void)getTracklist:(NSString *)ualbumId upagenum:(NSString *)upagenum   upagecount:(NSString *)upagecount  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@user_gettracklist_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"ualbumId=%@&upagenum=%@&upagecount=%@",ualbumId,upagenum,upagecount];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}

#pragma mark --获取APP列表
/***
 *  1. app类别，为0时不分类型获取 2.upagenum 第几页 3. upagecount 每页多少条
 */
+(void)getApplist:(NSString *)uitemtype   upagenum:(NSString *)upagenum   upagecount:(NSString *)upagecount  success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@user_getapplist_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"ualbumId=%@&upagenum=%@&upagecount=%@",uitemtype,upagenum,upagecount];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark - 增加app下载次数
/***
 *  1.uid app的id
 */
+(void)updateApploadtimes:(NSString *)uid success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@user_updateapploadtimes_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uid=%@",uid];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark - 获取app分类

/***
 *  1.utype 为0时获取所有
 */

+(void)getApptype:(NSString *)utype success:(void (^)(BBTEquipmentRespone *respone))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@ user_getapptype_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"utype=%@",utype];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"result=====%@",result);
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark - 获取广告列表http://192.168.1.17:8080/bbt-phone/bulletins/deviceTypes/12
+ (void)GetBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(Bulletin *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/bulletins/deviceTypes/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceTypeId];
    
        NSLog(@"bulletins请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        //        NSLog(@"resultbuuuuu=====%@",result);
        
        Bulletin *respone = [Bulletin mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}


#pragma mark - 获取新需求广告列表http://192.168.1.17:8080/bbt-phone/bulletins/deviceTypes/12
+ (void)GetNewBulletinDeviceTypeId:(NSString *)deviceTypeId Parameter:(NSDictionary *)parameter success:(void(^)(NewBulletin *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/bulletins/deviceTypes/%@/recommend/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceTypeId,[parameter objectForKey:@"type"]];
    
    NSLog(@"bulletins请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[parameter objectForKey:@"userId"] , @"token": [parameter objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        
        //        NSLog(@"resultbuuuuu=====%@",result);
        
        NewBulletin *respone = [NewBulletin mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}



#pragma mark - 获取设备类型列表http://domain/bbt-phone/deviceTypes
+ (void)GETEquipmentData:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceTypes",BBT_HTTP_URL,PROJECT_NAME_APP];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}

#pragma mark - 获取设备的绑定说明http://domain/bbt-phone/deviceBindGuidances/deviceTypes/{deviceTypeId}
+ (void)GETdeviceBindGuidances:(NSString *)deviceTypeId  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceBindGuidances/deviceTypes/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceTypeId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
}

#pragma mark - 获取使用帮助列表 http://domain/bbt-phone/helps/deviceTypes/{deviceTypeId}

+ (void)GETdevicehelps:(NSString *)deviceTypeId  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceBindGuidances/deviceTypes/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceTypeId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark -- 检测app版本
+ (void)checkAppVersionupload:(void(^)(QDevice *respone))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/firmwareApp/checkVersion",BBT_HTTP_URL,PROJECT_NAME_APP];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    // NSDictionary *bodyDic = @{@"deviceId" :deviceId,@"version" :version};
    NSLog(@"888===%@",urlStr);
    NSLog(@"params===%@",params);
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"检测AppVersion版本=====%@", result);
        
        QDevice *respone = [QDevice mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}


#pragma mark - 检查环信是否注册 http://localhost/api/app/huanxin/user/6901060000000135

+ (void)GETHuanxinPhoneNum:(NSString *)phonenumstr  success:(void(^)(BBTEquipmentRespone *registerRespone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/huanxin/user/%@",BBT_HTTP_URL,PROJECT_NAME_APP,phonenumstr];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        BBTEquipmentRespone *respone = [BBTEquipmentRespone mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark - 奥古奇热点配网
+ (void)GetAoguqiHotNetworkParameter:(NSDictionary *)parameter  success:(void(^)(NSString *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/ssid=%@&pwd=%@",@"192.168.51.1",[parameter objectForKey:@"wifiName"],[parameter objectForKey:@"wifiPassword"]];
    
    NSLog(@"888===%@",urlStr);
    
    [BBTHttpTool GETAoguqi:urlStr parameters:nil success:^(id result) {
        
        NSLog(@"resultresultresultresultssssssssss%@",result);
        
        
        if (success) {
            
            success(result);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    

}

//接口名称 获取token
//请求类型 post
//请求Url  /bbt-phone/tmall/{deviceId}
+ (void)GetTmallDeviceId:(NSString *)deviceId success:(void(^)(TmallModel *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/tmall/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId];
    
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"检测tmall版本=====%@", result);
        
        TmallModel *respone = [TmallModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

#pragma mark - 获取小先登录token

+ (void)GETXiaoXianDeviceId:(NSString *)deviceId  success:(void(^)(XiaoXianModel *registerRespone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/huanxin/token/%@",BBT_HTTP_URL,PROJECT_NAME_APP,deviceId];
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        
        XiaoXianModel *respone = [XiaoXianModel mj_objectWithKeyValues:result];
        
        
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
