//
//  PanetMineAddressCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineAddressCell.h"
#import "Header.h"

@implementation PanetMineAddressCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,111)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 111)];
    
    _leftImage.userInteractionEnabled = YES;
//
    _leftImage.image = [UIImage imageNamed:@"PanetMine_adress_bg"];
    [bgView addSubview:_leftImage];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 38, 46 - 10.5, 100, 17)];
    _NameLabel.font = [UIFont systemFontOfSize:16.0];
    _NameLabel.backgroundColor = [UIColor clearColor];

    _NameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0  blue:83/255.0  alpha:1.0];
    [_leftImage addSubview:_NameLabel];
    
  
    CGFloat  subtitleX = CGRectGetMaxX(_NameLabel.frame) + 16;
    CGFloat  subtitleW = 120;
    
    _phonenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 48 - 10.5, subtitleW, 12)];
    
    _phonenoLabel.font = [UIFont systemFontOfSize:16.0];
    _phonenoLabel.backgroundColor = [UIColor clearColor];
    _phonenoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0  blue:83/255.0  alpha:1.0];
    _phonenoLabel.textAlignment = NSTextAlignmentRight;
    
    
    [_leftImage addSubview:_phonenoLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, CGRectGetMaxY(_NameLabel.frame) + 8, kDeviceWidth - 38 -16, 14)];
    
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0  blue:181/255.0  alpha:1.0];
//    _addressLabel.textAlignment = NSTextAlignmentRight;
    
    
    [_leftImage addSubview:_addressLabel];
    
    _EditBtn = [[UIButton alloc]initWithFrame:CGRectMake( kDeviceWidth - 22 -35 ,35  ,22, 22)];
    
    _EditBtn.backgroundColor = [UIColor clearColor];
    [_EditBtn setBackgroundImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    
    
    [_leftImage addSubview:_EditBtn];
    
    //    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    //
    //    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    //
    //    [bgView addSubview:lineView];
    
    return bgView;
}


@end
