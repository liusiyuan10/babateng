//
//  QAlbumListCell.h
//  BaBaTeng
//
//  Created by liu on 17/5/23.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QAlbumListCell : UITableViewCell
//
//@end


#import <UIKit/UIKit.h>

typedef enum {
    BtnTypePlay,//播放
    BtnTypePause,//暂停
    BtnTypePrevious,//上一首
    BtnTypeNext//下一首
}BtnType;


@class  QAlbumListCell;

@protocol QAlbumListCellDelegate <NSObject>

-(void)qalbumListCell:(QAlbumListCell *)toolbar listening:(BOOL)ifListening;

@end



@interface QAlbumListCell : UITableViewCell

/*
 *播放状态 默认暂停状态
 */
@property(assign,nonatomic,getter=isPlaying)BOOL playing;

@property(nonatomic,weak)id<QAlbumListCellDelegate> delegate;

@property(nonatomic, strong) UIButton *collectbtn;

@property(nonatomic, strong) UIButton *playbtn;

@end
