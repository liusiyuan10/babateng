//
//  ClassroomPlaybackData.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassroomPlaybackData : NSObject

//duration    播放时长    number    @mock=1559096
//httpsPlayPath    回放ssl地址    string    @mock=https://global.talk-cloud.net/replay/1345555286/11351/1544959799995/
//playPath    回放地址    string    @mock=https://global.talk-cloud.net/replay/1345555286/11351/1544959799995/
//recordTitle    名称    string    @mock=1544959799995
//size    大小    number    @mock=232096195
//startTime    录制时间

@property (nonatomic, copy) NSString   *duration;

@property (nonatomic, copy) NSString   *httpsPlayPath;
@property (nonatomic, copy) NSString   *playPath;

@property (nonatomic, copy) NSString   *recordTitle;

@property (nonatomic, copy) NSString   *size;
@property (nonatomic, copy) NSString   *startTime;


@end

NS_ASSUME_NONNULL_END
