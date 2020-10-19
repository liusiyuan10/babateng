//
//  EquipmentSoundGNetWorkViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/26.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentSoundGNetWorkViewController.h"

#import "MyPcmPlayerImp.h"
#import "MyPcmRecorderImp.h"
#import <MediaPlayer/MediaPlayer.h>

#import "EquipmentBindingViewController.h"
#import "HWProgressView.h"

static const char* const CODE_BOOK = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_";

#define TOKEN_COUNT 24

#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioSession.h>

FILE*   mFile;

ESVoid onSinVoiceRecognizerStart(ESVoid* cbParam) {
    NSLog(@"onSinVoiceRecognizerStart file");
    EquipmentSoundGNetWorkViewController* vc = (__bridge EquipmentSoundGNetWorkViewController*)cbParam;
    vc->mResultCount = 0;
}

ESVoid onSinVoiceRecognizerToken(ESVoid* cbParam, ESInt32 index) {
    NSLog(@"onSinVoiceRecognizerToken, index:%d", index);
    EquipmentSoundGNetWorkViewController* vc = (__bridge EquipmentSoundGNetWorkViewController*)cbParam;
    vc->mResults[vc->mResultCount++] = index;
}

ESVoid onSinVoiceRecognizerEnd(ESVoid* cbParam, ESInt32 result) {
    NSLog(@"onSinVoiceRecognizerEnd, result:%d", result);
    EquipmentSoundGNetWorkViewController* vc = (__bridge EquipmentSoundGNetWorkViewController*)cbParam;
    [vc onRecogToken:vc];
}

ESVoid onSinVoicePlayerStart(ESVoid* cbParam) {
    NSLog(@"onSinVoicePlayerStart, start");
    EquipmentSoundGNetWorkViewController* vc = (__bridge EquipmentSoundGNetWorkViewController*)cbParam;
    [vc onPlayData:vc];
    NSLog(@"onPlayData, end");
}

ESVoid onSinVoicePlayerStop(ESVoid* cbParam) {
    EquipmentSoundGNetWorkViewController* vc = (__bridge EquipmentSoundGNetWorkViewController*)cbParam;
    
    NSLog(@"onSinVoicePlayerStop");
    [vc onPlayerStop:vc];

}

SinVoicePlayerCallback gSinVoicePlayerCallback = {onSinVoicePlayerStart, onSinVoicePlayerStop};
SinVoiceRecognizerCallback gSinVoiceRecognizerCallback = {onSinVoiceRecognizerStart, onSinVoiceRecognizerToken, onSinVoiceRecognizerEnd};

@interface EquipmentSoundGNetWorkViewController ()

@property(nonatomic, strong)  UIImageView *cofigView;

@property (nonatomic, strong) UIButton      *successdBtn;//连接网络成功
@property (nonatomic, strong) UIButton      *failedBtn;//连接网络失败

@property(nonatomic, strong)  UILabel *configLabel;

@property(nonatomic, strong)  UILabel *sendLabel;

@property(nonatomic, assign)  NSInteger Num;

@property (nonatomic, strong) MPVolumeView *mpVolumeView;

@property (nonatomic, strong) UISlider *mpVolumeSlider;
@property (nonatomic, weak) HWProgressView *progressView;
@property(nonatomic, strong)  UILabel *promptLabel;

@end

@implementation EquipmentSoundGNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"小腾4G声波配网";
    
    self.Num = 0;
    
    [self setupmpVolumeView];
    
    
    mPcmPlayer.create = MyPcmPlayerImp_create;
    mPcmPlayer.start = MyPcmPlayerImp_start;
    mPcmPlayer.stop = MyPcmPlayerImp_stop;
    mPcmPlayer.setParam = MyPcmPlayerImp_setParam;
    mPcmPlayer.destroy = MyPcmPlayerImp_destroy;
    mSinVoicePlayer = SinVoicePlayer_create2("com.sinvoice.for_xinyijia", "BaBaTeng", &gSinVoicePlayerCallback, (__bridge ESVoid *)(self), &mPcmPlayer);
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    mMaxEncoderIndex = SinVoicePlayer_getMaxEncoderIndex(mSinVoicePlayer);
    
    [self LoadChlidView];
    
//    [self tapPage];
    
    [self performSelector:@selector(tapPage) withObject:nil afterDelay:1.0];
    
}

- (void)setupmpVolumeView
{

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

}

-(void)volumeChanged:(NSNotification *)notification{

    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue]; NSLog(@"FlyElephant-系统音量:%f", volume);

    [_mpVolumeSlider setValue:1.0 animated:NO];
}


- (void)LoadChlidView
{

    self.cofigView = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 300)/2.0, 50, 300, 150)];
    self.cofigView.image = [UIImage imageNamed:@"Sound1.png"];
    self.cofigView.userInteractionEnabled = YES;//打开用户交互
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
    
    
    self.sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.cofigView.frame)+5, kDeviceWidth - 60, 10)];
    self.sendLabel.textColor = [UIColor lightGrayColor];
    self.sendLabel.text = @"点击图片再次发送声波";
    self.sendLabel.font = [UIFont systemFontOfSize:15.0f];

    self.sendLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sendLabel.hidden = YES;
    
    [self.view addSubview:self.sendLabel];
    
    
    self.configLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.cofigView.frame)+20, kDeviceWidth - 60, 70)];
    self.configLabel.textColor = [UIColor orangeColor];
//    self.configLabel.text = @"正在获取声波音频,请稍后";
    self.configLabel.font = [UIFont systemFontOfSize:18.0f];
    self.configLabel.numberOfLines =0;
    self.configLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:  self.configLabel];
    
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
    
    //进度条
    HWProgressView *progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.configLabel.frame) + 30, kDeviceWidth- 40, 15)];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.progressView.frame)+20, kDeviceWidth - 60, 70)];
    self.promptLabel.textColor = [UIColor redColor];
    self.promptLabel.text = @"温馨提示:请将手机喇叭靠近并且对准机器人mic孔";
    self.promptLabel.font = [UIFont systemFontOfSize:15.0f];
    self.promptLabel.numberOfLines =0;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.promptLabel];
    
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


-(void)onPlayData:(EquipmentSoundGNetWorkViewController*)data
{
    
//    NSLog(@"onPlayData");
    NSThread* curThrd =[NSThread currentThread];
    NSLog(@"onPlayData, thread:%@",curThrd);
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:data waitUntilDone:FALSE];
}

-(void)updateUI:(EquipmentSoundGNetWorkViewController*)data
{
    NSThread* curThrd =[NSThread currentThread];
    NSLog(@"updateUI, thread:%@",curThrd);
    
    char ch[100] = { 0 };
    for ( int i = 0; i < mPlayCount; ++i ) {
        ch[i] = (char)data->mRates[i];
    }
    
    NSLog(@"是否被阻塞");
}

-(void)onRecogToken:(EquipmentSoundGNetWorkViewController*)data
{
    NSThread* curThrd =[NSThread currentThread];
    NSLog(@"onRecordData, thread:%@",curThrd);
    [self performSelectorOnMainThread:@selector(updateRecordUI:) withObject:data waitUntilDone:FALSE];
}

-(void)updateRecordUI:(EquipmentSoundGNetWorkViewController*)data
{
    NSThread* curThrd =[NSThread currentThread];
    NSLog(@"updateUI111111, thread:%@",curThrd);
    
    if ( mMaxEncoderIndex < 255 ) {
        NSMutableString* str = [[NSMutableString alloc]init];
        for ( int i = 0; i < mResultCount; ++i ) {
            [str appendFormat:@"%c", CODE_BOOK[data->mResults[i]]];
        }
        
//        _mRecognisedLable.text = str;
    } else {
        char ch[100] = { 0 };
        for ( int i = 0; i < mResultCount; ++i ) {
            ch[i] = (char)data->mResults[i];
        }
        
        NSString* str = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
//        _mRecognisedLable.text = str;
    }
    
    NSLog(@"updateUI111111sss");
}

-(void)onPlayerStop:(EquipmentSoundGNetWorkViewController*)data
{
    NSLog(@"页面结束");
    _progressView.progress = self.Num/4.0;
    if (self.Num < 4) {
//        sleep(500);

         [self performSelector:@selector(tapPage) withObject:nil afterDelay:1.0];
//        [self tapPage];
        NSLog(@"继续播放%ld",(long)self.Num);
        
    }
    else
    {
        self.Num = 0;
        
         self.progressView.hidden = YES;
        _progressView.progress = self.Num/4.0;
        
        self.sendLabel.hidden = NO;
        self.cofigView.userInteractionEnabled = YES;//播放完成恢复点击
        self.configLabel.text = @"声波发送完毕,联网成功了吗？ 设备说出'联网成功'就算是成功了";

        self.successdBtn.hidden = NO;
        self.failedBtn.hidden = NO;

        [self showConfigSuccess];
    }


//            self.cofigView.userInteractionEnabled = YES;//播放完成恢复点击
//            self.configLabel.text = @"声波发送完毕,联网成功了吗？ 设备说出'联网成功'就算是成功了";
//
//            self.successdBtn.hidden = NO;
//            self.failedBtn.hidden = NO;
//
//            [self showConfigSuccess];

}

//点击事件
-(void)tapPage{
    
    self.Num++;
    NSLog(@"播放音频文件同时播放动画");
    self.configLabel.text = @"声波发送中...";
    [self showConfiging];
    self.cofigView.userInteractionEnabled = NO;//播放中不能点击
    
    self.progressView.hidden = NO;
    
    self.sendLabel.hidden = YES;
    
    self.successdBtn.hidden = YES;
    self.failedBtn.hidden = YES;
    
    NSLog(@"push start play");
    int index = 0;
    
    NSError *error;
    NSDictionary *wifiDic = @{@"ssid":self.wifiName,@"pwd":self.wifiPassword};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:wifiDic options:0 error:&error];
//
//    NSString *xx = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   
    
//    NSString* xx = [NSString stringWithFormat:@"{\"ssid\": \"%@\",\"pwd\":\"%@\"}",self.wifiName,self.wifiPassword];
    
//       NSString* xx = [NSString stringWithFormat:@"{ssid: %@,pwd:%@}",self.wifiName,self.wifiPassword];
    
    NSString* xx = [NSString stringWithFormat:@"V0:\r\n%@\r\n%@",self.wifiName,self.wifiPassword];
    
     NSLog(@"xxx===%@",xx);
    
    const char* str = [xx cStringUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"str ==== %s",str);

    
    mPlayCount = (int)strlen(str);
    
    if ( mMaxEncoderIndex < 255 ) {
        int lenCodeBook = (int)strlen(CODE_BOOK);
        int isOK = 1;
        while ( index < mPlayCount) {
            int i = 0;
            for ( i = 0; i < lenCodeBook; ++i ) {
                if ( str[index] == CODE_BOOK[i] ) {
                    mRates[index] = i;
                    break;
                }
            }
            if ( i >= lenCodeBook ) {
                isOK = 0;
                break;
            }
            ++index;
        }
        if ( isOK ) {
            SinVoicePlayer_play(mSinVoicePlayer, mRates, mPlayCount);
        }
    } else {
        int index = 0;
        
        while ( index < mPlayCount) {
            mRates[index] = str[index];
            ++index;
        }
        
        SinVoicePlayer_play(mSinVoicePlayer, mRates, mPlayCount);
    }
    
    
    NSLog(@"jieshu");
    

 
}

-(void)showConfiging{
    
    [self.cofigView startAnimating];
    
}

-(void) showConfigSuccess{
    
    [self.cofigView stopAnimating];
    
    self.cofigView.image = [UIImage imageNamed:@"Sound3.png"];
    
}



- (void)btnClicked
{
    
    NSLog(@"push stop play");
    SinVoicePlayer_stop(mSinVoicePlayer);


}

//

- (void)dealloc
{
    NSLog(@"111111111111111111111111sdfsdfdsff");
    self.Num = 7;
    SinVoicePlayer_stop(mSinVoicePlayer);
//    SinVoicePlayer_destroy(mSinVoicePlayer);
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
