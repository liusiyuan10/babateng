//
//  IntelligenceCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "IntelligenceCell.h"
#import "Header.h"

@implementation IntelligenceCell

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
    
    _konwledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 21, 200, 16)];
    _konwledgeLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _konwledgeLabel.backgroundColor = [UIColor clearColor];
    
    _konwledgeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_konwledgeLabel];
    
    CGFloat  subtitleX =16;
    CGFloat  subtitleW = 200;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_konwledgeLabel.frame) + 8, subtitleW, 9)];
    
    _timeLabel.font = [UIFont systemFontOfSize:11.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_timeLabel];
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 80 - 16, 30, 80, 12)];
    
    _noLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _noLabel.backgroundColor = [UIColor clearColor];
    _noLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    _noLabel.textAlignment = NSTextAlignmentRight;
    
    [bgView addSubview:_noLabel];
    
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  73.5, kDeviceWidth - 32,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}
@end
