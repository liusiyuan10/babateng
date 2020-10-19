//
//  QSongCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSongCell.h"
#import "Header.h"

@implementation QSongCell

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
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 50, 50)];
    
    _leftImage.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:_leftImage];
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 15, 26, 100, 14)];
    _labTip.font = [UIFont systemFontOfSize:15.0];
    _labTip.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _labTip.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    [bgView addSubview:_labTip];
    
    //    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX = kDeviceWidth - 175;
    CGFloat  subtitleW = 125;
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 27, subtitleW, 12)];
    //        _subtitleLabel.backgroundColor = [UIColor redColor];
    //    (151,150,149
    _subtitleLabel.font = [UIFont systemFontOfSize:13.0];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_subtitleLabel];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 43, 15, 34, 34)];
    
    arrow.image = [UIImage imageNamed:@"btn_genduo2_nor"];
    //    self.accessoryView = arrow;
    
    [bgView addSubview:arrow];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
