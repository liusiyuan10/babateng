//
//  SaveOrderDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/12.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveOrderDataModel : NSObject

//    订单来源    number    @mock=456
//    创建时间    string    @mock=2019-04-11 16:03:57
//    商品编号    string    @mock=3
//    商品图片    string    @mock=https://iknowpc.bdimg.com/static/common/widget/search-box-new/img/logo-new.5b64efa.png
//    商品名称    string    @mock=aaaaaaaaaaaaaaaaa
//    商品数量    number    @mock=2
//    返利    number    @mock=6
//    商品总价    number    @mock=200





@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *goodsRebate;
@property (nonatomic, copy) NSString *goodsTotalPrice;

@property (nonatomic, copy) NSString *goodsUnitPrice;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderRemark;
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *receiverAddress;

@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
