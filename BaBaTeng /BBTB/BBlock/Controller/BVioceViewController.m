//
//  BVioceViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BVioceViewController.h"

#import "BICVoiceHud.h"
#import "ICVoiceHud.h"
#import "ICRecordManager.h"
#import <AVFoundation/AVFoundation.h>

#import "AFNetworking.h"

#import "BVoiceModel.h"
#import "BVoiceDataModel.h"

#import "BBTQAlertView.h"
#import "NewHomeViewController.h"
#import "BBTMainTool.h"

#import "EasyUtils.h"

#import "QAlbumDataTrackList.h"

#import "BPlayTestViewController.h"





@interface BVioceViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) UIButton *RecordBtn;

/** 录音文件名 */
@property (nonatomic, copy) NSString *recordName;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) BICVoiceHud *voiceHud;

//@property (nonatomic, strong) ICVoiceHud *voiceHud;

@property (nonatomic,strong)  AVAudioPlayer  *player;

@property (nonatomic, copy) NSString *recordPath;//录音文件路径
@property (nonatomic, strong) NSMutableArray *playSaveDataArray;

@property (nonatomic, strong) NSMutableArray *playoldSaveDataArray;


@end

@implementation BVioceViewController



- (BICVoiceHud *)voiceHud
{
    if (!_voiceHud) {
        _voiceHud = [[BICVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(App_Frame_Width/2, APP_Frame_Height/2 - 80);
    }
    return _voiceHud;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (UIButton *)RecordBtn
{
    if (_RecordBtn == nil) {

        _RecordBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 74)/2.0, KDeviceHeight - 133 - 64 - 50, 74,133)];
        
        [_RecordBtn setImage:[UIImage imageNamed:@"mc_nor"] forState:UIControlStateNormal];
        [_RecordBtn setImage:[UIImage imageNamed:@"mc_pre"] forState:UIControlStateHighlighted];
//        [_RecordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
//        [_RecordBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        
//        [_RecordBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
//        [_RecordBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
//        [_RecordBtn.layer setMasksToBounds:YES];
//        [_RecordBtn.layer setCornerRadius:4.0f];
//        [_RecordBtn.layer setBorderWidth:0.5f];

        [_RecordBtn addTarget:self action:@selector(talkButtonDown:) forControlEvents:UIControlEventTouchDown];
        [_RecordBtn addTarget:self action:@selector(talkButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_RecordBtn addTarget:self action:@selector(talkButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_RecordBtn addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_RecordBtn addTarget:self action:@selector(talkButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_RecordBtn addTarget:self action:@selector(talkButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _RecordBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //允许转成横屏
//    appDelegate.allowRotation = YES;
//    //调用转屏代码
//    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    self.title = @"语音控制";
    
    [self SendBlueCode:@"M228 0"];
    
    self.playoldSaveDataArray = appDelegate.playSaveDataArray;
    
    [self LoadChlidView];
    
    
    [self IScurrPeripheral];
    
    
}


- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"VoiceBg"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
//    //适配iphone x
//    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+kDevice_Is_iPhoneX, 99, 70)];
//    
//    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_nor"] forState:UIControlStateNormal];
//    [backbutton setImage:[UIImage imageNamed:@"bbtbbtn_fh_pre"] forState:UIControlStateHighlighted];
//    [backbutton addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
//    
//    [bgImageView addSubview:backbutton];
    
    [self.view addSubview:self.RecordBtn];
    
//    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 50, 30)];
//
//    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
//
//    [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//    [playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:playBtn];
    
    
    
}

//-(void)playBtnClicked
//{
//    NSLog(@"self.recordPath====%@",self.recordPath);
//
////    NSString *namestr = [NSString stringWithFormat:@"%@",@"小蝌蚪找妈妈第一段"];
////    //
////    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:namestr withExtension:@"mov"];
////
//////     [self PlayMuisc:musicURL];
////
////    NSLog(@"music====%@",musicURL);
//
//    [self PlayMuisc:self.recordPath];
//}

- (void)PlayMuisc:(NSString *)name
{

    
//    NSString *namestr = [NSString stringWithFormat:@"%@",name];
//    //
//    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:namestr withExtension:@"mp3"];
    
    NSURL *musicURL = [NSURL URLWithString:name];
    
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
    //    [_player setNumberOfLoops:7];//循环播放12次
    // [_player setVolume:1];
    //    _player.volume = 1;
    [_player prepareToPlay];
    [_player play];
    
    
}

// [self sendMessage:@"" type:QChatMessageSelf recordPath:recordPath];

- (void)sendMessagerecordPath:(NSString *)recordPath
{
    
    [self voiceDidCancelRecording];
    
    [self postBBTBVoiceFile:recordPath];
    
}


// 说话按钮
- (void)talkButtonDown:(UIButton *)sender
{
    

//    
//    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidStartRecordingVoice:)]) {
//        [_delegate chatBoxDidStartRecordingVoice:self];
//    }
//    
//    sender.enabled = NO;
//    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
//    
//    self.talktimer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(talkButtonUpInside:) userInfo:nil repeats:NO];

    self.recordName = [self currentRecordFileName];
    
    [[ICRecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {   // 加了录音权限的判断
        } else {
            
            [self voiceDidStartRecording];
        }
    }];
    
}


- (void)talkButtonUpInside:(UIButton *)sender
{

    
    __weak typeof(self) weakSelf = self;
    [[ICRecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:shortRecord]) {
            
            [self voiceRecordSoShort];
            
            [[ICRecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {
            NSLog(@"recordPath1234567890909=====%@",recordPath);
//            [self sendMessage:@"" type:QChatMessageSelf recordPath:recordPath];
            self.recordPath = recordPath;
            [self sendMessagerecordPath:recordPath];
            
        }
    }];
    
}

- (void)talkButtonUpOutside:(UIButton *)sender
{
//    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidCancelRecordingVoice:)]) {
//        [_delegate chatBoxDidCancelRecordingVoice:self];
//    }
    
    [self voiceDidCancelRecording];
    
    [[ICRecordManager shareManager] removeCurrentRecordFile:self.recordName];
    
}

- (void)talkButtonDragOutside:(UIButton *)sender
{
//    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
//        [_delegate chatBoxDidDrag:NO];
//    }
    
    [self voiceWillDragout:NO];
}

- (void)talkButtonDragInside:(UIButton *)sender
{
//    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
//        [_delegate chatBoxDidDrag:YES];
//    }
    
     [self voiceWillDragout:YES];
    
}

- (void)talkButtonTouchCancel:(UIButton *)sender
{
}


- (NSString *)currentRecordFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}

- (void)timerInvalue
{
    [_timer invalidate];
    _timer  = nil;
}

#pragma mark - voice & video

- (void)voiceDidCancelRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = YES;
}
- (void)voiceDidStartRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = NO;
    [self timer];
}

// 向外或向里移动
- (void)voiceWillDragout:(BOOL)inside
{
    if (inside) {
        [_timer setFireDate:[NSDate distantPast]];
        _voiceHud.image  = [UIImage imageNamed:@"BBTBVoice_1"];
//        _voiceHud.image  = [UIImage imageNamed:@"voice_1"];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.voiceHud.animationImages  = nil;
        self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];//cancelVoice
    }
}
- (void)progressChange
{
    AVAudioRecorder *recorder = [[ICRecordManager shareManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    
    
    NSLog(@"power=====%f",power);
    
    NSLog(@"progress=====%f",progress);
    
    
    self.voiceHud.progress = progress;
}

- (void)voiceRecordSoShort
{
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceHud.hidden = YES;
    });
}

- (void)backFore
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
}


//- (void)postBBTBVoiceFile:(NSString *)recordPath
//{
//    //用AFN的AFHTTPSessionManager
//    AFHTTPSessionManager *sharedManager = [[AFHTTPSessionManager alloc]init];
//    sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
//    sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    sharedManager.requestSerializer.timeoutInterval =20;
//
//    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
//    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
//
//    //    NSString *url = [NSString stringWithFormat:@"你的url"];
////  bbt-cropus/cropus/devices/{deviceId}/convertVoiceToMessage
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@/cropus/devices/%@/convertVoiceToMessage",BBT_HTTP_URL,@"bbt-cropus",[[TMCache sharedCache] objectForKey:@"deviceId"]];
//
//    NSLog(@"urlStr11112222======%@",urlStr);
//
////    NSString *urlStr = [NSString stringWithFormat:@"%@%@/programming/devices/%@/convertVoiceToMessage",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
//
//     [self startLoading];
//    [sharedManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        NSData *data = [NSData dataWithContentsOfFile:recordPath];
//        //上传数据:FileData-->data  name-->fileName(固定，和服务器一致)  fileName-->你的语音文件名  mimeType-->我的语音文件type是audio/amr 如果你是图片可能为image/jpeg
//        [formData appendPartWithFileData:data name:@"file" fileName:@"amrRecord.wav" mimeType:@"audio/wav"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//        NSLog(@"ssssssss%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//          [self stopLoading];
//
//        // NSData转为NSString
//        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"jsonStr===%@", jsonStr);
//
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//         NSLog(@"result==========%@",result);
//
//        BVoiceModel *respone = [BVoiceModel mj_objectWithKeyValues:responseObject];
//
//        NSLog(@"respone======%@",respone);
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//
//            if ([respone.data.dataStatusCode isEqualToString:@"1"]) {
//
//                for (int i = 0; i < respone.data.controldata.count; i++) {
//                    NSString *controldatastr = [respone.data.controldata objectAtIndex:i];
//
//                    [self SendBlueCode:controldatastr];
//                }
//            }
//            else if ([respone.data.dataStatusCode isEqualToString:@"2"] || [respone.data.dataStatusCode isEqualToString:@"3"])
//            {
//                NSLog(@"歌曲类资源");
//                self.playSaveDataArray = respone.data.QAlbumDataTrackList;
//                if (self.playSaveDataArray.count == 0) {
//
//                    [self showToastWithString:@"没有搜到歌曲"];
//                    return ;
//                }
//
//                appDelegate.playSaveDataArray = self.playSaveDataArray;
//
//                QAlbumDataTrackList *listRespone = self.playSaveDataArray[0];
//
//
//                [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
//
//                NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
//
//                [[BPlayTestViewController sharedInstance] testPlay:0];
//
//
//            }
//            else
//            {
////                NSLog(@"其它格式");
//                [self showToastWithString:@"没有搜到歌曲"];
//
//            }
//
//
//        }
//
//        else if( [respone.statusCode isEqualToString:@"101"] )
//        {
//            NSLog(@"未登录或登录已过期");
//
//            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
//
//
//            [QalertView showInView:self.view];
//
//            //点击按钮回调方法
//            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//                if (titleBtnTag == 1) {
//
//                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
//
//                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
//                    [[TMCache sharedCache]removeObjectForKey:@"token"];
//                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
//                    [[TMCache sharedCache]removeObjectForKey:@"password"];
//                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
//                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
//                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
//                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
//                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
//                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
//                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
//
//                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
//                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
//                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
//
//                    //  NSLog(@"sb");
//                }
//
//            };
//
//        }
//
//        else
//        {
//            //            [self.chatBox.textView resignFirstResponder];
//            [self showToastWithString:respone.message];
//
//
//        }
//
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [self stopLoading];
//        NSLog(@"%@",error);
//
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];//暂时屏蔽会是键盘弹出框消失
//
//
//    }];
//
//}


- (void)postBBTBVoiceFile:(NSString *)recordPath
{
    
    
    NSLog(@"recordPathNNNNNNNNNNNN=====%@",recordPath);
    //用AFN的AFHTTPSessionManager
    AFHTTPSessionManager *sharedManager = [[AFHTTPSessionManager alloc]init];
    sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    sharedManager.requestSerializer.timeoutInterval =20;
    
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    //    NSString *url = [NSString stringWithFormat:@"你的url"];
    //  bbt-cropus/cropus/devices/{deviceId}/convertVoiceToMessage
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/cropus/devices/%@/convertVoiceToMessage",BBT_HTTP_URL,@"bbt-cropus",[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    NSLog(@"urlStr11112222======%@",urlStr);
    
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@/programming/devices/%@/convertVoiceToMessage",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    [self startLoading];
    [sharedManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = [NSData dataWithContentsOfFile:recordPath];
        //上传数据:FileData-->data  name-->fileName(固定，和服务器一致)  fileName-->你的语音文件名  mimeType-->我的语音文件type是audio/amr 如果你是图片可能为image/jpeg
        [formData appendPartWithFileData:data name:@"file" fileName:@"amrRecord.wav" mimeType:@"audio/wav"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"sssssss%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self stopLoading];
        
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr===%@", jsonStr);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result==========%@",result);
        
        BVoiceModel *respone = [BVoiceModel mj_objectWithKeyValues:responseObject];
        
        NSLog(@"respone======%@",respone);
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            if ([respone.data.dataStatusCode isEqualToString:@"1"]) {
                
                for (int i = 0; i < respone.data.controldata.count; i++) {
                    NSString *controldatastr = [respone.data.controldata objectAtIndex:i];
                    
                    [self SendBlueCode:controldatastr];
                }
            }
            else if ([respone.data.dataStatusCode isEqualToString:@"2"] || [respone.data.dataStatusCode isEqualToString:@"3"])
            {
                NSLog(@"歌曲类资源");
                self.playSaveDataArray = respone.data.QAlbumDataTrackList;
                if (self.playSaveDataArray.count == 0) {
                    
                    [self showToastWithString:@"没有搜到歌曲"];
                    return ;
                }
                
                appDelegate.playSaveDataArray = self.playSaveDataArray;
                
                QAlbumDataTrackList *listRespone = self.playSaveDataArray[0];
                
                
                [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
                
                NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
                
                [[BPlayTestViewController sharedInstance] testPlay:0];
                
                
            }
            else
            {
                //                NSLog(@"其它格式");
                [self showToastWithString:@"没有搜到歌曲"];
                
            }
            
            
        }
        
        else if( [respone.statusCode isEqualToString:@"101"] )
        {
            NSLog(@"未登录或登录已过期");
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:self.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
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
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
        }
        
        else
        {
            //            [self.chatBox.textView resignFirstResponder];
            [self showToastWithString:respone.message];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self stopLoading];
        NSLog(@"%@",error);
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];//暂时屏蔽会是键盘弹出框消失
        
        
    }];
    
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
//    if (self.currPeripheral.state == CBPeripheralStateDisconnected) {
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
    
    NSLog(@"code11111111111111111111111======%@",code);
    NSString *str11 =  [EasyUtils ConvertStringToHexString:code];
    NSString *str121 = [NSString stringWithFormat:@"%@%@",str11,@"0a"];
    
    
    
    //    NSString *str121 = @"C2:XYJWIFI:xyjwifi@2017";
    
    NSData *data = [EasyUtils convertHexStrToData:str121];
    
    
    //fe6a
    NSLog(@"ssss ---- %@ ",data);
    
//    [self.characteristic writeValueWithData:data callback:^(EasyCharacteristic *characteristic, NSData *data, NSError *error) {
//
//        queueMainStart
//        NSLog(@"发送成功");
//        queueEnd
//    }];
    
    [self.currPeripheral writeValue:data forCharacteristic:self.babycharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    NSLog(@"1234345");
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    appDelegate.playSaveDataArray = self.playoldSaveDataArray;
    
    QAlbumDataTrackList *listRespone = self.playSaveDataArray[0];
    
    
    [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
    
    NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
    
    [[BPlayTestViewController sharedInstance] testPlay:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
