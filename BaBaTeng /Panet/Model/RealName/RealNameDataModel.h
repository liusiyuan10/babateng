//
//  RealNameDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealNameDataModel : NSObject

//alipayAccount    支付宝账号    string    @mock=test
//backImage    证件背面相片    string    @mock=http://file.ai.babateng.cn//image%2Ficon%2F5dd566d2-2a75-494b-a1ad-1f1ba9702b3f
//cardNumber    证件号码    string    @mock=431026199902113836
//createTime    创建时间    string    @mock=2019-02-22 11:24:34
//faceImage    证件正面相片    string    @mock=http://file.ai.babateng.cn//image%2Ficon%2F5dd566d2-2a75-494b-a1ad-1f1ba9702b3f
//id    编号    number    @mock=1
//nickName    昵称    string    @mock=你大爷
//phoneNumber    手机号码    string    @mock=15112295282
//realName    真实姓名    string    @mock=周星星
//remark    不通过原因
//userId    用户编号    string    @mock=150872488215886964
//verifyStatus    状态    number    @mock=1
//verifyTime    审核时间    string    @mock=2019-02-22 11:24:18
//weixinAccount    微信账号    string    @mock=test

@property (nonatomic, copy) NSString *alipayAccount;
@property (nonatomic, copy) NSString *backImage;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *verifyStatus;
@property (nonatomic, copy) NSString *verifyTime;
@property (nonatomic, copy) NSString *weixinAccount;
@property (nonatomic, copy) NSString *faceImage;

@end

NS_ASSUME_NONNULL_END
