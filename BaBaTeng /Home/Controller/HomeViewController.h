//
//  HomeViewController.h
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
@interface HomeViewController : CommonViewController

//- (void)SendMessage:(NSDictionary *)message;

- (void)disconnectWithmKTopic;

- (void)SendMessagemKTopic:(NSString *)mktopic Message:(NSDictionary *)message;

- (void)offDeviceStaues;

- (void)KickedOutDeviceStaues;

+(HomeViewController *)getInstance;

@end
