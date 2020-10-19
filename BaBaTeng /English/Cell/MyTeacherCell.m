//
//  MyTeacherCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "MyTeacherCell.h"

#import "Header.h"

@implementation MyTeacherCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,113)];
//    bgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:240/255.0 alpha:1.0];
        bgView.backgroundColor = [UIColor whiteColor];
    
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,8, kDeviceWidth,106)];
//    backView.backgroundColor = [UIColor whiteColor];
//
//    [bgView addSubview:backView];
    
    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16,81, 81)];
    _iocnView.userInteractionEnabled = YES;
    _iocnView.backgroundColor = [UIColor clearColor];
    _iocnView.contentMode = UIViewContentModeScaleToFill;
    _iocnView.layer.cornerRadius= 15.0f;
    _iocnView.layer.borderWidth = 1.0;
    _iocnView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    _iocnView.clipsToBounds = YES;//去除边界
    _iocnView.layer.masksToBounds = YES;
    _iocnView.image = [UIImage imageNamed:@"Teacher"];
    
    [bgView addSubview:_iocnView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16, 27,kDeviceWidth - CGRectGetMaxX(_iocnView.frame) - 12 - 77, 20)];
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:24];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _nameLabel.text = @"Teacher A";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_nameLabel];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16, CGRectGetMaxY(_nameLabel.frame) + 12, 150, 13)];
    
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _numLabel.text = @"剩余可约次数:20";
    _numLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_numLabel];
    
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16,CGRectGetMaxY(_numLabel.frame) + 8, 200, 10)];

    _dateLabel.font = [UIFont systemFontOfSize:10];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _dateLabel.text = @"最后约课时间:2018-04-17";
    _dateLabel.textAlignment = NSTextAlignmentLeft;

    [bgView addSubview:_dateLabel];
    

    
    _experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 80 -16,39 ,80, 36)];
    //    _phoneView.userInteractionEnabled = NO;
    _experienceBtn.backgroundColor = MNavBackgroundColor;
    _experienceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_experienceBtn setTitle:@"预约" forState:UIControlStateNormal];
    
//    _experienceBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    
    _experienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    _experienceBtn.layer.cornerRadius= 18.0f;
    
    _experienceBtn.clipsToBounds = YES;//去除边界
    
    [bgView addSubview:_experienceBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(113, 112, kDeviceWidth - 113 - 16, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    
    return bgView;
    
}

@end
