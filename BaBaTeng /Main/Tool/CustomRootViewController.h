//
//  CustomRootViewController.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/16.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"

@interface CustomRootViewController : CommonViewController
+(CustomRootViewController *) getInstance;

@property(nonatomic,strong) NSString *EquipmentType;

-(void)comeback;

@end
