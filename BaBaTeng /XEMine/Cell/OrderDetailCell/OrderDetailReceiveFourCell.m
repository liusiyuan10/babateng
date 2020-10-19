//
//  OrderDetailReceiveFourCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "OrderDetailReceiveFourCell.h"
#import "Header.h"


@implementation OrderDetailReceiveFourCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,79 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,79)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    _CouriercompanyLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17,backViewW - 17, 12)];
    
    _CouriercompanyLabel.font = [UIFont systemFontOfSize:12.0];
    _CouriercompanyLabel.backgroundColor = [UIColor clearColor];
    _CouriercompanyLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _CouriercompanyLabel.text = @"快递公司：百世快递";
    _CouriercompanyLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_CouriercompanyLabel];
    
    
    _CourierorderLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(_CouriercompanyLabel.frame) + 6 ,backViewW - 17, 12)];
    
    _CourierorderLabel.font = [UIFont systemFontOfSize:12.0];
    _CourierorderLabel.backgroundColor = [UIColor clearColor];
    _CourierorderLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _CourierorderLabel.text = @"快递单号：51407931202372";
    _CourierorderLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_CourierorderLabel];
    
    
    _deliverytimeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(_CourierorderLabel.frame) + 6,backViewW - 17, 12)];
    
    _deliverytimeLabel.font = [UIFont systemFontOfSize:12.0];
    _deliverytimeLabel.backgroundColor = [UIColor clearColor];
    _deliverytimeLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1.0];
    _deliverytimeLabel.text = @"发货时间：2018-10-26 15:55:33";
    _deliverytimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_deliverytimeLabel];
    
    
    _lcopyBtn = [[UIButton alloc]initWithFrame:CGRectMake(backViewW - 50 - 17, 34  ,50, 20)];
    _lcopyBtn.backgroundColor = [UIColor clearColor];
    _lcopyBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_lcopyBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    [_lcopyBtn setTitle:@"复制" forState:UIControlStateNormal];
    _lcopyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    //    [_phoneBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    [backView addSubview:_lcopyBtn];
    

    
    return bgView;
}


@end
