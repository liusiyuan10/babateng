//
//  BeansCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "BeansCell.h"
#import "Header.h"

@implementation BeansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView*cellView = [self contentViewCell];
        //        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,74)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 21, 200, 16)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    CGFloat  subtitleX =16;
    CGFloat  subtitleW = 200;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_nameLabel.frame) + 8, subtitleW, 9)];
    
    _timeLabel.font = [UIFont systemFontOfSize:11.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_timeLabel];
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 120 - 32, 22, 120, 12)];
    
    _noLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _noLabel.backgroundColor = [UIColor clearColor];
    _noLabel.textColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:0/255.0 alpha:1.0];
    _noLabel.textAlignment = NSTextAlignmentRight;
    
    [bgView addSubview:_noLabel];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 150 - 32,CGRectGetMaxY(_noLabel.frame) + 9, 150, 11)];
    
    _subLabel.font = [UIFont systemFontOfSize:11.0];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _subLabel.textAlignment = NSTextAlignmentRight;
    
    [bgView addSubview:_subLabel];
    
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  73.5, kDeviceWidth - 32,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
