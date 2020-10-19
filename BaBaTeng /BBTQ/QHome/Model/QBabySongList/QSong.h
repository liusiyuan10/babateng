//
//  QHistory.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSongData.h"
@interface QSong : NSObject

@property (nonatomic, strong) QSongData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end
