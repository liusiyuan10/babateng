//
//  MineOneCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MineOneCell.h"
#import "Header.h"

@implementation MineOneCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,125)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 15, 200, 16)];
    NameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    NameLabel.backgroundColor = [UIColor clearColor];
    NameLabel.text = @"我的订单";
    NameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [bgView addSubview:NameLabel];
    
    CGFloat paymentY =  CGRectGetMaxY(NameLabel.frame) + 16;
    CGFloat paymentMW = (kDeviceWidth - 50*4 - 47*2)/3.0;
    
    _paymentlBtn = [[XEMButton alloc]initWithFrame:CGRectMake(47, paymentY, 50, 65)];

    _paymentlBtn.backgroundColor = [UIColor clearColor];
    [_paymentlBtn setImage:[UIImage imageNamed:@"payment"] forState:UIControlStateNormal];
    
    
    [_paymentlBtn setTitle:@"待付款" forState:UIControlStateNormal];
    [_paymentlBtn setTitleColor:[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];

    
    _paymentlBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];


    [bgView addSubview:_paymentlBtn];
    
    _receiveBtn = [[XEMButton alloc]initWithFrame:CGRectMake(47 + paymentMW + 50, paymentY, 50, 65)];

    _receiveBtn.backgroundColor = [UIColor clearColor];
    [_receiveBtn setImage:[UIImage imageNamed:@"Receipt"] forState:UIControlStateNormal];
    
    
    [_receiveBtn setTitle:@"待收货" forState:UIControlStateNormal];
    [_receiveBtn setTitleColor:[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];

    
    _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];


    [bgView addSubview:_receiveBtn];
    
    _completedBtn = [[XEMButton alloc]initWithFrame:CGRectMake(47 + paymentMW * 2 + 50*2, paymentY, 50, 65)];

    _completedBtn.backgroundColor = [UIColor clearColor];
    [_completedBtn setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
    
    
    [_completedBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [_completedBtn setTitleColor:[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];

    
    _completedBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];


    [bgView addSubview:_completedBtn];
    
    _myorderBtn = [[XEMButton alloc]initWithFrame:CGRectMake(47 + paymentMW * 3 + 50*3, paymentY, 50, 65)];

    _myorderBtn.backgroundColor = [UIColor clearColor];
    [_myorderBtn setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
    
    
    [_myorderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_myorderBtn setTitleColor:[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];

    
    _myorderBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];


    [bgView addSubview:_myorderBtn];
    
    
    
    
//    _paymentView = [[UIView alloc] initWithFrame:CGRectMake(47, paymentY, 50, 44)];
//    _paymentView.backgroundColor = [UIColor clearColor];
//
//    [bgView addSubview:_paymentView];
//
//    _paymentlBtn = [[UIButton alloc]initWithFrame:CGRectMake( (50 - 24)/2.0,0 ,24, 24)];
//
//    _paymentlBtn.backgroundColor = [UIColor clearColor];
//    [_paymentlBtn setBackgroundImage:[UIImage imageNamed:@"payment"] forState:UIControlStateNormal];
//
//
//    [_paymentView addSubview:_paymentlBtn];
//
//    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_paymentlBtn.frame) + 8, 50, 8)];
//    paymentLabel.font = [UIFont systemFontOfSize:12.0];
//    paymentLabel.backgroundColor = [UIColor clearColor];
//    paymentLabel.text = @"待付款";
//    paymentLabel.textAlignment = NSTextAlignmentCenter;
//    paymentLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//    [_paymentView addSubview:paymentLabel];
//
    

    
    
//    UIView *receiveView = [[UIView alloc] initWithFrame:CGRectMake(47 + paymentMW + 50, paymentY, 40, 44)];
//    receiveView.backgroundColor = [UIColor clearColor];
//
//    [bgView addSubview:receiveView];
//
//    _receiveBtn = [[UIButton alloc]initWithFrame:CGRectMake( (50 - 24)/2.0,0 ,24, 24)];
//
//    _receiveBtn.backgroundColor = [UIColor clearColor];
//    [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"Receipt"] forState:UIControlStateNormal];
//
//
//    [receiveView addSubview:_receiveBtn];
//
//    UILabel *receiveLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_receiveBtn.frame) + 8, 50, 8)];
//    receiveLabel.font = [UIFont systemFontOfSize:12.0];
//    receiveLabel.backgroundColor = [UIColor clearColor];
//    receiveLabel.text = @"待收货";
//    receiveLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//     receiveLabel.textAlignment = NSTextAlignmentCenter;
//    [receiveView addSubview:receiveLabel];
//
//    UIView *completedView = [[UIView alloc] initWithFrame:CGRectMake(47 + paymentMW * 2 + 50*2, paymentY, 50, 44)];
//    completedView.backgroundColor = [UIColor clearColor];
//
//    [bgView addSubview:completedView];
//
//    _completedBtn = [[UIButton alloc]initWithFrame:CGRectMake( (50 - 24)/2.0,0 ,24, 24)];
//
//    _completedBtn.backgroundColor = [UIColor clearColor];
//    [_completedBtn setBackgroundImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
//
//
//    [completedView addSubview:_completedBtn];
//
//    UILabel *completedLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_completedBtn.frame) + 8, 50, 8)];
//    completedLabel.font = [UIFont systemFontOfSize:12.0];
//    completedLabel.backgroundColor = [UIColor clearColor];
//    completedLabel.text = @"已完成";
//    completedLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//    completedLabel.textAlignment = NSTextAlignmentCenter;
//    [completedView addSubview:completedLabel];
//
//    UIView *myorderView = [[UIView alloc] initWithFrame:CGRectMake(47 + paymentMW * 3 + 50*3, paymentY, 50, 44)];
//    myorderView.backgroundColor = [UIColor clearColor];
//
//    [bgView addSubview:myorderView];
//
//    _myorderBtn = [[UIButton alloc]initWithFrame:CGRectMake( (50 - 24)/2.0,0 ,24, 24)];
//
//    _myorderBtn.backgroundColor = [UIColor clearColor];
//    [_myorderBtn setBackgroundImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
//
//
//    [myorderView addSubview:_myorderBtn];
//
//    UILabel *myorderLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_myorderBtn.frame) + 8, 50, 8)];
//    myorderLabel.font = [UIFont systemFontOfSize:12.0];
//    myorderLabel.backgroundColor = [UIColor clearColor];
//    myorderLabel.text = @"我的订单";
//    myorderLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//    myorderLabel.textAlignment = NSTextAlignmentCenter;
//    [myorderView addSubview:myorderLabel];
    
    
    

    
    return bgView;
}


@end
