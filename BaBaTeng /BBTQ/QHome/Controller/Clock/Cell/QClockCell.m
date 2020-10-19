//
//  QClockCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/27.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockCell.h"

#import "Header.h"

@implementation QClockCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,152)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    [bgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, kDeviceWidth - 32, 27)];
    
    _timeLabel.font = [UIFont boldSystemFontOfSize:36];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:4/255.0 alpha:1.0];
    
//    _timeLabel.text = @"18:00";
    
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    

    
    [bgView addSubview:_timeLabel];
    
    
//    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeLabel.frame), 37, 100, 14)];
//    
//    _dateLabel.font = [UIFont systemFontOfSize:15];
//    _dateLabel.backgroundColor = [UIColor clearColor];
//    _dateLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    
//    _dateLabel.text = @"上午";
//    
//    _dateLabel.textAlignment = NSTextAlignmentLeft;
//    
//
//    
//    [bgView addSubview:_dateLabel];
    
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_timeLabel.frame) + 17, kDeviceWidth - 82, 14)];
    
    _tagLabel.font = [UIFont systemFontOfSize:15];
    _tagLabel.backgroundColor = [UIColor clearColor];
    _tagLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    _tagLabel.text = @"宝宝起床了";
    
    _tagLabel.textAlignment = NSTextAlignmentLeft;
    

    
    [bgView addSubview:_tagLabel];
    
    _repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_tagLabel.frame) + 12, kDeviceWidth - 82, 16)];
    
    _repeatLabel.font = [UIFont systemFontOfSize:16];
    _repeatLabel.backgroundColor = [UIColor clearColor];
    _repeatLabel.textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:83/255.0 alpha:1.0];
    
    _repeatLabel.text = @"每天";
    
    _repeatLabel.textAlignment = NSTextAlignmentLeft;
    

    
    [bgView addSubview:_repeatLabel];
    
    _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_repeatLabel.frame) + 8, kDeviceWidth - 82, 10)];
    
    _countdownLabel.font = [UIFont systemFontOfSize:10];
    _countdownLabel.backgroundColor = [UIColor clearColor];
    _countdownLabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
    
//    _countdownLabel.text = @"10小时5分钟后闹铃";
    
    _countdownLabel.textAlignment = NSTextAlignmentLeft;
    

    
    [bgView addSubview:_countdownLabel];
    
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 50 - 18, (152 - 15)/2.0, 9, 15)];
    
    _arrowView.backgroundColor = [UIColor clearColor];
    _arrowView.contentMode = UIViewContentModeScaleAspectFill;
    _arrowView.image = [UIImage imageNamed:@"clock_front"];
    [bgView addSubview:_arrowView];
    
    _switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    _switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];

    self.accessoryView = _switchview;
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0] CGColor];
    lineLayer.frame = CGRectMake(14,0, kDeviceWidth - 28, 0.5);
    [bgView.layer addSublayer:lineLayer];
    
    return bgView;
}





//- (void)layoutSubviews
//
//{
//
//    [super layoutSubviews];
//
//    self.backgroundColor = [UIColor clearColor];
//
//    for (UIView *subview in self.subviews) {
//
//        for (UIView *subview2 in subview.subviews) {
//
//            if ([NSStringFromClass([subview2 class]) isEqualToString:@"_UITableViewCellActionButton"]) { // move delete confirmation view
//
//                [subview bringSubviewToFront:subview2];
//                self.frame = CGRectMake(0, self.frame.origin.y, kDeviceWidth, CGRectGetHeight(self.frame));
//            }
//
//        }
//
//    }
//}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (!self.selected) {
//                        img.image=[UIImage imageNamed:@"clock_delete"];
//                        img.size =CGSizeMake(100,21);
//                    }
//                }
//            }
//        }
//    }
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
