//
//  PictureBookViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

//
//  EquipmentScanBindingViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2018/1/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "PictureBookViewController.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTDevice.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "NewHomeViewController.h"

@interface PictureBookViewController ()<STQRCodeControllerDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;


@end

@implementation PictureBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title =@"绘本阅读";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CellBackgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20,kDeviceWidth-40 ,KDeviceHeight-240-kDevice_Is_iPhoneX)];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.view addSubview:backView];
    
    //适配iphone x
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kDeviceWidth-40 ,250)];
    
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.text = @"                             绘本阅读功能使用说明 \n\n     请保证使用绘本阅读功能的机器人网络连接正常。\n\n      初次阅读的绘本，请使用“扫一扫”按钮的扫一扫功能，扫描书本的ISBN条形编码；APP扫描完成后，机器人将发出添加绘本提示音，当绘本添加完成后，把绘本封面平放到机器人面前，就可以正常阅读啦。\n\n    机器人已经下载并阅读过的绘本不需要再次使用APP扫码即可阅读。\n\n    若使用APP扫码完成后，机器人没有发出添加绘本提示音，则表示该本书机器人暂不支持阅读，请换一本书吧。";
    
    self.textLabel.numberOfLines = 0;
    
    [backView addSubview:self.textLabel];
    
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 118)/2, CGRectGetMaxY(backView.frame)+10, 118, 118)];
    [scanButton setImage:[UIImage imageNamed:@"icon_Scan"] forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"icon_Scan"] forState:UIControlStateHighlighted];
    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    scanButton.hidden = NO;
    [self.view addSubview:scanButton];
    
  
    
}


-(void)scanAction{
    
    NSLog(@"equippedNetworkAction");
    
    STQRCodeController *codeVC = [[STQRCodeController alloc]init];
    codeVC.delegate = self;
    
    //    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:codeVC];
    //    [self presentViewController:navVC animated:YES completion:nil];
    
    [self.navigationController pushViewController:codeVC animated:YES];
    
}

#pragma mark - --- 2.delegate 视图委托 ---
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType
{
    //    NSLog(@"扫描结果0====%s %@", __FUNCTION__, readerScanResult);
    //   NSLog(@"扫描结果1===%s %lu", __FUNCTION__, (unsigned long)resultType);
    //    [STQRCodeAlert showWithTitle:readerScanResult];
    
    if (readerScanResult.length==0||IsStrEmpty(readerScanResult)) {
        
        [STQRCodeAlert showWithTitle:@"未识别到条码信息"];
        
    }else{
        
        [self bangding:readerScanResult];
    }
    
    
    
}

-(void)bangding:(NSString*)code{
    
    NSLog(@"---------%@",code);
    
    NSDictionary *dic = @{@"cmd" : @"XIAOXIAN_HUIBEN",@"userid" : [[TMCache sharedCache] objectForKey:@"phoneNumber"], @"code" : code };
    
    NSLog(@"m=====%@",[[TMCache sharedCache] objectForKey:@"mKTopic"]);
    

    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    
    [self showToastWithString:@"绘本已添加"];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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


