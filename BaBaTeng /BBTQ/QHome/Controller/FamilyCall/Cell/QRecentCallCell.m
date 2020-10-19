//
//  QRecentCallCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/3.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QRecentCallCell.h"
#import "Header.h"

@implementation QRecentCallCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,84)];
    
    
    bgView.backgroundColor = [UIColor whiteColor];
  
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 64, 64)];
    self.iconView.image = [UIImage imageNamed:@"BBZL_icon_touxian"];
    
    [bgView addSubview:self.iconView];
    
    self.FamilyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 16, 20, 100, 22)];
    self.FamilyNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.FamilyNameLabel.font = [UIFont systemFontOfSize:16.0];
    self.FamilyNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:self.FamilyNameLabel];
    
    self.callView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 19, CGRectGetMaxY(self.FamilyNameLabel.frame) + 10, 22, 20)];
    
    self.callView.image = [UIImage imageNamed:@"icon_missed"];
    
    [bgView addSubview:self.callView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 66, 55, 50, 17)];
    
    self.timeLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    [bgView addSubview:self.timeLabel];
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 16, 83, kDeviceWidth - CGRectGetMaxX(self.iconView.frame) - 16, 1)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    
    
    return bgView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
