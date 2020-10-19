//
//  OrderDetailDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/12.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailDataModel : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *cancelTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deliverTime;
@property (nonatomic, copy) NSString *expressCompany;
@property (nonatomic, copy) NSString *expressNumber;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, assign) CGFloat goodsTotalPrice;
@property (nonatomic, assign) CGFloat goodsUnitPrice;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderRemark;
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *payNo;
@property (nonatomic, copy) NSString *payTime;

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *receiveTime;
@property (nonatomic, copy) NSString *receiverAddress;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, assign) CGFloat goodsRebate;
@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, assign) CGFloat goodsDeduction;

@property (nonatomic, assign) CGFloat orderTotalPrice;
@property (nonatomic, assign) CGFloat knowledgeReward;
@property (nonatomic, assign) CGFloat logisticsCost;
@property (nonatomic, assign) CGFloat payKnowledgeReward;



@end

NS_ASSUME_NONNULL_END
