//
//  QAlbumDetial.h
//  BaBaTeng
//
//  Created by liu on 17/9/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QAlbumDetialData.h"

@interface QAlbumDetial : NSObject

@property (nonatomic, strong) QAlbumDetialData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end
