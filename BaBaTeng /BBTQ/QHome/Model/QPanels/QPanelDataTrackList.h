//
//  QPanelDataTrackList.h
//  BaBaTeng
//
//  Created by liu on 17/7/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPanelDataTrackList : NSObject

//"createTime": "2017-06-30 18:57:55",
//"panelId": 1,
//"trackListAuthor": "张三",
//"trackListIcon": "http://orfvq12yi.bkt.clouddn.com/image/icon/%E5%84%BF%E6%AD%8C%E7%B2%BE%E9%80%89.jpg",
//"trackListId": 1,
//"trackListName": "专辑1"

@property(nonatomic ,copy) NSString *createTime;
@property(nonatomic ,copy) NSString *panelId;
@property(nonatomic ,copy) NSString *trackListAuthor;
@property(nonatomic ,copy) NSString *trackListIcon;
@property(nonatomic ,copy) NSString *trackListId;
@property(nonatomic ,copy) NSString *trackListName;

@end
