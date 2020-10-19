//
//  QSongDetailsPlayData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSongDetailsPlayData : NSObject
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, strong) NSMutableArray  *tracks;

@end
