//
//  BTutorialViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BTutorialViewController.h"
#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"
#import "JSNativeMethod.h"

#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#import "BPlayTestViewController.h"


@interface BTutorialViewController ()<UIWebViewDelegate,JSNativeMethodDelegate,AVAudioPlayerDelegate>
{
    JSContext *jsContext;
}


@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) UIButton *back;

@property(nonatomic,assign)BOOL backPortrait;

@property (nonatomic,strong)  AVAudioPlayer  *player;

@property(nonatomic,assign)BOOL IsPlaying;

@end

@implementation BTutorialViewController



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
    
    self.title = @"编程模式";
    
    [self SendBlueCode:@"M228 0"];
    
    self.IsPlaying = NO;
    
    if ([BPlayTestViewController sharedInstance].IsBPlaying) {
        [[BPlayTestViewController sharedInstance] testPasue];
        self.IsPlaying = YES;
    }
    
    [[TMCache sharedCache] setObject:@"block" forKey:@"ISPLAYBLOCK"];
    
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGRect webViewRect=CGRectMake(0, 0, KDeviceHeight, kDeviceWidth );
    self.webView=[[UIWebView alloc]initWithFrame:webViewRect];
    self.webView.contentMode = UIViewContentModeScaleToFill;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.webView setUserInteractionEnabled:YES];
    self.webView.delegate = self;
    [self.view  addSubview:self.webView];
    
    
    [self loadFile];
    
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
    
    NSString *str22 = [str2 substringWithRange:NSMakeRange(0,6)];
    NSLog(@"str22222=================%@",str22);
    CGFloat str2Length = str2.length;
    NSString *str23 = [str2 substringWithRange:NSMakeRange(6,str2Length - 6)];
    NSLog(@"str2333333=================%@",str23);
    
    NSString *str3 =  [EasyUtils ConvertHexStringToString:str22];
    
    NSLog(@"strrecivicessssss======%@",str3);
    
    NSRange range = [str3 rangeOfString:@"DT"];
    NSRange range1 = [str3 rangeOfString:@"CL"];
    NSRange range2 = [str3 rangeOfString:@"IR"];
    
    NSRange range3 = [str3 rangeOfString:@"TOU"];
    
    
    //    461e17300f2a
    
    //    if (range.location == NSNotFound && range1.location == NSNotFound && range2.location == NSNotFound)
    if (range3.location != NSNotFound)
    {
        NSString *alertJS=@"bbt_touch()"; //准备执行的js代码
        NSLog(@"00alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else if(range.location != NSNotFound){
        
        NSString *str4 =  [EasyUtils ConvertHexStringToString:str2];
        
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4]; //准备执行的js代码
        NSLog(@"11alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else if(range1.location != NSNotFound){
        
        NSString *str4 =  [EasyUtils ConvertHexStringToString:str2];
        
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4]; //准备执行的js代码
        NSLog(@"22alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else if(range2.location != NSNotFound){
        
        NSString *str4 =  [NSString stringWithFormat:@"%@%@", str3,str23];
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4];//准备执行的js代码
        NSLog(@"33alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else
    {
        NSLog(@"没有匹配的指令");
    }
    
    
    
    
}


//- (void)characteristicReciveData:(NSData *)recivedata
//{
//    NSLog(@"characteristicReciveData=======%@", recivedata);
//
//
//    NSString *str =  [EasyUtils convertDataToHexStr:recivedata];
//
//    NSLog(@"strrecivice======%@",str);
//
//    CGFloat strLength = str.length;
//
//    NSString *str2 = [str substringWithRange:NSMakeRange(6,strLength -8)];//str2 = "name"
//
//    NSLog(@"str2=================%@",str2);
//
//    NSString *str3 =  [EasyUtils ConvertHexStringToString:str2];
//
//    NSLog(@"strrecivicessssss======%@",str3);
//
//    NSRange range = [str3 rangeOfString:@"DT"];
//    NSRange range1 = [str3 rangeOfString:@"CL"];
//    NSRange range2 = [str3 rangeOfString:@"IR"];
//
//    NSRange range3 = [str3 rangeOfString:@"TOUCH"];
//    //    if (range.location == NSNotFound && range1.location == NSNotFound && range2.location == NSNotFound)
//    if (range3.location != NSNotFound)
//    {
//        NSString *alertJS=@"bbt_touch()"; //准备执行的js代码
//        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//
//    }
//    else if(range.location != NSNotFound){
//
//        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str3]  ; //准备执行的js代码
//        NSLog(@"alertJS======%@",alertJS);
//        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//
//    }
//    else if(range1.location != NSNotFound){
//
//        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str3]  ; //准备执行的js代码
//        NSLog(@"alertJS======%@",alertJS);
//        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//
//    }
//    else if(range2.location != NSNotFound){
//
//        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str3]  ; //准备执行的js代码
//        NSLog(@"alertJS======%@",alertJS);
//        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//
//    }
//    else
//    {
//        NSLog(@"没有匹配的指令");
//    }
//
//
//
//
//}
//
//



#pragma mark - 加载文件
- (void)loadFile
{
    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
    //    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"labplus/apps/code/index.html" withExtension:nil];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    //    [self.webView loadRequest:request];
//    http://192.168.1.19/blockly/courseList.html?userId=123&&token=123
//    NSString *urlStr = @"http://192.168.1.19/blockly/courseList.html";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@blockly/courseList.html?userId=%@&&token=%@",BBT_HTTP_URL,[[TMCache sharedCache] objectForKey:@"userId"],[[TMCache sharedCache] objectForKey:@"token"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}



#pragma mark --webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载网页调用此方法
    [self startLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    
    [self stopLoading];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
    //    [jsContext evaluateScript:send];//通过oc方法调用js的alert
    
    //测试
    
    
    JSNativeMethod *appMethod = [[JSNativeMethod alloc] init];
    appMethod.delegate = self;
    jsContext[@"App"] = appMethod;
    appMethod.jsContext = jsContext;
    
      [self IScurrPeripheral];
}

- (void)JSNativeMethodBtnClicked:(JSNativeMethod *)Method selectName:(NSString *)name
{
    NSLog(@"sssssviewcontroller=====%@",name);
    
    NSRange range = [name rangeOfString:@"M"];
    
    if (range.location == NSNotFound)
        
    {
        [self PlayMuisc:name];
        
    }else {
        
         [self SendBlueCode:name];
        
    }
    
    
    
    
    //    [self SendBlueCode:name];
    
    
    
}

- (void)PlayMuisc:(NSString *)name
{
    
    //    NSString *file = [[NSBundle mainBundle] pathForResource:@"大家好我是小腾" ofType:@"mp3"];
    //
    //    NSString *newDataName = [[NSBundle mainBundle] pathForResource:@"大家好我是小腾" ofType:@"mp3"];
    //
    //    NSLog(@"file=======%@",file);
    //
    //    NSLog(@"newDataName=======%@",newDataName);
    
    NSString *namestr = [NSString stringWithFormat:@"%@",name];
    //
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:namestr withExtension:@"mp3"];
    
    NSLog(@"musicURL=======%@",musicURL);
    
    [self play:musicURL];
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
//    if (self.currPeripheral != nil &&self.currPeripheral.state == CBPeripheralStateDisconnected) {
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
    
    NSString *str11 =  [EasyUtils ConvertStringToHexString:code];
    NSString *str121 = [NSString stringWithFormat:@"%@%@",str11,@"0a"];
    
    //        NSString *str121 = @"C2:XYJWIFI:xyjwifi@2017";
    
    NSData *data = [EasyUtils convertHexStrToData:str121];
    
    NSLog(@"str11======%@",str11);
    //fe6a
    NSLog(@"ssss ---- %@ ",data);
    
    [self.currPeripheral writeValue:data forCharacteristic:self.babycharacteristic type:CBCharacteristicWriteWithResponse];
    
//    [self.characteristic writeValueWithData:data callback:^(EasyCharacteristic *characteristic, NSData *data, NSError *error) {
//
//        queueMainStart
//        NSLog(@"发送成功");
//        queueEnd
//    }];
    
    
    
}



- (void)JSNativeMethodBBolckBack:(JSNativeMethod *)Method selectName:(NSString *)name
{
    NSLog(@"sssssss返回");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.navigationController popViewControllerAnimated:YES];
        
        [self backForePage];
        
    });
}

- (void)JSNativeMethodEnglisBack:(JSNativeMethod *)Method selectName:(NSString *)name { 
    
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //网页加载失败 调用此方法
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
    [_player prepareToPlay];
    [_player play];
    
    
}


- (void)dealloc
{
//    [self.characteristicrevice removeObserver:self forKeyPath:@"notifyDataArray"];
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
    //
    //    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //    //切换到竖屏
    //    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    //
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSLog(@"1234345");
    
    
    [[TMCache sharedCache] removeObjectForKey:@"ISPLAYBLOCK"];
    
    if (self.IsPlaying) {
        
        [[BPlayTestViewController sharedInstance] testPasue];
    }
    
}

- (void)backForePage
{
    //    [super backForePage];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
