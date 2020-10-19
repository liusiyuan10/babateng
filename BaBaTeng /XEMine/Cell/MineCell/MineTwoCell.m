//
//  MineTwoCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MineTwoCell.h"
#import "Header.h"

@implementation MineTwoCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,90)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,0, kDeviceWidth - 32,90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    CGFloat ViewW = (kDeviceWidth - 32 - 2)/3.0;
    
    _SeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewW, 90)];
    _SeeView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:_SeeView];
    
    _SeeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
    _SeeLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _SeeLabel.backgroundColor = [UIColor clearColor];
    _SeeLabel.text = @"34.34";
    _SeeLabel.textAlignment = NSTextAlignmentCenter;
    _SeeLabel.textColor = MNavBackgroundColor;
    [_SeeView addSubview:_SeeLabel];
    
    UILabel *SeesubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_SeeLabel.frame) + 10, ViewW, 12)];
    SeesubLabel.font = [UIFont systemFontOfSize:12.0];
    SeesubLabel.backgroundColor = [UIColor clearColor];
    SeesubLabel.text = @"see币";
    SeesubLabel.textAlignment = NSTextAlignmentCenter;
    SeesubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [_SeeView addSubview:SeesubLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW, 18, 1.0, 90 - 18 -16 )];

    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];

    [backView addSubview:lineView];
    
    _SmallTwoView = [[UIView alloc] initWithFrame:CGRectMake(ViewW + 1, 0, ViewW, 90)];
    _SmallTwoView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:_SmallTwoView];
    
    _SmallTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
    _SmallTwoLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _SmallTwoLabel.backgroundColor = [UIColor clearColor];
    _SmallTwoLabel.text = @"12.02";
    _SmallTwoLabel.textAlignment = NSTextAlignmentCenter;
    _SmallTwoLabel.textColor = [UIColor colorWithRed:240/255.0 green:171/255.0 blue:63/255.0 alpha:1.0];
    [_SmallTwoView addSubview:_SmallTwoLabel];
    
    UILabel *SmallTwosubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_SmallTwoLabel.frame) + 10, ViewW, 12)];
    SmallTwosubLabel.font = [UIFont systemFontOfSize:12.0];
    SmallTwosubLabel.backgroundColor = [UIColor clearColor];
    SmallTwosubLabel.text = @"小二币";
    SmallTwosubLabel.textAlignment = NSTextAlignmentCenter;
    SmallTwosubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [_SmallTwoView addSubview:SmallTwosubLabel];
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW * 2 + 1, 18, 1.0, 90 - 18 -16 )];
    
    line1View.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:line1View];
    
    _walletView = [[UIView alloc] initWithFrame:CGRectMake( (ViewW + 1) *2, 0, ViewW, 90)];
    _walletView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:_walletView];
    
    UIButton *walletBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 22)/2.0, 24 ,22, 21)];
    
    walletBtn.backgroundColor = [UIColor clearColor];
    [walletBtn setBackgroundImage:[UIImage imageNamed:@"wallet"] forState:UIControlStateNormal];
    
    
    [_walletView addSubview:walletBtn];

    
//    _SmallTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
//    _SmallTwoLabel.font = [UIFont boldSystemFontOfSize:18.0];
//    _SmallTwoLabel.backgroundColor = [UIColor clearColor];
//    _SmallTwoLabel.text = @"12.02";
//    _SmallTwoLabel.textAlignment = NSTextAlignmentCenter;
//    _SmallTwoLabel.textColor = [UIColor colorWithRed:240/255.0 green:171/255.0 blue:63/255.0 alpha:1.0];
//    [walletView addSubview:_SmallTwoLabel];
    
    UILabel *walletsubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_SmallTwoLabel.frame) + 10, ViewW, 12)];
    walletsubLabel.font = [UIFont systemFontOfSize:12.0];
    walletsubLabel.backgroundColor = [UIColor clearColor];
    walletsubLabel.text = @"我的钱包";
    walletsubLabel.textAlignment = NSTextAlignmentCenter;
    walletsubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [_walletView addSubview:walletsubLabel];
    
    return bgView;
    
}
@end
