//
//  TeacherInfoData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherInfoData : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *registerNumber;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *introductionImgUrl;

@property (nonatomic, copy) NSDictionary *teacherCourseCount; 

@end
