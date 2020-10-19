//
//  QEditClockCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QEditClockCell.h"
#import "Header.h"

@implementation QEditClockCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,64)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = DefaultBackgroundColor;
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (64-18)/2.0, 60, 18)];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blackColor];
    
    
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    
    [bgView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 200 - 16 - 9 - 16, (64-14)/2.0, 200, 14)];
    
    _subLabel.font = [UIFont boldSystemFontOfSize:15];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];
    
    
    _subLabel.textAlignment = NSTextAlignmentRight;
    
    
    
    [bgView addSubview:_subLabel];
    
    
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 9 - 16, (64 - 15)/2.0, 9, 15)];
    
    _arrowView.backgroundColor = [UIColor clearColor];
    _arrowView.contentMode = UIViewContentModeScaleAspectFill;
    _arrowView.image = [UIImage imageNamed:@"clock_front"];
    [bgView addSubview:_arrowView];
    
    
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 63, kDeviceWidth, 1)];
//
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//
//    [bgView addSubview:lineView];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0] CGColor];
    lineLayer.frame = CGRectMake(0,63, kDeviceWidth, 1.0);
    [bgView.layer addSublayer:lineLayer];
    
    return bgView;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
