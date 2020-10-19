//
//  OrderDetailTwoCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "OrderDetailTwoCell.h"
#import "Header.h"


@implementation OrderDetailTwoCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,179 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,179)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(17,  16,100, 100)];
    _leftImage.userInteractionEnabled = YES;
    _leftImage.backgroundColor = [UIColor clearColor];
    
    
    _leftImage.image = [UIImage imageNamed:@"order_image_empty"];
    
    _leftImage.layer.cornerRadius= 5.0f;
    
    
    
    _leftImage.layer.masksToBounds = YES;
    
    [backView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, 29,kDeviceWidth - 32 -CGRectGetMaxX(_leftImage.frame) - 16, 40)];
    
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    _nameLabel.text = @"晓宝在线少儿英语套餐1";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 0;
    [backView addSubview:_nameLabel];
    
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 17, CGRectGetMaxY(_nameLabel.frame) + 8 ,60, 9)];
    
    _noLabel.font = [UIFont systemFontOfSize:9.0];
    _noLabel.backgroundColor = [UIColor clearColor];
    _noLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _noLabel.text = @"数量:2";
    _noLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_noLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 17, CGRectGetMaxY(_noLabel.frame) + 6 ,200, 15)];
    
    _priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = MNavBackgroundColor;
    _priceLabel.text = @"3600see";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_priceLabel];
    
    
    
    _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, CGRectGetMaxY(_leftImage.frame) + 17 ,kDeviceWidth - 32 -18, 12)];
    
    _noteLabel.font = [UIFont systemFontOfSize:12.0];
    _noteLabel.backgroundColor = [UIColor clearColor];
    _noteLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _noteLabel.text = @"备注信息 不要忘了我的贺卡";
    _noteLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_noteLabel];
    
    
    UILabel *rewardtextLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, CGRectGetMaxY(_noteLabel.frame) + 7 ,60, 12)];

    rewardtextLabel.font = [UIFont systemFontOfSize:12.0];
    rewardtextLabel.backgroundColor = [UIColor clearColor];
    rewardtextLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    rewardtextLabel.text = @"奖励:";
    rewardtextLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:rewardtextLabel];
    
   _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(rewardtextLabel.frame), CGRectGetMaxY(_noteLabel.frame) + 7 ,200, 12)];
    
    _rewardLabel.font = [UIFont systemFontOfSize:12.0];
    _rewardLabel.backgroundColor = [UIColor clearColor];
    _rewardLabel.textColor = MNavBackgroundColor;
    _rewardLabel.text = @"23.00小二币";
    _rewardLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_rewardLabel];
    
    return bgView;
}



@end
