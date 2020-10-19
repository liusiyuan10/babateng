//
//  SyncEnglishDataListModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SyncEnglishDataListPanelModel.h"

@interface SyncEnglishDataListModel : NSObject


@property (nonatomic, copy)   NSString *costPrice;
@property (nonatomic, copy)    NSString *createTime;
@property (nonatomic, copy)    NSString *deviceTypeId;
@property (nonatomic, strong)    SyncEnglishDataListPanelModel *panel;
@property (nonatomic, copy)    NSString   *panelId;
@property (nonatomic, copy)    NSString   *price;
@property (nonatomic, copy)    NSString   *trackCount;
@property (nonatomic, copy)    NSString   *trackListAuthor;
@property (nonatomic, copy)    NSString   *trackListDescription;
@property (nonatomic, copy)    NSString   *trackListIcon;
@property (nonatomic, copy)    NSString   *trackListId;
@property (nonatomic, copy)    NSString   *trackListName;
@property (nonatomic, copy)    NSString   *trackListStatus;
@property (nonatomic, copy)    NSString   *updateTime;


@end
