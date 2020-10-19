//
//  XERechargeRecordCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XERechargeRecordCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *noLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong) UIButton *resonBtn;

@end

NS_ASSUME_NONNULL_END
