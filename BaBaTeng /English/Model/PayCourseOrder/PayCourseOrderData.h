//
//  PayCourseOrderData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayCourseOrderData : NSObject

@property (nonatomic, copy) NSString *bizContent;

@property (nonatomic, copy) NSString *outTradeNo;

@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *signType;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *prepayid;

@end
