//
//  EnglishRequestTool.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/24.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EnglishRequestTool.h"

#import "Student.h"
#import "AllEgTeacher.h"
#import "TeacherInfo.h"
#import "TeaReservation.h"
#import "Header.h"

#import "BBTHttpTool.h"
#import "TMCache.h"
#import "MyEgTeacher.h"
#import "EnglishCommon.h"
#import "StudentCourse.h"
#import "TotalCourse.h"

#import "SaveCourseOrder.h"
#import "PayCourseOrder.h"
#import "CoursePackage.h"
#import "QueryPayCourseOrder.h"
#import "EnglishTimeModel.h"
#import "studentVideo.h"
#import "ClassroomPerformance.h"
#import "ClassroomPlayback.h"

@implementation EnglishRequestTool

#pragma mark --学生剩余课程数和有效期
+(void)getStudentParameter:(NSDictionary *)parameter success:(void (^)(Student *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/students",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"学生剩余课程数和有效期请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result学生剩余课程数和有效期=====%@",result);
        
        Student *respone = [Student mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

#pragma mark --查询所有外教老师信息 /bbt-phone/teachers/allEgTeachers
+(void)getAllEgTeacherParameter:(NSDictionary *)parameter success:(void (^)(AllEgTeacher *respone))success failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teachers/allEgTeachers",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询所有外教老师信息请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询所有外教老师信息=====%@",result);
        
        AllEgTeacher *respone = [AllEgTeacher mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

#pragma mark --获取老师信息 /bbt-phone/teachers/teacherInfo
+(void)getTeacherInfoParameter:(NSDictionary *)parameter success:(void (^)(TeacherInfo *respone))success failure:(void (^)(NSError *error))failure
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teachers/teacherInfo/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"teacherId"]];
    
    NSLog(@"获取老师信息请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result获取老师信息=====%@",result);
        
        TeacherInfo *respone = [TeacherInfo mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

#pragma mark --查询待预约的课程 /bbt-phone/teachers/reservations/{teacherId}
+(void)getTeacherReservationsParameter:(NSDictionary *)parameter success:(void (^)(TeaReservation *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teachers/reservations/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"teacherId"]];
    
    NSLog(@"查询待预约的课程请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询待预约的课程=====%@",result);
        
        TeaReservation *respone = [TeaReservation mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

#pragma mark --查询我预约的老师信息 /bbt-phone/teachers/myselfTeachers
+(void)getTeacherMyselfTeachersParameter:(NSDictionary *)parameter success:(void (^)(MyEgTeacher *respone))success failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teachers/myselfTeachers",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询我预约的老师信息请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询我预约的老师信息=====%@",result);
        
        MyEgTeacher *respone = [MyEgTeacher mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}



#pragma mark --立即预约 /bbt-phone/students
+ (void)PostStudentsParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(EnglishCommon *response))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/students",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"立即预约请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    
    [BBTHttpTool POSTEnHead:urlStr parameters:params bodyArr:bodyarr success:^(id result) {
        
        NSLog(@"result立即预约息=====%@",result);
        
        EnglishCommon *respone = [EnglishCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}
#pragma mark --查询学生课程列表 /bbt-phone/studentCourse
+ (void)GetStudentCourse:(NSString *)status pageNum:(NSString *)pageNum success:(void(^)(StudentCourse *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studentCourse?&status=%@&pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,status,pageNum,@"20"];
    
    
     NSLog(@"查询学生课程列表请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"查询学生课程列表ssss=====%@",result);
        
        StudentCourse *respone = [StudentCourse mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --统计学生课程数量 /bbt-phone/studentCourse/total
+(void)getToalStudentCourseParameter:(NSDictionary *)parameter success:(void (^)(TotalCourse *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studentCourse/total",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"统计学生课程数量请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result统计学生课程数量=====%@",result);
        
        TotalCourse *respone = [TotalCourse mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}
#pragma mark --取消课程 /bbt-phone/studentCourse/cancel/{stCourseId}
+(void)PutCancelStudentCourseParameter:(NSDictionary *)parameter success:(void (^)(EnglishCommon *respone))success failure:(void (^)(NSError *error))failure;
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studentCourse/cancel/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"stCourseId"]];
    
    NSLog(@"取消课程请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    
    [BBTHttpTool PUTNewHead:urlStr parameters:params success:^(id result) {
        NSLog(@"result取消课程=====%@",result);
        
        EnglishCommon *respone = [EnglishCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

    


    
}


#pragma mark --查询套餐列表/bbt-phone/coursePackage
+(void)getCoursePackageParameter:(NSDictionary *)parameter success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/coursePackage",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询套餐列表请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询套餐列表=====%@",result);
        
        CoursePackage *respone = [CoursePackage mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

#pragma mark --查询用用支付列表 /bbt-phone/courseOrder
+(void)getQueryPayCourseOrderParameter:(NSDictionary *)parameter success:(void (^)(QueryPayCourseOrder *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/courseOrder",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询用用支付列表请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询用用支付列表=====%@",result);
        
        QueryPayCourseOrder *respone = [QueryPayCourseOrder mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

#pragma mark --保存套餐订单  /bbt-phone/courseOrder
+ (void)PostSaveCourseOrder:(NSDictionary *)parameter success:(void(^)(SaveCourseOrder *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/courseOrder",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"保存套餐订单请求链接%@",urlStr);
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSDictionary *bodydic = @{@"packageId":[parameter objectForKey:@"packageId"], @"phoneNumber":[parameter objectForKey:@"phoneNumber"], @"payType":[parameter objectForKey:@"payType"] };
    
    NSLog(@"apppayparams===%@",params);
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"zhifuresult=====%@",result);
        
        SaveCourseOrder *respone = [SaveCourseOrder mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
}

#pragma mark --订单预付  /bbt-admin/courseOrder/pay
+ (void)PostPayCourseOrder:(NSDictionary *)parameter success:(void(^)(PayCourseOrder *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/courseOrder/pay",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"apppayurlStr===%@",urlStr);
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSDictionary *bodydic = @{@"payType" : [parameter objectForKey:@"payType"], @"outTradeNo":[parameter objectForKey:@"outTradeNo"] };
    
    NSLog(@"apppayparams111===%@",params);
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"订单详情result=====%@",result);
        
        PayCourseOrder *respone = [PayCourseOrder mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}

#pragma mark --免费领取  bbt-phone/reservations
+ (void)PostFreeReservations:(NSDictionary *)parameter success:(void(^)(EnglishCommon *respone))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/reservations",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"a免费领取urlStr===%@",urlStr);
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"],@"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSDictionary *bodydic = @{@"age" : [parameter objectForKey:@"age"], @"phone":[parameter objectForKey:@"phone"] , @"remark":[parameter objectForKey:@"remark"] , @"source":[parameter objectForKey:@"source"] };
    
    NSLog(@"免费领取params111===%@",params);
    NSLog(@"bodydicparams111===%@",bodydic);
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:bodydic success:^(id result) {
        
        NSLog(@"免费领取result=====%@",result);
        
        EnglishCommon *respone = [EnglishCommon mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
    
    
}


#pragma mark --检验前10分钟进入课程 bbt-phone/studentCourse/checkTime/{studentCourseId}/{type}
+(void)getCourseCheckTimeParameter:(NSDictionary *)parameter success:(void (^)(EnglishTimeModel *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studentCourse/checkTime/%@/%@",BBT_HTTP_URL,PROJECT_NAME_APP,[parameter objectForKey:@"studentCourseId"],[parameter objectForKey:@"type"]];
    
    NSLog(@"检验前10分钟进入课程%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result检验前10分钟进入课程=====%@",result);
        
        EnglishTimeModel *respone = [EnglishTimeModel mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

//接口名称 查询学生信息
//请求类型 get
//请求Url  bbt-phone/students/detail/{studentId}
#pragma mark --查询学生信息
+(void)getStudentDetailStudentId:(NSString *)studentId success:(void (^)(Student *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/students/detail/%@",BBT_HTTP_URL,PROJECT_NAME_APP,studentId];
    
    NSLog(@"查询学生信息%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询学生信息=====%@",result);
        
        Student *respone = [Student mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
}

#pragma mark --查询指定套餐/bbt-phone/coursePackage/assign
+(void)getCoursePackageAssignParameter:(NSDictionary *)parameter success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/coursePackage/assign",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"查询套餐列表请求链接%@",urlStr);
    
    NSDictionary *params = @{@"userId" :[[TMCache sharedCache] objectForKey:@"userId"] , @"token": [[TMCache sharedCache] objectForKey:@"token"] };
    //    NSLog(@"请求参数%@",params);
    
    [BBTHttpTool GETHead:urlStr parameters:params success:^(id result) {
        
        NSLog(@"result查询指定套餐=====%@",result);
        
        CoursePackage *respone = [CoursePackage mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
        
    }];
    
}

//接口名称 GET
//请求类型 get
//请求Url  bbt-phone/studentVideo/get
//接口描述 获取封面地址，视频地址，学生姓名等数据

#pragma mark --获取封面地址，视频地址，学生姓名等数据
+(void)getStudentVideopageNum:(NSString *)pageNum success:(void (^)(studentVideo *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/studentVideo/get?pageNum=%@&pageSize=%@",BBT_HTTP_URL,PROJECT_NAME_APP,pageNum,@"20"];
    
    
    NSLog(@"获取封面地址，视频地址，学生姓名等数据请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"获取封面地址，视频地址，学生姓名等数据ssss=====%@",result);
        
        studentVideo *respone = [studentVideo mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 课堂表现
//请求类型 get
//请求Url  /bbt-phone/teacherEvaluation
#pragma mark --课堂表现
+(void)getteacherEvaluationCourseId:(NSString *)courseId success:(void (^)(ClassroomPerformance *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teacherEvaluation?courseId=%@",BBT_HTTP_URL,PROJECT_NAME_APP,courseId];
    
    
    NSLog(@"课堂表现请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"课堂表现ssss=====%@",result);
        
        ClassroomPerformance *respone = [ClassroomPerformance mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}

//接口名称 课程回放
//请求类型 get
//请求Url  /teacherCourse/playback/{serial}
#pragma mark --课程回放
+(void)getteacherCourseplaybackSerial:(NSString *)serial success:(void (^)(ClassroomPlayback *respone))success failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/teacherCourse/playback/%@",BBT_HTTP_URL,PROJECT_NAME_APP,serial];
    
    
    NSLog(@"课程回放请求链接===%@",urlStr);
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    // NSLog(@"点播历史列表请求参数===%@",parameter);
    
    [BBTHttpTool GETHead:urlStr parameters:parameter success:^(id result) {
        
        
        
        NSLog(@"课程回放ssss=====%@",result);
        
        ClassroomPlayback *respone = [ClassroomPlayback mj_objectWithKeyValues:result];
        
        if (success) {
            
            success(respone);
        }
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
            
        }
        
    }];
}


//接口名称 家长说
//请求类型 post
//请求Url  /bbt-phone/userSuggest
#pragma mark --家长说
+ (void)PostuserSuggestParameter:(NSDictionary *)parameter success:(void(^)(EnglishCommon *respone))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/userSuggest",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"家长说urlStr===%@",urlStr);
    
    
    
    NSDictionary *params = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"],@"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    

    NSLog(@"家长说params111===%@",params);
    NSLog(@"bodydicparams111===%@",parameter);
    
    [BBTHttpTool POSTTokenHead:urlStr parameters:params bodyDic:parameter success:^(id result) {
        
        NSLog(@"家长说result=====%@",result);
        
        EnglishCommon *respone = [EnglishCommon mj_objectWithKeyValues:result];
        
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
