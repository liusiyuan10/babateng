//
//  CommonViewController.h
//  SingleProject
//
//  Created by admin on 16/7/7.
//  Copyright © 2016年 admin. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//#import "RDVTabBarController.h"
//#import "RDVTabBarItem.h"
//#import "AppDelegate.h"
//
//@interface CommonViewController : UIViewController
//
//@end


#import <UIKit/UIKit.h>
#import "Header.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "AppDelegate.h"
#import "TMCache.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "IphoneType.h"
@interface CommonViewController : UIViewController{

   AppDelegate *appDelegate;
}


@property(nonatomic, copy) NSString *searchstr;


/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏,也就是停止加载
 */
- (void)hideLoading;
/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showError;
/**
 *这种加载框锁住界面，加载没完成不能进行下一步的操作
 */
-(void)showOnWindow;
/**
 * 一些操作结果的提示,提示没有消失不能进行下一步操作
 */
- (void)showOnWindowWithString:(NSString *)content;
/**
 *一些操作结果的提示,提示没有消失可以进行下一步操作
 */
-(void) showToastWithString:(NSString *)content;


-(void)startLoading;


-(void)stopLoading;

@end
