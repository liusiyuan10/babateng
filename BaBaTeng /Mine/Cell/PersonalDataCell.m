//
//  PersonalDataCell.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "PersonalDataCell.h"
#import "Header.h"
@implementation PersonalDataCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,60)];
    
    bgView.backgroundColor = [UIColor whiteColor];//CellBackgroundColor;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    [bgView addSubview:_nameLabel];
    

    _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-90, 5, 50, 50)];
    [_rightImage.layer setCornerRadius:(_rightImage.frame.size.height/2)];
    [_rightImage.layer setMasksToBounds:YES];
    [_rightImage setContentMode:UIViewContentModeScaleAspectFill];
    [_rightImage setClipsToBounds:YES];
    _rightImage.layer.borderColor = MainFontColor.CGColor;
    _rightImage.image = [UIImage imageNamed:@"icon_touxian"];
    _rightImage.backgroundColor = [UIColor clearColor];
    _rightImage.hidden = YES;
    [bgView addSubview:_rightImage];
    
    self.sevenSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(kDeviceWidth-90, 15, 70, 30)];
    self.sevenSwitch.offImage = [UIImage imageNamed:@"cross.png"];
    self.sevenSwitch.onImage = [UIImage imageNamed:@"check.png"];
    self.sevenSwitch.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
    self.sevenSwitch.isRounded = YES;
    self.sevenSwitch.hidden = YES;
    [bgView addSubview:self.sevenSwitch];
    [self.sevenSwitch setOn:NO animated:YES];
    
    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-220, 10, 180, 40)];
    _subNameLabel.font = [UIFont systemFontOfSize:14];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor lightGrayColor];
    _subNameLabel.textAlignment = NSTextAlignmentRight;
    _subNameLabel.hidden = YES;
    //_subNameLabel.text = @"23:00-7:00";
    [bgView addSubview:_subNameLabel];
    
    
    //需要画一条横线
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,59.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
    topImageView.image = [UIImage imageNamed:@"line.png"];
    
    [bgView addSubview:topImageView];
    
    
    
    return bgView;
}

@end
