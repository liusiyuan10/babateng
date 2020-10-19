//
//  CurriculumCancelCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CurriculumCancelCell.h"
#import "Header.h"

@implementation CurriculumCancelCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,170 + 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    CGFloat Kdistance = 16;
    
    if (kDevice_IS_PAD) {
        Kdistance = 66;
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(Kdistance,16, kDeviceWidth - Kdistance * 2,170)];
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
    _dateLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _dateLabel.text = @"4/25 周三";
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 13, 90, 11)];
    
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _timeLabel.text = @"07:30-07:55";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_timeLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(109, CGRectGetMaxY(_timeLabel.frame) + 36, kDeviceWidth - Kdistance *2 - 109 - 17, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    _cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(lineView.frame) , kDeviceWidth - Kdistance *2 - 17,40)];
    
    _cancelLabel.font = [UIFont systemFontOfSize:14];
    _cancelLabel.backgroundColor = [UIColor clearColor];
    _cancelLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    //    _cancelLabel.text = @"07:30-07:55";
    _cancelLabel.textAlignment = NSTextAlignmentLeft;
    _cancelLabel.numberOfLines = 0;
    [backView addSubview:_cancelLabel];
    
    
    //    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 77,36 ,65, 24)];
    //    //    _phoneView.userInteractionEnabled = NO;
    //    //    _cancelBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:107/255.0 blue:98/255.0 alpha:1.0];
    //    _cancelBtn.backgroundColor = [UIColor clearColor];
    //    //    _cancelBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    //    _cancelBtn.contentMode = UIViewContentModeScaleAspectFill;
    //
    //    [_cancelBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:107/255.0 blue:38/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    [_cancelBtn setTitle:@"查看原因" forState:UIControlStateNormal];
    //
    //    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    //
    //
    //    [backView addSubview:_cancelBtn];
    
    
    return bgView;
    
}


@end
