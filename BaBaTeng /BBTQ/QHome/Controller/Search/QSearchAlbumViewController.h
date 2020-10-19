//
//  QSearchAlbumViewController.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/24.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"

#import "QHeadView.h"

@interface QSearchAlbumViewController : CommonViewController<QHeadViewDelegate>
{
    NSInteger _currentSection;
    NSInteger _currentRow;
    
    /**
     *  添加播放新增属性
     */
    NSInteger _currentListenSection;//保存试听播放的当前行
    
    BOOL  IsPlaying;//是否正在播放
    
    BOOL  IsListenButton;//是否试听Button
    
    BOOL  IsPlayButton;//是否试听
    
    BOOL  IsRefreshPlay;//是否需要刷新当前试听
    
    BOOL  IsAddPlayList;//是否第一次点播的时候添加到播放列表
    
    BOOL  IsRePalying;
}

//@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) NSString *trackListId;


@end
