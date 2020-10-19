//
//  XEMallOrderViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface XEMallOrderViewController : CommonViewController
@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsFaceImage;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) CGFloat sellPrice;
@property (nonatomic, assign) CGFloat goodsRebate;

@property (nonatomic, copy) NSString *storeSevicePhone;

@property (nonatomic, assign) CGFloat peasRate;
@property (nonatomic, assign) CGFloat maxDeduction;

@property (nonatomic, copy) NSString *goodsPostage;

@property (nonatomic, copy) NSString *rewardKeyWords;

@property (nonatomic, assign) CGFloat scoreValue;

@property (nonatomic, assign) CGFloat knowledgeReward;

@end

NS_ASSUME_NONNULL_END
