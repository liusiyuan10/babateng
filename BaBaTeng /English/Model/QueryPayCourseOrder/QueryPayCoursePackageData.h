//
//  QueryPayCoursePackageData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/26.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryPayCoursePackageData : NSObject

@property (nonatomic, copy) NSString *packageTimes;
@property (nonatomic, copy) NSString *presentTimes;
@property (nonatomic, copy) NSString *validityPeriod;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *unitPrice;

//packageId = 1;
//packageName = "套餐一";
//packageTimes = 60;
//presentTimes = 5;
//totalPrice = "0.01";
//unitPrice = 0;
//validityPeriod = 6;

@end
