//
//  QSongDevicePlayData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSongDetailsPlayData.h"
@interface QSongDevicePlayData : NSObject

@property (nonatomic, strong) QSongDetailsPlayData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *statusCode;
@end
