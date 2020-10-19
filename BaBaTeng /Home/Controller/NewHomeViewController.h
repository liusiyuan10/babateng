//
//  NewHomeViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/24.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "AppDelegate.h"

//@class NewHomeViewController;
//
//
//@protocol NewHomeViewControllerDelegate <NSObject>
//
//- (void)NewHomeViewControllerName:(NewHomeViewController *)viewController DeviceName:(NSString *)name DeviceIcon:(NSString *)deviceicon;
//
//@end

#import "WMPageController.h"


@interface NewHomeViewController : WMPageController
{
    
    AppDelegate *appDelegate;
}


//@property(nonatomic, assign) id<NewHomeViewControllerDelegate> newdelegate;

- (void)disconnectWithmKTopic;

- (void)SendMessagemKTopic:(NSString *)mktopic Message:(NSDictionary *)message;

- (void)KickedOutDeviceStaues;


+(NewHomeViewController *)getInstance;

@end
