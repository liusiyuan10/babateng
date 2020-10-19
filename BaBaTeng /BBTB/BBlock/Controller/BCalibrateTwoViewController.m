//
//  BCalibrateTwoViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/8/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BCalibrateTwoViewController.h"
#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"

#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#import "BCalibrateOneViewController.h"
#import "BCalibrateTwoViewController.h"



@interface BCalibrateTwoViewController ()

@property (nonatomic, strong) UIButton *CalibrateBtn;



@property(nonatomic,assign)BOOL backPortrait;

@end

@implementation BCalibrateTwoViewController

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


- (UIButton *)CalibrateBtn
{
    if (_CalibrateBtn == nil) {
        
        _CalibrateBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth -122)/2.0, (KDeviceHeight -122)/2.0 - 64, 122,122)];
        
        
        [_CalibrateBtn addTarget:self action:@selector(CalibrateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_CalibrateBtn setImage:[UIImage imageNamed:@"CalibrateT_btn_xxxz_n"] forState:UIControlStateNormal];
        [_CalibrateBtn setImage:[UIImage imageNamed:@"CalibrateT_btn_xxxz_s"] forState:UIControlStateHighlighted];
        
    }
    return _CalibrateBtn;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"巡线模式";
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self LoadChlidView];
    
    
    
    
}

- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"CalibrateT_bg_xxxz"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    [bgImageView addSubview:self.CalibrateBtn];

    
    
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+kDevice_Is_iPhoneX, 99, 70)];
    
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_nor"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_pre"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backbutton];
    
    
}



- (void)CalibrateBtnClicked
{

    [self SendBlueCode:@"M231"];
    
}

- (void)SendBlueCode:(NSString *)code
{
    
    
    NSString *str11 =  [EasyUtils ConvertStringToHexString:code];
    NSString *str121 = [NSString stringWithFormat:@"%@%@",str11,@"0a"];
    
    //        NSString *str121 = @"C2:XYJWIFI:xyjwifi@2017";
    
    NSData *data = [EasyUtils convertHexStrToData:str121];
    
    NSLog(@"str11======%@",str11);
    //fe6a
    NSLog(@"ssss ---- %@ ",data);
    
    
    [self.currPeripheral writeValue:data forCharacteristic:self.babycharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    
}

- (void)backFore
{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//
//
//
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
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
