//
//  QCategoryScrollListViewController.h
//  BaBaTeng
//
//  Created by liu on 17/6/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "QHeadView.h"
#import "QCategoryListViewController.h"
//添加试听播放器
#import "MusicPlayerView.h"
#import "QCategoryListViewController.h"
#import "QAlbumDataTrackList.h"
@interface QCategoryScrollListViewController : CommonViewController<QHeadViewDelegate>
{
    NSInteger _currentSection;
    NSInteger _currentRow;
    
    /**
     *  添加播放新增属性
     */
    
    NSInteger _currentListenSection;//保存试听播放的当前行
    
    
    BOOL  IsListenButton;//是否试听Button
    
    BOOL  IsPlayButton;//是否试听
    
    BOOL  IsAddPlayList;//是否第一次点播的时候添加到播放列表
    
    BOOL  IsRefreshPlay;//是否需要刷新当前试听
    
    BOOL  IsRePalying;
    
    
    QAlbumDataTrackList *resultRespone;
}
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign)  BOOL  IsPlaying;//是否正在播放
@property (nonatomic, strong) NSString *categoryid;
@property (nonatomic,strong)  MusicPlayerView *playerView;
@property (nonatomic, strong)     UITableView *tableView;
@property (nonatomic, strong)     NSMutableArray *Qcateoryarr;
@property (nonatomic, strong)   NSMutableArray *playSaveArray;




@end
