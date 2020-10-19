//
//  BVoiceDataModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/29.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface BVoiceDataModel : NSObject<MJKeyValue>

//@property(nonatomic, copy) NSString *message;
//
//@property(nonatomic, copy) NSString *statusCode;
//
//@property(nonatomic, strong) BVoiceDataModel *data;

@property(nonatomic, copy) NSString *dataStatusCode;
@property(nonatomic, strong) NSArray *controldata;
@property(nonatomic, copy)  NSArray *QAlbumDataTrackList;
@end
