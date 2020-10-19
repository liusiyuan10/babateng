//
//  SyncEnglishCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/10/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "SyncEnglishCell.h"
#import "Header.h"

@implementation SyncEnglishCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,132)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 100, 100)];
    
//    _leftImage.backgroundColor = [UIColor lightGrayColor];
//    SyncEnglishimage
//    _leftImage.image = [UIImage imageNamed:@"SyncEnglishimage"];
    
    _leftImage.layer.cornerRadius = 10.0;
    _leftImage.clipsToBounds = YES;
    [bgView addSubview:_leftImage];
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 17, 32, 200, 16)];
    _labTip.font = [UIFont systemFontOfSize:16.0];
    _labTip.backgroundColor = [UIColor clearColor];

    _labTip.textColor = [UIColor colorWithRed:33/255.0 green:18/255.0 blue:4/255.0 alpha:1.0];
    [bgView addSubview:_labTip];
    

    _beginLearnBtn = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_labTip.frame) + 25, 103, 32)];
    _beginLearnBtn.backgroundColor = [UIColor orangeColor];
    _beginLearnBtn.contentMode = UIViewContentModeScaleAspectFill;
    [_beginLearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_beginLearnBtn setTitle:@"开始学习" forState:UIControlStateNormal];
    
    _beginLearnBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _beginLearnBtn.layer.cornerRadius = 16.0;
    _beginLearnBtn.clipsToBounds = YES;
    
    [bgView addSubview:_beginLearnBtn];
    

    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
