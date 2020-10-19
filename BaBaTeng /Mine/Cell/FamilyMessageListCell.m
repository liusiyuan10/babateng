//
//  FamilyMessageListCell.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "FamilyMessageListCell.h"

#import "Header.h"

@implementation FamilyMessageListCell

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
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, (kDeviceWidth-20)-16, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = MainFontColor;
    _nameLabel.text = @"巴巴腾6459邀请我加入哈哈哈的群组";
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [container addSubview:_nameLabel];
    
    

    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, (kDeviceWidth-20)-8-8, 45)];
    _subNameLabel.font = [UIFont systemFontOfSize:14];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor grayColor];
    _subNameLabel.textAlignment = NSTextAlignmentLeft;
    _subNameLabel.text = @"附言:我是巴巴腾2345";
    _subNameLabel.numberOfLines = 0;
    

    [container addSubview:_subNameLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 105, (kDeviceWidth-16-20)/2, 20)];
    _stateLabel.font = [UIFont systemFontOfSize:14];
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.textColor = [UIColor redColor];
    _stateLabel.text = @"等待回应";
    _stateLabel.numberOfLines = 0;
    _stateLabel.textAlignment = NSTextAlignmentLeft;
    [container addSubview:_stateLabel];
    
    _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-16-20)/2+8, 105,(kDeviceWidth-16-20)/2, 20)];
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
