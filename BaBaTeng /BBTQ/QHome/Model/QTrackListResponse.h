//
//  Q3TrackListResponse.h
//  XZ_WeChat
//
//  Created by liu on 17/3/30.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTrackListResponse : NSObject

//id = 1;
//deviceId = df;
//play = 0;
//albumTitle = 故事;
//coverSmallUrl = fd;

//totalNum = 0;
//tackListId = 444;
//tackListName = 英语;

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *play;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) NSString *coverSmallUrl;
@property (nonatomic, strong) NSString *totalNum;
@property (nonatomic, strong) NSString *tackListId;
@property (nonatomic, strong) NSString *tackListName;
@property (nonatomic, strong) NSString *downloadTrackCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *trackCount;
@end
