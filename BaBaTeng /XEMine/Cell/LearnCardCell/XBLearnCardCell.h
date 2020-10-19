//
//  XBLearnCardCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBLearnCardCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImageview;

@property(nonatomic,strong) UILabel *iconpriceLabel;
@property(nonatomic,strong) UILabel *iconcardLabel;
@property(nonatomic,strong) UILabel *iconclassNoLabel;
@property(nonatomic,strong) UILabel *iconvalidityLabel;

@end

NS_ASSUME_NONNULL_END
