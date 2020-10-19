//
//  PCVideoViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/10/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "PCXXVideoViewController.h"


@interface PCXXVideoViewController ()




@end

@implementation PCXXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"亲子视频";
    
    [self LoadChildView];
}


- (void)LoadChildView
{
    UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 140)/2.0, 37, 140, 100)];
    
    [videoBtn setImage:[UIImage imageNamed:@"PVCvideo_n"] forState:UIControlStateNormal];
    
    [videoBtn setImage:[UIImage imageNamed:@"PVCvideo_s"] forState:UIControlStateHighlighted];
    
    [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:videoBtn];
    
    UILabel *videoLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, CGRectGetMaxY(videoBtn.frame) + 3, 100, 17)];
    
    videoLabel.text = @"视频通话";
    videoLabel.font = [UIFont systemFontOfSize:18.0];
    videoLabel.textColor = [UIColor colorWithRed:28/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:videoLabel];
    
    UIButton *MonitoringBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 140)/2.0, CGRectGetMaxY(videoLabel.frame) + 70, 140, 100)];
    
    [MonitoringBtn setImage:[UIImage imageNamed:@"PVCcamera"] forState:UIControlStateNormal];
    
    [MonitoringBtn setImage:[UIImage imageNamed:@"PVCcamera_s"] forState:UIControlStateHighlighted];
    
    [MonitoringBtn addTarget:self action:@selector(MonitoringBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:MonitoringBtn];
    
    UILabel *monitoringLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, CGRectGetMaxY(MonitoringBtn.frame) + 3, 100, 17)];
    
    monitoringLabel.text = @"视频监控";
    monitoringLabel.font = [UIFont systemFontOfSize:18.0];
    monitoringLabel.textColor = [UIColor colorWithRed:28/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    monitoringLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:monitoringLabel];
    
    UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 140)/2.0, CGRectGetMaxY(monitoringLabel.frame) + 70, 140, 100)];
    

    
    [voiceBtn setImage:[UIImage imageNamed:@"PVCphone_n"] forState:UIControlStateNormal];
    
    [voiceBtn setImage:[UIImage imageNamed:@"PVCphone_s"] forState:UIControlStateHighlighted];
    
    [voiceBtn addTarget:self action:@selector(voiceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:voiceBtn];
    
    UILabel *voiceLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, CGRectGetMaxY(voiceBtn.frame) + 3, 100, 17)];
    
    voiceLabel.text = @"语音通话";
    voiceLabel.font = [UIFont systemFontOfSize:18.0];
    voiceLabel.textColor = [UIColor colorWithRed:28/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    voiceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:voiceLabel];
    
//    self.rocker = [[XXZMRocker alloc] initWithFrame:CGRectMake( (kDeviceWidth - 130)/2.0, 200, 130, 130)];
//    
//    [self.rocker setRockerStyle:XXRockStyleTranslucent];
//    
//
//    
//     self.rocker.delegate = self;
//    
//    [self.view addSubview:self.rocker];
    
    
    
}

//-(void)bangding:(NSString*)code{
//
//    NSLog(@"---------%@",code);
//
//    NSDictionary *dic = @{@"cmd" : @"XIAOXIAN_HUIBEN",@"userid" : [[TMCache sharedCache] objectForKey:@"phoneNumber"], @"code" : code };
//
//    NSLog(@"m=====%@",[[TMCache sharedCache] objectForKey:@"mKTopic"]);
//
//
//    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
//
//
//}




- (void)videoBtnClicked
{
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];

    if ([HomedeviceStatusStr isEqualToString:@"0"]) {

        [self showToastWithString:@"设备不在线"];
        return;
    }


    [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:self.deviceCode callType:UCSCallType_VideoPhone callName:[[TMCache sharedCache] objectForKey:@"QdeviceName"]];

    
    
    
}

- (void)MonitoringBtnClicked
{
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
     [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:self.deviceCode callType:UCSCallType_VideoPhone callName:@"视频监控"];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":[[TMCache sharedCache] objectForKey:@"deviceId"], @"type":[NSNumber numberWithInt:2]}];
    
}


- (void)voiceBtnClicked
{
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"QdeviceName"];

    if ([HomedeviceStatusStr isEqualToString:@"0"]) {

        [self showToastWithString:@"设备不在线"];
        return;
    }


    
     [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:self.deviceCode callType:UCSCallType_VOIP callName:[[TMCache sharedCache] objectForKey:@"QdeviceName"]];
    
//      [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:@"18145860109" callType:UCSCallType_VOIP callName:@"秀"];
}



//- (void)videoBtnClicked
//{
//
//    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
//
//    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
//
//        [self showToastWithString:@"设备不在线"];
//        return;
//    }
//
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":[[TMCache sharedCache] objectForKey:@"deviceId"], @"type":[NSNumber numberWithInt:1]}];
//
//
//
//}
//
//- (void)MonitoringBtnClicked
//{
//
//    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
//
//    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
//
//        [self showToastWithString:@"设备不在线"];
//        return;
//    }
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":[[TMCache sharedCache] objectForKey:@"deviceId"], @"type":[NSNumber numberWithInt:2]}];
//
//}
//
//
//- (void)voiceBtnClicked
//{
//
//    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
//
//    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
//
//        [self showToastWithString:@"设备不在线"];
//        return;
//    }
//
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":[[TMCache sharedCache] objectForKey:@"deviceId"], @"type":[NSNumber numberWithInt:0]}];
//
//
//}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
