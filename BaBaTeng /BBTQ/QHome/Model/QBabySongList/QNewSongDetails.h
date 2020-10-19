//
//  QNewSongDetails.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNewSongDetailsData.h"
@interface QNewSongDetails : NSObject

@property (nonatomic, strong) QNewSongDetailsData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end
