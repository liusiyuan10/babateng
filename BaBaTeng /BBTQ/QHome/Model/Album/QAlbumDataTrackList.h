//
//  QAlbumDataTrackList.h
//  BaBaTeng
//
//  Created by liu on 17/7/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAlbumDataTrackList : NSObject

//    downloadUrl = "http://orfvq12yi.bkt.clouddn.com/track/Nobody%E4%B8%AD%E6%96%87%E5%B9%BC%E5%84%BF%E7%89%88.mp3";
//    duration = 214000;
//    playUrl = "http://orfvq12yi.bkt.clouddn.com/track/1/Nobody%E4%B8%AD%E6%96%87%E5%B9%BC%E5%84%BF%E7%89%88.mp3";
//    trackIcon = "http://orfvq12yi.bkt.clouddn.com/image/icon/%E5%84%BF%E6%AD%8C%E7%B2%BE%E9%80%89.jpg";
//    trackId = 1;
//    trackListId = 1;
//    trackName = "Nobody\U4e2d\U6587\U5e7c\U513f\U7248";
//    trackNamePinyin = Nobodyzhongwenyouerban;
//    trackSize = 3436505;

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
@property(nonatomic, assign) BOOL  isListening;//是否正在试听

@property(nonatomic, assign) BOOL  IsDeviceplay;//是否正在试听

@property(nonatomic, assign) BOOL  IsDevicePlaying;//是否正在试听

@end
