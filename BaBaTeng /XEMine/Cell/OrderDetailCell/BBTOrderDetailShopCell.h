//
//  BBTOrderDetailShopCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/12.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBTOrderDetailShopCell : UITableViewCell

@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *totalnoLabel;
@property(nonatomic,strong)UILabel *freightnoLabel;
@property(nonatomic,strong)UILabel *rewardnoLabel;
@property(nonatomic,strong)UILabel *knowledgenoLabel;
@property(nonatomic,strong)UILabel *rewardLabel;

@property(nonatomic,strong) UILabel *knowledgeLabel;
@end

NS_ASSUME_NONNULL_END