//
//  ExperienceCollectionViewCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/21.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "ExperienceCollectionViewCell.h"
#import "Header.h"
#import "UILabel+LXAdd.h"

@implementation ExperienceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *cellView = [self contentViewCell];

        [self.contentView addSubview:cellView];
        
        
    }
    
    return self;
}


-(UIView*)contentViewCell{
    

    CGFloat bgViewW = kDeviceWidth - 100;
    
    if (kDevice_IS_PAD) {
        bgViewW = kDeviceWidth - 200;
    }
    CGFloat bgViewH = KDeviceHeight - 260 - kDevice_IsE_iPhoneX;
    
    if (kDevice_IS_PAD) {
        bgViewH = KDeviceHeight - 300 - kDevice_IsE_iPhoneX;
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0,  bgViewW ,bgViewH)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0,52,  bgViewW ,bgViewH - 52)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 15; //设置图片圆角的尺度
    _backView.layer.masksToBounds = YES; //没这句话它圆不起来

    
    [_backView.layer setBorderWidth:2.0];
    [_backView.layer setBorderColor:[UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0f].CGColor];
    
    [bgView addSubview:_backView];
    
//    bgView.layer.masksToBounds = YES; //没这句话它圆不起来
//    bgView.layer.cornerRadius = 15; //设置图片圆角的尺度
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgViewW - 104)/2.0, 0, 104, 104)];
    
    _iconImageView.userInteractionEnabled = YES;
    
    _iconImageView.layer.cornerRadius = 52; //设置图片圆角的尺度
    _iconImageView.layer.borderWidth = 1.0;
    _iconImageView.layer.borderColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0].CGColor;
    _iconImageView.clipsToBounds = YES;//去除边界
    _iconImageView.layer.masksToBounds = YES; //没这句话它圆不起来

    
    [bgView addSubview:_iconImageView];
    
    _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame) + 21, bgViewW, 14)];
    
    _teacherLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _teacherLabel.backgroundColor = [UIColor clearColor];

    _teacherLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _teacherLabel.textAlignment = NSTextAlignmentCenter;
//    _teacherLabel.text = @"Teacher";

    [_backView addSubview:_teacherLabel];
    
    UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(21 , CGRectGetMaxY(_teacherLabel.frame) + 42, 120, 13)];
    
    experienceLabel.font = [UIFont systemFontOfSize:14.0];
    experienceLabel.backgroundColor = [UIColor clearColor];
    
    experienceLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    experienceLabel.textAlignment = NSTextAlignmentLeft;
    experienceLabel.text = @"剩余可预约课程";
    
    [_backView addSubview:experienceLabel];
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgViewW - 52, CGRectGetMaxY(_teacherLabel.frame) + 42, 30, 11)];

    _noLabel.font = [UIFont systemFontOfSize:14.0];
    _noLabel.backgroundColor = [UIColor clearColor];
    _noLabel.textColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    _noLabel.textAlignment = NSTextAlignmentRight;

    [_backView addSubview:_noLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  CGRectGetMaxY(_noLabel.frame) + 21, bgViewW - 32,0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    [_backView addSubview:lineView];
    
    //计算label的宽高
    
    
    _descLabel = [[UILabel alloc] init];
//    [[UILabel alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(lineView.frame) + 17, bgViewW - 46, 100)];
//    CGRect h =  [_descLabel getLableHeightWithMaxWidth:300];
    
    _descLabel.frame = CGRectMake(23, CGRectGetMaxY(lineView.frame) + 17, bgViewW - 46, 100);
    
    _descLabel.font = [UIFont systemFontOfSize:13.0];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    _descLabel.textAlignment = NSTextAlignmentLeft;
    _descLabel.numberOfLines = 0;
//        lab.frame=CGRectMake( self.padding, CGRectGetMaxY(self.registerBtn.frame)+10, kDeviceWidth - self.padding*2, h.size.height+30);
    
    _descLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [_backView addSubview:_descLabel];

    
//    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_iconImageView.frame) + 25, 108, 16)];
//    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
//    _nameLabel.backgroundColor = [UIColor clearColor];
//
//    _nameLabel.textColor = [UIColor colorWithRed:249/255.0 green:156/255.0 blue:30/255.0 alpha:1.0];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
//
//    [bgView addSubview:_nameLabel];
//
//    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 8, 108, 11)];
//
//    _noLabel.font = [UIFont systemFontOfSize:10.0];
//    _noLabel.backgroundColor = [UIColor clearColor];
//    _noLabel.textColor = [UIColor colorWithRed:175/255.0 green:174/255.0 blue:173/255.0 alpha:1.0];
//    _noLabel.textAlignment = NSTextAlignmentCenter;
//
//    [bgView addSubview:_noLabel];
    
    return bgView;
}



@end
