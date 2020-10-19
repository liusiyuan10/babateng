//
//  BCalibrateViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BCalibrateViewController.h"
#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"

#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#import "BCalibrateOneViewController.h"
#import "BCalibrateTwoViewController.h"



@interface BCalibrateViewController ()

@property (nonatomic, strong) UIButton *LineBtn;
@property (nonatomic, strong) UIButton *CurvesBtn;


@property(nonatomic,assign)BOOL backPortrait;

@end

@implementation BCalibrateViewController

//此状态一定要是 NO  不然无法对旋转后的尺寸进行适配
-(BOOL)shouldAutorotate{
    
    return NO;
}
//支持的状态
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    
    
}


- (UIButton *)LineBtn
{
    if (_LineBtn == nil) {
        
        _LineBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 236 - 30, (KDeviceHeight - 70 *2 - 50) /2.0, 236,70)];
        

        [_LineBtn addTarget:self action:@selector(LineBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
       [_LineBtn setImage:[UIImage imageNamed:@"Calibrate_btn_zxxsxz_p_n"] forState:UIControlStateNormal];
       [_LineBtn setImage:[UIImage imageNamed:@"Calibrate_btn_zxxsxz_p_s"] forState:UIControlStateHighlighted];

    }
    return _LineBtn;
}

- (UIButton *)CurvesBtn
{
    if (_CurvesBtn == nil) {
        
        _CurvesBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 236 - 30,  CGRectGetMaxY(self.LineBtn.frame) + 50, 236,70)];
        

        
        [_CurvesBtn addTarget:self action:@selector(CurvesBBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        

        [_CurvesBtn setImage:[UIImage imageNamed:@"Calibrate_btn_xxxz_p_n"] forState:UIControlStateNormal];
        [_CurvesBtn setImage:[UIImage imageNamed:@"Calibrate_btn_xxxz_p_s"] forState:UIControlStateHighlighted];
        
    }
    return _CurvesBtn;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"校准模式";
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self LoadChlidView];
    
    
    [self IScurrPeripheral];
    
    
}

- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"Calibrate_BK"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    [bgImageView addSubview:self.LineBtn];
    [bgImageView addSubview:self.CurvesBtn];

    
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+kDevice_Is_iPhoneX, 99, 70)];

    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_nor"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_pre"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];

    [bgImageView addSubview:backbutton];
    
    
}



- (void)LineBtnClicked
{
    
    BCalibrateOneViewController *BCalibrateOneVC = [[BCalibrateOneViewController alloc] init];
    
    BCalibrateOneVC.currPeripheral = appDelegate.currPeripheral;
    BCalibrateOneVC.babycharacteristic = appDelegate.babycharacteristic;
    BCalibrateOneVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
    BCalibrateOneVC->baby = appDelegate->baby;
    
    [self.navigationController pushViewController:BCalibrateOneVC animated:YES];

    
}

- (void)CurvesBBtnClicked
{
    BCalibrateTwoViewController *BCalibrateTwoVC = [[BCalibrateTwoViewController alloc] init];
    
    BCalibrateTwoVC.currPeripheral = appDelegate.currPeripheral;
    BCalibrateTwoVC.babycharacteristic = appDelegate.babycharacteristic;
    BCalibrateTwoVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
    BCalibrateTwoVC->baby = appDelegate->baby;
    
    [self.navigationController pushViewController:BCalibrateTwoVC animated:YES];
}



- (void)IScurrPeripheral
{
    if (self.currPeripheral == nil || self.currPeripheral.state == CBPeripheralStateDisconnected) {
        
        [self showToastWithString:@"蓝牙已断开"];
        
        NSString *encodedString = [[TMCache sharedCache] objectForKey:@"HomedeviceIocn"];
        
        NSDictionary   *jsonDict=@{@"deviceIocn":encodedString};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];
        
        
    }
    
    
}


- (void)backFore
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    

    
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    NSLog(@"1234345111111");
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
