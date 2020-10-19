//
//  SyncEnglishModelData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SyncEnglishDataListModel.h"

@interface SyncEnglishModelData : NSObject


@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, copy)    NSString *panelId;
@property (nonatomic, copy)    NSString *trackCount;
@property (nonatomic, strong)  SyncEnglishDataListModel *trackList;
@property (nonatomic, copy)    NSString *trackListAuthor;
@property (nonatomic, copy)    NSString   *trackListDescription;
@property (nonatomic, copy)    NSString *trackListIcon;
@property (nonatomic, copy)    NSString *trackListId;
@property (nonatomic, copy)    NSString *trackListName;
@property (nonatomic, copy)    NSString *studying;


@end
