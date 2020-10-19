//
//  MessageDetailsCell.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "MessageListCell.h"
#import "Header.h"
@implementation MessageListCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,180)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-200)/2, 10, 200, 20)];
    _dateLabel.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:98.0/255 green:96.0/255 blue:45.0/255 alpha:0.5f];
    _dateLabel.layer.cornerRadius = 3;
    _dateLabel.clipsToBounds = YES;
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.text = @"2017年12月25日";
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_dateLabel];
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10,35, kDeviceWidth-20,130)];
    container.layer.borderWidth = 1.5f;
    container.layer.cornerRadius = 10;
    container.layer.borderColor = [UIColor whiteColor].CGColor;
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:container];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, (kDeviceWidth-20)-16, 30)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor orangeColor]; //MainFontColor;
    _nameLabel.text = @"设备分享成功";
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:_nameLabel];

    
//    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 70, 70)];
//    [_leftImage.layer setCornerRadius:(_leftImage.frame.size.height/2)];
//    [_leftImage.layer setMasksToBounds:YES];
//    [_leftImage setContentMode:UIViewContentModeScaleAspectFill];
//    [_leftImage setClipsToBounds:YES];
//    _leftImage.layer.borderWidth = 1.5f;
//    _leftImage.layer.cornerRadius = 8;
//    _leftImage.layer.borderColor = MainFontColor.CGColor;
//    _leftImage.clipsToBounds = YES;
//    _leftImage.backgroundColor = MainFontColor;
//    
//    [container addSubview:_leftImage];

    
    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, (kDeviceWidth-20)-8-8, 55)];
    _subNameLabel.font = [UIFont systemFontOfSize:14];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor grayColor];
    _subNameLabel.textAlignment = NSTextAlignmentLeft;
    _subNameLabel.text = @"小巴分享成功,用户巴巴腾12345已经加入家庭圈小巴分享成功.小巴分享成功,用户巴巴腾12345已经加入家庭圈小巴分享成功.";
    _subNameLabel.numberOfLines = 0;
    
//    CGSize size = [_subNameLabel sizeThatFits:CGSizeMake(_subNameLabel.frame.size.width, MAXFLOAT)];
//    if(size.height>80){
//        _subNameLabel.frame = CGRectMake(_subNameLabel.frame.origin.x, _subNameLabel.frame.origin.y, _subNameLabel.frame.size.width,            80);
//    }else{
//        
//    _subNameLabel.frame = CGRectMake(_subNameLabel.frame.origin.x, _subNameLabel.frame.origin.y, _subNameLabel.frame.size.width,            size.height);
//    }
    [container addSubview:_subNameLabel];
    
    
    
    _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 105, (kDeviceWidth-20)-16, 20)];
    _detailsLabel.font = [UIFont systemFontOfSize:14];
    _detailsLabel.backgroundColor = [UIColor clearColor];
    _detailsLabel.textColor = [UIColor orangeColor];
    _detailsLabel.text = @"查看详情";
    _detailsLabel.numberOfLines = 0;
    _detailsLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:_detailsLabel];
    
    return bgView;
}

@end
