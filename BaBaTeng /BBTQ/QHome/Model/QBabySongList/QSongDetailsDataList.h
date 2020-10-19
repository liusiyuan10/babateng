//
//  QHistoryDataList.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSongDetailsDataList : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceSongListId;
@property (nonatomic, copy) NSString *deviceSongListName;
@property (nonatomic, copy) NSString *panelId;
@property (nonatomic, copy) NSString *trackCount;

@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, copy) NSString *trackIcon;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, copy) NSString *trackListId;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *trackNamePinyin;
@property (nonatomic, copy) NSString *trackSize;
@property (nonatomic, copy) NSString *isAddToSongList;
@property (nonatomic, copy) NSString *isCollected;



@property(nonatomic, assign) BOOL  isPlaying;//是否正在播放

@property(nonatomic, assign) BOOL  IsDeviceplay;//是否正在播放

@end
