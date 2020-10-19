//
//  QSearchViewController.h
//  BaBaTeng
//
//  Created by liu on 17/6/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"

#import "QHeadView.h"

@interface QSearchViewController : CommonViewController<QHeadViewDelegate>
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
typedef void(^SearchBlock) ();

@property (nonatomic, strong) NSString *trackListId;
@property(nonatomic,copy)SearchBlock block;

//@property(nonatomic, copy) NSString *searchstr;



@end
