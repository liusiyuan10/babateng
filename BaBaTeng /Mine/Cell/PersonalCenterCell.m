//
//  PersonalCenterCell.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "PersonalCenterCell.h"
#import "Header.h"
@implementation PersonalCenterCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,80)];
    bgView.backgroundColor = [UIColor clearColor];//CellBackgroundColor;
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12,10, 60, 60)];
    //    _leftImage.image = [UIImage imageNamed:@"ic_touxiang.png"];
    //    [_leftImage.layer setCornerRadius:(_leftImage.frame.size.height/2)];
    //    [_leftImage.layer setMasksToBounds:YES];
    //    [_leftImage setContentMode:UIViewContentModeScaleAspectFill];
    //    [_leftImage setClipsToBounds:YES];
    //    _leftImage.layer.shadowColor = [UIColor blackColor].CGColor;
    //    _leftImage.layer.shadowOffset = CGSizeMake(4, 4);
    
    _leftImage.backgroundColor = [UIColor clearColor];
    
    [bgView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 15, 10, 200, 30)];
    _nameLabel.font = BBT_TWO_FONT;
    _nameLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _nameLabel.textColor = MainFontColorTWO;
    [bgView addSubview:_nameLabel];
    
    _onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 15, 40, 200, 30)];
    _onlineLabel.font = BBT_THREE_FONT;
    _onlineLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _onlineLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:_onlineLabel];
    
    
    //需要画一条横线
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,79.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
    topImageView.image = [UIImage imageNamed:@"line.png"];
    
    [bgView addSubview:topImageView];
    
    
    return bgView;
}



@end
