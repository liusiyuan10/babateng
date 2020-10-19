//
//  QAlbumListResponse.h
//  BaBaTeng
//
//  Created by liu on 17/5/23.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAlbumListResponse : NSObject

@property (nonatomic, copy) NSString *playPathAacv224;
@property (nonatomic, copy) NSString *playPathAacv164;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, strong) NSString *playUrl32;
@property (nonatomic, copy) NSString *isPaid;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *albumImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *playUrl64;
@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *downloadSize;
@property (nonatomic, copy) NSString *trackListId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *sequence;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *downUrl;

@end
