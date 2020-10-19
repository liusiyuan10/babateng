//
//  QPlayingTrack.h
//  BaBaTeng
//
//  Created by liu on 17/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPlayingTrackData.h"

@interface QPlayingTrack : NSObject

@property (nonatomic, strong) QPlayingTrackData *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end
