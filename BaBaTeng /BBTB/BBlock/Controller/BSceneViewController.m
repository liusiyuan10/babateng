//
//  BSceneViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/23.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BSceneViewController.h"

#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"

#import "ZMRocker.h"


#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#import "BPlayTestViewController.h"

@interface BSceneViewController ()<ZMRockerDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) ZMRocker *rocker;

/** 定时器 **/
@property (nonatomic, strong) NSTimer *colortimer;

@property (nonatomic,strong)  AVAudioPlayer  *player;

@property (nonatomic, copy) NSString *colorStr;

@property(nonatomic,assign)BOOL IsPlaying;

@end

@implementation BSceneViewController

- (NSTimer *)colortimer
{
    if (!_colortimer) {
        _colortimer =[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(colorChange) userInfo:nil repeats:YES];
    }
    return _colortimer;
}

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
    
    self.title = @"场景模式";
    
    [self SendBlueCode:@"M1"];
    
    self.IsPlaying = NO;
    
    if ([BPlayTestViewController sharedInstance].IsBPlaying) {
        [[BPlayTestViewController sharedInstance] testPasue];
        self.IsPlaying = YES;
    }
    
    
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    self.colorStr = @"CL:3";
    
    [self LoadChlidView];
    

    [self PlayMuisc:@"小蝌蚪找妈妈第一段"];
    
}


- (void)timerInvalue
{
    [_colortimer invalidate];
    _colortimer  = nil;
}

- (void)LoadChlidView
{

    
    
    
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
    
    UIImageView *secenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (KDeviceHeight - 251)/2.0 + 20, 251, 225)];
    secenImageView.image = [UIImage imageNamed:@"SenceBG"];

    
    [bgImageView addSubview:secenImageView];
    
    self.rocker = [[ZMRocker alloc] initWithFrame:CGRectMake(kDeviceWidth - 260 - 20, (KDeviceHeight - 260)/2.0, 260, 260)];
    
    [self.rocker setRockerStyle:RockStyleTranslucent];
    
    //    self.rocker.userInteractionEnabled = NO;
    
    self.rocker.delegate = self;
    
    [bgImageView addSubview:self.rocker];
    
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
    
    NSRange range = [str3 rangeOfString:@"CL"];
    
    
    if (range.location != NSNotFound)
    {
        
//        NSString *str4 = [str3 substringFromIndex:3];
        
//        self.ValeLabel.text = [NSString stringWithFormat:@"%@",str4];
//        self.blueVale = [str4 floatValue];
        
//        NSLog(@"strrecisssssstr4s======%@",str4);
        
        
//
        
        if ([str3 isEqualToString:@"CL:3"]) {
            
            if ([self.colorStr isEqualToString:@"CL:3"]) {
               
                 self.colorStr = @"CL:1";
//                 [self timerInvalue];
                [self SendBlueCode:@"M221 3"];
                 [self PlayMuisc:@"小蝌蚪找妈妈第二段"];
            }
            
           
        }
        else if ([str3 isEqualToString:@"CL:1"]) {
            
            if ([self.colorStr isEqualToString:@"CL:1"]) {
                
                self.colorStr = @"CL:4";
//                [self timerInvalue];
                [self SendBlueCode:@"M221 1"];
                [self PlayMuisc:@"小蝌蚪找妈妈第三段"];
            }
            
           
        }
        else if ([str3 isEqualToString:@"CL:4"]) {
            
            if ([self.colorStr isEqualToString:@"CL:4"]) {
                
                self.colorStr = @"CL:2";
//                [self timerInvalue];
                [self SendBlueCode:@"M221 4"];
                [self PlayMuisc:@"小蝌蚪找妈妈第四段"];
            }
            
        
        }
        else if ([str3 isEqualToString:@"CL:2"]) {
            
            if ([self.colorStr isEqualToString:@"CL:2"]) {
                
                self.colorStr = @"CL:6";
//                [self timerInvalue];
                
                [self SendBlueCode:@"M221 2"];
                   [self PlayMuisc:@"小蝌蚪找妈妈第五段"];
            }
            
        
        }
        else if ([str3 isEqualToString:@"CL:6"]) {
            
            if ([self.colorStr isEqualToString:@"CL:6"]) {
                
                self.colorStr = @"CL:0";
//                [self timerInvalue];
                
                [self SendBlueCode:@"M221 6"];
                [self PlayMuisc:@"小蝌蚪找妈妈第六段"];
            }
            
        }
        
        
    }
    
    
}


- (void)colorChange
{
     [self SendBlueCode:@"M226"];
    
    NSLog(@"sdfsdfdsf11111111112222222");
}


- (void)PlayMuisc:(NSString *)name
{
    
    NSString *namestr = [NSString stringWithFormat:@"%@",name];
    //
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:namestr withExtension:@"mp3"];
    
    NSLog(@"musicURL=======%@",musicURL);
    
    [self play:musicURL];
}

-(void)play:(NSURL *)playPath{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:playPath error:&playerError];
    _player.delegate = self;
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    
    //    [_player setNumberOfLoops:7];//循环播放12次
    // [_player setVolume:1];
    //    _player.volume = 1;
    
    [self timerInvalue];
    self.rocker.userInteractionEnabled = NO;
  
    
    [_player prepareToPlay];
    [_player play];
    
    
}

#pragma mark 播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self colortimer];
    self.rocker.userInteractionEnabled = YES;
    
    if ([self.colorStr isEqualToString:@"CL:0"]) {
    
        [self timerInvalue];
        [self backFore];
    }
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
            [self SendBlueCode:@"M200 0 255"];
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
            
//              [self SendBlueCode:@"M1"];
            
            break;
            
        default:
            break;
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




- (void)backFore
{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    
    [self.player stop];//离开界面停止播放声音
    self.player = nil;
    
    [self timerInvalue];

    
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
    
    NSLog(@"1234345");
    

    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.IsPlaying) {
        
        [[BPlayTestViewController sharedInstance] testPasue];
    }
    
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
