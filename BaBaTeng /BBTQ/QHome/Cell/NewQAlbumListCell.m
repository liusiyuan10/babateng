//
//  NewQAlbumListCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "NewQAlbumListCell.h"
#import "Header.h"

@implementation NewQAlbumListCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,118)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 18, 81, 81)];
    _leftImage.layer.cornerRadius = 15.0;
    _leftImage.layer.masksToBounds = YES;
    
    _leftImage.layer.borderWidth = 1.0;
    _leftImage.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    //    self.selerListImage.layer.borderColor = [UIColor redColor].CGColor;
    _leftImage.clipsToBounds = YES;//去除边界
    
    _leftImage.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:_leftImage];
    
    _trackListNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 15, 36, kDeviceWidth -CGRectGetMaxX(_leftImage.frame) - 15 - 10, 17)];
    _trackListNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _trackListNameLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _trackListNameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_trackListNameLabel];
    
    //    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX = CGRectGetMaxX(_leftImage.frame) + 15;
    CGFloat  subtitleW = kDeviceWidth - subtitleX - 10;
    _trackListDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_trackListNameLabel.frame), subtitleW, 40)];

    _trackListDescriptionLabel.font = [UIFont systemFontOfSize:14.0];
    _trackListDescriptionLabel.backgroundColor = [UIColor clearColor];
    _trackListDescriptionLabel.textColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0];
    _trackListDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    _trackListDescriptionLabel.numberOfLines = 0;
    [bgView addSubview:_trackListDescriptionLabel];
    
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
