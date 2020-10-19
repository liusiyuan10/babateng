 //
//  ECGOHttpTool.m
//  integral
//
//  Created by liu on 16/1/25.
//  Copyright © 2016年 ecg. All rights reserved.
//

#import "BBTHttpTool.h"
#import "AFNetworking.h"
#import "TMCache.h"
#import "BBTQAlertView.h"
#import "BBTMainTool.h"

#import "HomeViewController.h"
#import "NewHomeViewController.h"

#import "BBTAFmanager.h"

//#import "MJExtension.h"

@implementation BBTHttpTool

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



+ (void)GETHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    
    // 请求管理者
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // GET方法
    
    [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"GETSG请求成功:%@", responseObject);
        
        // json数据或者NSDictionary转为NSData，responseObject为json数据或者NSDictionary
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
      }
        
    if (success) {
        
        success(result);
    }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];

    
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 请求管理者
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // GET方法
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"GETSG请求成功:%@", responseObject);
    
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//         NSLog(@"GETSG请求成功:%@", result);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
    
        if (success) {
            success(result);
        }
    
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}


+ (void)POSTHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
 
    
    [manager POST:URLString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
        
        //NSLog(@"请求成功JSON:%@", result);
        
        if (success) {
            success(result);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


+ (void)PUTNewHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    
    
    [manager PUT:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"请求成功JSON:%@", result);
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
        
        if (success) {
            success(result);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }

    }];
    
}




+ (void)POSTNewHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    
    
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    
    [manager POST:URLString parameters:bodydic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"请求成功JSON:%@", result);
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
        
        if (success) {
            success(result);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}

//headwenjian
+ (void)POSTTokenHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{

    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodydic options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
 
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"消息 Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                

                
                NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] ;
                
                if ( [str isEqualToString:@"101"])
                {
                    UIViewController *viewVc = [self getCurrentVC];
                    
                    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
                    
                    
                    [QalertView showInView:viewVc.view];
                    
                    //点击按钮回调方法
                    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {
                            
                            [[NewHomeViewController getInstance] disconnectWithmKTopic];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"userId"];
                            [[TMCache sharedCache]removeObjectForKey:@"token"];
                   
                            [[TMCache sharedCache]removeObjectForKey:@"password"];
                            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                            [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                            
                            [BBTMainTool setLoginRootViewController:CZKeyWindow];
                            
                            //  NSLog(@"sb");
                        }
                        
                    };
                    
                    return ;
                }
                
                
                if (success) {
                    success(responseObject);
                }
                
                
                //blah blah
                
            }
            else
            {
                if (success) {
                    success(responseObject);
                }
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    




}


+ (void)POSTUserTokenHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodydic options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
//    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"消息 Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                
                
                NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] ;
                
                if ( [str isEqualToString:@"101"])
                {
                    UIViewController *viewVc = [self getCurrentVC];
                    
                    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
                    
                    
                    [QalertView showInView:viewVc.view];
                    
                    //点击按钮回调方法
                    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {
                            
                            [[NewHomeViewController getInstance] disconnectWithmKTopic];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"userId"];
                            [[TMCache sharedCache]removeObjectForKey:@"token"];
                            //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"password"];
                            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                            [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                            
                            [BBTMainTool setLoginRootViewController:CZKeyWindow];
                            
                            //  NSLog(@"sb");
                        }
                        
                    };
                    
                    return ;
                }
                
                
                if (success) {
                    success(responseObject);
                }
                
                
                //blah blah
                
            }
            else
            {
                if (success) {
                    success(responseObject);
                }
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
    
    
    
    
}


+ (void)PUTHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"parameters===%@",parameters);
    NSLog(@"bodydic===%@",bodydic);
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodydic options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            //NSLog(@"Reply JSON＝＝＝＝＝＝＝＝＝999: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
//                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] ;
                
                if ( [str isEqualToString:@"101"])
                {
                    UIViewController *viewVc = [self getCurrentVC];
                    
                    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
                    
                    
                    [QalertView showInView:viewVc.view];
                    
                    //点击按钮回调方法
                    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {
                            
                            [[NewHomeViewController getInstance] disconnectWithmKTopic];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"userId"];
                            [[TMCache sharedCache]removeObjectForKey:@"token"];
                            //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"password"];
                            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                            [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                            
                            [BBTMainTool setLoginRootViewController:CZKeyWindow];
                            
                            //  NSLog(@"sb");
                        }
                        
                    };
                    
                    return ;
                }

                
                
                if (success) {
                    success(responseObject);
                }
                
                
                //blah blah
                
            }
            
            else
            {
                if (success) {
                    success(responseObject);
                }
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
    
}



+ (void)PUTDeviceNameHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"parameters===%@",parameters);
    NSLog(@"bodydic===%@",bodydic);
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodydic options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"Reply JSON: %@", responseObject);
            
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                       NSLog(@"Reply JSON22222: %@", result);
                if (success) {
                    success(responseObject);
                }
  
//            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
    
}




+ (void)GETNewHead:(NSString *)URLString parameters:(id)parameters bodyDic:(NSDictionary *)bodydic success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    
   
    // 请求管理者
    AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // GET方法
    
    [manager GET:URLString parameters:bodydic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"GETSG请求成功:%@", responseObject);
        
        // json数据或者NSDictionary转为NSData，responseObject为json数据或者NSDictionary
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //         NSLog(@"GETSG请求成功:%@", result);
        

        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }

        
        if (success) {
            success(result);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    

    
}



+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
     AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
    
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
        //NSLog(@"请求成功JSON:%@", result);
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }

        
        if (success) {
            success(result);
        }

    
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        NSLog(@"请求失败:%@", error.description);
        
                if (failure) {
                    failure(error);
                }
        
    }];
    
}

+ (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"请求成功JSON:%@", result);
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }

        
        if (success) {
            success(result);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    

    
    
    
}


//+ (void)POSTYJ263:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
//
//    
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//
//        //    NSDictionary
//        // GET方法
//        [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//         //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            
//            // NSData转为NSString
//            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"jsonStr===%@", jsonStr);
//            
//            
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            
//            NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
//            
//            if ( [str isEqualToString:@"101"])
//            {
//                UIViewController *viewVc = [self getCurrentVC];
//                
//                BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
//                
//                
//                [QalertView showInView:viewVc.view];
//                
//                //点击按钮回调方法
//                QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//                    if (titleBtnTag == 1) {
//                        
//                        [[HomeViewController getInstance] disconnectWithmKTopic];
//                        
//                        [[TMCache sharedCache]removeObjectForKey:@"userId"];
//                        [[TMCache sharedCache]removeObjectForKey:@"token"];
//                        //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
//                        [[TMCache sharedCache]removeObjectForKey:@"password"];
//                        [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
//                        [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
//                        [[TMCache sharedCache]removeObjectForKey:@"createTime"];
//                        [[TMCache sharedCache]removeObjectForKey:@"nickName"];
//                        [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
//                        [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
//                        
//                        [BBTMainTool setLoginRootViewController:CZKeyWindow];
//                        
//                        //  NSLog(@"sb");
//                    }
//                    
//                };
//                
//                return ;
//            }
//
//
//            
//            if (success) {
//                success(responseObject);
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//            NSLog(@"请求失败:%@", error.description);
//
//            if (failure) {
//                failure(error);
//            }
//
//        }];
//    
//
//
//}
//

+ (void)DELETEHead:(NSString *)URLString parameters:(id)parameters bodyArr:(NSArray *)bodyarr success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{

    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyarr options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
//            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"jsonStr===%@", jsonStr);
            
            NSLog(@"Reply JSON: %@", responseObject);
            
            // NSData转为NSString
//            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"jsonStr===%@", jsonStr);
            
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] ;

                if ( [str isEqualToString:@"101"])
                {
                    UIViewController *viewVc = [self getCurrentVC];

                    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];


                    [QalertView showInView:viewVc.view];

                    //点击按钮回调方法
                    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {

                            [[NewHomeViewController getInstance] disconnectWithmKTopic];

                            [[TMCache sharedCache]removeObjectForKey:@"userId"];
                            [[TMCache sharedCache]removeObjectForKey:@"token"];
                            //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"password"];
                            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];

                            [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                            [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                            
                            [BBTMainTool setLoginRootViewController:CZKeyWindow];

                            //  NSLog(@"sb");
                        }

                    };

                    return ;
                }


                if (success) {
                    success(responseObject);
                }



            }
            else
            {
                if (success) {
                    success(responseObject);
                }
            }

        }
        else {

            NSLog(@"Error: %@, %@, %@", error, response, responseObject);

            if (failure) {
                failure(error);
            }

            
        }
        
        
        
        
    }] resume];

}



+ (void)DELETEHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    
    // 请求管理者
    AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    
    [manager DELETE:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                     [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
        
        

        
        
        if (success) {
            success(result);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)POSTEnHead:(NSString *)URLString parameters:(id)parameters bodyArr:(NSArray *)bodyarr success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyarr options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [BBTAFmanager defaultBBTManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:[parameters objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [req setValue:[parameters objectForKey:@"token"] forHTTPHeaderField:@"token"];
    // DELETE方法
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                
                // NSData转为NSString
                //                NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //                NSLog(@"jsonStr===%@", jsonStr);
                
                
                
                NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] ;
                
                if ( [str isEqualToString:@"101"])
                {
                    UIViewController *viewVc = [self getCurrentVC];
                    
                    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
                    
                    
                    [QalertView showInView:viewVc.view];
                    
                    //点击按钮回调方法
                    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {
                            
                            [[NewHomeViewController getInstance] disconnectWithmKTopic];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"userId"];
                            [[TMCache sharedCache]removeObjectForKey:@"token"];
                            //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"password"];
                            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                            
                            [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                            [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                            
                            [BBTMainTool setLoginRootViewController:CZKeyWindow];
                            
                            //  NSLog(@"sb");
                        }
                        
                    };
                    
                    return ;
                }
                
                
                
                
                
                if (success) {
                    success(responseObject);
                }
        
                
            }
            else
            {
                if (success) {
                    success(responseObject);
                }
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
}

+ (void)GETAoguqi:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 请求管理者
    AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
    NSString *encoded = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // GET方法
    
    [manager GET:encoded parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //         NSLog(@"GETSG请求成功:%@", result);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        
        if (success) {
            success(jsonStr);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}


+ (void)POSTPanetHead:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [BBTAFmanager shareBBTManager];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求成功:%@", responseObject);
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"statusCode"]] ;
        
        if ( [str isEqualToString:@"101"])
        {
            UIViewController *viewVc = [self getCurrentVC];
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:viewVc.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
            return ;
        }
        
        //NSLog(@"请求成功JSON:%@", result);
        
        if (success) {
            success(result);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败:%@", error.description);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}




//+ (void)postJsonToServer {
//    
//    NSArray *body = @[@"1",@"2",@"3"];
//    
//    NSError *error;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
//    
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:@"http://192.168.1.17:8080/bbt-phone/deviceSongLists/3" parameters:nil error:nil];
//    
//    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    
//    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    [req setValue:[[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
//    [req setValue:[[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
//    // DELETE方法
//    
//    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        if (!error) {
//            
//            NSLog(@"Reply JSON: %@", responseObject);
//            
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                
//                //blah blah
//                
//            }
//            
//        } else {
//            
//            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//            
//        }
//        
//    }] resume];
//    
//}



@end
