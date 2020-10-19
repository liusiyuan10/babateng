//
//  BCalibrateOneViewController.h
//  BaBaTeng
//
//  Created by xyj on 2018/8/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"


@interface BCalibrateOneViewController : CommonViewController
{
@public
    BabyBluetooth *baby;
}


@property (nonatomic,strong)CBCharacteristic *babycharacteristic;
@property (nonatomic,strong)CBCharacteristic *babycharacteristicrevice;
@property (nonatomic,strong)CBPeripheral *currPeripheral;
@end
