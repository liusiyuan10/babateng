//
//  Q2FavoriteResultRespone.h
//  XZ_WeChat
//
//  Created by liu on 17/3/17.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFavoriteResultRespone : NSObject


@property(nonatomic, strong) NSString *playPathAacv164;
@property(nonatomic, strong) NSString *playPathAacv224;
@property(nonatomic, strong) NSString *playUrl32;
@property(nonatomic, strong) NSString *flag;
@property(nonatomic, strong) NSString *playUrl64;
@property(nonatomic, strong) NSString *downUrl;

@property(nonatomic, strong) NSString *opDate;
@property(nonatomic, strong) NSString *trackId;
@property(nonatomic, strong) NSString *albumTitle;
@property(nonatomic, strong) NSString *deviceId;
@property(nonatomic, strong) NSString *openId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *duration;
@property(nonatomic, strong) NSString *downloadSize;

@property(nonatomic, strong) NSString *albumCoverSmallUrl;

@property(nonatomic, strong) NSString *coverSmallUrl;

@property(nonatomic, strong) NSString *downloadUrl;

@property(nonatomic, strong) NSString *url;

@property(nonatomic, assign) BOOL  isPlaying;//是否正在播放


@end
