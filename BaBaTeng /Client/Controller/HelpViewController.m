//
//  FYWebViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "HelpViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>



@interface HelpViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HelpViewController

- (void)loadView
{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    //        button.backgroundColor = [UIColor whiteColor];
    
    [button addTarget:self action:@selector(backForePage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//修复iOS 7开始的顶部偏差44pt
    self.automaticallyAdjustsScrollViewInsets = NO;//automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
    
    self.webView = [[WKWebView alloc] init];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    self.view = self.webView;
  
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
    
    
}
- (void)backForePage
{
//      self.webView.canGoBack
    
    if (self.webView.canGoBack) {
        
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= self.name;
    // 添加进入条
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.progressView = [[UIProgressView alloc] initWithFrame: windowFrame];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor =[UIColor redColor];
    
    self.progressView.progress =0.00;//设置一下初始进度 让用户在网速不好的情况下也知道正在加载
    
    [self.view addSubview:self.progressView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL)//懒加载
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
        //[self.uiWebView loadRequest:req];
    }
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    // 添加KVO监听
    
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    //    //[self.webView addObserver:self
    //                   forKeyPath:@"title"
    //                      options:NSKeyValueObservingOptionNew
    //                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [_webView removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    // [_webView removeObserver:self forKeyPath:@"title" context:nil];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [_webView removeObserver:self forKeyPath:@"title" context:nil];
    
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    
    // NSLog(@"self.webView.title==== %@",self.webView.title);
    
    if ([keyPath isEqualToString:@"loading"])
    {
        // NSLog(@"loading");
    }
    //    else if ([keyPath isEqualToString:@"title"])
    //    {
    //        self.title = self.webView.title;
    //
    //    }
    else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        //NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            self.title = self.webView.title;
            
        }
    }
    
    // 加载完成
    if (!self.webView.loading)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0.0;
        }];
    }
    
}


#pragma mark WKNavigationDelegate



// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [self showToastWithString:@"页面加载失败"];
    
}




@end
