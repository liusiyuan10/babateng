//
//  EquipmentSetHotNetworkViewController.h
//  BaBaTeng
//
//  Created by xyj on 2018/9/11.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"

@interface EquipmentSetHotNetworkViewController : CommonViewController

@property(nonatomic, copy) NSString *deivceProgramId;

@property(nonatomic, copy) NSString *deviceTypeName;
@property(nonatomic, copy) NSString *deviceTypeId;
@property(nonatomic, copy) NSString *iconUrl;

@property(nonatomic, copy) NSString *wifiName;
@property(nonatomic, copy) NSString *wifiPassword;

@end
