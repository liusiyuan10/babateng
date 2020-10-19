//
//  EquipmentBindingViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentBindingViewController.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "EquipmentInputViewController.h"
#import "EquipmentIDVerifyViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface EquipmentBindingViewController ()<STQRCodeControllerDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;


@end

@implementation EquipmentBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =self.deviceTypeName; //@"绑定设备";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CellBackgroundColor;
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth ,KDeviceHeight-220) style:UITableViewStylePlain];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    self.tableView.backgroundColor = [UIColor clearColor] ;
//    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    
//    self.dataArray = [NSMutableArray arrayWithObjects:@"确认设备已开机,设备已经联网并登录账号,选择“绑定已联网设备”选项",@"若品牌串号清晰可识别,选择“扫码设备串号”选项",@"若品牌串号丢失,选择“手动输入设备串号”选项",@"串号识别完成后,自动发送4位身份码,若未收到,点击重新获取",@"输入身份码,点击添加,等待设备绑定完成", nil];
//    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_01",@"icon_02",@"icon_03",@"icon_04",@"icon_05", nil];
//    [self.view addSubview:self.tableView];
    
    
    
    //适配iphone x
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(20, 20,kDeviceWidth-40 ,KDeviceHeight-240-kDevice_Is_iPhoneX)];
    
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
    NSString *urlStr = [NSString stringWithFormat:@"%@deviceBindGuidances.html?deviceTypeId=%@",BBT_HTML,self.deviceTypeId];

    NSLog(@"1111sssurlStr==%@",urlStr);
    
    
//    NSURL* url = [NSURL URLWithString:urlStr];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [self.webView loadRequest:request];//加载
   [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    
    
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.webView.frame)+10, kDeviceWidth - 40, 48)];
//    [scanButton setImage:[UIImage imageNamed:@"btn_smsbch_nor"] forState:UIControlStateNormal];
//    [scanButton setImage:[UIImage imageNamed:@"btn_smsbch_pre"] forState:UIControlStateHighlighted];
    
    scanButton.layer.cornerRadius= 10.0f;
    
    scanButton.clipsToBounds = YES;//去除边界
    scanButton.layer.masksToBounds = YES;
    
    UIImage *normal1Back = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglight1Back = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [scanButton setBackgroundImage:normal1Back forState:UIControlStateNormal];
    [scanButton setBackgroundImage:hihglight1Back forState:UIControlStateHighlighted];
    
    [scanButton setTitle:@"扫描设备串号" forState:UIControlStateNormal];
    
    [scanButton setTitle:@"扫描设备串号" forState:UIControlStateHighlighted];
    
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    scanButton.hidden = YES;
    [self.view addSubview:scanButton];
    
    
    UIButton *inputButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(scanButton.frame)+10, kDeviceWidth - 40, 48)];
//    [inputButton setBackgroundImage:[UIImage imageNamed:@"btn_xyb_nor"] forState:UIControlStateNormal];
//    [inputButton setBackgroundImage:[UIImage imageNamed:@"btn_xyb_pre"] forState:UIControlStateHighlighted];
    
    
    inputButton.layer.cornerRadius= 10.0f;

    inputButton.clipsToBounds = YES;//去除边界
    inputButton.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [inputButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [inputButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [inputButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [inputButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [inputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inputButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [inputButton addTarget:self action:@selector(inputAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputButton];
    
    
    [self.view addSubview:self.activity];

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



-(void)scanAction{
    
    
    NSLog(@"equippedNetworkAction");
    
   // [self.navigationController pushViewController:[EquipmentOpenOneViewController new] animated:YES];
    
    STQRCodeController *codeVC = [[STQRCodeController alloc]init];
    codeVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:codeVC];
    [self presentViewController:navVC animated:YES completion:nil];
    
}

-(void)inputAction{
    
    NSLog(@"手动输入");

//    [self.navigationController pushViewController:[EquipmentInputViewController new] animated:YES];
//    [self.navigationController pushViewController:[EquipmentIDVerifyViewController new] animated:YES];
    
    EquipmentIDVerifyViewController *IDVerifyVc = [[EquipmentIDVerifyViewController alloc] init];
    IDVerifyVc.deviceTypeName = self.deviceTypeName;
    IDVerifyVc.deviceTypeId = self.deviceTypeId;
    IDVerifyVc.iconUrl =self.iconUrl;
    [self.navigationController pushViewController:IDVerifyVc animated:YES];
    
}
#pragma mark - --- 2.delegate 视图委托 ---
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType
{
    NSLog(@"%s %@", __FUNCTION__, readerScanResult);
    NSLog(@"%s %lu", __FUNCTION__, (unsigned long)resultType);
    [STQRCodeAlert showWithTitle:readerScanResult];
}

- (void)backForePage
{

    NSArray *pushVCAry=[self.navigationController viewControllers];
//
//    NSLog(@"pushVCAry.count-5=%lu",pushVCAry.count-5);
    
    UIViewController *popVC=[pushVCAry objectAtIndex:2];
    
    [self.navigationController popToViewController:popVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
     self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"11开始加载");
    _activity.hidden = NO;
    [_activity startAnimating];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    _activity.hidden = YES;
    [_activity stopAnimating];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败");
     [self showToastWithString:@"网页加载失败"];
    _activity.hidden = YES;
    [_activity stopAnimating];
}



//#pragma mark WKNavigationDelegate
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//
//    NSLog(@"开始加载");
//    _activity.hidden = NO;
//    [_activity startAnimating];
//
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    NSLog(@"加载完成");
//    _activity.hidden = YES;
//    [_activity stopAnimating];
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//
//    NSLog(@"页面加载失败");
//
//    _activity.hidden = YES;
//    [_activity stopAnimating];
//
//}

- (UIActivityIndicatorView *)activity {
    
    if (_activity == nil) {
        
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _activity.center = self.webView.center;
        _activity.transform = transform;
        _activity.userInteractionEnabled  = NO;
        
    }
    
    return _activity;
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
