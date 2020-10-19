//
//  QPlayingTrackData.h
//  BaBaTeng
//
//  Created by liu on 17/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "QplayType.h"

@interface QPlayingTrackData : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *listId;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, strong) QplayType *playType;
@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, copy) NSString *mode;//播放模式



@end
