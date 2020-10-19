//
//  QSongListViewController.h
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "QSongDataList.h"

@interface QSongListViewController : CommonViewController
{
    
    BOOL  IsAddPlayList;//是否第一次点播的时候添加到播放列表
}

@property (nonatomic,strong) QSongDataList *QResponse;

@end
