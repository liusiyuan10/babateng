//
//  EquipmentScanBindingViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2018/1/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentScanBindingViewController.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTDevice.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface EquipmentScanBindingViewController ()<STQRCodeControllerDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;


@end

@implementation EquipmentScanBindingViewController
static EquipmentScanBindingViewController *equipmentScanBindingViewController;

+(EquipmentScanBindingViewController *)getInstance{
    
    return equipmentScanBindingViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    equipmentScanBindingViewController = self;
    
    self.title =@"扫码绑定";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CellBackgroundColor;


    //适配iphone x
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(20, 20,kDeviceWidth-40 ,KDeviceHeight-240-kDevice_Is_iPhoneX)];
    
//    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    self.webView.delegate =self;
//    
    //NSString *urlStr = [NSString stringWithFormat:@"%@deviceBindGuidances.html?deviceTypeId=%@",BBT_HTML,self.deviceTypeId];
    
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
//    NSURL* url = [NSURL URLWithString:@"http://www.babateng.cn/"];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [self.webView loadRequest:request];//加载
    
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/resources/html/sweepCode.html",BBT_HTTP_URL,PROJECT_NAME_APP];
    
//      {domian}/{projectName}
    
         NSLog(@"urlStr===%@",urlStr);
    
    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    

    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 118)/2, CGRectGetMaxY(self.webView.frame)+10, 118, 118)];
    [scanButton setImage:[UIImage imageNamed:@"icon_Scan"] forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"icon_Scan"] forState:UIControlStateHighlighted];
    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    scanButton.hidden = NO;
    [self.view addSubview:scanButton];
    
    [self.view addSubview:self.activity];
    
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
- (void)manuallyEnter:(NSString*)code{
    
    NSLog(@"---------%@",code);
    
   [self bangding:code];
    
}
-(void)bangding:(NSString*)code{
    
 NSLog(@"---------%@",code);
    
    NSString *urlStr;
    
    if (code.length<=16) {
        
        urlStr = [NSString stringWithFormat:@"%@%@/devices/%@/onbind",BBT_HTTP_URL,PROJECT_NAME_APP,code];
        
    }else{
        
    
//        NSLog(@"=============%@",[self getCompleteWebsite:code]);
        
        //判断是一个连接
        if ([self getCompleteWebsite:code]!=nil) {
            // 如果是连接,再判断是不是巴巴腾的
            if ([code hasPrefix:BBT_HTTP_URL] || [code containsString:BBT_CODE_URL] ) {
                
                NSLog(@"存在巴巴腾的域名");
                urlStr = code;
                
            } else {
                
                NSLog(@"不存在巴巴腾的域名");
                [self showToastWithString:@"二维码是不正确的绑定码"];
                return;
                
            }
        }else{
            
            [self showToastWithString:@"二维码是不正确的绑定码"];
            return;
        }
        
        urlStr = code;//[NSString stringWithFormat:@"%@%@",BBT_HTTP_URL,urlORCode];
        
    }
    
    NSLog(@"请111求链接%@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    [self startLoading];
    
    [BBTEquipmentRequestTool getScanbindcode:encodedString Parameter:parameter success:^(BBTDevice *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [[TMCache sharedCache] setObject:@"success" forKey:@"BingdingStr"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            if (IsStrEmpty(respone.message)) {
                
                [self showToastWithString:@"设备不存在"];
                
            }else{
                
               [self showToastWithString:respone.message];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}

//判断是不是请求连接
- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
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
    NSLog(@"33开始加载");
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

