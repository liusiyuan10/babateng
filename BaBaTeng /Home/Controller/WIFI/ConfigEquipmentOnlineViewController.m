//
//  ConfigEquipmentOnlineViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/17.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "ConfigEquipmentOnlineViewController.h"
#import "EquipmentOpenOneViewController.h"
#import "ConfigEquipmentInternetViewControlleron.h"
#import "EquipmentIDVerifyViewController.h"
#import "EquipmentBindingViewController.h"
#import "EquipmentPressNetWorkViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ConfigEquipmentOnlineViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong)  AVAudioPlayer  *player;

@end

@implementation ConfigEquipmentOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    self.title  = self.deviceTypeName;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CellBackgroundColor;

    
    
    //适配iphone x
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,kDeviceWidth-20 ,KDeviceHeight-240-kDevice_Is_iPhoneX)];
    promptImageView.backgroundColor = [UIColor yellowColor];
    promptImageView.image = [UIImage imageNamed:@"00_008(1)"];
    promptImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:promptImageView];

    

//    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth ,KDeviceHeight-220)];
//    
//    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//   
//    
//   // NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:_URL];//创建NSURLRequest
//    [webView loadRequest:request];//加载
//    
//    webView.backgroundColor = [UIColor redColor];
//     [self.view addSubview:webView];
    
    
    UIButton *equippedNetwork = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(promptImageView.frame)+10, kDeviceWidth - 40, 48)];
//    [equippedNetwork setImage:[UIImage imageNamed:@"btn_pzsbsw_nor"] forState:UIControlStateNormal];
//    [equippedNetwork setImage:[UIImage imageNamed:@"btn_pzsbsw_pre"] forState:UIControlStateHighlighted];
    
    equippedNetwork.layer.cornerRadius= 10.0f;
    
    equippedNetwork.clipsToBounds = YES;//去除边界
    equippedNetwork.layer.masksToBounds = YES;
    
    UIImage *normal1Back = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihgligh1tBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [equippedNetwork setBackgroundImage:normal1Back forState:UIControlStateNormal];
    [equippedNetwork setBackgroundImage:hihgligh1tBack forState:UIControlStateHighlighted];
    
    [equippedNetwork setTitle:@"配置设备上网" forState:UIControlStateNormal];
    
    [equippedNetwork setTitle:@"配置设备上网" forState:UIControlStateHighlighted];
    
    [equippedNetwork setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    equippedNetwork.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    
    [equippedNetwork addTarget:self action:@selector(equippedNetworkAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:equippedNetwork];
    
    
    UIButton *bindingButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(equippedNetwork.frame)+20, kDeviceWidth - 40, 48)];
//    [bindingButton setImage:[UIImage imageNamed:@"btn_bdylwsb_nor"] forState:UIControlStateNormal];
//    [bindingButton setImage:[UIImage imageNamed:@"btn_bdylwsb_pre"] forState:UIControlStateHighlighted];
    
    
    bindingButton.layer.cornerRadius= 10.0f;
    bindingButton.layer.borderWidth = 1.0;
    bindingButton.layer.borderColor = [UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0].CGColor;
    bindingButton.clipsToBounds = YES;//去除边界
    bindingButton.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor clearColor]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:0.3]];
    
    [bindingButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [bindingButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [bindingButton setTitle:@"绑定已联网设备" forState:UIControlStateNormal];
    
    [bindingButton setTitle:@"绑定已联网设备" forState:UIControlStateHighlighted];
    
    [bindingButton setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    bindingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [bindingButton addTarget:self action:@selector(bindingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingButton];
    
    [self PlayMuisc:@"app_open_robot"];

}

//根据背景颜色创建图片
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)equippedNetworkAction{

   
      NSLog(@"equippedNetworkAction");
    
//    [self.navigationController pushViewController:[EquipmentOpenOneViewController new] animated:YES];

//    EquipmentOpenOneViewController *Open = [[EquipmentOpenOneViewController alloc] init];
//    Open.deviceTypeName = self.deviceTypeName;
//    
//    [self.navigationController pushViewController:Open animated:YES];
    
    
//    [self.player stop];//离开界面停止播放声音
//    self.player = nil;
//
    
    
    EquipmentPressNetWorkViewController *configVc = [[EquipmentPressNetWorkViewController alloc] init];
    configVc.deviceTypeName = self.deviceTypeName;
    configVc.deviceTypeId = self.deviceTypeId;
    configVc.iconUrl =self.iconUrl;
    configVc.deivceProgramId = self.deivceProgramId;
    [self.navigationController pushViewController:configVc animated:YES];
    
}

-(void)bindingAction{

      //NSLog(@"bindingAction");
    
//      [self.navigationController pushViewController:[ConfigEquipmentInternetViewControlleron new] animated:YES];
//    [self.navigationController pushViewController:[EquipmentIDVerifyViewController new] animated:YES];
    
//    [self.navigationController pushViewController:[EquipmentBindingViewController new] animated:YES];
    
//    [self.player stop];//离开界面停止播放声音
//    self.player = nil;
//
    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    
    bindVc.iconUrl =self.iconUrl;
    
    [self.navigationController pushViewController:bindVc animated:YES];
    
    

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
    

    
    
    [_player prepareToPlay];
    [_player play];
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        [self.player stop];//离开界面停止播放声音
        self.player = nil;
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
