//
//  XEOrderListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEOrderListModel : NSObject

//goodsImage    商品图片    string    @mock=1111
//goodsNumber    商品数量    number    @mock=1
//goodsTotalPrice    商品总价    number    @mock=1
//orderId    订单编号    string    @mock=B20180513143803330909828
//orderStatus    订单状态，0待付款，1待发货，2：已发货，3：已完成，4已取消    number


@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, assign) CGFloat goodsTotalPrice;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *orderSn;

@property (nonatomic, assign) CGFloat orderTotalPrice;

@end

NS_ASSUME_NONNULL_END
