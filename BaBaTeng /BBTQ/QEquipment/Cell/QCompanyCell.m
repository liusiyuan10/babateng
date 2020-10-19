//
//  QCompanyCell.m
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
#import "QCompanyCell.h"

#import "Header.h"

@implementation QCompanyCell

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
        [self.contentView addSubview:cellView];
        
    }
    return self;
}


-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,65)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake( 19, 5, 90, 14+40)];
    _labTip.font = [UIFont systemFontOfSize:15.0];
    _labTip.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _labTip.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_labTip];
    
    //    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX = kDeviceWidth - 195;
    CGFloat  subtitleW = 159+20;
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 8, subtitleW, 11+40)];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
   // _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_subtitleLabel];
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 64.5, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}



@end

