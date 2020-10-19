//
//  QAlbumDetialData.h
//  BaBaTeng
//
//  Created by liu on 17/9/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAlbumDataTrack.h"

@interface QAlbumDetialData : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *panelId;
@property (nonatomic, copy) NSString *trackListAuthor;
@property (nonatomic, copy) NSString *trackListDescription;
@property (nonatomic, copy) NSString *trackListIcon;
@property (nonatomic, copy) NSString *trackListId;
@property (nonatomic, copy) NSString *trackListName;
@property (nonatomic, copy) NSString *trackCount;
@property (nonatomic, strong) QAlbumDataTrack *tracks;

@end
