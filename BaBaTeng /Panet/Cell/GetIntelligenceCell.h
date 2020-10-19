//
//  GetIntelligenceCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetIntelligenceCell : UITableViewCell

@property(nonatomic,strong) UIImageView *leftImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property (nonatomic, strong) UIButton *intelligenceBtn;

@property(nonatomic,strong) UILabel *konwLabel;
@end

NS_ASSUME_NONNULL_END
