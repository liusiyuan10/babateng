//
//  HDMyFriendCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/5/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "HDMyFriendCell.h"
#import "Header.h"

@implementation HDMyFriendCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,86)];
    bgView.backgroundColor = [UIColor whiteColor];
    
//    CGFloat backViewW = kDeviceWidth - 32;
//
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,0, kDeviceWidth - 32, 60)];
//    backView.backgroundColor = [UIColor colorWithRed:18/255.0 green:25/255.0 blue:92/255.0 alpha:0.5];
//
//    backView.layer.cornerRadius= 10.0f;
//
//    backView.clipsToBounds = YES;//去除边界
//    backView.layer.masksToBounds = YES;
//
//    [bgView addSubview:backView];
    

    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 27, 200, 14)];
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    
    CGFloat  subtitleX = kDeviceWidth - 120-32 -16;
    CGFloat  subtitleW = 200;
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, CGRectGetMaxY(_nameLabel.frame) + 10, subtitleW, 11)];
    
    _phoneLabel.font = [UIFont systemFontOfSize:11.0];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.textColor = [UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [bgView addSubview:_phoneLabel];
    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 80- 35 , (86 - 13)/2.0,80, 13)];

    _subNameLabel.font = [UIFont systemFontOfSize:14.0];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    _subNameLabel.textAlignment = NSTextAlignmentRight;


    [bgView addSubview:_subNameLabel];
    
    _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 7- 16,   (86 - 12)/2.0, 7,12)];
    
    _arrowImage.image = [UIImage imageNamed:@"PanetMine_back"];
    
    [bgView addSubview:_arrowImage];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 85, kDeviceWidth - 16, 1.0)];

    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];

    [bgView addSubview:lineView];
    
    return bgView;
}

@end
