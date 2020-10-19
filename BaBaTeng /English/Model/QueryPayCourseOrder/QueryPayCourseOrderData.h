//
//  QueryPayCourseOrderData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryPayCoursePackageData.h"

@interface QueryPayCourseOrderData : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *outTradeNo;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *payMoney;
@property (nonatomic, copy) NSString *payNo;
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *refundMoney;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) QueryPayCoursePackageData *coursePackage;
@end
