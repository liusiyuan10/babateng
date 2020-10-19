//
//  XEOrderViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEOrderViewController.h"

#import "XEMyOrderViewController.h"
#import "XEPaymentViewController.h"
#import "XEReceiveViewController.h"
#import "XECompletedViewController.h"
#import "TapSliderScrollView.h"

@interface XEOrderViewController ()<SliderLineViewDelegate>

@property (nonatomic,strong)NSMutableArray *LbuttonViewArr;

@end

@implementation XEOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.LbuttonViewArr = [NSMutableArray array];
    
    [self LoadChlidView];
    
   
}

- (void)LoadChlidView
{
    XEMyOrderViewController    *XEMyOrderVC = [[XEMyOrderViewController alloc] init];
    XEPaymentViewController    *XEPaymentVC = [[XEPaymentViewController alloc] init];
    XEReceiveViewController    *XEReceiveVC = [[XEReceiveViewController alloc] init];
    XECompletedViewController  *XECompletedVC = [[XECompletedViewController alloc] init];
    
    
    TapSliderScrollView *viewControlVC = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    viewControlVC.delegate = self;
    //设置滑动条的颜色
    viewControlVC.sliderViewColor = MNavBackgroundColor;
    viewControlVC.titileColror = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    viewControlVC.selectedColor = MNavBackgroundColor;//x
    
    
    
    [viewControlVC createView:@[@"全部",@"待付款",@"待收货",@"已完成"] andViewArr:@[XEMyOrderVC,XEPaymentVC,XEReceiveVC,XECompletedVC] andRootVc:self];
    
    
    self.LbuttonViewArr = viewControlVC.LbuttonViewArr;
    
    [self.view addSubview:viewControlVC];
    
    //自动滑动到第二页
    [viewControlVC sliderToViewIndex:self.pageIndex];
    

    
}


#pragma mark sliderDelegate
-(void)sliderViewAndReloadData:(NSInteger)index
{
    
    NSLog(@"刷新数据啦%ld",(long)index);

    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    
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
