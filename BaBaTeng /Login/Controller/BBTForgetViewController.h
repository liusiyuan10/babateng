//
//  BBTForgetViewController.h
//  BaBaTeng
//
//  Created by liu on 16/10/19.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@protocol AutomaticLoginDelegate <NSObject>

- (void)didAutomaticLogin:(NSString*)userName Password:(NSString*)password;

@end

@interface BBTForgetViewController : CommonViewController

@property(nonatomic,copy) NSString * username;

@property (strong, nonatomic) id<AutomaticLoginDelegate>delegate;

@end
