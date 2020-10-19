//
//  HomeCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "HomeCell.h"
#import "Header.h"

@implementation HomeCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,125 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 125 , 125 )];
    
    _leftImage.userInteractionEnabled = YES;
    
    _leftImage.layer.masksToBounds = YES; //没这句话它圆不起来
    _leftImage.layer.cornerRadius = 15; //设置图片圆角的尺度
    _knowledgeLabel.layer.borderWidth = 1.0;
    _knowledgeLabel.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    _knowledgeLabel.clipsToBounds = YES;//去除边界

    
    [bgView addSubview:_leftImage];
    

    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, 20, kDeviceWidth - CGRectGetMaxX(_leftImage.frame) - 32, 40)];
    _NameLabel.font = [UIFont systemFontOfSize:16.0];
    _NameLabel.backgroundColor = [UIColor clearColor];

    _NameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    
    _NameLabel.numberOfLines = 0;
    _NameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_NameLabel];
    

    
    _knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_NameLabel.frame) + 21, 80, 16)];
    _knowledgeLabel.font = [UIFont boldSystemFontOfSize:10.0];
    _knowledgeLabel.backgroundColor = [UIColor clearColor];
    _knowledgeLabel.layer.cornerRadius= 3.0f;
    _knowledgeLabel.layer.borderWidth = 1.0;
    _knowledgeLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0].CGColor;
    _knowledgeLabel.clipsToBounds = YES;//去除边界
    _knowledgeLabel.textAlignment = NSTextAlignmentCenter;
    
    _knowledgeLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    _knowledgeLabel.text = @"赠送200知识豆";
    [bgView addSubview:_knowledgeLabel];
    
    _intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_knowledgeLabel.frame) + 6, CGRectGetMaxY(_NameLabel.frame) + 21, 80, 16)];
    _intelligenceLabel.font = [UIFont boldSystemFontOfSize:10.0];
    _intelligenceLabel.backgroundColor = [UIColor clearColor];
    _intelligenceLabel.layer.cornerRadius= 3.0f;
    _intelligenceLabel.layer.borderWidth = 1.0;
    _intelligenceLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0].CGColor;
    _intelligenceLabel.clipsToBounds = YES;//去除边界
    _intelligenceLabel.textAlignment = NSTextAlignmentCenter;
    
    _intelligenceLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    _intelligenceLabel.text = @"赠送33智力";
    [bgView addSubview:_intelligenceLabel];

    CGFloat  subtitleX =CGRectGetMaxX(_leftImage.frame) + 16;
    CGFloat  subtitleW = 100;
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_knowledgeLabel.frame) + 8, subtitleW, 15)];
    
    _priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor  colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    _priceLabel.textAlignment = NSTextAlignmentLeft;

    [bgView addSubview:_priceLabel];
    
    _SpecialLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_knowledgeLabel.frame) + 8, 50 , 16 )];

    _SpecialLabel.font = [UIFont boldSystemFontOfSize:10.0];
    _SpecialLabel.backgroundColor = [UIColor  colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    _SpecialLabel.textColor = [UIColor whiteColor];
    _SpecialLabel.textAlignment = NSTextAlignmentCenter;
    
    _SpecialLabel.layer.cornerRadius= 3.0f;
    _SpecialLabel.clipsToBounds = YES;//去除边界
    
    [bgView addSubview:_SpecialLabel];
    
    _DescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtitleX, CGRectGetMaxY(_priceLabel.frame) + 11, subtitleW, 9)];
    
    _DescriptionLabel.font = [UIFont systemFontOfSize:9.0];
    _DescriptionLabel.backgroundColor = [UIColor clearColor];
    _DescriptionLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    _DescriptionLabel.textAlignment = NSTextAlignmentLeft;

    [bgView addSubview:_DescriptionLabel];
    
    
    
    //    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    //
    //    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    //
    //    [bgView addSubview:lineView];
    
    return bgView;
}


- (void)layoutSubviews {
    
    NSString *knowledgeStr = [NSString stringWithFormat:@"%@ ",self.knowledgeLabel.text];
    
    CGFloat knowledgeW = [self getWidthWithText:knowledgeStr height:16.0 font:10.0];
    
    
    self.knowledgeLabel.frame = CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_NameLabel.frame) + 21, knowledgeW, 16);
    
    NSString *intelligenceStr = [NSString stringWithFormat:@" %@ ",self.intelligenceLabel.text];
    
    CGFloat intelligenceW = [self getWidthWithText:intelligenceStr height:16.0 font:10.0];
    
    self.intelligenceLabel.frame =CGRectMake( CGRectGetMaxX(self.knowledgeLabel.frame) + 6, CGRectGetMaxY(_NameLabel.frame) + 21, intelligenceW, 16);
    

    NSString *priceLabelStr = [NSString stringWithFormat:@"%@",self.priceLabel.text];
    
    
    CGFloat priceLabelW = [self getWidthWithText:priceLabelStr height:15.0 font:18.0];
    
    self.priceLabel.frame =  CGRectMake(CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_knowledgeLabel.frame) + 8, priceLabelW, 15);
    
    NSString *SpecialStr = [NSString stringWithFormat:@" %@ ",self.SpecialLabel.text];
    
    CGFloat SpeciallW = [self getWidthWithText:SpecialStr height:16.0 font:10.0];
    
    self.SpecialLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+5, CGRectGetMaxY(_knowledgeLabel.frame) + 8, (int)SpeciallW , 16 );
    
}


- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    return rect.size.width;
    
    
}

@end
