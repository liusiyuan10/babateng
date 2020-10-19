//
//  ForeignDetailData.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForeignDetailData : NSObject

//createTime    创建时间    string    @mock=2019-03-03 15:27:12
//packageDetail    套餐详情    string    @mock=<p>8789754<img src="http://test.file.babateng.cn//image/icon/06d69adf-1e53-45b8-8505-920efd977883.jpg" style="font-size: 14px; max-width: 100%;"></p>
//packageId    套餐编号    number    @mock=8
//packageImage    套餐封面    string    @mock=http://test.file.babateng.cn/image%2Ficon%2Fca062d2e-03c9-4a62-a177-4698faef1cb7.png
//packageName    套餐名称    string    @mock=rrg
//packageTimes    套餐次数    number    @mock=23
//packageType    套餐类型    number    @mock=2
//presentPeas    英豆数量    number    @mock=66
//presentTimes    赚送次数    number    @mock=30
//totalPrice    套餐总价    number    @mock=6500
//unitPrice    套餐单价    number    @mock=122.6
//updateTime    更新时间    string    @mock=2019-03-03 15:27:12
//validityPeriod

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *packageDetail;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *packageImage;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *packageTimes;
@property (nonatomic, copy) NSString *packageType;
@property (nonatomic, copy) NSString *presentTimes;
@property (nonatomic, copy) NSString *totalPrice;

@property (nonatomic, copy) NSString *unitPrice;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *validityPeriod;

@end

NS_ASSUME_NONNULL_END
