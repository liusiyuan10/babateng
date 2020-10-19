//
//  BBTMainTool.m
//  BaBaTeng
//
//  Created by liu on 16/10/19.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTMainTool.h"
#import "HomeViewController.h"
#import "HelpViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "QHomeViewController.h"
//#import "QReactNaHomeViewController.h"
#import "QChatViewController.h"
//#import "Q2ChatViewController.h"
#import "QCategoryViewController.h"
#import "QCustomViewController.h"
#import "QEquipmentViewController.h"
#import "BBTLoginViewController.h"


#import "NewHomeViewController.h"

#import "BBTPersonalCenterViewController.h"

#import "EnglishViewController.h"
#import "ChildViewController.h"
#import "PanetViewController.h"


#import "BBTShopViewController.h"
#import "XEMineViewController.h"

@implementation BBTMainTool

+ (void)setUpRootViewController:(UIWindow *)window
{

//    UIViewController *firstViewController = [[NewHomeViewController alloc] init];
//    UIViewController * secondViewController = [[QCustomViewController alloc] init];
//    UIViewController * thirdViewController = [[BBTPersonalCenterViewController alloc] init];
////    UIViewController * fourViewController = [[QHomeViewController alloc] init];
////    UIViewController * fireViewController = [[BBTPersonalCenterViewController alloc] init];
    
    UIViewController *firstViewController = [[NewHomeViewController alloc] init];
    UIViewController * secondViewController = [[EnglishViewController alloc] init];
//    UIViewController * thirdViewController = [[PanetViewController alloc] init];
    UIViewController * fourViewController = [[BBTShopViewController alloc] init];
    UIViewController * fireViewController = [[XEMineViewController alloc] init];




    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];




    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];




//    UIViewController *thirdNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:thirdViewController];



    UIViewController *fourNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:fourViewController];




    UIViewController *fireNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:fireViewController];



    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                       fourNavigationController,fireNavigationController]];

    // options是动画选项
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        //[UIApplication sharedApplication].keyWindow.rootViewController = [BBTLoginViewController new];
        window.rootViewController = tabBarController;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
    }];




    // 设置窗口的根控制器
   // window.rootViewController = tabBarController;

    [self customizeTabBarForController:tabBarController];


}


//+ (void)setUpRootViewController:(UIWindow *)window
//{
//
//    UIViewController *firstViewController = [[HomeViewController alloc] init];
//    UIViewController * secondViewController = [[OrderViewController alloc] init];
//    UIViewController * thirdViewController = [[ProductViewController alloc] init];
//    UIViewController * fourViewController = [[HelpViewController alloc] init];
//    //UIViewController * fireViewController = [[MineViewController alloc] init];
//
//
//
//
//    UIViewController *firstNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:firstViewController];
//
//
//
//
//    UIViewController *secondNavigationController = [[UINavigationController alloc]
//                                                    initWithRootViewController:secondViewController];
//
//
//
//
//    UIViewController *thirdNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:thirdViewController];
//
//
//
//    UIViewController *fourNavigationController = [[UINavigationController alloc]
//                                                  initWithRootViewController:fourViewController];
//
//
//
//
//   // UIViewController *fireNavigationController = [[UINavigationController alloc]
////                                                  initWithRootViewController:fireViewController];
//
//
//
//    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
//    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
//                                           thirdNavigationController,fourNavigationController]];
//
//    // options是动画选项
//    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        BOOL oldState = [UIView areAnimationsEnabled];
//        [UIView setAnimationsEnabled:NO];
//        //[UIApplication sharedApplication].keyWindow.rootViewController = [BBTLoginViewController new];
//        window.rootViewController = tabBarController;
//        [UIView setAnimationsEnabled:oldState];
//    } completion:^(BOOL finished) {
//    }];
//
//
//
//
//    // 设置窗口的根控制器
//   // window.rootViewController = tabBarController;
//
//    [self customizeTabBarForController:tabBarController];
//
//
//}



+ (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
//
//    NSArray *tabBarItemImages ;
//    NSArray *tabBarItemTitle ;
//
//
//    tabBarItemImages = @[@"first", @"second", @"third",@"four", @"five",];
//    tabBarItemTitle = @[@"首页", @"订单", @"商品",@"客户", @"我的",];
//
//
//
//
//    NSInteger index = 0;
//    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
//
//
//        item.title = tabBarItemTitle[index];
//        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
//                                                      [tabBarItemImages objectAtIndex:index]]];
//        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
//                                                        [tabBarItemImages objectAtIndex:index]]];
//        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
//
//        if (index == 2) {
//            item.enabled = NO;
//        }
//
//        index++;
//    }
    
    
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    
    NSArray *tabBarItemImages ;
    NSArray *tabBarItemTitle ;
    
    
    tabBarItemImages = @[@"first",@"second" ,@"four", @"five",];
    tabBarItemTitle = @[@"首页",@"少儿英语", @"商城", @"我的"];
    
    
    
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        
        item.title = tabBarItemTitle[index];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
//        if (index == 2) {
//            item.enabled = NO;
//        }
        
        index++;
    }
    
}




-(void)ridingButtonWasPressed:(id)sender{
    
    
}

+ (void)setLoginRootViewController:(UIWindow *)window{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DropsORCharge" object:self userInfo:nil];//掉线或者充电通知
    
    
    
    BBTLoginViewController *oneVC = [[BBTLoginViewController alloc] init];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];

    // options是动画选项
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        //[UIApplication sharedApplication].keyWindow.rootViewController = [BBTLoginViewController new];
         window.rootViewController = nav;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
    }];
    
}


@end
