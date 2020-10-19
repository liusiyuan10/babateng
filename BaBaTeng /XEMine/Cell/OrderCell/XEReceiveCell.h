//
//  XEReceiveCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEReceiveCell : UITableViewCell

@property(nonatomic,strong)UILabel *orderStaueLabel;
@property(nonatomic,strong) UIImageView *leftImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *totalLabel;

@property(nonatomic,strong)UIButton *payBtn;

@end

NS_ASSUME_NONNULL_END
