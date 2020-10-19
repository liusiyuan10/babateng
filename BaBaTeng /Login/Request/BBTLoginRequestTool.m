//
//  BBTLoginRequestTool.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/30.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"

#import "Header.h"
#import "BBTHttpTool.h"
#import "MJExtension.h"
#import "NSString+MD5String.h"
#import "TMCache.h"
@implementation BBTLoginRequestTool

#pragma mark --登陆
+(void)postLoginUserName:(NSString *)userName Password:(NSString *)password newLoginsuccess:(void (^)(BBTUserInfoRespone *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/login",BBT_HTTP_URL,PROJECT_NAME_LOGIN];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@",BBT_HTTP_URL];

//    NSString *name = [NSString stringWithFormat:@"uphone=%@&upwd=%@",userName,[NSString md5String:password] ];
    NSLog(@"请求链接%@",urlStr);
    
    
    NSDictionary *jsonStr = @{@"phoneNumber" : userName , @"userPassword" : password};
    NSLog(@"请求jsonStr%@",jsonStr);
    
    [BBTHttpTool POSTJSON:urlStr parameters:jsonStr success:^(id result) {
        
        
         NSLog(@"登录result=====%@",result);
       
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
    
}

#pragma mark --注册
+ (void)registerUserName:(NSString *)userName Password:(NSString *)password Code:(NSString *)code inviteCode:(NSString *)invitecode uploadPhoneNum:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


     NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/register",BBT_HTTP_URL,PROJECT_NAME_LOGIN];
    
  
    NSDictionary *User = @{@"phoneNumber" : userName,@"userPassword" : password };
    
//    NSDictionary *jsonStr = @{@"user" : User,@"code" : code };
    
    NSDictionary *jsonStr = @{@"phoneNumber" : userName,@"userPassword" : password,@"code" : code ,@"inviteCode" : invitecode,@"type": @"1"};
    NSLog(@"jsonStr%@",jsonStr);
    
    [BBTHttpTool POSTJSON:urlStr parameters:jsonStr success:^(id result) {
     
        NSLog(@"result=====%@",result);
    
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        if (success) {
            
            success(respone);
            
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}



#pragma mark --获取验证码

+ (void)verifyPhoneNumber:(NSString *)phoneNumber upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *jsonStr = @{@"phoneNumber" : phoneNumber ,@"type": @"1"};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/register/code",BBT_HTTP_URL,PROJECT_NAME_LOGIN];
    
    
    [BBTHttpTool POSTJSON:urlStr parameters:jsonStr success:^(id result) {
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        if (success) {

            success(respone);

        }
        
        
    } failure:^(NSError *error) {
        
        
        if (failure) {
            
            failure(error);
            
        }
        
        
        
    }];
    
//    [BBTHttpTool POST:urlStr parameters:jsonStr success:^(id result) {
//        
//        NSLog(@"result=====%@",result);
//        
////        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
////        if (success) {
////            
////            success(respone);
////            
////        }
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
//                NSLog(@"请求失败:%@", error);
//    }];
    

    
}

+ (void)verifyPhoneforgetPassword:(NSString *)phoneNumber upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{
    
    
    NSDictionary *jsonStr = @{@"phoneNumber" : phoneNumber,@"type": @"1" };
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/forgetPassword/code",BBT_HTTP_URL,PROJECT_NAME_LOGIN];
    
    
    [BBTHttpTool POSTJSON:urlStr parameters:jsonStr success:^(id result) {
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        if (success) {
            
            success(respone);
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        if (failure) {
            
            failure(error);
            
        }
        
        
        
    }];
    
}



#pragma mark --获取用户信息

+ (void)getuserinfo:(NSString *)phone uploadPhone:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@user_getuserinfo_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@",phone];
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"获取用户信息=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}


 #pragma mark --更新用户头像

+ (void)updateuserhead:(NSString *)phone uhead:(NSString *)uhead   upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@user_updateuserhead_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@&uhead=%@",phone,uhead ];
    
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"更新用户头像=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}

 #pragma mark --  更新用户邮箱

+ (void)updateemail:(NSString *)uphone  uemail:(NSString *)uemail  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

 
    NSString *urlStr = [NSString stringWithFormat:@"%@user_updateemail_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@&uemail=%@",uphone,uemail ];
    
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"更新用户邮箱=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}


 #pragma mark --  更新用户昵称

+ (void)updatenickname:(NSString *)uphone  unickname :(NSString *)unickname   upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@user_updatenickname_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@&unickname=%@",uphone,unickname ];
    
    
    NSDictionary *params = @{@"params" : name };
    
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"更新用户昵称=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}

#pragma mark --获取Token
+ (void)POSTTokenHeadNowTimeTimestamp:(NSString*)timestamp  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


    
    NSString *urlStr = [NSString stringWithFormat:@"%@bbt-files/files/token",BBT_HTTP_URL];
    
    //NSLog(@"urlStr=====%@", urlStr);//
    
     NSDictionary *bodyDic = @{@"folder" : @"image/icon/", @"fileName": [[NSString alloc]initWithFormat:@"header_%@_%@.png",[[TMCache sharedCache] objectForKey:@"userId"],timestamp] };
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    //NSLog(@"bodyDic====%@", bodyDic);
    
    //NSLog(@"params====%@", params);
    
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
       // NSLog(@"POSTTokenHead=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];



}



#pragma mark -- APP用户修改密码
+ (void)updatepwd:(NSString *)userId  uoldpwd :(NSString *)uoldpwd   unewpwd:(NSString *)unewpwd    upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/%@/password",BBT_HTTP_URL,PROJECT_NAME_APP,userId];
    
    NSLog(@"urlStr=====%@", urlStr);//
    
    NSDictionary *bodyDic = @{@"oldPassword" : uoldpwd, @"password":unewpwd };
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"更新用户密码=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        
        
        if (success) {
            
            success(respone);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@user_updatepwd_proc",BaseURLString];
//    
//    NSString *name = [NSString stringWithFormat:@"uphone=%@&uoldpwd=%@&unewpwd=%@",uphone,[NSString md5String:uoldpwd],[NSString md5String:unewpwd] ];
//    
//    
//    NSDictionary *params = @{@"params" : name };
    
    
//    
//    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
//        
//        
//        NSLog(@"更新用户密码=====%@",result);
//        
//        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
//        
//        if (success) {
//            
//            success(respone);
//        }
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            
//            failure(error);
//            
//        }
//    }];


    
//    [BBTHttpTool PUTHead:urlStr parameters:params success:^(id result) {
//        
//        NSLog(@"更新用户密码=====%@",result);
//
//        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
//        
//
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

}

#pragma mark -- 忘记用户密码
+ (void)forgetpwd:(NSString *)uphone  unewpwd:(NSString *)unewpwd   Code:(NSString *)code   upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/forgetPassword",BBT_HTTP_URL,PROJECT_NAME_LOGIN];
    
    NSDictionary *jsonStr = @{@"phoneNumber" : uphone,@"userPassword" : unewpwd,@"code" : code ,@"type": @"1" };
    NSLog(@"jsonStr%@",jsonStr);
    
    [BBTHttpTool POSTJSON:urlStr parameters:jsonStr success:^(id result) {
        
        NSLog(@"result=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        if (success) {
            
            success(respone);
            
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
    
    //    NSString *urlStr = [NSString stringWithFormat:@"%@user_forgetpwd_proc",BaseURLString];
    //
    //    NSString *name = [NSString stringWithFormat:@"uphone=%@&unewpwd=%@",uphone,[NSString md5String:unewpwd] ];
    //
    //
    //    NSDictionary *params = @{@"params" : name };
    //    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
    //
    //        NSLog(@"忘记用户密码=====%@",result);
    //
    //        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
    //
    //        if (success) {
    //
    //            success(respone);
    //        }
    //    } failure:^(NSError *error) {
    //
    //        if (failure) {
    //
    //            failure(error);
    //            
    //        }
    //    }];
    
    
}

#pragma mark -- 更新用户信息
+ (void)updateuserinfo:(NSString *)uphone  unickname:(NSString *)unickname usex:(NSString *)usex  ubirthday:(NSString *)ubirthday   uemail:(NSString *)uemail  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@user_updateuserinfo_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@&unickname=%@&usex=%@&ubirthday=%@& uemail=%@",uphone,unickname,usex,ubirthday,uemail ];
    
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"更新用户信息=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    


}

#pragma mark -- 反馈意见
+ (void)sumitfeedback:(NSString *)uphone  uquestion:(NSString *)uquestion  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@user_sumitfeedback_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@&uquestion=%@",uphone,uquestion];
    
    
    NSDictionary *params = @{@"params" : name };
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"反馈意见=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}


#pragma mark -- 获取反馈意见
+ (void)getfeedback:(NSString *)uphone  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@user_getfeedback_proc",BaseURLString];
    
    NSString *name = [NSString stringWithFormat:@"uphone=%@",uphone];
    
    
    NSDictionary *params = @{@"params" : name };
    
    [BBTHttpTool POST:urlStr parameters:params success:^(id result) {
        
        NSLog(@"获取反馈意见=====%@",result);
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
            
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}


//接口名称 退出登陆
//请求类型 get
//请求Url  /bbt-phone/users/loginOut
#pragma mark --退出登陆
+(void)GetloginOutParameter:(NSDictionary *)parameter success:(void (^)(BBTUserInfoRespone *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/loginOut",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"退出登陆==================%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
        
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
