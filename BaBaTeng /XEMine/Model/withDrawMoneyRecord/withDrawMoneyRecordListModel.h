//
//  withDrawMoneyRecordListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/10.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface withDrawMoneyRecordListModel : NSObject



@property (nonatomic, copy) NSString *accountBalance;
@property (nonatomic, copy) NSString *alipayNo;
@property (nonatomic, copy) NSString *applyStatus;

@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, copy) NSString *checkRemark;

@property (nonatomic, copy) NSString *checkTime;
@property (nonatomic, copy) NSString *levelId;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *transferNo;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *withdrawId;

@property (nonatomic, copy) NSString *withdrawMoney;


@end

NS_ASSUME_NONNULL_END
