//
//  RechargeRecordListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeRecordListModel : NSObject


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *memberLevel;
@property (nonatomic, strong) NSDictionary *level;

@property (nonatomic, copy) NSString *memberScore;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *rechargeId;
@property (nonatomic, copy) NSString *rechargeSocre;
@property (nonatomic, copy) NSString *rechargeStatus;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *walletAddress;

@property (nonatomic, copy) NSString *verifyRemark;

@property (nonatomic, copy) NSString *payNum;
@property (nonatomic, copy) NSString *peasRate;




@end

NS_ASSUME_NONNULL_END
