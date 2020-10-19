//
//  XEReceiveCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEReceiveCell.h"
#import "Header.h"

@implementation XEReceiveCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,241 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,241)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    _orderStaueLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17,260, 14)];
    
    _orderStaueLabel.font = [UIFont systemFontOfSize:14.0];
    _orderStaueLabel.backgroundColor = [UIColor clearColor];
    _orderStaueLabel.textColor = MNavBackgroundColor;
    _orderStaueLabel.text = @"等待买家收货";
    _orderStaueLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_orderStaueLabel];
    
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(_orderStaueLabel.frame) + 16,100, 100)];
    _leftImage.userInteractionEnabled = YES;
    _leftImage.backgroundColor = [UIColor clearColor];
    
    
    _leftImage.image = [UIImage imageNamed:@"order_image_empty"];
    
    _leftImage.layer.cornerRadius= 5.0f;
    
    
    
    _leftImage.layer.masksToBounds = YES;
    
    [backView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, 59,kDeviceWidth - 32 -CGRectGetMaxX(_leftImage.frame) - 16, 40)];
    
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    _nameLabel.text = @"晓宝在线少儿英语套餐1";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 0;
    [backView addSubview:_nameLabel];
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) , CGRectGetMaxY(_leftImage.frame) + 21 ,65, 11)];
    
    _totalLabel.font = [UIFont systemFontOfSize:12.0];
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _totalLabel.text = @"共2件商品";
    _totalLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:_totalLabel];
    
    
    UILabel *combinedLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_totalLabel.frame) + 8, CGRectGetMaxY(_leftImage.frame) + 21 ,45, 11)];
    
    combinedLabel.font = [UIFont systemFontOfSize:12.0];
    combinedLabel.backgroundColor = [UIColor clearColor];
    combinedLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    combinedLabel.text = @"实付款:";
    combinedLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:combinedLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(combinedLabel.frame), CGRectGetMaxY(_leftImage.frame) + 18 ,130, 15)];
    
    _priceLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = MNavBackgroundColor;
    _priceLabel.text = @"3600see";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_priceLabel];
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_totalLabel.frame) + 17, backViewW - 32, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    
    _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(lineView.frame) + 6 ,backViewW - 32, 33)];
    _payBtn.backgroundColor = [UIColor clearColor];
    _payBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_payBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    [_payBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    
    //    [_phoneBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
        _payBtn.layer.borderWidth = 1.0f;
    
        _payBtn.layer.borderColor = MNavBackgroundColor.CGColor;
    
    _payBtn.layer.cornerRadius= 5.0f;
    
    _payBtn.clipsToBounds = YES;//去除边界
    
    [backView addSubview:_payBtn];
    
    return bgView;
}


@end
