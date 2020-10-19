//
//  BBTOrderThreeCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "BBTOrderThreeCell.h"
#import "Header.h"


@implementation BBTOrderThreeCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,60 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,60)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, 25, 250, 12)];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"可用1000知识豆抵扣10元";
    _titleLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:1.0];
    [backView addSubview:_titleLabel];
    
    
    _chickBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 32 - 21 - 17,20,21, 21)];
    [_chickBtn setImage:[UIImage imageNamed:@"shopunchoose"] forState:UIControlStateNormal];
    
    [_chickBtn setImage:[UIImage imageNamed:@"shopchoose"] forState:UIControlStateSelected];

//    [_chickBtn addTarget:self action:@selector(chickBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:_chickBtn];
    return bgView;
}


//- (void)chickBtnClicked:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//
//    if (btn.selected) {
//      NSLog(@"ssssss");
//    }
//    else
//    {
//        NSLog(@"llllllll");
//    }
//
//}



@end
