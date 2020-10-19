//
//  Q2DemandResultRespone.h
//  BaBaTeng
//
//  Created by liu on 17/4/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QDemandResultRespone : NSObject

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
