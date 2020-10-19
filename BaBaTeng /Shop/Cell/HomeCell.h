//
//  HomeCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell

@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *DescriptionLabel;
@property(nonatomic,strong)UIImageView *leftImage;

@property(nonatomic,strong)UILabel *knowledgeLabel;

@property(nonatomic,strong)UILabel *intelligenceLabel;

@property(nonatomic,strong)UILabel *SpecialLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
