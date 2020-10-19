//
//  QClockClueCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockClueCell.h"
#import "Header.h"

@implementation QClockClueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}



-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 64)];
    //    bgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:240/255.0 alpha:1.0];
    bgView.backgroundColor = DefaultBackgroundColor;
    
    //    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,8, kDeviceWidth,84)];
    //    backView.backgroundColor = [UIColor whiteColor];
    //
    //    [bgView addSubview:backView];
    
    _clockclueBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, (64 - 49)/2.0, kDeviceWidth - 24, 49)];
    
    [_clockclueBtn setBackgroundImage:[UIImage imageNamed:@"buyselectnor"] forState:UIControlStateNormal];
    [_clockclueBtn setBackgroundImage:[UIImage imageNamed:@"clock_clue_pre"] forState:UIControlStateHighlighted];
    
    [_clockclueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clockclueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    _clockclueBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bgView addSubview:_clockclueBtn];
    
    
    return bgView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
