//
//  EquipmentPressNetWorkViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentPressNetWorkViewController.h"
#import "EquipmentConfigNetWorkViewController.h"
#import "EquipmentSetNetworkViewController.h"

#import "EquipmentHSetNetworkViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#import "QCheckBox.h"
#import <AVFoundation/AVFoundation.h>

#import "UILabel+LXAdd.h"
#import "NetHelpViewController.h"

//handler name
static NSString *baseMessagehandler = @"baseMessagehandler";

@interface EquipmentPressNetWorkViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,QCheckBoxDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong)  AVAudioPlayer  *player;

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (strong, nonatomic) QCheckBox  *check;
@property (strong, nonatomic)  UIButton *nextBtn;

@end

@implementation EquipmentPressNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.deviceTypeName; //@"设备配置";
    
    [self registerMessageHandler];
    
    [self LoadChlidView];
}

- (void)LoadChlidView
{
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, kDeviceWidth - 100, 20)];
    //    titleLabel.text = @"请点击音箱上 Wi-Fi 键";
    //
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.textColor = [UIColor orangeColor];
    //
    //    [self.view addSubview:titleLabel];
    
    //适配iphone x
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(20, 20,kDeviceWidth-40 ,KDeviceHeight-240-kDevice_Is_iPhoneX) configuration:configuration];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
    NSString *urlStr = [NSString stringWithFormat:@"%@netConfigGuidances.html?deviceTypeId=%@",BBT_HTML,self.deviceTypeId];

    
    NSLog(@"urlStr===%@",urlStr);
    
    //    NSURL* url = [NSURL URLWithString:urlStr];//创建URL
    //
    ////    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
    //    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    //    [self.webView  loadRequest:request];//加载
    
    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
//    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    
    self.webView .backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView ];
    
    //适配iphone x
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-120-kDevice_Is_iPhoneX, kDeviceWidth - 40, 48)];
    
    //    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-120, kDeviceWidth - 40, 48)];
//    [nextBtn setImage:[UIImage imageNamed:@"btn_xyb_nor"] forState:UIControlStateNormal];
//    [nextBtn setImage:[UIImage imageNamed:@"btn_xyb_pre"] forState:UIControlStateHighlighted];
    
    nextBtn.layer.cornerRadius= 10.0f;
    
    nextBtn.clipsToBounds = YES;//去除边界
    nextBtn.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [nextBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
    
    self.nextBtn = nextBtn;
    
    [self.view addSubview:self.activity];
    
    self.check = [[QCheckBox alloc] initWithDelegate:self];
    [self.check  setTitle:@"已确认上述操作" forState:UIControlStateNormal];
    [self.check .titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.check setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.check.selected = NO;
    self.check.frame = CGRectMake(30, CGRectGetMaxY(self.webView.frame), kDeviceWidth-80, 40);
    self.check.backgroundColor = [UIColor clearColor];
    
    self.check.hidden = YES;
    
    [self.view addSubview:self.check];
    
    if ([self.deviceTypeId isEqualToString:@"010011"]) {
        
        self.check.hidden = NO;
        self.nextBtn.userInteractionEnabled = NO;
        UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0]];
        [self.nextBtn setImage:normalBack forState:UIControlStateNormal];
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
    }
    
    if ([self.deivceProgramId isEqualToString:@"6"] ||[self.deivceProgramId isEqualToString:@"8"]||[self.deivceProgramId isEqualToString:@"9"]||[self.deivceProgramId isEqualToString:@"10"])
    {
        [self createLabele];
    }
    
    
    
    [self PlayMuisc:@"app_net_connect"];
    
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



//加配网说明
-(void)createLabele
{
    
    
    UILabel *lab=[[UILabel alloc] init];
    lab.text=@"点击注册,即表示您同意配网协议";
    lab.backgroundColor=[UIColor clearColor];
    lab.numberOfLines=0;
    
    lab.font=[UIFont systemFontOfSize:14];
    lab.characterSpace=0;//字间距
    lab.lineSpace=5;//行间距
    lab.textColor  = MainFontColor;
    //关键字
    lab.keywords=@"配网协议";
    lab.keywordsColor=[UIColor redColor];
    lab.keywordsFont=[UIFont systemFontOfSize:15];
    //下划线
    lab.underlineStr=@"配网协议";
    lab.underlineColor=[UIColor redColor];
    
    //计算label的宽高
    CGRect h =  [lab getLableHeightWithMaxWidth:300];
    lab.frame=CGRectMake(30, CGRectGetMaxY(self.webView.frame) - 3 ,kDeviceWidth - 30*2, h.size.height+30);
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    
    // 2. 将点击事件添加到label上
    [lab addGestureRecognizer:labelTapGestureRecognizer];
    lab.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
}

- (void)labelClick
{
    NetHelpViewController *helpVc = [[NetHelpViewController alloc] init];
    helpVc.name = @"配网协议";
    // NSString *urlStr = [NSString stringWithFormat:@"%@UserAgreement.html",BBT_HTML];
    NSString *urlStr = [NSString stringWithFormat:@"%@NetConfigProtocol.html",BBT_HTML];
    NSLog(@"用户协议urlStr====%@",urlStr);
    
    helpVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:helpVc animated:YES];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"22开始加载");
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
//       NSLog(@"页面加载失败");
//    _activity.hidden = YES;
//    [_activity stopAnimating];
//}

- (UIActivityIndicatorView *)activity {
    
    if (_activity == nil) {
        
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        //        _activity.center = CGPointMake(self.webView.bounds.size.width/2,self.webView.bounds.size.height / 2.0);
        _activity.center = self.webView.center;
        _activity.transform = transform;
        _activity.userInteractionEnabled  = NO;
        
    }
    
    return _activity;
}

- (void)nextBtnClicked
{
    NSLog(@"下一步");
    
//    [self.player stop];//离开界面停止播放声音
//    self.player = nil;
//    
    
    if ([self.deivceProgramId isEqualToString:@"5"]) {
        
        EquipmentHSetNetworkViewController *configVc = [[EquipmentHSetNetworkViewController alloc] init];
        configVc.deviceTypeName = self.deviceTypeName;
        configVc.deviceTypeId = self.deviceTypeId;
        configVc.iconUrl =self.iconUrl;
        configVc.deivceProgramId =self.deivceProgramId;
        [self.navigationController pushViewController:configVc animated:YES];
        
    }
    
    else
    {
        EquipmentSetNetworkViewController *configVc = [[EquipmentSetNetworkViewController alloc] init];
        configVc.deviceTypeName = self.deviceTypeName;
        configVc.deviceTypeId = self.deviceTypeId;
        configVc.iconUrl =self.iconUrl;
        configVc.deivceProgramId =self.deivceProgramId;
        [self.navigationController pushViewController:configVc animated:YES];
    }

    

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



- (void)registerMessageHandler
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:baseMessagehandler];
}


- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    if (checked) {
        
        self.nextBtn.userInteractionEnabled = YES;
        
//        [self.nextBtn setImage:[UIImage imageNamed:@"btn_xyb_nor"] forState:UIControlStateNormal];
        
        UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
        [self.nextBtn setImage:normalBack forState:UIControlStateNormal];
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
        
    }
    else
    {
        self.nextBtn.userInteractionEnabled = NO;
        
//        [self.nextBtn setImage:[UIImage imageNamed:@"btn_xyb_diss"] forState:UIControlStateNormal];
        UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0]];
        [self.nextBtn setImage:normalBack forState:UIControlStateNormal];
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.player stop];//离开界面停止播放声音
    self.player = nil;
}


@end

