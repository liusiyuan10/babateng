//
//  DemandCell.h
//  BaBaTeng
//
//  Created by liu on 17/2/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDemandCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *leftImage;
@property(nonatomic,strong)UIButton *rightUpImage;
@property(nonatomic,strong)UIButton *rightMiddleImage;
//@property(nonatomic,strong)UIButton *rightDownImage;
@property(nonatomic,strong) UIImageView *lineView;

@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UIImageView *timeView;

@end
