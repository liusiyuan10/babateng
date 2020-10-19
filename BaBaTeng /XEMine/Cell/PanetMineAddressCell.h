//
//  PanetMineAddressCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAddressCell : UITableViewCell

@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *phonenoLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIImageView *leftImage;


@property(nonatomic,strong)UIButton *EditBtn;

@end

NS_ASSUME_NONNULL_END
