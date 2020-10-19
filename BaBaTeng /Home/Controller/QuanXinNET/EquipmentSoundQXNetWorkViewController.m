//
//  EquipmentSoundQXNetWorkViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/12/10.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//
//  EquipmentSoundConfigNetWorkViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/12/8.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentSoundQXNetWorkViewController.h"
#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BBTSound.h"
#import "MJExtension.h"
#import "BBTQAlertView.h"
#import "EquipmentBindingViewController.h"
#import "EquipmentConfigNetWorkViewController.h"

#import "HomeViewController.h"
#import "BBTMainTool.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "NewHomeViewController.h"
#import "HWProgressView.h"

#define ZZRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface EquipmentSoundQXNetWorkViewController ()<AVAudioPlayerDelegate>{
    
    AppDelegate *appDele;
}



@property(nonatomic, strong)  UIImageView *cofigView;

@property (nonatomic, strong) UIButton      *cancelBtn;

@property (nonatomic, strong) UIButton      *successdBtn;//连接网络成功
@property (nonatomic, strong) UIButton      *failedBtn;//连接网络失败


@property (nonatomic,strong)  AVAudioPlayer  *player;

@property(nonatomic, strong)  UILabel *configLabel;

@property(nonatomic, strong)  UILabel *sendLabel;

@property(nonatomic, strong)  NSURL *playPath;

@property(nonatomic, strong)  NSString *fullPath;

//@property (nonatomic, weak) HWCircleView *circleView;

@property (nonatomic, strong) MPVolumeView *mpVolumeView;

@property (nonatomic, strong) UISlider *mpVolumeSlider;

@property (nonatomic, assign) BOOL  ifleave;

@property (nonatomic, assign) NSInteger playNum;

@property (nonatomic, weak) HWProgressView *progressView;



@end

@implementation EquipmentSoundQXNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"声波配网";
    
    [self LoadChlidView];
    
    self.ifleave = YES;
    //[self showConfiging];
    
    [self soundNetwork];//下载声波
    
    if (!_mpVolumeView) {
        if (_mpVolumeView == nil) {
            _mpVolumeView = [[MPVolumeView alloc] init];
            
            for (UIView *view in [_mpVolumeView subviews]) {
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                    _mpVolumeSlider = (UISlider *)view;
                    break;
                }
            }
            [_mpVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
            [_mpVolumeView setShowsVolumeSlider:YES];
            [_mpVolumeView setHidden:YES];
            [_mpVolumeView sizeToFit];
        }
    }
    
    [_mpVolumeSlider setValue:1.0 animated:YES];
    
    self.playNum = 0;
    
}

-(void)volumeChanged:(NSNotification *)notification{
    
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue]; NSLog(@"FlyElephant-系统音量:%f", volume);
    
    [_mpVolumeSlider setValue:1.0 animated:NO];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    
    
}

- (void)LoadChlidView
{
    
    //    icon_WIFIBIG_01
    
    self.cofigView = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 300)/2.0, 50, 300, 150)];
    self.cofigView.image = [UIImage imageNamed:@"Sound0.png"];
    self.cofigView.userInteractionEnabled = NO;//打开用户交互
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPage)];
    [self.cofigView addGestureRecognizer:tapGesturRecognizer];
    self.cofigView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"Sound1.png"],
                                      [UIImage imageNamed:@"Sound2.png"],
                                      [UIImage imageNamed:@"Sound3.png"],
                                      [UIImage imageNamed:@"Sound4.png"],
                                      nil];
    self.cofigView.backgroundColor = [UIColor clearColor];
    [self.cofigView setAnimationDuration:1.0f];
    [self.cofigView setAnimationRepeatCount:0];
    //    [self.cofigView startAnimating];
    [self.view addSubview:self.cofigView];
    
    
    //自定义起始角度、自定义小圆点
    //    circle3 = [[ZZCACircleProgress alloc] initWithFrame:CGRectMake((kDeviceWidth - 150)/2.0, 50, 150, 150) pathBackColor:nil pathFillColor:ZZRGB(120, 208, 211) startAngle:-255 strokeWidth:8];
    //    circle3.reduceAngle = 0;
    //    circle3.increaseFromLast = YES;
    //    circle3.pointImage.image = [UIImage imageNamed:@"test_point"];
    //    circle3.duration = 1.5;//动画时长
    //    circle3.progressLabel.hidden = YES;
    //    circle3.prepareToShow = YES;//设置好属性，准备好显示了，显示之前必须调用一次
    //
    //    [self.view addSubview:circle3];
    
    //    //圆圈
    //    HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:CGRectMake((kDeviceWidth - 150)/2.0, 50, 150, 150)];
    //    [self.view addSubview:circleView];
    //    self.circleView = circleView;
    
    
    self.sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.cofigView.frame)+5, kDeviceWidth - 60, 10)];
    self.sendLabel.textColor = [UIColor lightGrayColor];
    self.sendLabel.text = @"点击图片再次发送声波";
    self.sendLabel.font = [UIFont systemFontOfSize:15.0f];
    
    self.sendLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sendLabel.hidden = YES;
    
    [self.view addSubview:self.sendLabel];
    
    self.configLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.cofigView.frame)+20, kDeviceWidth - 60, 70)];
    self.configLabel.textColor = [UIColor orangeColor];
    self.configLabel.text = @"正在获取声波音频,请稍后";
    self.configLabel.font = [UIFont systemFontOfSize:18.0f];
    self.configLabel.numberOfLines =0;
    self.configLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.configLabel];
    
    
    
    //适配iphone x
    //    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight - 180-kDevice_Is_iPhoneX, kDeviceWidth - 40, 51)];
    //    [self.cancelBtn setTitle:@"返回wifi配网" forState:UIControlStateNormal];
    //    [ self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    //    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.view addSubview:self.cancelBtn];
    
    //联网成功
    self.successdBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight - 200-kDevice_Is_iPhoneX, kDeviceWidth - 40, 48)];
//    [self.successdBtn  setImage:[UIImage imageNamed:@"btn_successd_nor"] forState:UIControlStateNormal];
//    [self.successdBtn  setImage:[UIImage imageNamed:@"btn_successd_pre"] forState:UIControlStateHighlighted];
//    [self.successdBtn  setTitle:@"成功了,去绑定设备" forState:UIControlStateNormal];
    
    self.successdBtn.layer.cornerRadius= 10.0f;
    
    self.successdBtn.clipsToBounds = YES;//去除边界
    self.successdBtn.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [self.successdBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [self.successdBtn setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [self.successdBtn setTitle:@"成功了，去绑定设备" forState:UIControlStateNormal];
    
    [self.successdBtn setTitle:@"成功了，去绑定设备" forState:UIControlStateHighlighted];
    
    [self.successdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.successdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.successdBtn  addTarget:self action:@selector(successdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:  self.successdBtn ];
    
    
    //联网失败
    self.failedBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,KDeviceHeight - 200-kDevice_Is_iPhoneX+68, kDeviceWidth - 40, 48)];
//    [self.failedBtn setImage:[UIImage imageNamed:@"btn_failed_nor"] forState:UIControlStateNormal];
//    [self.failedBtn setImage:[UIImage imageNamed:@"btn_failed_pre"] forState:UIControlStateHighlighted];
    
    self.failedBtn.layer.cornerRadius= 10.0f;
    self.failedBtn.layer.borderWidth = 1.0;
    self.failedBtn.layer.borderColor = [UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0].CGColor;
    self.failedBtn.clipsToBounds = YES;//去除边界
    self.failedBtn.layer.masksToBounds = YES;
    
    UIImage *normal1Back = [self imageFromColor:[UIColor clearColor]];
    UIImage *hihglight1Back = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:0.3]];
    
    [self.failedBtn setBackgroundImage:normal1Back forState:UIControlStateNormal];
    [self.failedBtn setBackgroundImage:hihglight1Back forState:UIControlStateHighlighted];
    
    [self.failedBtn setTitle:@"失败了，重新联网" forState:UIControlStateNormal];
    
    [self.failedBtn setTitle:@"失败了，重新联网" forState:UIControlStateHighlighted];
    
    [self.failedBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:74/255.0 blue:52/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.failedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [self.failedBtn addTarget:self action:@selector(failedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.failedBtn];
    
    self.successdBtn.hidden = YES;
    self.failedBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    
    
    //进度条
    HWProgressView *progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.configLabel.frame) + 30, kDeviceWidth- 40, 15)];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    
    
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


-(void)successdBtnAction{
    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    bindVc.iconUrl =self.iconUrl;
    [self.navigationController pushViewController:bindVc animated:YES];
    
}
-(void)failedAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancelBtnClick{
    
    NSLog(@"返回Wi-Fi配网");
    
    
    [appDele.wscPresenter setPassword:self.wifiPassword forSSID:[appDele.wscPresenter getCurrentSSID] isHidden:NO];
    
    EquipmentConfigNetWorkViewController *configVc = [[EquipmentConfigNetWorkViewController alloc] init];
    
    configVc.deviceTypeName = self.deviceTypeName;
    configVc.deviceTypeId = self.deviceTypeId;
    configVc.iconUrl =self.iconUrl;
    [self.navigationController pushViewController:configVc animated:YES];
    
    
}

//点击事件
-(void)tapPage{
    
    NSLog(@"播放音频文件同时播放动画");
    self.configLabel.text = @"声波发送中...";
    [self showConfiging];
    [self play:self.playPath];
    
    self.successdBtn.hidden = YES;
    self.failedBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    
    self.progressView.hidden = NO;
    
    self.sendLabel.hidden = YES;
    
    
}




-(void)showConfiging{
    
    [self.cofigView startAnimating];
    
}

-(void) showConfigSuccess{
    
    [self.cofigView stopAnimating];
    
    self.cofigView.image = [UIImage imageNamed:@"Sound3.png"];
    
}


- (void)soundNetwork
{
    
    //NSString *urlStr =[NSString stringWithFormat:@"%@bbt-phone/sinvoice",BBT_HTTP_URL];
    //NSString *urlStr = @"http://192.168.1.17:8080/bbt-phone/sinvoice";
    //     NSString *urlStr =[NSString stringWithFormat:@"%@%@/sinvoice",BBT_HTTP_URL,PROJECT_NAME_APP];/
    
    NSString *urlStr =[NSString stringWithFormat:@"%@%@/sinvoice/huba",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    //    NSString *urlStr =[NSString stringWithFormat:@"%@%@/sinvoice/quanxin",BBT_HTTP_URL,PROJECT_NAME_APP];
    
    NSLog(@"urlStr=========%@",urlStr);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //    NSDictionary
    
    NSDictionary *item = @{@"ssid":self.wifiName,@"password":self.wifiPassword};
    
    NSLog(@"item=====%@",item);
    
    // GET方法
    [manager POST:urlStr parameters:item progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BBTSound *respone = [BBTSound mj_objectWithKeyValues:result];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self download:respone.data];
            
        }else{
            
            if ( [respone.statusCode isEqualToString:@"101"])
            {
                
                BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
                
                
                [QalertView showInView:self.view];
                
                //点击按钮回调方法
                QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                    if (titleBtnTag == 1) {
                        
                        [[NewHomeViewController getInstance] disconnectWithmKTopic];
                        
                        [[TMCache sharedCache]removeObjectForKey:@"userId"];
                        [[TMCache sharedCache]removeObjectForKey:@"token"];
                        //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                        [[TMCache sharedCache]removeObjectForKey:@"password"];
                        [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                        [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                        [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                        [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                        [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                        [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                        [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                        
                        [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                        [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                        [BBTMainTool setLoginRootViewController:CZKeyWindow];
                        
                        //  NSLog(@"sb");
                    }
                    
                };
                
            }else{
                
                [self showToastWithString:respone.message];
            }
            
            
        }
        
        NSLog(@"声波请求结果%@",result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        NSLog(@"请求失败:%@", error.description);
        //
        //        NSLog(@"*********");
        //        NSLog(@"error = %@", error);
        //        NSLog ( @"error description:%@" ,[error description ]);
        
        [self showToastWithString:@"网络连接失败"];
        
    }];
    
}




-(void)download:(NSString*)url
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    // NSURL *urlStr = [NSURL URLWithString:@"http://120.76.99.212/storybox/download/sinvoice/o7GmpuLcrG-05GAglcDixlcv_6y0.wav"];
    
    NSURL *urlStr = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    
    //2.下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调 downloadProgress
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成之后的回调
     filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        //_circleView.progress = 1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        self.fullPath = fullPath;
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"===888===%@",filePath);
        self.cofigView.userInteractionEnabled = YES;//打开用户交互
        self.playPath =filePath;
        //self.configLabel.text = @"请点击蓝色图标进行配网";
        self.cofigView.image = [UIImage imageNamed:@"Sound1.png"];
        
        //circle3.hidden = YES;
        if (self.ifleave) {
            
            [self tapPage];
        }
        
        
    }];
    
    //3.执行Task
    [download resume];
    
    
    
}

-(void)play:(NSURL *)playPath{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //    NSURL *audioUrl = [NSURL fileURLWithPath:self.playPath];
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:playPath error:&playerError];
    _player.delegate = self;
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    
    self.cofigView.userInteractionEnabled = NO;//播放过程中不能重复点击
    //    [_player setNumberOfLoops:1];//循环播放12次
    // [_player setVolume:1];
    //    _player.volume = 1;
    [_player prepareToPlay];
    [_player play];
    
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    self.playNum++;
    NSLog(@"self.playNum====%ld",(long)self.playNum);
    NSLog(@"111111播放完成，进一步操作待定");
    
    _progressView.progress = self.playNum/5.0;
    
    if (self.playNum < 5) {
        [self play:self.playPath];
    }
    else
    {
        self.sendLabel.hidden = NO;
        self.progressView.hidden = YES;
        
        self.playNum = 0;
        _progressView.progress = self.playNum/5.0;
        NSLog(@"播放完成，进一步操作待定");
        self.cofigView.userInteractionEnabled = YES;//播放完成恢复点击
        self.configLabel.text = @"声波发送完毕,联网成功了吗？ 设备说出'联网成功'就算是成功了";
        
        self.successdBtn.hidden = NO;
        self.failedBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        
        [self showConfigSuccess];
        
    }
    
    //    NSLog(@"播放完成，进一步操作待定");
    //    self.cofigView.userInteractionEnabled = YES;//播放完成恢复点击
    //    self.configLabel.text = @"声波发送完毕,联网成功了吗？ 设备说出'联网成功'就算是成功了";
    //
    //    self.successdBtn.hidden = NO;
    //    self.failedBtn.hidden = NO;
    //    self.cancelBtn.hidden = YES;
    //
    //    [self showConfigSuccess];
    
    
}
//-(void)dealloc
//{
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
//}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_player stop];//离开界面停止播放声音
    
    self.ifleave =NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    NSError *error = nil;
    //删除声波音频文件
    [[NSFileManager defaultManager] removeItemAtPath: self.fullPath error:&error];
    
    if (error) {
        
        NSLog(@"删除失败");
        
    }else{
        
        NSLog(@"删除成功");
    }
    
}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    NSLog(@"sdfs1122222333334444455555666");
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

