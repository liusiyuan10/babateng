//
//  EquipmentScanBindingViewController.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2018/1/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"

@interface EquipmentScanBindingViewController : CommonViewController
@property(nonatomic, copy) NSString *deviceTypeName;

@property(nonatomic, copy) NSString *deviceTypeId;

@property(nonatomic, copy) NSString *iconUrl;

- (void)manuallyEnter:(NSString*)code;

+(EquipmentScanBindingViewController *)getInstance;

@end
