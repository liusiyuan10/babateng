//
//  MusicPlayerView.h
//  VedioPlayer
//
//  Created by yanghuang on 2017/5/27.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VedioPlayerView.h"
#import "VedioModel.h"
#import "MusicSlider.h"


@protocol MusicPlayerViewDelegate <NSObject>

@optional
//播放失败的代理方法
-(void)playerViewFailed;
//缓存中的代理方法
-(void)playerViewBuffering;
//播放完毕的代理方法
-(void)playerViewFinished;

//当前播放时间 float currentPlayTime
-(void)playerViewTimeNow:(CGFloat)currentPlayTime;

@end

@interface MusicPlayerView : VedioPlayerView
@property (nonatomic, weak) id<MusicPlayerViewDelegate> musicPlayerDelegate;

@property (nonatomic, assign) BOOL  IsListen;//是否是暂停过后进入后台

@property (nonatomic, strong) UILabel *timeNowLabel;

@property (nonatomic, strong) UILabel *timeTotalLabel;
@property (nonatomic, strong) MusicSlider *timeSlider;
- (void)setUp:(VedioModel *)model;

- (void)changeMusic:(VedioModel *)musicModel;

#pragma mark 播放按钮事件
- (void)playButtonAction:(id)sender;

#pragma mark 播放，暂停
- (void)play;

- (void)pause;

- (void)destroyPlayer;

- (void)removeObserver;

-(void)playControl;

@end
