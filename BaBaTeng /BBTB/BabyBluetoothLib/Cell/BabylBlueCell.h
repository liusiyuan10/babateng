//
//  ToolBlueCell.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BabylBlueCell : UITableViewCell

@property (nonatomic,strong)CBPeripheral *peripheral;

@property(nonatomic,strong)UILabel *bluenameLabel;
@property(nonatomic,strong)UILabel *blueUUIDLabel;
@property(nonatomic,strong)UILabel *stateLabel;

@end
