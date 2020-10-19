//
//  MybuyClassCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/26.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MybuyClassCell.h"
#import "Header.h"

@implementation MybuyClassCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,232 + 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,232)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17,260, 17)];
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _nameLabel.text = @"Teacher A";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_nameLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_nameLabel.frame) + 16, kDeviceWidth - 32 - 17 - 17, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    
    
    
    
    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(lineView.frame) + 16,81, 81)];
    _iocnView.userInteractionEnabled = YES;
    _iocnView.backgroundColor = [UIColor clearColor];
    _iocnView.contentMode = UIViewContentModeScaleToFill;
    
    _iocnView.image = [UIImage imageNamed:@"Teacher"];
    
    _iocnView.layer.cornerRadius= 40.5f;
    
    _iocnView.layer.borderWidth = 1.0;
    _iocnView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    _iocnView.clipsToBounds = YES;//去除_iocnView
    _iocnView.layer.masksToBounds = YES;
    
    [backView addSubview:_iocnView];
    

    
    
    
    UILabel *presenttextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 15,CGRectGetMaxY(lineView.frame) + 28, 60, 14)];
    
    presenttextLabel.font = [UIFont systemFontOfSize:14];
    presenttextLabel.backgroundColor = [UIColor clearColor];
    presenttextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    presenttextLabel.text = @"赠送课时";
    presenttextLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:presenttextLabel];
    
    _presentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(presenttextLabel.frame), CGRectGetMaxY(lineView.frame) + 28, 50, 14)];
    
    _presentLabel.font = [UIFont systemFontOfSize:14];
    _presentLabel.backgroundColor = [UIColor clearColor];
    _presentLabel.textColor = [UIColor colorWithRed:252/255.0 green:55/255.0 blue:104/255.0 alpha:1.0];
//    _presentLabel.text = @"07:30-07:55";
    _presentLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_presentLabel];
    
    UILabel *educeMoneytextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_presentLabel.frame) ,CGRectGetMaxY(lineView.frame) + 28, 50, 14)];
    
    educeMoneytextLabel.font = [UIFont systemFontOfSize:14];
    educeMoneytextLabel.backgroundColor = [UIColor clearColor];
    educeMoneytextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    educeMoneytextLabel.text = @",节省";
    educeMoneytextLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:educeMoneytextLabel];
    
    _educeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(educeMoneytextLabel.frame), CGRectGetMaxY(lineView.frame) + 28, 80, 14)];
    
    _educeMoneyLabel.font = [UIFont systemFontOfSize:14];
    _educeMoneyLabel.backgroundColor = [UIColor clearColor];
    _educeMoneyLabel.textColor = [UIColor colorWithRed:252/255.0 green:55/255.0 blue:104/255.0 alpha:1.0];
    //    _presentLabel.text = @"07:30-07:55";
    _educeMoneyLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_educeMoneyLabel];
    
    UILabel *totaltextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 15,CGRectGetMaxY(presenttextLabel.frame) + 11, 70, 14)];
    
    totaltextLabel.font = [UIFont systemFontOfSize:14];
    totaltextLabel.backgroundColor = [UIColor clearColor];
    totaltextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    totaltextLabel.text = @"课时总计";
    totaltextLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:totaltextLabel];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totaltextLabel.frame), CGRectGetMaxY(presenttextLabel.frame) + 11, 80, 14)];
    
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.textColor = [UIColor colorWithRed:252/255.0 green:55/255.0 blue:104/255.0 alpha:1.0];
    //    _presentLabel.text = @"07:30-07:55";
    _totalLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_totalLabel];
    
    UILabel *unitPricetextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 15,CGRectGetMaxY(totaltextLabel.frame) + 11, 100, 14)];
    
    unitPricetextLabel.font = [UIFont systemFontOfSize:14];
    unitPricetextLabel.backgroundColor = [UIColor clearColor];
    unitPricetextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    unitPricetextLabel.text = @"平均一课时费用";
    unitPricetextLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:unitPricetextLabel];
    
    _unitPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(unitPricetextLabel.frame), CGRectGetMaxY(totaltextLabel.frame) + 11, 80, 14)];
    
    _unitPriceLabel.font = [UIFont systemFontOfSize:14];
    _unitPriceLabel.backgroundColor = [UIColor clearColor];
    _unitPriceLabel.textColor = [UIColor colorWithRed:252/255.0 green:55/255.0 blue:104/255.0 alpha:1.0];
    //    _presentLabel.text = @"07:30-07:55";
    _unitPriceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_unitPriceLabel];
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(114, CGRectGetMaxY(unitPricetextLabel.frame) + 22, kDeviceWidth - 32 - 114 - 17, 1.0)];
    
    line1View.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [backView addSubview:line1View];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(line1View.frame) + 26, 80, 16)];
    
    _totalPriceLabel.font = [UIFont boldSystemFontOfSize:21];
    _totalPriceLabel.backgroundColor = [UIColor clearColor];
    _totalPriceLabel.textColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    //    _presentLabel.text = @"07:30-07:55";
    _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_totalPriceLabel];
    
    
    _buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 16 *2 - 17 - 90,CGRectGetMaxY(line1View.frame) + 16 ,90, 36)];
    
    _buyBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    
    
    _buyBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    _buyBtn.layer.cornerRadius= 18.0f;
    
    _buyBtn.clipsToBounds = YES;//去除边界
    
    [backView addSubview:_buyBtn];

    

    return bgView;
    
}

@end
