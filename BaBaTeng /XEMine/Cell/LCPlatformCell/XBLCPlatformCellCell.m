//
//  XBLCPlatformCellCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/30.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBLCPlatformCellCell.h"

#import "Header.h"

@implementation XBLCPlatformCellCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,153 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, backViewW,153)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 23, 23,200, 16)];
    
    _priceLabel.font = [UIFont systemFontOfSize:21.0];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _priceLabel.text = @"￥198";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_priceLabel];
    
    _platformStaueLabel = [[UILabel alloc] initWithFrame:CGRectMake( backViewW - 80 -21, 21,80, 20)];
    
    _platformStaueLabel.font = [UIFont boldSystemFontOfSize:21.0];
    _platformStaueLabel.backgroundColor = [UIColor clearColor];
    _platformStaueLabel.textColor = MNavBackgroundColor;
    _platformStaueLabel.text = @"未激活 ";
    _platformStaueLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:_platformStaueLabel];
    
    _CardLabel = [[UILabel alloc] initWithFrame:CGRectMake( 22, CGRectGetMaxY(_platformStaueLabel.frame) + 24,200, 13)];
    
    _CardLabel.font = [UIFont systemFontOfSize:14.0];
    _CardLabel.backgroundColor = [UIColor clearColor];
    _CardLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _CardLabel.text = @"卡号";
    _CardLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_CardLabel];

    
    _CardNoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 21, CGRectGetMaxY(_CardLabel.frame) + 9,backViewW - 21*2, 14)];
    
    _CardNoLabel.font = [UIFont systemFontOfSize:18.0];
    _CardNoLabel.backgroundColor = [UIColor clearColor];
    _CardNoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _CardNoLabel.text = @"453320589741023501";
    _CardNoLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_CardNoLabel];
    
    
    
    _ClassNoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 21, CGRectGetMaxY(_CardNoLabel.frame) + 21, 100, 13)];
    
    _ClassNoLabel.font = [UIFont systemFontOfSize:14.0];
    _ClassNoLabel.backgroundColor = [UIColor clearColor];
    _ClassNoLabel.textColor =  [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _ClassNoLabel.text = @"课时数：5节";
    _ClassNoLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_ClassNoLabel];
    
    _ValidityLabel = [[UILabel alloc] initWithFrame:CGRectMake( backViewW - 200 -21, CGRectGetMaxY(_CardNoLabel.frame) + 21, 200, 13)];
    
    _ValidityLabel.font = [UIFont systemFontOfSize:14.0];
    _ValidityLabel.backgroundColor = [UIColor clearColor];
    _ValidityLabel.textColor =  [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _ValidityLabel.text = @"课程有效期：2019-2-2";
    _ValidityLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:_ValidityLabel];
   
    return bgView;
}


@end
