//
//  QClockCell.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/27.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QClockCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;
//@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *tagLabel;
@property(nonatomic,strong)UILabel *repeatLabel;
@property(nonatomic,strong)UILabel *countdownLabel;

@property(nonatomic,strong) UIImageView *arrowView;

@property(nonatomic,strong)UISwitch *switchview;
@end
