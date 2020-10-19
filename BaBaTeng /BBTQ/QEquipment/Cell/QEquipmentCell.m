//
//  QEquipmentCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import "QEquipmentCell.h"
//
//@implementation QEquipmentCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end


#import "QEquipmentCell.h"
#import "Header.h"



@implementation QEquipmentCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,50)];
//    NSLog(@"cell的高度%f" );
    bgView.backgroundColor = [UIColor whiteColor];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 14, 22, 22)];
    //    _leftImage.image = [UIImage imageNamed:@"ic_touxiang.png"];
    [_leftImage.layer setCornerRadius:(_leftImage.frame.size.height/2)];
    [_leftImage.layer setMasksToBounds:YES];
    [_leftImage setContentMode:UIViewContentModeScaleAspectFill];
    [_leftImage setClipsToBounds:YES];
    _leftImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _leftImage.layer.shadowOffset = CGSizeMake(4, 4);
    
    _leftImage.userInteractionEnabled = YES;
    //    _leftImage.backgroundColor = [UIColor orangeColor];
    
    [bgView addSubview:_leftImage];
    
    _labTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 14, 18, 100, 14)];
    _labTip.font = [UIFont systemFontOfSize:15.0];
    _labTip.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _labTip.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_labTip];
    
    //    CGFloat  subtitleX = CGRectGetMaxX(_labTip.frame) + 90;
    CGFloat  subtitleX = kDeviceWidth - 144 - 40;
    CGFloat  subtitleW = 140;
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, 0, subtitleW, 13+36)];
    // _subtitleLabel.backgroundColor = [UIColor redColor];
    
    _subtitleLabel.font = [UIFont systemFontOfSize:13];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    _subtitleLabel.numberOfLines =0;
    [bgView addSubview:_subtitleLabel];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 34, 12, 22, 26)];
    
    arrow.image = [UIImage imageNamed:@"btn_genduo2_nor"];
    //    self.accessoryView = arrow;
    
    [bgView addSubview:arrow];
    
    self.arrow = arrow;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 49.5, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    return bgView;
}

@end
