//
//  PanetMineSetingCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XESetingCell.h"
#import "Header.h"

@implementation XESetingCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,87)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 87)];
    
    _leftImage.userInteractionEnabled = YES;
    //
    _leftImage.image = [UIImage imageNamed:@"PanetMine_Setting_bg"];
    [bgView addSubview:_leftImage];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 38, 46 - 10.5, 100, 17)];
    _NameLabel.font = [UIFont systemFontOfSize:16.0];
    _NameLabel.backgroundColor = [UIColor clearColor];
    
    _NameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0  blue:83/255.0  alpha:1.0];
    [_leftImage addSubview:_NameLabel];
    
    
    
    _switchview = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth - 38 - 49, 39 - 10.5, 49, 32)];
    _switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
    
    _switchview.on = YES;
    _switchview.hidden = YES;
    
//    [_switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
   
    [_leftImage addSubview:_switchview];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 50 - 38, 28+10.5,50 , 11)];
    
    _subLabel.font = [UIFont systemFontOfSize:11.0];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.textColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1.0];
    _subLabel.textAlignment = NSTextAlignmentRight;
    _subLabel.text = @"未设置";
    _subLabel.hidden = YES;
    
    [_leftImage addSubview:_subLabel];
  


    
    return bgView;
}
@end
