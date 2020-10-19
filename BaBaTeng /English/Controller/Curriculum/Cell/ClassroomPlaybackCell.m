//
//  ClassroomPlaybackCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/10.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "ClassroomPlaybackCell.h"
#import "Header.h"

@implementation ClassroomPlaybackCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,70)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18,kDeviceWidth -32, 16)];
    
    _nameLabel.font = [UIFont systemFontOfSize:17.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _nameLabel.text = @"回放时长";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_nameLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_nameLabel.frame) + 7, 200, 13)];
    
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0f];
    _timeLabel.text = @"27分44秒";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_timeLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 69, kDeviceWidth - 16 *2, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    
    
    _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 16 - 81, (70 - 36)/2.0 ,81, 36)];
    
    _payBtn.backgroundColor = MNavBackgroundColor;
    
    
    _payBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payBtn setTitle:@"播放" forState:UIControlStateNormal];
    
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    _payBtn.layer.cornerRadius= 18.0f;
    
    _payBtn.clipsToBounds = YES;//去除边界
    
    [bgView addSubview:_payBtn];
    
    
    return bgView;
    
}


@end

