//
//  XBLCPlatformViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/30.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBLCPlatformViewController.h"

#import "XBAllLCPlatformViewController.h"
#import "XBActivationViewController.h"
#import "XBNoActivationViewController.h"
#import "XBToAuditViewController.h"
#import "XBExpiredViewController.h"
#import "TapSliderScrollView.h"

@interface XBLCPlatformViewController ()<SliderLineViewDelegate>

@property (nonatomic,strong)NSMutableArray *LbuttonViewArr;

@end

@implementation XBLCPlatformViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"代理平台";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.LbuttonViewArr = [NSMutableArray array];
    
    [self LoadChlidView];
    
}

- (void)LoadChlidView
{
    XBAllLCPlatformViewController    *XBAllLCPlatformVC = [[XBAllLCPlatformViewController alloc] init];
    XBNoActivationViewController     *XBNoActivationVC = [[XBNoActivationViewController alloc] init];
    XBToAuditViewController          *XBToAuditVC = [[XBToAuditViewController alloc] init];
    XBActivationViewController       *XBActivationVC = [[XBActivationViewController alloc] init];
    XBExpiredViewController          *XBExpiredVC = [[XBExpiredViewController alloc] init];
    
    
    TapSliderScrollView *viewControlVC = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    viewControlVC.delegate = self;
    //设置滑动条的颜色
    viewControlVC.sliderViewColor = MNavBackgroundColor;
    viewControlVC.titileColror = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    viewControlVC.selectedColor = MNavBackgroundColor;//x
    
    
    
    [viewControlVC createView:@[@"全部",@"未激活",@"待审核",@"已激活",@"已过期"] andViewArr:@[XBAllLCPlatformVC,XBNoActivationVC,XBToAuditVC,XBActivationVC,XBExpiredVC] andRootVc:self];
    
    
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


@end
