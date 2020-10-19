//
//  XBLearnCardCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBLearnCardCell.h"
#import "Header.h"

@implementation XBLearnCardCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,180 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake( 16 ,16, kDeviceWidth - 32, 180)];

    _iconImageview.image = [UIImage imageNamed:@"studycard"];

    [bgView addSubview:_iconImageview];



    _iconpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth -32 - 150)/2.0 - 30,77 , 150, 27)];

    _iconpriceLabel.font = [UIFont boldSystemFontOfSize:28.0];
    _iconpriceLabel.backgroundColor = [UIColor clearColor];
    _iconpriceLabel.textColor = [UIColor whiteColor];
    _iconpriceLabel.text = @"￥198";
    _iconpriceLabel.textAlignment = NSTextAlignmentCenter;

    [_iconImageview addSubview:_iconpriceLabel];

    _iconcardLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_iconpriceLabel.frame), 88, 120, 16)];

    _iconcardLabel.font = [UIFont systemFontOfSize:16.0];
    _iconcardLabel.backgroundColor = [UIColor clearColor];
    _iconcardLabel.textColor = [UIColor whiteColor];
    _iconcardLabel.text = @"学习卡";
    _iconcardLabel.textAlignment = NSTextAlignmentLeft;

    [_iconImageview addSubview:_iconcardLabel];

    _iconclassNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_iconcardLabel.frame) + 40, 150, 16)];

    _iconclassNoLabel.font = [UIFont systemFontOfSize:16.0];
    _iconclassNoLabel.backgroundColor = [UIColor clearColor];
    _iconclassNoLabel.textColor = [UIColor whiteColor];
    _iconclassNoLabel.text = @"课时数：5节";
    _iconclassNoLabel.textAlignment = NSTextAlignmentLeft;

    [_iconImageview addSubview:_iconclassNoLabel];


    _iconvalidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 200 -21 -32, CGRectGetMaxY(_iconcardLabel.frame) + 40, 200, 16)];

    _iconvalidityLabel.font = [UIFont systemFontOfSize:16.0];
    _iconvalidityLabel.backgroundColor = [UIColor clearColor];
    _iconvalidityLabel.textColor = [UIColor whiteColor];
    _iconvalidityLabel.text = @"有效期：2019-10-12";
    _iconvalidityLabel.textAlignment = NSTextAlignmentRight;

    [_iconImageview addSubview:_iconvalidityLabel];
    
    return bgView;
}




@end
