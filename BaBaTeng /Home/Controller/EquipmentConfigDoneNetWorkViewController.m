//
//  EquipmentConfigDoneNetWorkViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentConfigDoneNetWorkViewController.h"

@interface EquipmentConfigDoneNetWorkViewController ()

@end

@implementation EquipmentConfigDoneNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self LoadChlidView];
}

- (void)LoadChlidView
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, kDeviceWidth - 100, 20)];
    
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.text = self.messageStr;
    
    [self.view addSubview:titleLabel];
}

@end
