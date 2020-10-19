//
//  MybuyClassCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/26.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MybuyClassCell : UITableViewCell

@property(nonatomic,strong)UILabel *presentLabel;
@property(nonatomic,strong)UILabel *educeMoneyLabel;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *unitPriceLabel;
@property(nonatomic,strong)UILabel *totalPriceLabel;

@property(nonatomic,strong)UIImageView *iocnView;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIButton *buyBtn;
@end

NS_ASSUME_NONNULL_END
