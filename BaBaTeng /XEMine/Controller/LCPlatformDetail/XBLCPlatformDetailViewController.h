//
//  XBLCPlatformDetailViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "LCPlatformListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XBLCPlatformDetailViewController : CommonViewController

@property(nonatomic, strong)  LCPlatformListModel *listdata;

@end

NS_ASSUME_NONNULL_END
