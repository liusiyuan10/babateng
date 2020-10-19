//
//  CustomRootViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/16.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CustomRootViewController.h"
#import "BBTMainTool.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "QHomeViewController.h"
//#import "QReactNaHomeViewController.h"
#import "QChatViewController.h"
//#import "Q2ChatViewController.h"

#import "QCategoryViewController.h"
#import "QCustomViewController.h"
#import "QEquipmentViewController.h"
@interface CustomRootViewController ()<RDVTabBarControllerDelegate>

@end

@implementation CustomRootViewController
static CustomRootViewController * BackUpFilePath;

+(CustomRootViewController *) getInstance{
    
    return BackUpFilePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     BackUpFilePath =self;
        
  //  [BBTMainTool setQCommonUpRootViewController:self];

    [self setQCommonUpRootViewController:self];

}


-(void)setQCommonUpRootViewController:(UIViewController *)viewController{
    
    
    //走ReactNa界面
   // UIViewController *firstViewController = [[QReactNaHomeViewController alloc] init];
    
    UIViewController *firstViewController = [[QHomeViewController alloc] init];
    
    UIViewController * secondViewController = [[QCategoryViewController alloc] init];
    
    UIViewController * thirdViewController = [[QCustomViewController alloc] init];
    
    UIViewController * fourViewController = [[QChatViewController alloc] init];
    
    UIViewController * fiveViewController = [[QEquipmentViewController alloc] init];
    
    
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    
    
    
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    
    
    UIViewController *fourNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:fourViewController];
    
    
    UIViewController *fiveNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:fiveViewController];
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    tabBarController.pageType = @"goChat";
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,thirdNavigationController,fourNavigationController,fiveNavigationController]];
    
    tabBarController.delegate = self;
    
    [viewController.view addSubview:tabBarController.view];
    
    [viewController addChildViewController:tabBarController];
    
    //tabBarController.selectedIndex = 0;
    
    [self customizeQ2TabBarForController:tabBarController];
    
    
}



- (void)customizeQ2TabBarForController:(RDVTabBarController *)tabBarController {
    
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    
    NSArray *tabBarItemImages ;
    NSArray *tabBarItemTitle ;
    
    
    tabBarItemImages = @[@"first", @"second", @"",@"four", @"five",];
    tabBarItemTitle = @[@"首页", @"分类", @"",@"微聊", @"设备",];
    
    
    
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        
        item.title = tabBarItemTitle[index];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        if (index == 2) {
            item.enabled = NO;
        }
        
        index++;
    }
    
}

#pragma mark - RDVTabBarControllerDelegate

- (void)goChatViewController{
    
    [self.navigationController pushViewController:[QChatViewController new] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)comeback
{
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)comePresentback
{
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [[AppDelegate appDelegate]suspendButtonHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
     [[AppDelegate appDelegate]suspendButtonHidden:YES];
     self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
