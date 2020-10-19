//
//  QSearchCell.m
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//


#import "QSearchCell.h"
#import "Header.h"
#import "JXButton.h"

@implementation QSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *cellView = [self contentViewCell];
        
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

- (UIView*)contentViewCell
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,65)];
    bgView.backgroundColor = [UIColor colorWithRed:246/255.0 green:234/255.0 blue:221/255.0 alpha:1.0];
    
    CGFloat btnW = 44;
    CGFloat btnX = 69/375.0 *kDeviceWidth;
    //    CGFloat playbtnX = (kDeviceWidth - 44 *2);
    JXButton *playbtn = [[JXButton alloc] initWithFrame:CGRectMake(btnX, 9, 59, 48)];
    
    
    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_nor"] forState:UIControlStateNormal];
    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_sel"] forState:UIControlStateSelected];
    
    [playbtn setTitle:@"手机试听" forState:UIControlStateNormal];
    [playbtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    playbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];

    [playbtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgView addSubview:playbtn];
    self.playbtn = playbtn;
    
    JXButton *collectbtn = [[JXButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - btnW)/2.0, 9, btnW, 48)];
    
    
//    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];
//    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_pre"] forState:UIControlStateHighlighted];
//
    
    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];
    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_sel"] forState:UIControlStateSelected];
    
    [collectbtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectbtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [collectbtn setTitleColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    collectbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [bgView addSubview:collectbtn];
    
    self.collectbtn = collectbtn;
    
    JXButton *detailsbtn = [[JXButton alloc] initWithFrame:CGRectMake(kDeviceWidth - btnW - btnX, 9, btnW, 48)];

//    [detailsbtn setImage:[UIImage imageNamed:@"icon_zj04_nor"] forState:UIControlStateNormal];
//    [detailsbtn setImage:[UIImage imageNamed:@"icon_zj04_pre"] forState:UIControlStateHighlighted];

    [detailsbtn setImage:[UIImage imageNamed:@"icon_zj04_nor"] forState:UIControlStateNormal];
    [detailsbtn setImage:[UIImage imageNamed:@"icon_zj04_pre"] forState:UIControlStateSelected];
    
    [detailsbtn setTitle:@"专辑" forState:UIControlStateNormal];
    [detailsbtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [detailsbtn setTitleColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    detailsbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];


    [bgView addSubview:detailsbtn];
    
    self.detailsbtn = detailsbtn;
    
    return bgView;
    
    
}

//- (void)collectbtnClick:(UIButton *)btn
//{
//    
//}


//- (void)detailsbtnClick:(UIButton *)btn {
//    
//    [self notifyDelegateWithBtnType:BtnTypeNext];
//    
//    
//}


- (void)playBtnClick:(UIButton *)btn {
    
    btn.selected =  !btn.selected;
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(qalbumListCell:listening:)]) {
        [self.delegate qalbumListCell:self listening: btn.selected];
    }
}


//- (void)playBtnClick:(UIButton *)btn {
//    
//    //更改播放状态
//    self.playing = !self.playing;
//    if (self.playing) {//播放音乐
//        //        NSLog(@"播放音乐");
//        //1.如果是播放的状态，按钮的图片更改为暂停的状态
//        
//        
//        //        [btn setTitle:@"暂停" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"icon_shiting_sel"] forState:UIControlStateNormal];
//        [self notifyDelegateWithBtnType:BtnTypePlay];
//    }else{//暂停音乐
//        NSLog(@"暂停音乐");
//        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
//        
//        [btn setImage:[UIImage imageNamed:@"icon_shiting_nor"] forState:UIControlStateNormal];
//        [self notifyDelegateWithBtnType:BtnTypePause];
//    }
//    
//}

////通知代理
//-(void)notifyDelegateWithBtnType:(BtnType)btnType{
//    //通知代理
//    if ([self.delegate respondsToSelector:@selector(QSearchCellCell:btnClickWithType:)]) {
//        [self.delegate QSearchCellCell:self btnClickWithType:btnType];
//    }
//    
//}


@end
