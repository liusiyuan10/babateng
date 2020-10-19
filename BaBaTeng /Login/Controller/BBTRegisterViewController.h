//
//  BBTRegisterViewController.h
//  BaBaTeng
//
//  Created by liu on 16/10/13.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@protocol RegisterLoginDelegate <NSObject>

- (void)didRegisterLogin:(NSString*)userName Password:(NSString*)password;

@end

@interface BBTRegisterViewController : CommonViewController

@property (strong, nonatomic) id<RegisterLoginDelegate>delegate;

@end
