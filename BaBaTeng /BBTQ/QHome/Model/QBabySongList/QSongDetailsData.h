//
//  QHistoryData.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface QSongDetailsData : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceSongListId;
@property (nonatomic, copy) NSString *deviceSongListName;
@property (nonatomic, copy) NSString *panelId;
@property (nonatomic, copy) NSString *trackCount;
@property (nonatomic, strong) NSMutableArray  *tracks;


@end
