//
//  EquipmentConfigNetWorkViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentConfigNetWorkViewController.h"
#import "EquipmentConfigDoneNetWorkViewController.h"
#import "EquipmentBindingViewController.h"
#import "BBTQAlertView.h"


@interface EquipmentConfigNetWorkViewController ()
{
        AppDelegate *appDele;
}

@property(nonatomic, strong) UIImageView *cofigView;
@property(nonatomic, strong) BBTQAlertView *QalertView;
@property (nonatomic, strong) UIButton      *cancelBtn;

@end

@implementation EquipmentConfigNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.deviceTypeName;//@"链接WI-FI";
    
    [self LoadChlidView];
    
    appDele = [(id)[UIApplication sharedApplication] delegate];
    [appDele.wscPresenter setVista:self];
    [appDele.wscPresenter startConfig];
    [self showConfiging];
    
    //[self showConfigFailure];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    
    [appDele.wscPresenter stopConfig];
}

- (void)LoadChlidView
{
    
//    icon_WIFIBIG_01

    self.cofigView = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 97)/2.0, 120, 97, 97)];
    self.cofigView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"icon_WIFIBIG_01.png"],
                                     [UIImage imageNamed:@"icon_WIFIBIG_02.png"],
                                     [UIImage imageNamed:@"icon_WIFIBIG_03.png"],
                                     [UIImage imageNamed:@"icon_WIFIBIG.png"],
                                      nil];
    [self.cofigView setAnimationDuration:5.0f];
    [self.cofigView setAnimationRepeatCount:0];
//    [self.cofigView startAnimating];
    [self.view addSubview:self.cofigView];
    
    UILabel *configLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.cofigView.frame) + 20, kDeviceWidth - 100, 20)];
    configLabel.textColor = [UIColor lightGrayColor];
    configLabel.text = @"设备正在连接网络";
    
    configLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:configLabel];
    
    
    
    
    //适配iphone x
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-50)/2, KDeviceHeight - 180-kDevice_Is_iPhoneX, 50, 51)];
    
//    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
//    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    
    [ self.cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    
    
//    self.configLoading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];//指定进度轮的大小
//    
//    [self.configLoading setCenter:CGPointMake(kDeviceWidth/2.0, KDeviceHeight/2.0)];//指定进度轮中心点
//    
//    [self.configLoading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
//    
//    self.configLoading.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:self.configLoading];
    

    
}

-(void)cancelBtnClick{

    [appDele.wscPresenter stopConfig];

    NSArray *pushVCAry=[self.navigationController viewControllers];
    
    
    //下面的pushVCAry.count-3 是让我回到视图1中去
    
    UIViewController *popVC=[pushVCAry objectAtIndex:1];
    
    
    
    [self.navigationController popToViewController:popVC animated:YES];
}

- (void)backForePage
{
      [appDele.wscPresenter stopConfig];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    NSArray *pushVCAry=[self.navigationController viewControllers];
//
//    UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-4];
//
//
//
//    [self.navigationController popToViewController:popVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)showConfiging{
    [self.cofigView startAnimating];
}

//#pragma mark - WSC delegate
-(void)showConfigFailure{
    NSLog(@"showConfigFailure**");
    
    [self.cofigView stopAnimating];
    
    
//    self.QalertView = [[BBTQAlertView alloc] initWithImage:@"kong" andWithTag:1 andWithButtonTitle:@"取消",@"确定", nil];
    

    
    self.QalertView = [[BBTQAlertView alloc] initWithNetImage:@"kong" andWithTag:1 andWithButtonTitle:@"确定"];
    
    
    [self.QalertView showInView:self.view];
    
    __block EquipmentConfigNetWorkViewController *self_c = self;
    
    //点击按钮回调方法
    self.QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
//            NSArray *pushVCAry=[self_c.navigationController viewControllers];
//
//
//            //下面的pushVCAry.count-3 是让我回到视图1中去
//
//            UIViewController *popVC=[pushVCAry objectAtIndex:1];
//
//
//
//            [self_c.navigationController popToViewController:popVC animated:YES];
            
             [self_c.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"确定");
        }
        
        
//        if (titleBtnTag == 0) {
//
//            NSLog(@"取消");
//
//
//            NSArray *pushVCAry=[self_c.navigationController viewControllers];
//
//
//            //下面的pushVCAry.count-3 是让我回到视图1中去
//
//            UIViewController *popVC=[pushVCAry objectAtIndex:1];
//
//
//
//            [self_c.navigationController popToViewController:popVC animated:YES];
//
//
//
//        }
        
        
    };
    
    
    
}


-(void) showConfigSuccess{
    NSLog(@"******showConfigSuccess******");
    [self.cofigView stopAnimating];

    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    bindVc.iconUrl =self.iconUrl;
    [self.navigationController pushViewController:bindVc animated:YES];

}

@end
