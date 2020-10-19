//
//  XERechargeRecordCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XERechargeRecordCell.h"
#import "Header.h"

@implementation XERechargeRecordCell

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
    
//
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,74)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 21, 100, 16)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    _nameLabel.text = @"充值成功";
    [bgView addSubview:_nameLabel];
    
    _resonBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 21, 16, 16)];
//    _resonImage.image = [UIImage imageNamed:@"reson"];
    [_resonBtn setImage:[UIImage imageNamed:@"reson"] forState:UIControlStateNormal];
    
    _resonBtn.hidden = YES;
    
    [bgView addSubview:_resonBtn];
    
    CGFloat  subtitleX =16;
    CGFloat  subtitleW = 200;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_nameLabel.frame) + 8, subtitleW, 9)];
    
    _timeLabel.font = [UIFont systemFontOfSize:11.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel.text = @"2019-02-25   13:22";
    [bgView addSubview:_timeLabel];
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 180 - 16, 30, 180, 12)];
    
    _noLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _noLabel.backgroundColor = [UIColor clearColor];
    _noLabel.textColor = MNavBackgroundColor;
    _noLabel.textAlignment = NSTextAlignmentRight;
    
    _noLabel.text = @"+10.25";
    
    [bgView addSubview:_noLabel];
    
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  73.5, kDeviceWidth - 32,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
