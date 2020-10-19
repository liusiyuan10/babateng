//
//  BuyCourseCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BuyCourseCell.h"
#import "Header.h"

@implementation BuyCourseCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, 72 + 20)];
//    bgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:240/255.0 alpha:1.0];
    bgView.backgroundColor = [UIColor whiteColor];
    
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,8, kDeviceWidth,84)];
//    backView.backgroundColor = [UIColor whiteColor];
//
//    [bgView addSubview:backView];
    
    _courseBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 20, kDeviceWidth - 24, 72)];
    
    [_courseBtn setBackgroundImage:[UIImage imageNamed:@"buyselectnor"] forState:UIControlStateNormal];
    [_courseBtn setBackgroundImage:[UIImage imageNamed:@"buyselectsel"] forState:UIControlStateSelected];
    [_courseBtn setBackgroundImage:[UIImage imageNamed:@"buyselectsel"] forState:UIControlStateHighlighted];
    [bgView addSubview:_courseBtn];
    
    _packageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 60, 28)];
    
    _packageLabel.textColor = [UIColor blackColor];
    _packageLabel.font = [UIFont boldSystemFontOfSize:18];
    //    _amountLabel.text = @"2500元";
    _packageLabel.textAlignment = NSTextAlignmentLeft;
    _packageLabel.backgroundColor = [UIColor clearColor];
    
    [_courseBtn addSubview:_packageLabel];
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_packageLabel.frame) + 4 , 14, 150, 28)];
    
    _amountLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    _amountLabel.font = [UIFont systemFontOfSize:20];
    _amountLabel.text = @"2500元";
    _amountLabel.textAlignment = NSTextAlignmentLeft;
    _amountLabel.backgroundColor = [UIColor clearColor];
    
    [_courseBtn addSubview:_amountLabel];
    
    _discountImageview = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_amountLabel.frame), 21, 35, 15)];
    
    _discountImageview.image = [UIImage imageNamed:@"buycourseyh"];
    _discountImageview.hidden = YES;
    
    [_courseBtn addSubview:_discountImageview];
    
    _EveryamountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 24 - 12 - 150, 14, 150, 28)];
    _EveryamountLabel.font = [UIFont boldSystemFontOfSize:20];
    _EveryamountLabel.backgroundColor = [UIColor clearColor];
    _EveryamountLabel.textColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:5/255.0 alpha:1.0];
    _EveryamountLabel.text = @"¥38.5/次";
    _EveryamountLabel.textAlignment = NSTextAlignmentRight;
    
    [_courseBtn addSubview:_EveryamountLabel];
    
    

    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_amountLabel.frame) + 1,200, 14)];
    
    _numLabel.font = [UIFont systemFontOfSize:10];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _numLabel.text = @"65次(6个月)";
    _numLabel.textAlignment = NSTextAlignmentLeft;
    
    [_courseBtn addSubview:_numLabel];
    
    
    _givingnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 24 - 100 - 12, CGRectGetMaxY(_EveryamountLabel.frame) + 2, 100, 14)];
    
    _givingnumLabel.font = [UIFont systemFontOfSize:10];
    _givingnumLabel.backgroundColor = [UIColor clearColor];
    _givingnumLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _givingnumLabel.text = @"赠65次";
    _givingnumLabel.textAlignment = NSTextAlignmentRight;
    
    [_courseBtn addSubview:_givingnumLabel];
    
    
    
    return bgView;
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    self.courseBtn.selected = selected;
//    
//
//    
//}


@end
