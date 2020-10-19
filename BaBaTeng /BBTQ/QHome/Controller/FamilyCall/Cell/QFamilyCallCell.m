//
//  QFamilyCallCell.m
//  BaBaTeng
//
//  Created by liu on 17/12/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyCallCell.h"
#import "Header.h"

@implementation QFamilyCallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}



-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,174)];
    
    
    bgView.backgroundColor = DefaultBackgroundColor;
    
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 54)];
    
    heardView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    
    [bgView addSubview:heardView];
    
    self.heardLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 24, 100, 20)];
    self.heardLabel.font = [UIFont systemFontOfSize:14.0];
    self.heardLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    self.heardLabel.textAlignment = NSTextAlignmentLeft;
    
    [heardView addSubview:self.heardLabel];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 86, 26, 57, 18)];
    
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    
    [moreBtn setTitleColor:[UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [heardView addSubview:moreBtn];
    
    self.moreBtn = moreBtn;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moreBtn.frame), 28, 14, 14)];
    
    arrowImageView.image = [UIImage imageNamed:@"icon_more04"];
    
    [heardView addSubview:arrowImageView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heardViewClicked)];
    [heardView addGestureRecognizer:singleTap];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth, 120)];
    cellView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:cellView];
    
    self.cellView = cellView;
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
    
    self.iconView.image = [UIImage imageNamed:@"BBZL_icon_touxian"];
    
    [cellView addSubview:self.iconView];
    
    self.FamilyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 8/375.0 *kDeviceWidth,  38/668.0*KDeviceHeight, 100, 22)];
    
    self.FamilyNameLabel.font = [UIFont systemFontOfSize:16];
    self.FamilyNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.FamilyNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [cellView addSubview:self.FamilyNameLabel];
    
//    self.normalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.FamilyNameLabel.frame) + 8/375.0 *kDeviceWidth,38/668.0*KDeviceHeight, 24, 15)];
//
//    self.normalImageView .image = [UIImage imageNamed:@"contact_normal"];
//
//    [bgView addSubview:self.normalImageView ];
    
    self.FamilyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 8/375.0 *kDeviceWidth, CGRectGetMaxY(self.FamilyNameLabel.frame) + 8, 100, 17)];
    
    self.FamilyNumLabel.font = [UIFont systemFontOfSize:12];
    self.FamilyNumLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.FamilyNumLabel.textAlignment = NSTextAlignmentLeft;
    
    [cellView addSubview:self.FamilyNumLabel];
    
//    self.inboundView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 120, CGRectGetMaxY(heardView.frame) + 30, 22, 20)];
//
//    self.inboundView.image = [UIImage imageNamed:@"icon_Incoming"];
//
//    [bgView addSubview:self.inboundView];
    
    self.inboundLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 170, 41/668.0*KDeviceHeight, 150, 20)];
    
    self.inboundLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
    self.inboundLabel.font = [UIFont systemFontOfSize:12.0];
    self.inboundLabel.textAlignment = NSTextAlignmentRight;
    
    
    [cellView addSubview:self.inboundLabel];
    
    self.BreatheoutView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 120, CGRectGetMaxY(self.inboundLabel.frame) + 12/668.0*KDeviceHeight, 22, 20)];
    
    self.BreatheoutView.image = [UIImage imageNamed:@"icon_Exhale"];
    
    [cellView addSubview:self.BreatheoutView];
    
    self.BreatheoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 110, CGRectGetMaxY(self.inboundLabel.frame) + 12/668.0*KDeviceHeight, 90, 20)];
    
    self.BreatheoutLabel.textColor = [UIColor colorWithRed:117/255.0 green:207/255.0 blue:25/255.0 alpha:1.0];
    self.BreatheoutLabel.font = [UIFont systemFontOfSize:14.0];
    self.BreatheoutLabel.textAlignment = NSTextAlignmentRight;
    
    
    [cellView addSubview:self.BreatheoutLabel];
    
    UITapGestureRecognizer *cellViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellViewClicked)];
    [cellView addGestureRecognizer:cellViewTap];
    
    
    _nocellView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth, 120)];
    _nocellView .backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_nocellView ];
    
    _noiconView = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
    
    _noiconView.image = [UIImage imageNamed:@"contact_n"];
    
    [_nocellView addSubview:_noiconView];
    
    _noFamilhCallLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_noiconView.frame) + 8/375.0 *kDeviceWidth,  49/668.0*KDeviceHeight, 100, 22)];
    
    _noFamilhCallLabel.font = [UIFont systemFontOfSize:16];
    _noFamilhCallLabel.text = @"无最近通话";
    _noFamilhCallLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    _noFamilhCallLabel.textAlignment = NSTextAlignmentLeft;
    
    [_nocellView addSubview:_noFamilhCallLabel];
    
    

    return bgView;
}

- (void)cellViewClicked
{
    if ([self.delegate respondsToSelector:@selector(qfamilycallcellView:)]) {
        
        [self.delegate qfamilycallcellView:self];
        
    }
    
}

- (void)heardViewClicked
{
    
    
//    if ([self.delegate respondsToSelector:@selector(QDeviceViewBtnClicked:selectName:selectIndex:)]) {
//
//
//        //        [self.delegate Q3PlayListViewAddBtnClicked:self sectionIndex:listresponse.id ListTitle:listresponse.name];
//        NSLog(@"indexPath.row======%ld",(long)indexPath.row);
//
//        [self.delegate QDeviceViewBtnClicked:self selectName:name selectIndex:indexPath.row];
//
//    }
    
//    NSLog(@"sdfsdfsdqqqqqq");
    
    if ([self.delegate respondsToSelector:@selector(qfamilycall:)]) {
    
        [self.delegate qfamilycall:self];
    
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
