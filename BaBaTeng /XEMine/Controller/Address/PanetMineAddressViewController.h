//
//  PanetMineAddressViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

typedef void(^PanetMineAddressBlock) (NSString *addressStr, NSString *phonenumStr, NSString *nameStr);

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAddressViewController : CommonViewController

@property(nonatomic,copy)PanetMineAddressBlock block;

@property (nonatomic, strong) NSString *addressType;

@end

NS_ASSUME_NONNULL_END
