//
//  OrderDetailThreeCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "OrderDetailThreeCell.h"
#import "Header.h"


@implementation OrderDetailThreeCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,62 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,62)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    _ordernoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17,backViewW - 17, 12)];
    
    _ordernoLabel.font = [UIFont systemFontOfSize:12.0];
    _ordernoLabel.backgroundColor = [UIColor clearColor];
    _ordernoLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _ordernoLabel.text = @"订单编号：DJG154631646164613";
    _ordernoLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_ordernoLabel];
    
    
    _ordertimeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(_ordernoLabel.frame) + 6 ,backViewW - 17, 12)];
    
    _ordertimeLabel.font = [UIFont systemFontOfSize:12.0];
    _ordertimeLabel.backgroundColor = [UIColor clearColor];
    _ordertimeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _ordertimeLabel.text = @"订单时间：2018-10-26 08:37:22";
    _ordertimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_ordertimeLabel];
    
    return bgView;
}
@end
