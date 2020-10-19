//
//  QPanelData.h
//  BaBaTeng
//
//  Created by liu on 17/7/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface QPanelData : NSObject<MJKeyValue>

//"devicePanelIcon": "aa",
//"devicePanelName": "学英语",
//"deviceTypeId": "010000",
//"panelId": 3,
//"trackLists": []

@property(nonatomic, copy) NSString *devicePanelIcon;
@property(nonatomic, copy) NSString *devicePanelName;
@property(nonatomic, copy) NSString *deviceTypeId;
@property(nonatomic, copy) NSString *panelId;
@property(nonatomic, strong) NSArray *trackLists;

@end
