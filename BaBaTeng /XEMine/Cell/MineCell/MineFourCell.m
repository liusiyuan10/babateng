//
//  MineFourCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MineFourCell.h"
#import "Header.h"


@implementation MineFourCell

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
    
    CGFloat bgViewH = 118;
    if (kDevice_IS_PAD) {
        bgViewH = 185;
    }
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,bgViewH + 20)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth - 32, bgViewH)];
    
    _iconImageView.userInteractionEnabled = YES;
   
//    _iconImageView.backgroundColor = [UIColor redColor];
    
    
    [bgView addSubview:_iconImageView];
    
    
    return bgView;
}

@end
