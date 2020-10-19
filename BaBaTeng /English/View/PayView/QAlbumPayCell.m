//
//  QAlbumPayCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2017/12/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QAlbumPayCell.h"
#import "Header.h"

@implementation QAlbumPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *cellView = [self contentViewCell];
        
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

- (UIView*)contentViewCell
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,66)];
    bgView.backgroundColor = [UIColor whiteColor];

    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 36, 36)];
//    self.iconImageView.backgroundColor = [UIColor redColor];
    
    [bgView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 16, 22, 100, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
//    self.nameLabel.text = @"支付宝";
    self.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    [bgView addSubview:self.nameLabel];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 36, 21, 24, 24)];
//    self.selectImageView.backgroundColor = [UIColor redColor];
    self.selectImageView.image = [UIImage imageNamed:@"icon_Choice_sel"];
    
    [bgView addSubview:self.selectImageView];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, kDeviceWidth, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    
    
    return bgView;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    NSLog(@"selected12345==== %hhd",selected);

     self.selectImageView.image = selected?[UIImage imageNamed:@"icon_Choice_sel"]:[UIImage imageNamed:@"icon_Choice_nor"];


}

@end
