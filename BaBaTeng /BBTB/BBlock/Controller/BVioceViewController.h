//
//  BVioceViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface BVioceViewController : CommonViewController

@property (nonatomic,strong)CBCharacteristic *babycharacteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
