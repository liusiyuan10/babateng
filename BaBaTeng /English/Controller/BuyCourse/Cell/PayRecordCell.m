//
//  PayRecordCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "PayRecordCell.h"
#import "Header.h"

@implementation PayRecordCell

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
    _courseBtn.enabled = NO;
    [_courseBtn setBackgroundImage:[UIImage imageNamed:@"buyselectnor"] forState:UIControlStateNormal];
  
    [bgView addSubview:_courseBtn];
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 60, 28)];
    
    _amountLabel.textColor = [UIColor blackColor];
    _amountLabel.font = [UIFont boldSystemFontOfSize:18];
//    _amountLabel.text = @"2500元";
    _amountLabel.textAlignment = NSTextAlignmentLeft;
    _amountLabel.backgroundColor = [UIColor clearColor];
    
    [_courseBtn addSubview:_amountLabel];
    
    _paysuccessLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_amountLabel.frame), 14 + 6, 100, 20)];
    
    _paysuccessLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];;
    _paysuccessLabel.font = [UIFont systemFontOfSize:14];
        _paysuccessLabel.text = @"付款成功";
    _paysuccessLabel.textAlignment = NSTextAlignmentLeft;
    _paysuccessLabel.backgroundColor = [UIColor clearColor];
    
    [_courseBtn addSubview:_paysuccessLabel];

    
    _EveryamountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 24 - 12 - 150, 14, 150, 28)];
    _EveryamountLabel.font = [UIFont boldSystemFontOfSize:20];
    _EveryamountLabel.backgroundColor = [UIColor clearColor];
    _EveryamountLabel.textColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:5/255.0 alpha:1.0];
    _EveryamountLabel.text = @"65次";
    _EveryamountLabel.textAlignment = NSTextAlignmentRight;
    
    [_courseBtn addSubview:_EveryamountLabel];
    
    
    _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 60-24-12, CGRectGetMaxY(_EveryamountLabel.frame) + 3,60, 10)];
    
    _payTypeLabel.font = [UIFont systemFontOfSize:10];
    _payTypeLabel.backgroundColor = [UIColor clearColor];
    _payTypeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _payTypeLabel.text = @"1";
    _payTypeLabel.textAlignment = NSTextAlignmentRight;
    
    [_courseBtn addSubview:_payTypeLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_amountLabel.frame) + 1,120, 14)];
    
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _timeLabel.text = @"2018-04-15 12:30";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [_courseBtn addSubview:_timeLabel];
    
    
//    _givingnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 24 - 150 - 12, CGRectGetMaxY(_EveryamountLabel.frame) + 2, 150, 14)];
//    
//    
//    
//    _givingnumLabel.font = [UIFont systemFontOfSize:10];
//    _givingnumLabel.backgroundColor = [UIColor clearColor];
//    _givingnumLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//    _givingnumLabel.text = @"6个月(赠65次)";
//    _givingnumLabel.textAlignment = NSTextAlignmentRight;
//    
//    [_courseBtn addSubview:_givingnumLabel];
    
    
    
    return bgView;
    
}

- (void)layoutSubviews {
    
    NSString *amountStr = [NSString stringWithFormat:@"%@ ",self.amountLabel.text];
    
    CGFloat amountW = [self getWidthWithText:amountStr height:28.0 font:18.0];
    
    
    self.amountLabel.frame =CGRectMake(16, 14, amountW, 28);
    
    self.paysuccessLabel.frame = CGRectMake(CGRectGetMaxX(self.amountLabel.frame) + 6, 14 + 6, 100, 20);
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    return rect.size.width;
    
    
}

@end
