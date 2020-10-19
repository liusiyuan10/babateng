//
//  WalletDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDataModel : NSObject

@property (nonatomic, copy) NSString *memberScore;
@property (nonatomic, assign) CGFloat monthProfit;
@property (nonatomic, assign) CGFloat totalProfit;
@property (nonatomic, assign) CGFloat weekProfit;
@property (nonatomic, assign) CGFloat yestodayProfit;

@property (nonatomic, assign) CGFloat memberAmount;

@property (nonatomic, assign) CGFloat enableProfit;
@property (nonatomic, assign) CGFloat allProfit;
@end

NS_ASSUME_NONNULL_END
