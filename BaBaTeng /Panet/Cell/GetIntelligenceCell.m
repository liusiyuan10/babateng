//
//  GetIntelligenceCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "GetIntelligenceCell.h"
#import "Header.h"

@implementation GetIntelligenceCell

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
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 23, 32, 30)];
    
    [bgView addSubview:_leftImage];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 17, 21, 200, 16)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    CGFloat  subtitleX =CGRectGetMaxX(_leftImage.frame) + 17;
    CGFloat  subtitleW = 200;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_nameLabel.frame) + 8, subtitleW, 9)];
    
    _timeLabel.font = [UIFont systemFontOfSize:11.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_timeLabel];
    
    _konwLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 64 - 16, 8, 64, 10)];
    
    _konwLabel.font = [UIFont boldSystemFontOfSize:11.0];
    _konwLabel.backgroundColor = [UIColor clearColor];
    _konwLabel.textColor = [UIColor redColor];
    _konwLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:_konwLabel];
    
    _intelligenceBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 70 -16, 21, 70, 32)];
    
    [_intelligenceBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_orange"] forState:UIControlStateNormal];
    [_intelligenceBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_white"] forState:UIControlStateDisabled];
//    _intelligenceBtn.titleLabel.textColor = [UIColor whiteColor];
    [_intelligenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_intelligenceBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:150/255.0 blue:30/255.0 alpha:1.0] forState:UIControlStateDisabled];
    _intelligenceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [_intelligenceBtn setTitle:@"sfsdf" forState:UIControlStateNormal];
    [bgView addSubview:_intelligenceBtn];
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  73.5, kDeviceWidth - 32,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}
@end
