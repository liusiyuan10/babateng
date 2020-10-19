//
//  QSongListCell.h
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSongListCell : UITableViewCell

@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIButton *leftImage;
@property(nonatomic,strong) UIButton *collectBtn;
@property(nonatomic,strong) UIButton *deleteBtn;

@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UIImageView *timeView;

@end
