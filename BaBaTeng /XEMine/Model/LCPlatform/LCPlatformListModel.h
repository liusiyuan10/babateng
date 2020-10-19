//
//  LCPlatformListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCPlatformListModel : NSObject

//activeTime    激活时间    string    @mock=2019-07-30 15:50:46
//cardNo    卡号    string    @mock=01000000000001
//cardOwnerName    持卡人姓名    string    @mock=tcp
//cardOwnerPhone    持卡人手机号    string    @mock=151****5282
//cardPrice    卡面值    number    @mock=200
//cardStatus    卡状态：1:未激活，2：待审核，3：已激活，4：已过期    number    @mock=3
//cardType    卡类型    string    @mock=体验卡
//expireDate    过期时间    string    @mock=2019年09月30日
//saleChannle    销售渠道    string    @mock=代理商
//studyTimes    学习次数    number    @mock=50
//studyType    学习类型    string    @mock=在线少儿英语
//validTime    有效时间，整数，取月    number    @mock=3

@property (nonatomic, copy) NSString *activeTime;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *cardOwnerName;
@property (nonatomic, copy) NSString *cardOwnerPhone;
@property (nonatomic, copy) NSString *cardPrice;
@property (nonatomic, copy) NSString *cardStatus;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *expireDate;
@property (nonatomic, copy) NSString *saleChannle;
@property (nonatomic, copy) NSString *studyTimes;
@property (nonatomic, copy) NSString *studyType;
@property (nonatomic, copy) NSString *validTime;



@end

NS_ASSUME_NONNULL_END
