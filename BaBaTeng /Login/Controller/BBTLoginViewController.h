//
//  BBTLoginViewController.h
//  BaBaTeng
//
//  Created by liu on 16/10/11.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
@interface BBTLoginViewController : CommonViewController
@property (strong, nonatomic)  NSString* pageType;//判断是否是自动登录
@property (strong, nonatomic)  NSString* username;//自动登录username
@property (strong, nonatomic)  NSString* password;//自动登录password



@end
