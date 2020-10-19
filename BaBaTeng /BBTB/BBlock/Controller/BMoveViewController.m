//
//  BMoveViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/16.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BMoveViewController.h"

#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"

#import "ZMRocker.h"

#import "CLRocker.h"

#import "EasyUtils.h"

#import "BSceneViewController.h"



@interface BMoveViewController ()<ZMRockerDelegate,CLRockerDelegate>

@property (strong, nonatomic) ZMRocker *rocker;

@property (nonatomic, strong) CLRocker *clrocker;

@property (nonatomic, strong) UIButton *FaceHpBtn;
@property (nonatomic, strong) UIButton *FaceOHBtn;
@property (nonatomic, strong) UIButton *FaceUNBtn;

@property (nonatomic, assign) NSInteger FaceBtnNum;

@property (nonatomic, assign) NSInteger FacerockerNum;

@end

@implementation BMoveViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运动模式";
    
    [self SendBlueCode:@"M228 0"];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    self.FaceBtnNum = 0;
    
    [self LoadChlidView];
    
    
      [self IScurrPeripheral];
    
}

- (void)LoadChlidView
{
    
//    UIButton *backBtn = [UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    

    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"kz_bg"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    //适配iphone x
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+kDevice_Is_iPhoneX, 99, 70)];
    
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_nor"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_pre"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backbutton];
    
    self.rocker = [[ZMRocker alloc] initWithFrame:CGRectMake(20, (KDeviceHeight - 260)/2.0, 260, 260)];
    
    [self.rocker setRockerStyle:RockStyleTranslucent];
    
//    self.rocker.userInteractionEnabled = NO;
    
    self.rocker.delegate = self;
    
    [bgImageView addSubview:self.rocker];
    
    self.clrocker = [[CLRocker alloc] initWithFrame:CGRectMake(kDeviceWidth - 216 - 40, 80 + 5, 216, 216)];
    
//    [self.rocker setRockerStyle:RockStyleOpaque];
    
    self.clrocker.delegate = self;
    
    [bgImageView addSubview:self.clrocker ];
    
    self.FaceHpBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - (216 - 78)/2.0 - 78 -40 - 78 - 15, 5, 78, 78)];

    [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y-1"] forState:UIControlStateNormal];

    [self.FaceHpBtn addTarget:self action:@selector(FaceHpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:self.FaceHpBtn];
    
    self.FaceOHBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - (216 - 78)/2.0 - 78 -40, 5, 78, 78)];
    
    [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
    
    [self.FaceOHBtn addTarget:self action:@selector(FaceOhBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:self.FaceOHBtn];
    
    self.FaceUNBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.FaceOHBtn.frame) + 15, 5, 78, 78)];
    
    [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];

    [self.FaceUNBtn addTarget:self action:@selector(FaceUnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:self.FaceUNBtn];
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 102-57 - 40, 80 + 5 + 55 + 2, 102, 102)];
    
//    testBtn.backgroundColor = [UIColor redColor];
    [testBtn setImage:[UIImage imageNamed:@"btn_led_0"] forState:UIControlStateNormal];
    [testBtn setImage:[UIImage imageNamed:@"btn_led_9_on"] forState:UIControlStateSelected];
    [testBtn addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:testBtn];
    
    [self SendBlueCode:@"M220 1"];
    [self SendBlueCode:@"M221 2"];
    
    self.FacerockerNum = 2;
    
    UIButton *SenceBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 119)/2.0, KDeviceHeight - 32, 119, 27)];
    
    [SenceBtn setImage:[UIImage imageNamed:@"SenceBtn"] forState:UIControlStateNormal];
    
    [SenceBtn addTarget:self action:@selector(SenceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:SenceBtn];
    
}

- (void)SenceBtnClicked
{
    BSceneViewController *BSceneVC = [[BSceneViewController alloc] init];
    
    BSceneVC.currPeripheral = appDelegate.currPeripheral;
    BSceneVC.babycharacteristic = appDelegate.babycharacteristic;
    BSceneVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
    BSceneVC->baby = appDelegate->baby;

    [self.navigationController pushViewController:BSceneVC animated:YES];
}


- (void)FaceHpBtnClicked
{
    self.FaceBtnNum = 0;
    
    [self SendBlueCode:@"M220 1"];
    
//    [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y-1"] forState:UIControlStateNormal];
    
    [self FaceHpBtnRockerImage:self.FacerockerNum];
    
    
     [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
    

    
    [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
}

- (void)FaceOhBtnClicked
{
    self.FaceBtnNum = 1;
    
//    [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_o"] forState:UIControlStateNormal];
    
    [self SendBlueCode:@"M220 0"];
    
    [self FaceOhBtnRockerImage:self.FacerockerNum];
    
    [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
    
    

    
    [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
}

- (void)FaceUnBtnClicked
{
    self.FaceBtnNum = 2;
    
    [self SendBlueCode:@"M220 2"];
    
//     [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_o"] forState:UIControlStateNormal];
    
    [self FaceUnBtnRockerImage:self.FacerockerNum];
    
    [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
    
    [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
}

-(void)testBtnClicked:(UIButton *)btn
{
    NSLog(@"sdfdsss1111111111111111");
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.clrocker.hidden = YES;
        [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
        
        [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
        
        [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
        
        self.FaceHpBtn.hidden = YES;
        self.FaceUNBtn.hidden = YES;
        self.FaceOHBtn.hidden = YES;
        
        [self SendBlueCode:@"M221 0"];
        
    }else
    {
//        [self SendBlueCode:@"M221 1"];
        
        [self SendBlueCode:@"M200 0"];
        
        self.FacerockerNum = 2;
        
        [self SendBlueCode:@"M221 2"];
        
        
        
        self.FaceBtnNum = 0;
        self.clrocker.hidden = NO;
        
        self.FaceHpBtn.hidden = NO;
        self.FaceUNBtn.hidden = NO;
        self.FaceOHBtn.hidden = NO;
        [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
        
        [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
        
          [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y-1"] forState:UIControlStateNormal];
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



- (void)rockerDidChangeDirection:(ZMRocker *)rocker
{
    NSLog(@"Directionssss : %ld",(long)rocker.direction);
    
//    NSArray *directios = @[@"Left",@"Up",@"Right",@"Down",@"Center"];

//    /CoreData:  API Misuse: Attempt to serialize store access on non-owning coordinator (PSC = 0x7faed803fe80, store PSC = 0x0)
//    _label.text = directios[rocker.direction];
    
    switch (rocker.direction) {
        case 0:
            [self SendBlueCode:@"M200 1 -100"];
            [self SendBlueCode:@"M200 2 100"];
            break;
        case 1:
            [self SendBlueCode:@"M200 0 150"];
            break;
        case 2:
            [self SendBlueCode:@"M200 2 -100"];
            [self SendBlueCode:@"M200 1 100"];
            
            break;
        case 3:
            [self SendBlueCode:@"M200 0 -150"];
            break;
            
        case 4:
            [self SendBlueCode:@"M200 0 0"];
          
            break;
            
        default:
            break;
    }
    
    
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
//        [self showToastWithString:@"蓝牙已断开"];
////        [self.navigationController popViewControllerAnimated:YES];
//        [self backFore];
//        return;
//    }
    
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
    
    NSLog(@"code11111111111111111111111======%@",code);
    NSString *str11 =  [EasyUtils ConvertStringToHexString:code];
    NSString *str121 = [NSString stringWithFormat:@"%@%@",str11,@"0a"];
    
  
//    NSString *str121 = @"C2:XYJWIFI:xyjwifi@2017";
    
    NSData *data = [EasyUtils convertHexStrToData:str121];
    

    //fe6a
    NSLog(@"ssss ---- %@ ",data);
    
//    [self.characteristic writeValueWithData:data callback:^(EasyCharacteristic *characteristic, NSData *data, NSError *error) {
//
//        queueMainStart
//        NSLog(@"发送成功");
//        queueEnd
//    }];  
    NSLog(@"self.babycharacteristic=========%@",self.babycharacteristic);
    [self.currPeripheral writeValue:data forCharacteristic:self.babycharacteristic type:CBCharacteristicWriteWithResponse];
    
    
}


- (void)clrockerDidChangeDirection:(CLRocker *)rocker
{
        NSLog(@"ssssssssDirectionssss : %ld",(long)rocker.direction);
    
    if (self.FaceBtnNum == 0) {
        [self FaceHpBtnImage:rocker];
    }
    else if (self.FaceBtnNum == 1)
    {
        [self FaceOhBtnImage:rocker];
    }else if (self.FaceBtnNum == 2)
    {
        [self FaceUnBtnImage:rocker];
    }
    


}



//self.FaceHpBtn

- (void)FaceHpBtnImage:(CLRocker *)rocker
{
    
    self.FacerockerNum = rocker.direction;
    switch (rocker.direction) {
        case 1:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 3"];

            break;
        case 2:
             [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y-1"] forState:UIControlStateNormal];
             [self SendBlueCode:@"M221 2"];
            break;
        case 3:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_r"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 1"];
            break;
        case 4:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_g"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 4"];
            break;
        case 5:
             [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_c"] forState:UIControlStateNormal];
             [self SendBlueCode:@"M221 5"];
            break;
        case 6:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_w"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 8"];
            break;
        case 7:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_b"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 6"];
            break;
        case 8:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_p"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 7"];
            break;
            
        default:
            
             [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
            break;
    }
    
}


- (void)FaceOhBtnImage:(CLRocker *)rocker
{
    self.FacerockerNum = rocker.direction;
    switch (rocker.direction) {
        case 1:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_y"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 3"];
            break;
        case 2:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_o"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 2"];
            break;
        case 3:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_r"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 1"];
            break;
        case 4:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_g"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 4"];
            break;
        case 5:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_c"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 5"];
            break;
        case 6:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_w"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 8"];
            break;
        case 7:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_b"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 6"];
            break;
        case 8:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_p"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 7"];
            break;
            
        default:
            
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
            break;
    }
    
}

- (void)FaceUnBtnImage:(CLRocker *)rocker
{
    self.FacerockerNum = rocker.direction;
    switch (rocker.direction) {
        case 1:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_y"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 3"];
            break;
        case 2:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_o"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 2"];
            break;
        case 3:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_r"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 1"];
            break;
        case 4:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_g"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 4"];
            break;
        case 5:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_c"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 5"];
            break;
        case 6:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_w"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 8"];
            break;
        case 7:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_b"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 6"];
            break;
        case 8:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_p"] forState:UIControlStateNormal];
            [self SendBlueCode:@"M221 7"];
            break;
            
        default:
            
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
            break;
    }
    
}


#pragma mark -------灯光缓冲
- (void)FaceHpBtnRockerImage:(NSInteger)rockernum
{
    switch (rockernum) {
        case 1:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y"] forState:UIControlStateNormal];

            break;
        case 2:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_y-1"] forState:UIControlStateNormal];
        
            break;
        case 3:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_r"] forState:UIControlStateNormal];
      
            break;
        case 4:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_g"] forState:UIControlStateNormal];
  
            break;
        case 5:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_c"] forState:UIControlStateNormal];

            break;
        case 6:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_w"] forState:UIControlStateNormal];

            break;
        case 7:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_b"] forState:UIControlStateNormal];

            break;
        case 8:
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_p"] forState:UIControlStateNormal];

            break;
            
        default:
            
            [self.FaceHpBtn setImage:[UIImage imageNamed:@"face_hp_nor"] forState:UIControlStateNormal];
            break;
    }
    
}

- (void)FaceOhBtnRockerImage:(NSInteger)rockernum
{
    switch (rockernum) {
        case 1:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_y"] forState:UIControlStateNormal];
 
            break;
        case 2:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_o"] forState:UIControlStateNormal];
    
            break;
        case 3:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_r"] forState:UIControlStateNormal];
  
            break;
        case 4:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_g"] forState:UIControlStateNormal];

            break;
        case 5:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_c"] forState:UIControlStateNormal];
 
            break;
        case 6:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_w"] forState:UIControlStateNormal];
    
            break;
        case 7:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_b"] forState:UIControlStateNormal];
     
            break;
        case 8:
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_p"] forState:UIControlStateNormal];

            break;
            
        default:
            
            [self.FaceOHBtn setImage:[UIImage imageNamed:@"face_oh_nor"] forState:UIControlStateNormal];
            break;
    }
    
}

- (void)FaceUnBtnRockerImage:(NSInteger)rockernum
{

    switch (rockernum) {
        case 1:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_y"] forState:UIControlStateNormal];
         
            break;
        case 2:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_o"] forState:UIControlStateNormal];
      
            break;
        case 3:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_r"] forState:UIControlStateNormal];
  
            break;
        case 4:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_g"] forState:UIControlStateNormal];
      
            break;
        case 5:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_c"] forState:UIControlStateNormal];
         
            break;
        case 6:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_w"] forState:UIControlStateNormal];
     
            break;
        case 7:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_b"] forState:UIControlStateNormal];
      
            break;
        case 8:
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_p"] forState:UIControlStateNormal];
         
            break;
            
        default:
            
            [self.FaceUNBtn setImage:[UIImage imageNamed:@"face_un_nor"] forState:UIControlStateNormal];
            break;
    }
    
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

    NSLog(@"1234345");
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

//- (void)backForePage
//{
//    //    [super backForePage];
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
