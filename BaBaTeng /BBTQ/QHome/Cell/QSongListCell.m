//
//  QSongListCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSongListCell.h"
#import "Header.h"

@implementation QSongListCell

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
    
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 64.5, kDeviceWidth - 28, 0.5)];
//    
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//    
//    [bgView addSubview:lineView];
//    
    _leftImage = [[UIButton alloc] initWithFrame:CGRectMake(14, 13, 40, 40)];
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateSelected];
    
    
    //    [_leftImage addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:_leftImage];
    
    _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 8, 16,19, 14)];
    _myImageView.userInteractionEnabled = NO;
    _myImageView.backgroundColor = [UIColor clearColor];
    _myImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.myImageView.image = [UIImage imageNamed:@"nlk_1"];
    [bgView addSubview:_myImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 16)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    _timeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 8, 15, 15)];
    _timeView.image = [UIImage imageNamed:@"demandtime"];
    
    [bgView addSubview:_timeView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeView.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 9, kDeviceWidth -40 - CGRectGetMaxX(_timeView.frame) - 8, 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    [bgView addSubview:_timeLabel];
    
    
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 40, 17, 32, 32)];
    
    
    
//    [self.collectBtn setImage:[UIImage imageNamed:@"icon_tianjia_nor"] forState:UIControlStateNormal];
//    [self.collectBtn setImage:[UIImage imageNamed:@"icon_tianjia_pre"] forState:UIControlStateHighlighted];
    [bgView addSubview:self.collectBtn];
    
    
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
