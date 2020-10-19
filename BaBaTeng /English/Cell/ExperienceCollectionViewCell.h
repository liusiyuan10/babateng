//
//  ExperienceCollectionViewCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/21.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExperienceCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UILabel *noLabel;
@property(nonatomic,strong)UILabel *teacherLabel;
@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UIView *backView;

@end

NS_ASSUME_NONNULL_END
