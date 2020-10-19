//
//  EnglishRequestTool.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/24.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student,AllEgTeacher,TeacherInfo,TeaReservation,MyEgTeacher,EnglishCommon,StudentCourse,TotalCourse,SaveCourseOrder,PayCourseOrder,CoursePackage,QueryPayCourseOrder,EnglishTimeModel,studentVideo,ClassroomPerformance,ClassroomPlayback;

@interface EnglishRequestTool : NSObject

#pragma mark --学生剩余课程数和有效期
+(void)getStudentParameter:(NSDictionary *)parameter success:(void (^)(Student *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --查询所有外教老师信息
+(void)getAllEgTeacherParameter:(NSDictionary *)parameter success:(void (^)(AllEgTeacher *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --获取老师信息
+(void)getTeacherInfoParameter:(NSDictionary *)parameter success:(void (^)(TeacherInfo *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --查询待预约的课程
+(void)getTeacherReservationsParameter:(NSDictionary *)parameter success:(void (^)(TeaReservation *respone))success failure:(void (^)(NSError *error))failure;


#pragma mark --查询我预约的老师信息
+(void)getTeacherMyselfTeachersParameter:(NSDictionary *)parameter success:(void (^)(MyEgTeacher *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --立即预约
+ (void)PostStudentsParameter:(NSDictionary *)parameter bodyArr:(NSArray *)bodyarr success:(void(^)(EnglishCommon *response))success failure:(void(^)(NSError *error))failure;

#pragma mark --查询学生课程列表 /bbt-phone/studentCourse
+ (void)GetStudentCourse:(NSString *)status pageNum:(NSString *)pageNum success:(void(^)(StudentCourse *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --统计学生课程数量 /bbt-phone/studentCourse/total
+(void)getToalStudentCourseParameter:(NSDictionary *)parameter success:(void (^)(TotalCourse *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --取消课程 /bbt-phone/studentCourse/cancel/{stCourseId}
+(void)PutCancelStudentCourseParameter:(NSDictionary *)parameter success:(void (^)(EnglishCommon *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --查询套餐列表/bbt-phone/coursePackage
+(void)getCoursePackageParameter:(NSDictionary *)parameter success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --查询用用支付列表 /bbt-phone/courseOrder
+(void)getQueryPayCourseOrderParameter:(NSDictionary *)parameter success:(void (^)(QueryPayCourseOrder *respone))success failure:(void (^)(NSError *error))failure;

#pragma mark --保存套餐订单  /bbt-phone/courseOrder
+ (void)PostSaveCourseOrder:(NSDictionary *)parameter success:(void(^)(SaveCourseOrder *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --订单预付  /bbt-admin/courseOrder/pay
+ (void)PostPayCourseOrder:(NSDictionary *)parameter success:(void(^)(PayCourseOrder *respone))success failure:(void(^)(NSError *error))failure;

#pragma mark --免费领取  bbt-phone/freereservations
+ (void)PostFreeReservations:(NSDictionary *)parameter success:(void(^)(EnglishCommon *respone))success failure:(void(^)(NSError *error))failure;


//接口名称 检验前10分钟进入课程
//请求类型 get
//请求Url  bbt-phone/studentCourse/checkTime/{studentCourseId}/{type}
#pragma mark --检验前10分钟进入课程 bbt-phone/studentCourse/checkTime/{studentCourseId}/{type}
+(void)getCourseCheckTimeParameter:(NSDictionary *)parameter success:(void (^)(EnglishTimeModel *respone))success failure:(void (^)(NSError *error))failure;


//接口名称 查询学生信息
//请求类型 get
//请求Url  bbt-phone/students/detail/{studentId}
#pragma mark --查询学生信息
+(void)getStudentDetailStudentId:(NSString *)studentId success:(void (^)(Student *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 查询指定套餐
//请求类型 get
//请求Url  /bbt-phone/coursePackage/assign
#pragma mark --查询指定套餐
+(void)getCoursePackageAssignParameter:(NSDictionary *)parameter success:(void (^)(CoursePackage *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 GET
//请求类型 get
//请求Url  bbt-phone/studentVideo/get
//接口描述 获取封面地址，视频地址，学生姓名等数据

#pragma mark --获取封面地址，视频地址，学生姓名等数据
+(void)getStudentVideopageNum:(NSString *)pageNum success:(void (^)(studentVideo *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 课堂表现
//请求类型 get
//请求Url  /bbt-phone/teacherEvaluation
#pragma mark --课堂表现
+(void)getteacherEvaluationCourseId:(NSString *)courseId success:(void (^)(ClassroomPerformance *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 课程回放
//请求类型 get
//请求Url  /teacherCourse/playback/{serial}
#pragma mark --课程回放
+(void)getteacherCourseplaybackSerial:(NSString *)serial success:(void (^)(ClassroomPlayback *respone))success failure:(void (^)(NSError *error))failure;

//接口名称 家长说
//请求类型 post
//请求Url  /bbt-phone/userSuggest
#pragma mark --家长说
+ (void)PostuserSuggestParameter:(NSDictionary *)parameter success:(void(^)(EnglishCommon *respone))success failure:(void(^)(NSError *error))failure;

@end
