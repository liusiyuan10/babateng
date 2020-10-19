//
//  EnglishHeadCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/17.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EnglishHeadCell.h"

#import "Header.h"

@implementation EnglishHeadCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,64+kDevice_IsE_iPhoneX)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = MNavBackgroundColor;

    
//    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 24,36, 36)];
//    _iocnView.userInteractionEnabled = NO;
//    _iocnView.backgroundColor = [UIColor clearColor];
//    _iocnView.contentMode = UIViewContentModeScaleAspectFill;
//
//    [bgView addSubview:_iocnView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 24+kDevice_IsE_iPhoneX,70, 20)];
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"课程次数:";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:nameLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 25+kDevice_IsE_iPhoneX, 50, 20)];
    
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.text = @"20";
    _numLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_numLabel];
    
    
    
    UILabel *indateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,CGRectGetMaxY(nameLabel.frame), 50, 16)];
    
    indateLabel.font = [UIFont systemFontOfSize:11];
    indateLabel.backgroundColor = [UIColor clearColor];
    indateLabel.textColor = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:192/255.0 alpha:1.0];
    indateLabel.text = @"有效期:";
    indateLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:indateLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(indateLabel.frame), CGRectGetMaxY(nameLabel.frame), 150, 16)];
    
    _timeLabel.font = [UIFont systemFontOfSize:11];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:192/255.0 alpha:1.0];
    _timeLabel.text = @"2018.05.01";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_timeLabel];
    
//    _phoneImagView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth - 100,0, 100,64+kDevice_IsE_iPhoneX)];
//
//    _phoneImagView.userInteractionEnabled = YES;
//    _phoneImagView.backgroundColor = MNavBackgroundColor;
//
//    [bgView addSubview:_phoneImagView];
    
    _phoneView = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 43,26+kDevice_IsE_iPhoneX ,33, 33)];
    
    _phoneView.backgroundColor = [UIColor clearColor];
    
    
    [bgView addSubview:_phoneView];
    
    

    
    

    
    
    return bgView;
    
}
@end
