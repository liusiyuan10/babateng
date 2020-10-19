//
//  EquipmentSetNetworkViewController.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"
#import "WscPresenter.h"
#import "WscVista.h"

@interface EquipmentSetNetworkViewController : CommonViewController<WscVista>
@property(nonatomic, copy) NSString *deviceTypeName;
@property(nonatomic, copy) NSString *deviceTypeId;
@property(nonatomic, copy) NSString *iconUrl;

@property(nonatomic, copy) NSString *deivceProgramId;

@end
