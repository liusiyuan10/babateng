//
//  BBTMineRequestTool.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/25.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTMineRequestTool.h"
#import "BBTHttpTool.h"
#import "Header.h"
#import "BBTUserInfoRespone.h"
#import "BBTUserInfo.h"
#import "TMCache.h"
#import "QMessage.h"
#import "Family.h"
//@class BBTUserInfoRespone,BBTUserInfo;
@implementation BBTMineRequestTool
#pragma mark -- APP用户修改个人资料
+ (void)PUTResetPersonalData:(BBTUserInfo *)bbtUserInfo  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/%@",BBT_HTTP_URL,PROJECT_NAME_APP, [[TMCache sharedCache] objectForKey:@"userId"]];
    
     //NSLog(@"urlStr=====%@", urlStr);//
    
    
    if (IsStrEmpty(bbtUserInfo.nickName)) {
        bbtUserInfo.nickName = @" ";
    
    }
    if (IsStrEmpty(bbtUserInfo.userIcon)) {
        bbtUserInfo.userIcon = @" ";
        
    }
    if (IsStrEmpty(bbtUserInfo.userAddress)) {
        bbtUserInfo.userAddress = @" ";
        
    }
    
    
    
    NSDictionary *bodyDic = @{@"nickName" : bbtUserInfo.nickName, @"userIcon":bbtUserInfo.userIcon, @"userAddress":bbtUserInfo.userAddress  };
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
   // NSLog(@"params====%@", params);
    
   // NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        //NSLog(@"=====%@",result);
        
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


#pragma mark -- APP用户修改所在地
+ (void)PUTResetPersonalAddressData:(NSString *)address  upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/%@",BBT_HTTP_URL,PROJECT_NAME_APP, [[TMCache sharedCache] objectForKey:@"userId"]];
    
    
    NSDictionary *bodyDic = @{@"userAddress":address};
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    NSLog(@"bodyDic====%@", bodyDic);
    
    
    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:bodyDic success:^(id result) {
        
        NSLog(@"APP用户修改所在地=====%@",result);
        
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


#pragma mark -- APP用户查询个人资料http://domain/bbt-phone/users/

+ (void)GETPersonalData:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/%@",BBT_HTTP_URL,PROJECT_NAME_APP, [[TMCache sharedCache] objectForKey:@"userId"]];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
        NSLog(@"urlStr11111=====%@", urlStr);
        NSLog(@"params111111====%@", params);

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

#pragma mark -- 分页获取系统消息列表
+ (void)GETsystemNoticesbodyDic:(NSDictionary *)bodydic upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/systemNotices",BBT_HTTP_URL,PROJECT_NAME_APP];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"urlStr=====%@", bodydic);
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool GETNewHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
          NSLog(@"系统消息列表=====%@", result);
        
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }

        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
//    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
//        
//        
//        BBTUserInfoRespone *respone = [BBTUserInfoRespone mj_objectWithKeyValues:result];
//        
//        
//        if (success) {
//            
//            success(respone);
//        }
//        
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


#pragma mark -- 查询设备通知列表
+ (void)GETDeviceNoticespageNum:(NSString *)pageNum pageSize:(NSString *)pageSize upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/deviceNotices?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,pageSize];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params  success:^(id result) {
        
        NSLog(@"查询设备通知列表====%@", result);
        
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
    
}


#pragma mark -- 查询查询家人邀请列表
+ (void)GETFamilyNoticesspageNum:(NSString *)pageNum pageSize:(NSString *)pageSize upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/invitations?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,pageSize];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    NSLog(@"params====%@", params);
    
    
    [BBTHttpTool GETHead:urlStr parameters:params  success:^(id result) {
        
        NSLog(@"查询查询家人邀请列表====%@", result);
        
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}

#pragma mark -- 查询系统消息详情
+ (void)GETsystemNoticeId:(NSString *)bbtId  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/systemNotices/%@",BBT_HTTP_URL,PROJECT_NAME_APP, bbtId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
//    NSLog(@"urlStr=====%@", urlStr);
//    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
          NSLog(@"查询系统消息详情=====%@", result);
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
}


#pragma mark --查询家人邀请消息详情
+ (void)GETFamilyMessageDetailID:(NSString *)bbtId  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/invitations/%@",BBT_HTTP_URL,PROJECT_NAME_APP, bbtId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
//    NSLog(@"urlStr=====%@", urlStr);
//    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"查询家人邀请消息详情=====%@", result);
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
}

#pragma mark --处理家人邀请-接受或者拒绝

+ (void)PUTFamilyInvitations:(NSString *)invitations Status:(NSString *)status  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@/invitations/%@/status/%@",BBT_HTTP_URL,PROJECT_NAME_APP,invitations,status];
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
  
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        
        
        NSLog(@"处理家人邀请-接受或者拒绝=====%@", result);
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        

        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
//    [BBTHttpTool PUTHead:urlStr parameters:params bodyDic:nil success:^(id result) {
//        
//        NSLog(@"处理家人邀请-接受或者拒绝=====%@", result);
//        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
//        
//        
//        if (success) {
//            
//            success(respone);
//        }
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

#pragma mark --家庭圈之添加用户界面 查询手机号是否注册
+ (void)GETFamilyPhoneNumber:(NSString *)phoneNumber  upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{

    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/users/phone/%@",BBT_HTTP_URL,PROJECT_NAME_APP, phoneNumber];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    
    //    NSLog(@"urlStr=====%@", urlStr);
    //    NSLog(@"params====%@", params);
    
    [BBTHttpTool GETHead:encodedString parameters:params success:^(id result) {
        
        NSLog(@"添加用户界面查询手机号是否注册=====%@", result);
        
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];


}


#pragma mark -- 查询家庭圈及所有成员
+(void)GETFamilys:(NSString *)deviceId  upload:(void(^)(Family *respone))success failure:(void(^)(NSError *error))failure{


    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/devices/%@",BBT_HTTP_URL,PROJECT_NAME_APP, deviceId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };

    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"查询家庭圈及所有成员=====%@", result);
        
        Family *respone = [Family mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];

}


#pragma mark -- 提交意见反馈接口
+(void)POSTFeedback:(NSString *)deviceId Feedback:(NSString*)content upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure
  {


    NSString *urlStr = [NSString stringWithFormat:@"%@%@/advices/deviceTypes/%@",BBT_HTTP_URL,PROJECT_NAME_APP, deviceId];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    NSDictionary *bodydic = @{@"adviceContent" :content };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool POSTNewHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"提交意见反馈接口=====%@", result);
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    


}

#pragma mark -- 发起家人邀请

+(void)POSTReceiverId:(NSString *)receiverId FamilyId:(NSString *)familyId  Message:(NSString*)message upload:(void(^)(QMessage *respone))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/%@/familyMembers/%@",BBT_HTTP_URL,PROJECT_NAME_APP,familyId, receiverId];
     NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token":[[TMCache sharedCache] objectForKey:@"token"] };
    NSDictionary *bodydic = @{@"message" :message };
    
    NSLog(@"urlStr=====%@", urlStr);
    NSLog(@"params====%@", params);
    
    [BBTHttpTool POSTNewHead:encodedString parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"发起家人邀请=====%@", result);
        QMessage *respone = [QMessage mj_objectWithKeyValues:result];
        
        
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
