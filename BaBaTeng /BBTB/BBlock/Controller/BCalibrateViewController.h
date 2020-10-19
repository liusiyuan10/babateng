//
//  BCalibrateViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface BCalibrateViewController : CommonViewController
{
@public
    BabyBluetooth *baby;
}


@property (nonatomic,strong)CBCharacteristic *babycharacteristic;
@property (nonatomic,strong)CBCharacteristic *babycharacteristicrevice;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
