//
//  EquipmentSetWifiNetworkViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentSetWifiNetworkViewController.h"

#import "BBTQAlertView.h"

#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"

#import <SystemConfiguration/CaptiveNetwork.h>

#import "EquipmentBindingViewController.h"




@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>



@end

@implementation EspTouchDelegateImpl

-(void)onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self showAlertWithResult:result];
        
        
    });
}

@end



@interface EquipmentSetWifiNetworkViewController ()

@property(nonatomic, strong) UIImageView *cofigView;
@property(nonatomic, strong) BBTQAlertView *QalertView;
@property (nonatomic, strong) UIButton      *cancelBtn;

// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

// the state of the confirm/cancel button
@property (nonatomic, assign) BOOL _isConfirmState;


@property (nonatomic, strong) NSCondition *_condition;

@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;

@end

@implementation EquipmentSetWifiNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title = self.deviceTypeName;
     self._isConfirmState = YES;
     self._esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
    [self LoadChlidView];
    
    [self tapConfirmForResults];
}



- (void) tapConfirmForResults
{
    // do confirm
    if (self._isConfirmState)
    {
        [self showConfiging];
        NSLog(@"ESPViewController do confirm action...");
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            // execute the task
            NSArray *esptouchResultArray = [self executeForResults];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self._spinner stopAnimating];
//                [self enableConfirmBtn];
                
//                [self showConfigSuccess];
                
                [self.cofigView stopAnimating];
                
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                // check whether the task is cancelled and no results received
                if (!firstResult.isCancelled)
                {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        
                        [self showConfigSuccess];
                        
//                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                        
                    }
                    
                    else
                    {
//                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                        
                        [self showConfigFailure];
                    }
                }
                
            });
        });
    }
    
//    // do cancel
//    else
//    {
//        [self._spinner stopAnimating];
//        [self enableConfirmBtn];
//        NSLog(@"ESPViewController do cancel action...");
//        [self cancel];
//    }
    
    
}


#pragma mark - the example of how to cancel the executing task

- (void) cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
    NSString *apSsid = self.wifiName;
    NSString *apPwd = self.wifiPassword;
    NSDictionary *netInfo = [self fetchNetInfo];

    NSString *apBssid = [netInfo objectForKey:@"BSSID"];
    
    int taskCount = [@"1" intValue];
    
    NSLog(@"apSsid=====%@",apSsid);
    NSLog(@"apPwd=====%@",apPwd);
    NSLog(@"apBssid=====%@",apBssid);
    NSLog(@"taskCount=====%d",taskCount);
    
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd];
    // set delegate
    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}


- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
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
    
    
}

-(void)cancelBtnClick{
    
    [self cancel];
    
    
    NSArray *pushVCAry=[self.navigationController viewControllers];
    
    
    //下面的pushVCAry.count-3 是让我回到视图1中去
    
    UIViewController *popVC=[pushVCAry objectAtIndex:1];
    
    
    
    [self.navigationController popToViewController:popVC animated:YES];
}

- (void)backForePage
{
    [self cancel];
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
    
//    [self showToastWithString:@"联网成功"];
//
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    bindVc.iconUrl =self.iconUrl;
    //    bindVc.deivceProgramId =self.deivceProgramId;
    [self.navigationController pushViewController:bindVc animated:YES];
    
}

//#pragma mark - WSC delegate
-(void)showConfigFailure{
    NSLog(@"showConfigFailure**");
    
    [self.cofigView stopAnimating];
    
    
    self.QalertView = [[BBTQAlertView alloc] initWithNetImage:@"kong" andWithTag:1 andWithButtonTitle:@"确定"];
    
    [self.QalertView showInView:self.view];
    
    __block EquipmentSetWifiNetworkViewController *self_c = self;
    
    //点击按钮回调方法
    self.QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
//            NSArray *pushVCAry=[self_c.navigationController viewControllers];
            
            
            //下面的pushVCAry.count-3 是让我回到视图1中去
            
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
