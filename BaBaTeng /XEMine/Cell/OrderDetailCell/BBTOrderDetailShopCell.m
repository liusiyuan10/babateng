//
//  BBTOrderDetailShopCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/12.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "BBTOrderDetailShopCell.h"
#import "Header.h"


@implementation BBTOrderDetailShopCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,145 + 16 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,145)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 18, 100, 12)];
    _totalLabel.font = [UIFont systemFontOfSize:12.0];
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.text = @"商品总额";
    _totalLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:1.0];
    [backView addSubview:_totalLabel];
    
    
    CGFloat  subtitleX = kDeviceWidth - 32 - 120 -20;
    CGFloat  subtitleW = 120;
    
    _totalnoLabel = [[UILabel alloc] initWithFrame:CGRectMake( subtitleX, 17, subtitleW, 12)];
    
    _totalnoLabel.font = [UIFont systemFontOfSize:15.0];
    _totalnoLabel.backgroundColor = [UIColor clearColor];
    _totalnoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _totalnoLabel.textAlignment = NSTextAlignmentRight;
    _totalnoLabel.text = @"3600see";
    
    [backView addSubview:_totalnoLabel];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(_totalLabel.frame) + 16, 100, 12)];
    freightLabel.font = [UIFont systemFontOfSize:12.0];
    freightLabel.backgroundColor = [UIColor clearColor];
    freightLabel.text = @"运费";
    freightLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:1.0];
    [backView addSubview:freightLabel];
    
    
    
    
    _freightnoLabel = [[UILabel alloc] initWithFrame:CGRectMake( subtitleX, CGRectGetMaxY(_totalnoLabel.frame) + 12, subtitleW, 12)];
    
    _freightnoLabel.font = [UIFont systemFontOfSize:15.0];
    _freightnoLabel.backgroundColor = [UIColor clearColor];
    _freightnoLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0  blue:1/255.0  alpha:1.0];
    _freightnoLabel.textAlignment = NSTextAlignmentRight;
    _freightnoLabel.text = @"12.00小二币";
    
    [backView addSubview:_freightnoLabel];
    
    
    _knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(freightLabel.frame) + 16, 100, 12)];
    _knowledgeLabel.font = [UIFont systemFontOfSize:12.0];
    _knowledgeLabel.backgroundColor = [UIColor clearColor];
    _knowledgeLabel.text = @"知识豆";
    _knowledgeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:1.0];
    [backView addSubview:_knowledgeLabel];
    
    
    
    
    _knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake( subtitleX, CGRectGetMaxY(_freightnoLabel.frame) + 12, subtitleW, 12)];
    
    _knowledgenoLabel.font = [UIFont systemFontOfSize:15.0];
    _knowledgenoLabel.backgroundColor = [UIColor clearColor];
    _knowledgenoLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0  blue:1/255.0  alpha:1.0];
    _knowledgenoLabel.textAlignment = NSTextAlignmentRight;
    _knowledgenoLabel.text = @"12.00小二币";
    
    [backView addSubview:_knowledgenoLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_knowledgenoLabel.frame) + 16, kDeviceWidth - 32 *2, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake( kDeviceWidth - 32 - 100 - 50 - 20, CGRectGetMaxY(lineView.frame) + 17, 50, 11)];
    _rewardLabel.font = [UIFont systemFontOfSize:12.0];
    _rewardLabel.backgroundColor = [UIColor clearColor];
    _rewardLabel.text = @"实付款";
    _rewardLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:1.0];
    [backView addSubview:_rewardLabel];
    
    
    _rewardnoLabel = [[UILabel alloc] initWithFrame:CGRectMake( kDeviceWidth - 32 - 100-20 , CGRectGetMaxY(lineView.frame) + 15, 100, 15)];
    
    _rewardnoLabel.font = [UIFont systemFontOfSize:15.0];
    _rewardnoLabel.backgroundColor = [UIColor clearColor];
    _rewardnoLabel.textColor = MNavBackgroundColor;
    _rewardnoLabel.textAlignment = NSTextAlignmentRight;
    _rewardnoLabel.text = @"200";
    
    [backView addSubview:_rewardnoLabel];
    
    
    
    
    
    return bgView;
}

@end

