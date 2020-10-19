//
//  AboutCell.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/29.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "AboutCell.h"

#import "Header.h"



@implementation AboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth-40,50)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, (kDeviceWidth-40)/2, 30)];
    _labTip.font = BBT_TWO_FONT;
    _labTip.backgroundColor = [UIColor clearColor];
    _labTip.textColor = [UIColor grayColor]; //[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _labTip.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_labTip];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-40)/2, 10, (kDeviceWidth-40)/2-40, 30)];
    _subtitleLabel.font = BBT_THREE_FONT;
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor grayColor];//[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_subtitleLabel];
    
    
//    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellDetail.png"]];
//    self.accessoryView = arrow;
//    
//    [bgView addSubview:arrow];
    
    return bgView;
}


@end
