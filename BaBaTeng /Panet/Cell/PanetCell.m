//
//  PanetCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/26.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetCell.h"
#import "Header.h"

@implementation PanetCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,106)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 18, kDeviceWidth - 32, 90)];

    _leftImage.userInteractionEnabled = YES;
    
    [bgView addSubview:_leftImage];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 31, 26, 200, 17)];
    _NameLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _NameLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _NameLabel.textColor = [UIColor whiteColor];
    [_leftImage addSubview:_NameLabel];
    
    //    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX =31;
    CGFloat  subtitleW = 250;
    
    _DescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_NameLabel.frame) + 8, subtitleW, 12)];
    
    _DescriptionLabel.font = [UIFont systemFontOfSize:12.0];
    _DescriptionLabel.backgroundColor = [UIColor clearColor];
    _DescriptionLabel.textColor = [UIColor whiteColor];
    _DescriptionLabel.textAlignment = NSTextAlignmentLeft;
//    _DescriptionLabel.numberOfLines = 0;
    [_leftImage addSubview:_DescriptionLabel];
    
    
    
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
//
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//
//    [bgView addSubview:lineView];
    
    return bgView;
}

@end
