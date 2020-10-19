//
//  DeviceMessageListCell.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "DeviceMessageListCell.h"

@implementation DeviceMessageListCell

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
        cellView.backgroundColor = [UIColor clearColor];
        [self.contentView setBackgroundColor:[UIColor clearColor]];// = [UIColor redColor];
        [self.contentView addSubview:cellView];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,120)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-200)/2, 10, 200, 20)];
    _dateLabel.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:98.0/255 green:96.0/255 blue:45.0/255 alpha:0.5f];
    _dateLabel.layer.cornerRadius = 3;
    _dateLabel.clipsToBounds = YES;
    _dateLabel.font = [UIFont systemFontOfSize:13];
    //_dateLabel.text = @"2017年12月25日";
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_dateLabel];
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10,35, kDeviceWidth-20,70)];
    container.layer.borderWidth = 1.5f;
    container.layer.cornerRadius = 10;
    container.layer.borderColor = [UIColor whiteColor].CGColor;
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:container];
    
    
    
    
    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, (kDeviceWidth-20)-8-8, 55)];
    _subNameLabel.font = [UIFont systemFontOfSize:14];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor grayColor];
    _subNameLabel.textAlignment = NSTextAlignmentLeft;
   // _subNameLabel.text = @"小巴分享成功,用户巴巴腾12345已经加入家庭圈小巴分享成功.小巴分享成功,用户巴巴腾12345已经加入家庭圈小巴分享成功.";
    _subNameLabel.numberOfLines = 0;
    
    //    CGSize size = [_subNameLabel sizeThatFits:CGSizeMake(_subNameLabel.frame.size.width, MAXFLOAT)];
    //    if(size.height>80){
    //        _subNameLabel.frame = CGRectMake(_subNameLabel.frame.origin.x, _subNameLabel.frame.origin.y, _subNameLabel.frame.size.width,            80);
    //    }else{
    //
    //    _subNameLabel.frame = CGRectMake(_subNameLabel.frame.origin.x, _subNameLabel.frame.origin.y, _subNameLabel.frame.size.width,            size.height);
    //    }
    [container addSubview:_subNameLabel];
    
    

    
    return bgView;
}


@end
