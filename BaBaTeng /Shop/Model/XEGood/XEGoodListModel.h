//
//  XEGoodListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEGoodListModel : NSObject


@property (nonatomic, copy) NSString *category1st;
@property (nonatomic, copy) NSString *category2nd;
@property (nonatomic, copy) NSString *costPrice;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsDetail;
@property (nonatomic, copy) NSString *goodsFaceImage;
@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsOrder;
@property (nonatomic, assign) CGFloat goodsRebate;

@property (nonatomic, copy) NSString *goodsSize;
@property (nonatomic, copy) NSString *goodsStatus;
@property (nonatomic, copy) NSString *goodsStock;
@property (nonatomic, copy) NSString *goodsWeight;
@property (nonatomic, copy) NSString *marketPrice;

@property (nonatomic, assign) CGFloat sellPrice;

@property (nonatomic, copy) NSString *sellVolume;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *upDownTime;
@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *rewardKeyWords;
@property (nonatomic, copy) NSString *goodsPostage;

@property (nonatomic, copy) NSString *knowledgeReward;
@property (nonatomic, copy) NSString *marketingKeyWords;

@property (nonatomic, assign) CGFloat maxDeduction;

@property (nonatomic, assign) CGFloat rateChange;

@property (nonatomic, copy) NSString *goodsOrigin;

@end

NS_ASSUME_NONNULL_END
