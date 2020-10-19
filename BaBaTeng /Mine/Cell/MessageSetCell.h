//
//  MessageSetCell.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SevenSwitch.h"

@interface MessageSetCell : UITableViewCell

@property(nonatomic,strong)SevenSwitch *sevenSwitch;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *subNameLabel;

@end
