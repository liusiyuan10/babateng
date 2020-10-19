//
//  XEMallOrderOneCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMallOrderOneCell.h"
#import "Header.h"

@implementation XEMallOrderOneCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,90 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17, 150, 17)];
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
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_NameLabel.frame) + 11, kDeviceWidth - 38 -16 - 40, 40)];
    
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0  blue:181/255.0  alpha:1.0];
    //    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.numberOfLines = 0;
    
    [backView addSubview:_addressLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 32 - 26 - 17 , 39, 22, 26)];
    
    arrow.image = [UIImage imageNamed:@"btn_genduo2_nor"];
    //    self.accessoryView = arrow;
//    arrow.backgroundColor = [UIColor redColor];
    
    [backView addSubview:arrow];
    
    
    //    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    //
    //    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    //
    //    [bgView addSubview:lineView];
    
    return bgView;
}


@end
