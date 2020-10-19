//
//  StudentData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentData : NSObject

@property (nonatomic, copy) NSString *courseValidity;

@property (nonatomic, copy) NSString *remainingCourses;

@property (nonatomic, copy)  NSString *studentFlg;

//age = 4;
//classWdTimes = 0;
//classedTimes = 0;
//courseValidity = "2019-09-07";
//createTime = "2019-01-16 17:34:16";
//enPaseValue = 224;
//managePresentTimes = 0;
//name = "\U8001\U67f3";
//packageTimes = 2247;
//presentTimes = 10452;
//reaminPaseValue = "243.94234";
//remainingTimes = 4;
//remark = 111;
//sex = 1;
//telPhone = 18503051096;
//totalTimes = 12695;
//userAppId = 150632374388266134;

@property (nonatomic, copy)  NSString *age;
@property (nonatomic, copy)  NSString *classWdTimes;
@property (nonatomic, copy)  NSString *classedTimes;
//@property (nonatomic, copy)  NSString *courseValidity;

@property (nonatomic, copy)  NSString *createTime;
@property (nonatomic, copy)  NSString *enPaseValue;
@property (nonatomic, copy)  NSString *managePresentTimes;
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, copy)  NSString *packageTimes;
@property (nonatomic, copy)  NSString *presentTimes;


@property (nonatomic, copy)  NSString *reaminPaseValue;
@property (nonatomic, copy)  NSString *remainingTimes;
@property (nonatomic, copy)  NSString *remark;
@property (nonatomic, copy)  NSString *sex;
@property (nonatomic, copy)  NSString *telPhone;
@property (nonatomic, copy)  NSString *totalTimes;
@property (nonatomic, copy)  NSString *userAppId;

@end
