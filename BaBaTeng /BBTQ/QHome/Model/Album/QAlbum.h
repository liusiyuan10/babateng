//
//  QAlbum.h
//  BaBaTeng
//
//  Created by liu on 17/7/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAlbumData.h"

@interface QAlbum : NSObject

@property (nonatomic, strong) QAlbumData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end
