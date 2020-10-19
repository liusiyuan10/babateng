//
//  CurriculumNoHaveCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CurriculumHaveCell.h"
#import "Header.h"

@implementation CurriculumHaveCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,183 + 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    CGFloat Kdistance = 16;
    
    if (kDevice_IS_PAD) {
        Kdistance = 66;
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(Kdistance,16, kDeviceWidth - Kdistance *2,183)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17,81, 81)];
    _iocnView.userInteractionEnabled = YES;
    _iocnView.backgroundColor = [UIColor clearColor];
    _iocnView.contentMode = UIViewContentModeScaleToFill;
    
    _iocnView.image = [UIImage imageNamed:@"Teacher"];
    
    _iocnView.layer.cornerRadius= 40.5f;
    
    _iocnView.layer.borderWidth = 1.0;
    _iocnView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    _iocnView.clipsToBounds = YES;//去除_iocnView
    _iocnView.layer.masksToBounds = YES;
    
    [backView addSubview:_iocnView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16, 36,250, 18)];
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:22.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _nameLabel.text = @"Teacher A";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_nameLabel];
    
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16,CGRectGetMaxY(_nameLabel.frame) + 13, 100, 11)];
    
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = [UIColor colorWithRed:247.0/255 green:65.0/255 blue:78.0/255 alpha:1.0f];
    _dateLabel.text = @"4/25 周三";
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 13, 90, 11)];
    
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:247.0/255 green:65.0/255 blue:78.0/255 alpha:1.0f];
    _timeLabel.text = @"07:30-07:55";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_timeLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(109, CGRectGetMaxY(_timeLabel.frame) + 36, kDeviceWidth - Kdistance *2 - 109 - 17, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    
    _classroomperformanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - Kdistance *2 - 17 - 81 - 17 - 81,CGRectGetMaxY(lineView.frame) + 16 ,81, 36)];
    
    _classroomperformanceBtn.backgroundColor = MNavBackgroundColor;
    
    
    _classroomperformanceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_classroomperformanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_classroomperformanceBtn setTitle:@"课堂表现" forState:UIControlStateNormal];
    
    _classroomperformanceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    _classroomperformanceBtn.layer.cornerRadius= 18.0f;
    
    _classroomperformanceBtn.clipsToBounds = YES;//去除边界
    
    [backView addSubview:_classroomperformanceBtn];
    
    
    _classroomplaybackBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - Kdistance *2 - 17 - 81,CGRectGetMaxY(lineView.frame) + 16 ,81, 36)];

    _classroomplaybackBtn.backgroundColor = MNavBackgroundColor;


    _classroomplaybackBtn.contentMode = UIViewContentModeScaleAspectFill;

    [_classroomplaybackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_classroomplaybackBtn setTitle:@"课程回放" forState:UIControlStateNormal];

    _classroomplaybackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];

    _classroomplaybackBtn.layer.cornerRadius= 18.0f;

    _classroomplaybackBtn.clipsToBounds = YES;//去除边界

    [backView addSubview:_classroomplaybackBtn];
    //
    
    return bgView;
    
}

@end
