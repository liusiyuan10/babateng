//
//  PanetMineCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineCell.h"
#import "Header.h"


@implementation PanetMineCell

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
        //        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,61)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 27, 27)];
    
    [bgView addSubview:_leftImage];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, 23, 150, 16)];
    _nameLabel.font = [UIFont systemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    CGFloat  subtitleX =kDeviceWidth - 50 - 35;
    CGFloat  subtitleW = 50;
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 25, subtitleW, 12)];

    _subLabel.font = [UIFont systemFontOfSize:12.0];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.textColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1.0];
    _subLabel.textAlignment = NSTextAlignmentRight;
    _subLabel.text = @"未认证";
    _subLabel.hidden = YES;
    [bgView addSubview:_subLabel];
    
    //    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 80 - 16, 30, 80, 12)];
    //
    //    _noLabel.font = [UIFont boldSystemFontOfSize:15.0];
    //    _noLabel.backgroundColor = [UIColor clearColor];
    //    _noLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    //    _noLabel.textAlignment = NSTextAlignmentRight;
    //
    //    [bgView addSubview:_noLabel];
    

    _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 16 - 12,  25, 7,12)];
    
    _arrowImage.image = [UIImage imageNamed:@"PanetMine_back"];
    
    [bgView addSubview:_arrowImage];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(56,  60.5, kDeviceWidth - 56-16,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
