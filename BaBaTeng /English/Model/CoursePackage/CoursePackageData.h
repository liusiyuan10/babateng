//
//  CoursePackageData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursePackageData : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *packageTimes;
@property (nonatomic, copy) NSString *presentTimes;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *unitPrice;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *validityPeriod;

@property (nonatomic, copy) NSString *packageImage;

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *educeMoney;
@property (nonatomic, copy) NSString *isShow;
@property (nonatomic, copy) NSString *studentId;

@end
