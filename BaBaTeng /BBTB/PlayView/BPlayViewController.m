//
//  QCustomViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BPlayViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Header.h"

#import "MyButton.h"

#import "QPlayListView.h"
#import "GYZActionSheet.h"
#import "QAlbumViewController.h"
#import "QAlbumDataTrackList.h"
#import "MusicPlayerView.h"
@interface BPlayViewController ()<GYZActionSheetDelegate,MusicPlayerViewDelegate>
{
    //    UISlider *proView;
    //    UISlider *cacheView;
    //    UISlider *volumeView;
    
    UIButton *playBtn;
    // UIButton *pauseBtn;
    //UIButton *stopBtn;
    UIButton *preBtn;
    UIButton *nextBtn;
    UILabel *titelLabel;
    //    UILabel *timeLabel;
    NSInteger palyIndex;
    AppDelegate *appDelegate;
    CABasicAnimation* rotationAnimation;
    //    UIButton *downloadBtn;
    //    UIButton *resumeBtn;
    
    //    double proValue;
    //    double cacheValeue;
    
    //  NSTimer *timer;
    
    
    QAlbumDataTrackList *resultRespone;
    
    BOOL  IsPlaying;
    
    
}
@property( nonatomic, strong) UIImageView *pageImageView;

//@property (nonatomic, strong) MusicPlayerView *playerView;
@end

@implementation BPlayViewController

static BPlayViewController *bplayViewController;

+(BPlayViewController *)getInstance{
    
    return bplayViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //self.title = @"名称";
    
    bplayViewController = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BPlayVC:) name:@"BPlayVC" object:nil];
    
    [self LoadChlidView];
//    [MusicPlayerView sharedInstance]
    
    
}

//- (void)BPlayVC:(NSNotification *)noti{
//    NSLog(@"kaishibofang");
//     resultRespone= appDelegate.playSaveDataArray[palyIndex];
//     [self playMusic:resultRespone];
//
//}

//- (void)testPlay
//{
//        NSLog(@"kaishibofang");
//        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//         resultRespone= appDelegate.playSaveDataArray[0];
//         [self playMusic:resultRespone];
//}

- (void)LoadChlidView
{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    palyIndex =0;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    bgImageView.image = [UIImage imageNamed:@"BG_sjbfq"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_nor"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_sel"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backBtn];
    
    titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 34, kDeviceWidth - 150 , 17)];
    
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.font = [UIFont boldSystemFontOfSize:19.0];
    titelLabel.text = @"歌曲名称";
    
    [bgImageView addSubview:titelLabel];

    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 180) / 2.0,CGRectGetMaxY(titelLabel.frame) + 70, 180, 180)];
    pageImageView.image = [UIImage imageNamed:@"img-tu"];
    
    [pageImageView.layer setCornerRadius:(pageImageView.frame.size.height/2)];
    [pageImageView.layer setMasksToBounds:YES];
    pageImageView.layer.borderWidth = 5.0f;
    pageImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [pageImageView setContentMode:UIViewContentModeScaleAspectFill];
    [pageImageView setClipsToBounds:YES];
    
    
    [bgImageView addSubview:pageImageView];
    
    self.pageImageView = pageImageView;
    
    
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
    
    rotationAnimation.duration = 1;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = ULLONG_MAX;
    

    
//    self.playerView = [[MusicPlayerView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(pageImageView.frame) + 25, kDeviceWidth-40, 12)];
//    self.playerView.musicPlayerDelegate = self;
//    self.playerView.IsListen = NO;
//    // [self.playerView setUp:model];
//    [bgImageView addSubview:self.playerView];
//
//
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(20, 250,self.view.frame.size.width-40/568.0*KDeviceHeight,60/568.0*KDeviceHeight)];
    containView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:containView];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"icon_sc_nor",@"icon_tj02_nor",@"icon_lb02_nor",@"icon_zj02_nor", nil];
    NSArray *titleName = [NSArray arrayWithObjects:@"收藏",@"添加",@"列表",@"专辑", nil];
    NSLog(@"KDeviceHeight==%f",KDeviceHeight);
    for(int i=0;i<4;i++)
    {
        
        CGRect rect = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(i%4), (60/568.0*KDeviceHeight*(i/4)+0.5)+(i/4)*0.5, (self.view.frame.size.width-40)/4,60/568.0*KDeviceHeight);
        
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage:imageArray[i] title:titleName[i]  frame:rect type:@"no"];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = i+100;
        [containView addSubview:btn];
    }
    
    CGFloat playBtnY = KDeviceHeight - 110 /667.0 *KDeviceHeight;
    
    playBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 78)/2, playBtnY - 10, 78, 78)];
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_nor"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgImageView addSubview:playBtn];
    
    preBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 78)/2 - 25 - 58, playBtnY, 58, 58)];
    [preBtn setImage:[UIImage imageNamed:@"btn_shanyishou_nor"] forState:UIControlStateNormal];
    [preBtn setImage:[UIImage imageNamed:@"btn_shanyishou_pre"] forState:UIControlStateHighlighted];
    [preBtn addTarget:self action:@selector(preBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:preBtn];
    
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 78)/2 + 25 + 78, playBtnY, 58, 58)];
    [nextBtn setImage:[UIImage imageNamed:@"btn_xiayishou_nor"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"btn_xiayishou_pre"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:nextBtn];
    
    
    
}

-(void)detailBtnClick:(UIButton*)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    NSLog(@"%ld",(long)btn.tag);
    
    
    
    switch (btn.tag) {
            
        case 100:
            
            
            [self showToastWithString:@"你想收藏啥!"];
            break;
        case 101:
            
            
            [self showToastWithString:@"你想添加啥!"];
            break;
            
        case 102:
            
            NSLog(@"列表");
            
            [self list];
            
            break;
            
        case 103:
            
            NSLog(@"专辑");
            
            [[AppDelegate appDelegate]suspendButtonHidden:NO];
            [self.navigationController pushViewController:[QAlbumViewController new] animated:YES];
            break;
        default:
            break;
    }
    
}


-(void)list{

    
//
//    if ( appDelegate.playSaveDataArray.count==0) {
//
//        [self showToastWithString:@"还没有添加歌曲哦!"];
//
//    }else{
//
//        GYZActionSheet *actionSheet = [[GYZActionSheet alloc] initSheetStyle:GYZSheetStyleDefault playStyle:OrderPlayStyle  SortStyle:OrderStyle itemTitles: appDelegate.playSaveDataArray];
//
//        actionSheet.titleTextFont = [UIFont systemFontOfSize:18];
//        actionSheet.itemTextFont = [UIFont systemFontOfSize:16];
//        actionSheet.cancleTextFont = [UIFont systemFontOfSize:16];
//        actionSheet.titleTextColor = [UIColor whiteColor];
//        actionSheet.itemTextColor =  [UIColor grayColor];//[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
//        actionSheet.cancleTextColor = [UIColor grayColor]; //[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
//        actionSheet.zActionDelegate = self;
//        // __weak typeof(self) weakSelf = self;
//        [actionSheet didFinishSelectIndex:^(NSInteger index, QAlbumDataTrackList *respone) {
//            titelLabel.text = respone.trackName;
//            // timeLabel.text  =  [weakSelf getMMSSFromSS:respone.duration];
//
//            if (palyIndex ==index&&IsPlaying) {
//
//                return;
//            }
//            palyIndex =index;
//
//
//            if (IsPlaying) {
//
//
//                VedioModel *model = [[VedioModel alloc]init];
//                model.musicURL = respone.playUrl;
//                [self.playerView changeMusic:model];
//                IsPlaying = YES;
//
//            }else{
//
//                [self playMusic:respone];
//            }
//
//            playBtn.selected = YES;
//            [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//            [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
//
//        }];
//
//
//    }
    
    
}


//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    //    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}


- (void)backBtnClicked
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)playBtnClick:(UIButton *)button  {
    
//    button.selected =  !button.selected;
//    NSLog(@"播放");
//    if (button.selected) {
//
//        NSLog(@"播放");
//        resultRespone= appDelegate.playSaveDataArray[palyIndex];
//        resultRespone.isPlaying = YES;
//
//        if (IsPlaying) {
//
//            //[self play];
//
////            [self.playerView playButtonAction:button];
//
//        }else{
//
//            [self playMusic:resultRespone];
//        }
//
//
//        [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//
//        if (!IsStrEmpty(resultRespone.trackName)) {
//
//            titelLabel.text = resultRespone.trackName;
//            // timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
//        }else{
//
//            titelLabel.text =@"无数据";
//            //timeLabel.text  = @"00:00" ;//[weakSelf getMMSSFromSS:respone.duration];
//        }
//
//    }else{
//
//
//        NSLog(@"暂停");
//
//        [self.playerView playButtonAction:button];
//
//        resultRespone= appDelegate.playSaveDataArray[palyIndex];
//        resultRespone.isPlaying = NO;
//        [self.pageImageView.layer removeAnimationForKey:@"rotationAnimation"];
//        //[self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    }
//
    
    
}

- (void)playMusic:(QAlbumDataTrackList*)playerRespone{
    

    
//    NSLog(@"playerRespone.playUrl==%@",playerRespone.playUrl);
//
//    VedioModel *model = [[VedioModel alloc]init];
//    model.musicURL =playerRespone.playUrl;
//    [self.playerView setUp:model];
//    IsPlaying = YES;
    
    
}




-(void)preBtnClick:(id)sender
{
//    NSLog(@"上一首");
//
//    resultRespone= appDelegate.playSaveDataArray[palyIndex];
//    resultRespone.isPlaying = NO;
//    palyIndex = palyIndex-1;
//
//    if (palyIndex<0) {
//
//        resultRespone= appDelegate.playSaveDataArray[0];
//        resultRespone.isPlaying = YES;
//
//
//    }else{
//
//        resultRespone= appDelegate.playSaveDataArray[palyIndex];
//        resultRespone.isPlaying = YES;
//    }
//
//
//    if (palyIndex<0) {
//
//        [self showToastWithString:@"已经到第一首了"];
//        palyIndex =0;
//        return;
//    }
//    resultRespone = appDelegate.playSaveDataArray[palyIndex];
//
//
//    if (!IsStrEmpty(resultRespone.trackName)) {
//
//        titelLabel.text = resultRespone.trackName;
//        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
//    }else{
//
//        titelLabel.text =@"无数据";
//        // timeLabel.text  = @"00:00";//[self getMMSSFromSS:resultRespone.duration];
//    }
//
//    // [self playMusic:resultRespone];
//
//    VedioModel *model = [[VedioModel alloc]init];
//    model.musicURL = resultRespone.playUrl;
//    [self.playerView changeMusic:model];
//    IsPlaying = YES;
//
//    playBtn.selected = YES;
//    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
//    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
}

- (void)nextBtnClick:(id)sender

{
//    NSLog(@"下一首");
//
//    resultRespone= appDelegate.playSaveDataArray[palyIndex];
//    resultRespone.isPlaying = NO;
//    palyIndex = palyIndex+1;
//
//
//    
//    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
//        
//        [self showToastWithString:@"已经到最后一首了"];
//
//        resultRespone= appDelegate.playSaveDataArray[appDelegate.playSaveDataArray.count-1];
//        resultRespone.isPlaying = YES;
//        palyIndex =appDelegate.playSaveDataArray.count-1;
//        return;
//    }else{
//
//        resultRespone= appDelegate.playSaveDataArray[palyIndex];
//        resultRespone.isPlaying = YES;
//
//    }
//
//    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
//
//        [self showToastWithString:@"已经到最后一首了"];
//        
//        return;
//    }
//    resultRespone = appDelegate.playSaveDataArray[palyIndex];
//    if (!IsStrEmpty(resultRespone.trackName)) {
//        
//        titelLabel.text = resultRespone.trackName;
//        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
//    }else{
//
//        titelLabel.text =@"无数据";
//        //timeLabel.text  = @"00:00";
//    }
//    
//    // [self playMusic:resultRespone];
//    VedioModel *model = [[VedioModel alloc]init];
//    model.musicURL = resultRespone.playUrl;
//    [self.playerView changeMusic:model];
//    IsPlaying = YES;
//
//    playBtn.selected = YES;
//    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
//    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
}


//播放失败的代理方法
-(void)playerViewFailed{
    
    NSLog(@"播放失败");
}
//缓存中的代理方法
-(void)playerViewBuffering{
    
}
//播放完毕的代理方法
-(void)playerViewFinished{
    
//    NSLog(@"播放完成哈哈哈");
//
//    NSLog(@"下一首");
//
//    resultRespone= appDelegate.playSaveDataArray[palyIndex];
//    resultRespone.isPlaying = NO;
//    palyIndex = palyIndex+1;
//
//
//
//    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
//
//        [self showToastWithString:@"已经到最后一首了"];
//
//        resultRespone= appDelegate.playSaveDataArray[appDelegate.playSaveDataArray.count-1];
//        resultRespone.isPlaying = YES;
//        palyIndex =appDelegate.playSaveDataArray.count-1;
//        [playBtn setImage:[UIImage imageNamed:@"btn_bofan_nor"] forState:UIControlStateNormal];
//
//        return;
//    }else{
//
//        resultRespone= appDelegate.playSaveDataArray[palyIndex];
//        resultRespone.isPlaying = YES;
//
//    }
//
//    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
//
//        [self showToastWithString:@"已经到最后一首了"];
//        [playBtn setImage:[UIImage imageNamed:@"btn_bofan_nor"] forState:UIControlStateNormal];
//        return;
//    }
//    resultRespone = appDelegate.playSaveDataArray[palyIndex];
//    if (!IsStrEmpty(resultRespone.trackName)) {
//
//        titelLabel.text = resultRespone.trackName;
//        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
//    }else{
//
//        titelLabel.text =@"无数据";
//        //timeLabel.text  = @"00:00";
//    }
//
//    // [self playMusic:resultRespone];
//    VedioModel *model = [[VedioModel alloc]init];
//    model.musicURL = resultRespone.playUrl;
//    [self.playerView changeMusic:model];
//    IsPlaying = YES;
//
//    playBtn.selected = YES;
//    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
//    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}

//- (void)loopBasicAnimation
//
//{
//
//    //动画
//
//    CABasicAnimation* rotationAnimation;
//
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
//
//    rotationAnimation.duration = 1.0;
//
//    rotationAnimation.cumulative = YES;
//
//    rotationAnimation.repeatCount = ULLONG_MAX;
//
//    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//
//}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // [self.playerView pause];//暂停播放
    
//    if (IsPlaying) {
//        [self.playerView removeObserver];//注销观察者
//    }
  
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end


