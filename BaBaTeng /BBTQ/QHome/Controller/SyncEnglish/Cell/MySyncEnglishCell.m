//
//  MySyncEnglishCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/10/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "MySyncEnglishCell.h"
#import "Header.h"

@implementation MySyncEnglishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}



-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,65)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 50, 50)];
    
//    _leftImage.image = [UIImage imageNamed:@""];
//    _leftImage.backgroundColor = [UIColor lightGrayColor];
    _leftImage.image = [UIImage imageNamed:@"SyncEnglishimage_my"];
    [bgView addSubview:_leftImage];
    

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 10, 16, kDeviceWidth -CGRectGetMaxX(_leftImage.frame) - 21  - 40-20, 16)];
    
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    
    [bgView addSubview:_nameLabel];
    
    _timeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 8, 15, 15)];
    _timeView.image = [UIImage imageNamed:@"demandtime"];
    
    [bgView addSubview:_timeView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeView.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 9, kDeviceWidth -CGRectGetMaxX(_leftImage.frame) - 8 - 80 - 40, 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];;
    [bgView addSubview:_timeLabel];
    

    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0] CGColor];
    lineLayer.frame = CGRectMake(14,0, kDeviceWidth - 28, 0.5);
    [bgView.layer addSublayer:lineLayer];
    
    return bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
