//
//  EquipmentConfigNetWorkViewController.h
//  BaBaTeng
//
//  Created by liu on 17/5/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WscPresenter.h"
#import "WscVista.h"
#import "CommonViewController.h"

@interface EquipmentConfigNetWorkViewController : CommonViewController<WscVista>
@property(nonatomic, copy) NSString *deviceTypeName;
@property(nonatomic, copy) NSString *deviceTypeId;
@property(nonatomic, copy) NSString *iconUrl;

@property(nonatomic, copy) NSString *deivceProgramId;

@end
