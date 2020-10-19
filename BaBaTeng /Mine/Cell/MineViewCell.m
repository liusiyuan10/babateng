//
//  MineViewCell.m
//  BaBaTeng
//
//  Created by liu on 16/10/20.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "MineViewCell.h"
#import "Header.h"



@implementation MineViewCell

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
        
    }
    return self;
}


-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,60)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 40, 40)];
//    _leftImage.image = [UIImage imageNamed:@"ic_touxiang.png"];
    [_leftImage.layer setCornerRadius:(_leftImage.frame.size.height/2)];
    [_leftImage.layer setMasksToBounds:YES];
    [_leftImage setContentMode:UIViewContentModeScaleAspectFill];
    [_leftImage setClipsToBounds:YES];
    _leftImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _leftImage.layer.shadowOffset = CGSizeMake(4, 4);

    _leftImage.userInteractionEnabled = YES;
    _leftImage.backgroundColor = [UIColor orangeColor];
    
    [bgView addSubview:_leftImage];
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 40)];
    _labTip.font = [UIFont systemFontOfSize:15];
    _labTip.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _labTip.textColor = [UIColor darkGrayColor];
    [bgView addSubview:_labTip];
    
//    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX = kDeviceWidth - 100;
    CGFloat  subtitleW = 100;
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 10, subtitleW, 40)];
    //        _subtitleLabel.backgroundColor = [UIColor redColor];
    
    _subtitleLabel.font = [UIFont systemFontOfSize:15];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
//    _subtitleLabel.textColor = [UIColor light_Gray_Color];
//    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_subtitleLabel];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellDetail.png"]];
    self.accessoryView = arrow;
    
    [bgView addSubview:arrow];
    
    return bgView;
}



//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    
//}

@end
