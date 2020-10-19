//
//  QContactDetailCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QContactDetailCell.h"

#import "Header.h"

@implementation QContactDetailCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,98)];
    
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 22, 22, 20)];
    self.iconView.image = [UIImage imageNamed:@"icon_Exhale"];
    
    [bgView addSubview:self.iconView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 16, 20, 200, 22)];
    self.timeLabel.font = [UIFont systemFontOfSize:16];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    [bgView addSubview:self.timeLabel];
    
    self.callTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 16, CGRectGetMaxY(self.timeLabel.frame), 200, 17)];
    self.callTypeLabel.font = [UIFont systemFontOfSize:12];
    self.callTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.callTypeLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
    
    [bgView addSubview:self.callTypeLabel];
    
    self.calltimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 16, CGRectGetMaxY(self.callTypeLabel.frame), 200, 17)];
    self.calltimeLabel.font = [UIFont systemFontOfSize:12];
    self.calltimeLabel.textAlignment = NSTextAlignmentLeft;
    self.calltimeLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
    
    [bgView addSubview:self.calltimeLabel];
    
    
    
    
    return bgView;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
