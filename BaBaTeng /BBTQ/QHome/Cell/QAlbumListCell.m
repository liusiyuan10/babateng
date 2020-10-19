//
//  QAlbumListCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/23.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import "QAlbumListCell.h"
//
//@implementation QAlbumListCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end

#import "QAlbumListCell.h"
#import "Header.h"
#import "JXButton.h"


@implementation QAlbumListCell

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
    CGFloat btnX = 69;
//    CGFloat playbtnX = (kDeviceWidth - 44 *2);
    JXButton *playbtn = [[JXButton alloc] initWithFrame:CGRectMake(btnX, 9, 59, 48)];
    
//    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_nor"] forState:UIControlStateNormal];
//    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_sel"] forState:UIControlStateSelected];

    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_nor"] forState:UIControlStateNormal];
    [playbtn setImage:[UIImage imageNamed:@"icon_shiting_sel"] forState:UIControlStateSelected];
    
    [playbtn setTitle:@"手机试听" forState:UIControlStateNormal];
    [playbtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [playbtn setTitleColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    playbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [playbtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgView addSubview:playbtn];
     self.playbtn = playbtn;
    
    JXButton *collectbtn = [[JXButton alloc] initWithFrame:CGRectMake(kDeviceWidth - btnW - btnX, 9, btnW, 48)];
    
    
//    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];

    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];
    [collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_sel"] forState:UIControlStateSelected];
    
    [collectbtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectbtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [collectbtn setTitleColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    collectbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [bgView addSubview:collectbtn];
    
    self.collectbtn = collectbtn;
    

    
    return bgView;
    
    
}




- (void)playBtnClick:(UIButton *)btn {
    
      btn.selected =  !btn.selected;
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(qalbumListCell:listening:)]) {
        [self.delegate qalbumListCell:self listening: btn.selected];
    }
}



@end
