//
//  QBlockViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/3/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BBlockViewController.h"
#import "UIDevice+TFDevice.h"
#import "UIViewController+BackButtonHandler.h"
#import "JSNativeMethod.h"

#import "EasyUtils.h"
#import <AVFoundation/AVFoundation.h>

#import "BPlayTestViewController.h"

@interface BBlockViewController ()<UIWebViewDelegate,JSNativeMethodDelegate,AVAudioPlayerDelegate>
{
    JSContext *jsContext;
}


@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) UIButton *back;

@property(nonatomic,assign)BOOL backPortrait;


@property (nonatomic,strong)  AVAudioPlayer  *player;

@property(nonatomic,assign)BOOL IsPlaying;
@end

@implementation BBlockViewController



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
    
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    [[TMCache sharedCache] setObject:@"block" forKey:@"ISPLAYBLOCK"];

   
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGRect webViewRect=CGRectMake(0, 0, KDeviceHeight, kDeviceWidth );
    self.webView=[[UIWebView alloc]initWithFrame:webViewRect];
    self.webView.contentMode = UIViewContentModeScaleToFill;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.webView setUserInteractionEnabled:YES];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view  addSubview:self.webView];

    
    [self loadFile];
    
    [self CharacteristicRecive];
    
//
//    NSString *responseObject = @"7b226d657373616765223a2273756363657373222c22737461747573436f6465223a307d";
//
//    NSString *str =  [EasyUtils ConvertHexStringToString:responseObject];
//    //    NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonSt1111111r===%@", str);
    
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
//    NSLog(@"characteristicReciveData=======%@", recivedata);
    
    
   NSString *str =  [EasyUtils convertDataToHexStr:recivedata];
    
    
    NSLog(@"*******************************************************");

    NSLog(@"strrecivice======%@",str);
    

    NSLog(@"#######################################################");
    
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
//        NSString *str44 = [str4 substringWithRange:NSMakeRange(0,6)];
        str4 = [str4 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4]; //准备执行的js代码
        NSLog(@"11alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else if(range1.location != NSNotFound){
        
        NSString *str4 =  [EasyUtils ConvertHexStringToString:str2];
        str4 = [str4 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4]; //准备执行的js代码
        NSLog(@"22alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
        
    }
    else if(range2.location != NSNotFound){
        
        NSString *str4 =  [NSString stringWithFormat:@"%@%@", str3,str23];
        str4 = [str4 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *alertJS= [NSString stringWithFormat:@"bbt_touch('%@')",str4];//准备执行的js代码
        NSLog(@"33alertJS======%@",alertJS);
        [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
   
    }
    else
    {
        NSLog(@"没有匹配的指令");
    }



    
}


#pragma mark - 加载文件
- (void)loadFile
{
    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"labplus/apps/code/index.html" withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//    [self.webView loadRequest:request];
//    NSString *urlStr = @"http://192.168.1.19/blockly/";
//    http://192.168.1.19/blockly/index.html?userId=123&&token=123 #define BBT_HTTP_URL     @"http://192.168.1.19/"
    
    NSString *urlStr = [NSString stringWithFormat:@"%@blockly/index.html?userId=%@&&token=%@", BBT_HTTP_URL,[[TMCache sharedCache] objectForKey:@"userId"],[[TMCache sharedCache] objectForKey:@"token"]];
    
    NSLog(@"urlstr ===== %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}

//- (void)notifyWithRevicce
//{
//
//    [self.characteristicrevice notifyWithValue:!self.characteristic.isNotifying callback:^(EasyCharacteristic *characteristic, NSData *data, NSError *error) {
////        kWeakSelf(self)
//        queueMainStart
//        NSLog(@"订阅通知");
//        queueEnd
//    }];
//
//}

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
    
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('adpic')[0].style.display = 'none'"];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    NSString *alertJS=@"bbt_touch()"; //准备执行的js代码
    //    [jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
    
    //测试
    

    JSNativeMethod *appMethod = [[JSNativeMethod alloc] init];
    appMethod.delegate = self;
    jsContext[@"App"] = appMethod;
    appMethod.jsContext = jsContext;
    
     [self IScurrPeripheral];
    
    
}

- (void)JSNativeMethodBtnClicked:(JSNativeMethod *)Method selectName:(NSString *)name
{

    
//    dispatch_async(dispatch_get_main_queue(), ^{
//

//
//
//    });
    
    
//    [self SendBlueCode:name];
    
    NSLog(@"*******************************************************");
    NSLog(@"sssssviewcontroller=====%@",name);
    NSLog(@"#######################################################");

    NSRange range = [name rangeOfString:@"M"];

    if (range.location == NSNotFound)
    {
        NSRange range1 = [name rangeOfString:@"playstop"];

        if (range1.location == NSNotFound)
        {

            [self PlayMuisc:name];
        }else {

            [self.player stop];
            self.player = nil;

        }

  

    }else {

        [self SendBlueCode:name];

    }
 


}

- (void)JSNativeMethodEnglisBack:(JSNativeMethod *)Method selectName:(NSString *)name {
    

}


- (void)JSNativeMethodBBolckBack:(JSNativeMethod *)Method selectName:(NSString *)name
{
    NSLog(@"sssssss返回");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.navigationController popViewControllerAnimated:YES];
        
        [self backForePage];
        
    });
}

- (void)PlayMuisc:(NSString *)name
{
    
    
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
//    self.currPeripheral != nil &&
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
//
    
        NSString *str11 =  [EasyUtils ConvertStringToHexString:code];
        NSString *str121 = [NSString stringWithFormat:@"%@%@",str11,@"0a"];
    

    
        NSData *data = [EasyUtils convertHexStrToData:str121];
    
//        NSLog(@"str11======%@",str11);
//        //fe6a
//        NSLog(@"ssss ---- %@ ",data);
    

    
        [self.currPeripheral writeValue:data forCharacteristic:self.babycharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    
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
    [self.player stop];//离开界面停止播放声音
    self.player = nil;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    

    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//- (void)backForePage
//{
//    //    [super backForePage];
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
//    [self.navigationController popViewControllerAnimated:YES];
//}



















//- (void)left {
//
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//
//    [UIView animateWithDuration:0.3f animations:^{
//
//        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//
//        self.view.bounds = CGRectMake(64, 0, KDeviceHeight - 64, kDeviceWidth);
//
//        self.webView.frame = self.view.bounds;
//
//        //            self.back.frame = CGRectMake(kDeviceWidth-80, KDeviceHeight-10, 60, 60);
//
//
//    }];
//}
//
//
//
////横屏//横屏  状态下  width和height是颠倒的
//- (void)deviceOrientationDidChange
//{
//    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
//
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
//
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//
//        [UIView animateWithDuration:0.3f animations:^{
//
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 64, kDeviceWidth, KDeviceHeight - 64);
//
//            self.webView.frame = self.view.bounds;
//
////            self.back.frame = CGRectMake(kDeviceWidth-80, KDeviceHeight-100, 60, 60);
//
//
//        }];
//
//
//
//
//        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ) {
//
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//
//        [UIView animateWithDuration:0.3f animations:^{
//
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//
//            self.view.bounds = CGRectMake(64, 0, KDeviceHeight - 64, kDeviceWidth);
//
//            self.webView.frame = self.view.bounds;
//
////            self.back.frame = CGRectMake(kDeviceWidth-80, KDeviceHeight-10, 60, 60);
//
//
//        }];
//
//
//
//
//    }else if ( [UIDevice currentDevice].orientation== UIDeviceOrientationLandscapeRight){
//
//
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//
//        [UIView animateWithDuration:0.3f animations:^{
//
//            self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
//
//            self.view.bounds = CGRectMake(64, 0,KDeviceHeight - 64, kDeviceWidth);
//
//            self.webView.frame = self.view.bounds;
//
////            self.back.frame = CGRectMake(kDeviceWidth-80, KDeviceHeight-100, 60, 60);
//
//
//        }];
//    }
//}
//


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
