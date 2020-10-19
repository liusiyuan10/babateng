//
//  BCalibrateOneViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/8/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//
//  BCalibrateViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BCalibrateOneViewController.h"
#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"

#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#define  BCalibeH  (KDeviceHeight - 100 -32)/668.0*KDeviceHeight

@interface BCalibrateOneViewController ()

@property (nonatomic, strong) UIButton *LeftMaxBtn;
@property (nonatomic, strong) UIButton *LeftSmallBtn;
@property (nonatomic, strong) UIButton *RightMaxBtn;
@property (nonatomic, strong) UIButton *RightSmallBtn;
@property (nonatomic, strong) UIButton *StartBtn;

@property (nonatomic, strong) UIButton *DefaultBtn;

@property (nonatomic, strong) UILabel *ValeLabel;

@property (nonatomic, assign) CGFloat blueVale;

@property(nonatomic, strong) UIButton *back;

@property(nonatomic,assign)BOOL backPortrait;

@end

@implementation BCalibrateOneViewController

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

- (UILabel *)ValeLabel
{
    if (_ValeLabel == nil) {
        
        _ValeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 250) /2.0, 20, 250,60)];
        
        _ValeLabel.textAlignment = NSTextAlignmentCenter;
        
        _ValeLabel.font = [UIFont systemFontOfSize:72];
        
        _ValeLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:122.0/255.0 blue:33.0/255.0 alpha:1.0];
        
        
        
        //        [_LeftMaxBtn setTitle:@"左大进" forState:UIControlStateNormal];
        //        [_LeftMaxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //
        //        [_LeftMaxBtn addTarget:self action:@selector(LeftMaxBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //        [_LeftMaxBtn setImage:[UIImage imageNamed:@"mc_nor"] forState:UIControlStateNormal];
        //        [_LeftMaxBtn setImage:[UIImage imageNamed:@"mc_pre"] forState:UIControlStateHighlighted];
        
    }
    return _ValeLabel;
}

- (UIButton *)LeftMaxBtn
{
    if (_LeftMaxBtn == nil) {
        
        _LeftMaxBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0 - (30 + 82) * 2, BCalibeH + 9, 82,82)];
        
        //        [_LeftMaxBtn setTitle:@"左大进" forState:UIControlStateNormal];
        //        [_LeftMaxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_LeftMaxBtn addTarget:self action:@selector(LeftMaxBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_LeftMaxBtn setImage:[UIImage imageNamed:@"Calibrateleft2_n"] forState:UIControlStateNormal];
        [_LeftMaxBtn setImage:[UIImage imageNamed:@"Calibrateleft2_s"] forState:UIControlStateHighlighted];
        
    }
    return _LeftMaxBtn;
}

- (UIButton *)LeftSmallBtn
{
    if (_LeftSmallBtn == nil) {
        
        _LeftSmallBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0 - 30 - 82, BCalibeH + 9, 82,82)];
        
        //        [_LeftSmallBtn setTitle:@"左小进" forState:UIControlStateNormal];
        //        [_LeftSmallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_LeftSmallBtn addTarget:self action:@selector(LeftSmallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_LeftSmallBtn setImage:[UIImage imageNamed:@"Calibrateleft1_n"] forState:UIControlStateNormal];
        [_LeftSmallBtn setImage:[UIImage imageNamed:@"Calibrateleft1_s"] forState:UIControlStateHighlighted];
        
    }
    return _LeftSmallBtn;
}

- (UIButton *)StartBtn
{
    if (_StartBtn == nil) {
        
        _StartBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, BCalibeH, 100,100)];
        
        //        [_StartBtn setTitle:@"开始" forState:UIControlStateNormal];
        //        [_StartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_StartBtn addTarget:self action:@selector(StartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_StartBtn setImage:[UIImage imageNamed:@"Calibratestart"] forState:UIControlStateNormal];
        [_StartBtn setImage:[UIImage imageNamed:@"Calibratestop"] forState:UIControlStateSelected];
        
    }
    return _StartBtn;
}

- (UIButton *)RightSmallBtn
{
    if (_RightSmallBtn == nil) {
        
        _RightSmallBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.StartBtn.frame) + 30, BCalibeH + 9, 82,82)];
        
        //        [_RightSmallBtn setTitle:@"右小进" forState:UIControlStateNormal];
        //        [_RightSmallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_RightSmallBtn addTarget:self action:@selector(RightSmallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_RightSmallBtn setImage:[UIImage imageNamed:@"Calibrateright1_n"] forState:UIControlStateNormal];
        [_RightSmallBtn setImage:[UIImage imageNamed:@"Calibrateright1_s"] forState:UIControlStateHighlighted];
        
    }
    return _RightSmallBtn;
}

- (UIButton *)RightMaxBtn
{
    if (_RightMaxBtn == nil) {
        
        _RightMaxBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.RightSmallBtn.frame) + 30, BCalibeH + 9, 82,82)];
        
        //        [_RightMaxBtn setTitle:@"右大进" forState:UIControlStateNormal];
        //        [_RightMaxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_RightMaxBtn addTarget:self action:@selector(RightMaxBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_RightMaxBtn setImage:[UIImage imageNamed:@"Calibrateright2_n"] forState:UIControlStateNormal];
        [_RightMaxBtn setImage:[UIImage imageNamed:@"Calibrateright2_s"] forState:UIControlStateHighlighted];
        
    }
    return _RightMaxBtn;
}

- (UIButton *)DefaultBtn
{
    if (_DefaultBtn == nil) {
        
        _DefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 155 - 30, 20, 155,42)];
        
        //        [_RightMaxBtn setTitle:@"右大进" forState:UIControlStateNormal];
        //        [_RightMaxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_DefaultBtn addTarget:self action:@selector(DefaultBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_DefaultBtn setImage:[UIImage imageNamed:@"Calibrate_btn_hfmrz_n"] forState:UIControlStateNormal];
        [_DefaultBtn setImage:[UIImage imageNamed:@"Calibrate_btn_hfmrz_s"] forState:UIControlStateHighlighted];
        
    }
    return _DefaultBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"直线模式";
    
    [self SendBlueCode:@"M228 0"];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.blueVale = 0.0;
    
    [self LoadChlidView];
    
    //    [self SendBlueCode:@"M210"];
    
    
    [self performSelector:@selector(sendBlueM) withObject:nil afterDelay:1.0];
    
//    [self IScurrPeripheral];
    
    
}

- (void)sendBlueM
{
    [self SendBlueCode:@"M210"];
}

- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"Calibrate_bg"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    [bgImageView addSubview:self.LeftMaxBtn];
    [bgImageView addSubview:self.LeftSmallBtn];
    [bgImageView addSubview:self.StartBtn];
    [bgImageView addSubview:self.RightMaxBtn];
    [bgImageView addSubview:self.RightSmallBtn];
    [bgImageView addSubview:self.ValeLabel];
    
    [bgImageView addSubview:self.DefaultBtn];
    
    self.ValeLabel.text = @"0.0";
    
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+kDevice_Is_iPhoneX, 99, 70)];
    
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_nor"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_pre"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backbutton];
    
    [self CharacteristicRecive];
    
    
}

- (void)CharacteristicRecive
{
    [self.currPeripheral setNotifyValue:YES forCharacteristic:self.babycharacteristicrevice];
    
    NSLog(@"订阅通知");
    
    //    __weak typeof(self)weakSelf = self;
    [baby notify:self.currPeripheral
  characteristic:self.babycharacteristicrevice
           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
               NSLog(@"notify block");
               NSLog(@"new value %@",characteristics.value);
               
               [self characteristicReciveData:characteristics.value];
               
           }];
    
}

- (void)characteristicReciveData:(NSData *)recivedata
{
    NSLog(@"characteristicReciveData=======%@", recivedata);
    
    
    NSString *str =  [EasyUtils convertDataToHexStr:recivedata];
    
    NSLog(@"strrecivice======%@",str);
    
    CGFloat strLength = str.length;
    
    NSString *str2 = [str substringWithRange:NSMakeRange(6,strLength -8)];//str2 = "name"
    
    NSLog(@"str2=================%@",str2);
    
    NSString *str3 =  [EasyUtils ConvertHexStringToString:str2];
    
    NSLog(@"strrecivicessssss======%@",str3);
    
    NSRange range = [str3 rangeOfString:@"DC"];
    
    
    if (range.location != NSNotFound)
    {
        
        NSString *str4 = [str3 substringFromIndex:3];
        
        self.ValeLabel.text = [NSString stringWithFormat:@"%@",str4];
        self.blueVale = [str4 floatValue];
        
        NSLog(@"strrecisssssstr4s======%@",str4);
    }
    
    
    
    
    
    
}


- (void)LeftMaxBtnClicked
{
    self.blueVale -= 0.1;
    
    NSLog(@"LeftMaxBtnClickedself.blueVale===%f",self.blueVale);
    
    if (self.blueVale <0.0) {
        
        self.blueVale = 0.0;
    }
    
    self.ValeLabel.text = [NSString stringWithFormat:@"%.2f",self.blueVale];
    
    [self SendBlueCode:[NSString stringWithFormat:@"M209 %f",self.blueVale]];
    
    [self SendBlueCode:@"M200 0 150"];
    self.StartBtn.selected = YES;
    
}

- (void)LeftSmallBtnClicked
{
    self.blueVale -=  0.01;
    
    if (self.blueVale <0.0) {
        
        self.blueVale = 0.0;
    }
    
    NSLog(@"LeftSmallBtnClickedself.blueVale===%f",self.blueVale);
    self.ValeLabel.text = [NSString stringWithFormat:@"%.2f",self.blueVale];
    [self SendBlueCode:[NSString stringWithFormat:@"M209 %f",self.blueVale]];
    [self SendBlueCode:@"M200 0 150"];
    self.StartBtn.selected = YES;
}

- (void)StartBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        NSLog(@"开始");
        [self SendBlueCode:@"M210"];
        [self SendBlueCode:@"M200 0 150"];
        
    }
    else
    {
        NSLog(@"结束");
        [self SendBlueCode:@"M200 0 0"];
    }
}

- (void)RightSmallBtnClicked
{
    self.blueVale += 0.01;
    
    if (self.blueVale > 1.99) {
        
        self.blueVale = 1.99;
    }
    
    
    
    NSLog(@"RightSmallBtnClickedself.blueVale===%f",self.blueVale);
    self.ValeLabel.text = [NSString stringWithFormat:@"%.2f",self.blueVale];
    [self SendBlueCode:[NSString stringWithFormat:@"M209 %f",self.blueVale]];
    [self SendBlueCode:@"M200 0 150"];
    self.StartBtn.selected = YES;
}

- (void)RightMaxBtnClicked
{
    self.blueVale += 0.1;
    
    if (self.blueVale > 1.99) {
        
        self.blueVale = 1.99;
    }
    
    
    NSLog(@"RightSmallBtnClickedself.blueVale===%f",self.blueVale);
    self.ValeLabel.text = [NSString stringWithFormat:@"%.2f",self.blueVale];
    [self SendBlueCode:[NSString stringWithFormat:@"M209 %f",self.blueVale]];
    [self SendBlueCode:@"M200 0 150"];
    self.StartBtn.selected = YES;
}

- (void)DefaultBtnClicked
{
    self.blueVale = 1.0;
    self.ValeLabel.text = [NSString stringWithFormat:@"%.2f",self.blueVale];

    [self SendBlueCode:@"M209 1"];
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

- (void)SendBlueCode:(NSString *)code
{
    
    //    if (self.currPeripheral.state == CBPeripheralStateDisconnected) {
    //
    //        [self showToastWithString:@"蓝牙已断开"];
    //
    //        NSString *encodedString = [[TMCache sharedCache] objectForKey:@"HomedeviceIocn"];
    //
    //        NSDictionary   *jsonDict=@{@"deviceIocn":encodedString};
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];
    //
    //        return;
    //
    //    }
    
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
    
    [self SendBlueCode:@"M200 0 0"];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
