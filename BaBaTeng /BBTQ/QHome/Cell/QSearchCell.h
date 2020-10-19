//
//  QSearchCell.h
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    BtnTypePlay,//播放
    BtnTypePause,//暂停
    BtnTypePrevious,//上一首
    BtnTypeNext//下一首
}BtnType;


@class  QSearchCell;

@protocol QSearchCellCellDelegate <NSObject>

//-(void)QSearchCellCell:(QSearchCell *)toolbar btnClickWithType:(BtnType) btnType;
-(void)qalbumListCell:(QSearchCell *)toolbar listening:(BOOL)ifListening;
@end



@interface QSearchCell : UITableViewCell

/*
 *播放状态 默认暂停状态
 */
@property(assign,nonatomic,getter=isPlaying)BOOL playing;

@property(nonatomic,weak)id<QSearchCellCellDelegate> delegate;

@property(nonatomic, strong) UIButton *collectbtn;
@property(nonatomic, strong) UIButton *detailsbtn;
@property(nonatomic, strong) UIButton *playbtn;

@end
