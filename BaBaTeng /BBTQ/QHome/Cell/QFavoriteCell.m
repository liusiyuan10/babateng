//
//  QFavoriteCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//
//  DemandCell.m
//  BaBaTeng
//
//  Created by liu on 17/2/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QFavoriteCell.h"
#import "Header.h"


@implementation QFavoriteCell

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
        [self.contentView addSubview:cellView];
        
    }
    return self;
}



-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,65)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _leftImage = [[UIButton alloc] initWithFrame:CGRectMake(14, 7, 50, 50)];
    
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateSelected];
    
    [bgView addSubview:_leftImage];
    
    _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 8, 16,19, 14)];
    _myImageView.userInteractionEnabled = NO;
    _myImageView.backgroundColor = [UIColor clearColor];
    _myImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.myImageView.image = [UIImage imageNamed:@"nlk_1"];
    [bgView addSubview:_myImageView];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 21, 16, kDeviceWidth -CGRectGetMaxX(_leftImage.frame) - 21  - 40, 16)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    _timeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 8, 15, 15)];
    _timeView.image = [UIImage imageNamed:@"demandtime"];
    
    [bgView addSubview:_timeView];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeView.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 9, kDeviceWidth -CGRectGetMaxX(_leftImage.frame) - 21 - 80 - 40, 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];;
    [bgView addSubview:_timeLabel];
    
    
    _rightUpImage = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 78 - 8, 17, 32, 32)];
    
    [_rightUpImage setImage:[UIImage imageNamed:@"icon_tianjia_nor"] forState:UIControlStateNormal];
    [_rightUpImage setImage:[UIImage imageNamed:@"icon_tianjia_pre"] forState:UIControlStateHighlighted];
    
    _rightUpImage.hidden = YES;
    [bgView addSubview:_rightUpImage];
    
    
    _rightMiddleImage = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightUpImage.frame) + 8, 17, 32, 32)];
    
    [_rightMiddleImage setImage:[UIImage imageNamed:@"icon_tjdemand_nor"] forState:UIControlStateNormal];
    [_rightMiddleImage setImage:[UIImage imageNamed:@"icon_tjdemand_sel"] forState:UIControlStateDisabled];
    
    [bgView addSubview:_rightMiddleImage];
    
    //    _rightDownImage = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightMiddleImage.frame) + 8, 17, 32, 32)];
    //
    //    [_rightDownImage setImage:[UIImage imageNamed:@"icon_shanchu_pre"] forState:UIControlStateNormal];
    //
    //    [bgView addSubview:_rightDownImage];
    
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 64.5, kDeviceWidth - 28, 0.5)];
//    
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//    
//    [bgView addSubview:lineView];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0] CGColor];
    lineLayer.frame = CGRectMake(14,0, kDeviceWidth - 28, 0.5);
    [bgView.layer addSublayer:lineLayer];
    
    
    
    return bgView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        if (selected) {
            //            // 取消多选时cell成蓝色
                        self.contentView.backgroundColor = [UIColor whiteColor];
                        self.backgroundView.backgroundColor = [UIColor whiteColor];
            
        }else{
            
        }
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        
                        img.image = [UIImage imageNamed:@"ic_weixuan.png"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //    self.selected = NO;
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"ic_gouxuan.png"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"ic_weixuan.png"];
                    }
                }
            }
        }
    }
    
}



@end
