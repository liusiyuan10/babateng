//
//  EquipmentSetHotNetworkViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/9/11.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentSetHotNetworkViewController.h"

#import "BBTQAlertView.h"


#import "EquipmentBindingViewController.h"

#import "BBTEquipmentRequestTool.h"



@interface EquipmentSetHotNetworkViewController ()

@property(nonatomic, strong) UIImageView *cofigView;
@property(nonatomic, strong) BBTQAlertView *QalertView;
@property (nonatomic, strong) UIButton      *cancelBtn;



@end

@implementation EquipmentSetHotNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.deviceTypeName;

    [self LoadChlidView];
    
    [self showConfiging];
    
 
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
    
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(configLabel.frame) + 20, kDeviceWidth - 40, 150)];
    stateLabel.textColor = [UIColor lightGrayColor];
    stateLabel.text = @"当听到设备发出配网成功提示音后，表示设备已联网成功，您可返回到添加设备页面绑定已联网设备；若设备没有发出配网成功提示音，请点击返回按钮返回到上一页面重新操作。";
    
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.numberOfLines = 0;
    
    [self.view addSubview:stateLabel];
    
    
    
    //适配iphone x
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-100)/2, KDeviceHeight - 180-kDevice_Is_iPhoneX, 100, 51)];
    
    //    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
    //    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    
    [ self.cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    [self GetAoguqiHotNetwork];
    
    
}

- (void)GetAoguqiHotNetwork
{
    NSDictionary *parameter = @{@"wifiName" : self.wifiName, @"wifiPassword" : self.wifiPassword};
    
    [BBTEquipmentRequestTool GetAoguqiHotNetworkParameter:parameter success:^(NSString *response) {
        
        NSLog(@"responsessssssssss=========%@",response);
//        [response stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        [response stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
        NSCharacterSet *set1 = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];

        NSString *trimmedString1 = [response stringByTrimmingCharactersInSet:set1];
        
        if ([trimmedString1 isEqualToString:@"fail"]) {
            
            [self showToastWithString:@"设备收不到Wi-Fi信息，请重新操作"];
           
            
        }else
        {
             [self showToastWithString:@"设备已收到Wi-Fi信息，请耐心等待配网结果"];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

-(void)cancelBtnClick{
    

    
//    NSArray *pushVCAry=[self.navigationController viewControllers];
//
//
//    //下面的pushVCAry.count-3 是让我回到视图1中去
//
//    UIViewController *popVC=[pushVCAry objectAtIndex:1];
//
//
//
//    [self.navigationController popToViewController:popVC animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)backForePage
{
 
    [self.navigationController popViewControllerAnimated:YES];
    
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



-(void) showConfigSuccess{
    NSLog(@"******showConfigSuccess******");
    
    [self.cofigView stopAnimating];
    

    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    bindVc.iconUrl =self.iconUrl;
 
    [self.navigationController pushViewController:bindVc animated:YES];
    
}

//#pragma mark - WSC delegate
-(void)showConfigFailure{
    NSLog(@"showConfigFailure**");
    
    [self.cofigView stopAnimating];
    
    
    self.QalertView = [[BBTQAlertView alloc] initWithNetImage:@"kong" andWithTag:1 andWithButtonTitle:@"确定"];
    
    [self.QalertView showInView:self.view];
    
    __block EquipmentSetHotNetworkViewController *self_c = self;
    
    //点击按钮回调方法
    self.QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            

            
            [self_c.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"确定");
        }
        

    };
    
    
    
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
