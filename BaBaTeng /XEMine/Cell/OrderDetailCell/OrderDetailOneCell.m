//
//  OrderDetailOneCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "OrderDetailOneCell.h"
#import "Header.h"

@implementation OrderDetailOneCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,138 + 20)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView  *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 121 + 20)];
    
    headerView.backgroundColor = [UIColor clearColor];
    headerView.image = [UIImage imageNamed:@"mine"];
    
    headerView.userInteractionEnabled = YES;
    
    [bgView addSubview:headerView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,66, kDeviceWidth - 32,90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 17, kDeviceWidth - 66, 17)];

    _moneyLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _moneyLabel.backgroundColor = [UIColor clearColor];
    _moneyLabel.text = @"7200see 等待付款";
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:_moneyLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, CGRectGetMaxY(_moneyLabel.frame) + 7, kDeviceWidth - 66, 12)];
    
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = @"剩余时间：47小时50分钟";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:_timeLabel];
    
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17, 100, 17)];
    _NameLabel.font = [UIFont systemFontOfSize:16.0];
    _NameLabel.backgroundColor = [UIColor clearColor];
    
    _NameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0  blue:83/255.0  alpha:1.0];
    [backView addSubview:_NameLabel];
    
    
    CGFloat  subtitleX = kDeviceWidth - 120-38;
    CGFloat  subtitleW = 120;
    
    _phonenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_NameLabel.frame) + 16, 17, subtitleW, 12)];
    
    _phonenoLabel.font = [UIFont systemFontOfSize:16.0];
    _phonenoLabel.backgroundColor = [UIColor clearColor];
    _phonenoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0  blue:83/255.0  alpha:1.0];
    _phonenoLabel.textAlignment = NSTextAlignmentRight;
    
    
    [backView addSubview:_phonenoLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_NameLabel.frame) + 11, kDeviceWidth - 38 -16, 40)];
    
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0  blue:181/255.0  alpha:1.0];
    _addressLabel.numberOfLines =0;
    
    
    [backView addSubview:_addressLabel];
    
    return bgView;
    
}
@end
