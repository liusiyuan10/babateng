//
//  QCustomViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCustomViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Header.h"

#import "MyButton.h"
#import "AppDelegate.h"
#import "QPlayListView.h"
#import "GYZActionSheet.h"
#import "QAlbumPlayViewController.h"
//#import "QDemandResultRespone.h"
#import "QAlbumDataTrackList.h"
//#import "MusicPlayerView.h"
#import "HomeViewController.h"
#import "QMineRequestTool.h"
#import "JXButton.h"

#import "QHomeRequestTool.h"
#import "QAddSong.h"
#import "QSongDataList.h"

#import "BBTCustomViewRequestTool.h"
#import "QCustom.h"
#import "QCustomData.h"
#import "QPlayingTrack.h"
#import "QplayType.h"

#import "QCategoryRequestTool.h"

#import "QPlayingTrackList.h"

#import "UIImageView+AFNetworking.h"
#import "NewHomeViewController.h"


@interface QCustomViewController ()<GYZActionSheetDelegate,QPlayListViewDelegate>
{
    
    UIButton *playBtn;
    // UIButton *pauseBtn;
    //UIButton *stopBtn;
    UIButton *preBtn;
    UIButton *nextBtn;
    UILabel *titelLabel;
    UILabel *timeLabel;
    NSInteger palyIndex;
    
    CABasicAnimation* rotationAnimation;
    
    
    QAlbumDataTrackList *resultRespone;
    
    BOOL  IsPlaying;
    
    // BOOL  Islocal;
    
    
}
@property( nonatomic, strong) UIImageView *pageImageView;
@property( nonatomic, strong) JXButton *dogButton;
@property( nonatomic, strong) JXButton *dogButton1;
@property( nonatomic, strong) JXButton *dogButton2;
@property( nonatomic, strong) JXButton *dogButton3;
@property (nonatomic, strong)   NSString *strTracid1;

@property (strong, nonatomic) NSMutableArray *playSaveDataArray;
@property (nonatomic, strong)   NSString *strTracid;
@property (nonatomic, strong)   NSString *strTrackListid;

@property (nonatomic, strong) QplayType *qPlayType;
@property (nonatomic, strong) QCustomData *qCustomData;

@property (nonatomic, strong) QAlbumDataTrackList *currentPlaySong;
@end

@implementation QCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //self.title = @"名称";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.playSaveDataArray = [NSMutableArray array];
    
    [self LoadChlidView];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"DemandHistory" object:self_c userInfo:jsonDict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QCustomPlayStaus:) name:@"QCustomPlayStaus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QCustomPlayNext:) name:@"QCustomPlayNext" object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QCustomPlayON:) name:@"QCustomPlayON" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //[self GetPlayingTrackId];//获取当前播放歌曲
    
    // Islocal = NO;
    
    
}


////机器开机发送的通知
//- (void)QCustomPlayON:(NSNotification *)noti
//{
//    
//    IsPlaying =NO;
//    
//}

- (void)autoRefreshing
{
    
//    [self GetPlayingTrackId];//获取当前播放歌曲
    
    [self performSelector:@selector(GetPlayingTrackId) withObject:nil afterDelay:1.0];
    
}


- (void)GetPlayingTrackId
{
    NSString *deviceIdStr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if (deviceIdStr.length == 0) {
        
        [self showToastWithString:@"您还没有绑定设备"];
        return;
    }
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [self startLoading];
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            
            if (trackdata.tracks.count > 0) {
                
                QPlayingTrackList *listdata = trackdata.tracks[0];
                self.currentPlaySong = trackdata.tracks[0];
                self.strTrackListid =  listdata.trackListId;
                self.strTracid1 =  [listdata.trackId stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
    
                titelLabel.text = listdata.trackName;
                timeLabel.text  =  [self getMMSSFromSS:listdata.duration];
                
                NSLog(@"[listdata.isCollected intValue];====%d",[listdata.isCollected intValue]);
                
                self.dogButton.selected = [listdata.isCollected intValue];
                self.dogButton1.selected = [ listdata.isAddToSongList intValue];
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                
                [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
                [[TMCache sharedCache]setObject:resultRespone.trackIcon forKey:@"currentTrackIcon"];

                
            }
            
            
            [[TMCache sharedCache]setObject:trackdata.mode forKey:@"PlayMode"];
            
            [self getCurrentPlayingTracksId];//获取播放播放列表
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        
//        else if([respone.statusCode isEqualToString:@"6608"])
//        {
//
//            [[HomeViewController getInstance] offDeviceStaues];
//
//
//        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
    }];
}


#pragma mark --获取当前播放歌曲列表
-(void)getCurrentPlayingTracksId{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"orderBy" :@"0"};
    
    [BBTCustomViewRequestTool getCurrentPlayingTracksParameter:parameter success:^(QCustom *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.playSaveDataArray = respone.data.tracks;
            
            self.qPlayType = respone.data.playType;
            self.qCustomData= respone.data;
            
            if (self.playSaveDataArray.count>0) {
                
                for (int i=0; i<self.playSaveDataArray.count; i++) {
                    
                    
                    QAlbumDataTrackList *respone = self.playSaveDataArray[i];
                    
                    if ([respone.trackId isEqualToString:self.strTracid1]) {
                       
                         self.currentPlaySong = respone;
                        
                        palyIndex =i;
                        titelLabel.text = respone.trackName;
                        timeLabel.text  =  [self getMMSSFromSS:respone.duration];
                        self.dogButton.selected = [respone.isCollected intValue];
                        self.dogButton1.selected = [ respone.isAddToSongList intValue];
                        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)respone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                        
                        
                        [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
                          [[TMCache sharedCache]setObject:resultRespone.trackIcon forKey:@"currentTrackIcon"];
                        break;
                    }
                }
            }
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
//        else if([respone.statusCode isEqualToString:@"6608"])
//        {
//
//
//            [[HomeViewController getInstance] offDeviceStaues];
//
//
//        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}



//机器暂停和播放发送的通知
- (void)QCustomPlayStaus:(NSNotification *)noti
{
    


    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    if ([strtest isEqualToString:@"playing"]) {
        

        
        IsPlaying = YES;
        playBtn.selected = YES;
        [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        

        
    }else if ([strtest isEqualToString:@"pause"]){
   
         if ( self.playSaveDataArray.count>0){
              resultRespone= self.playSaveDataArray[palyIndex];
           }
        resultRespone.isPlaying = NO;
        playBtn.selected = NO;
        [self.pageImageView.layer removeAnimationForKey:@"rotationAnimation"];
             
        
    }
    
    
    
}


//上一曲下一曲播放的通知

- (void)QCustomPlayNext:(NSNotification *)noti
{
    
    
    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"trackId"]];
    
    NSString *strtest1 = [strtest stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([strtest1 isEqualToString:@"local"]) {
       
        NSLog(@"播放界面播放本地歌曲");
        
       
        [[TMCache sharedCache] setObject:@"Islocal" forKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]];
        
    
        titelLabel.text = @"歌曲名称";
        timeLabel.text  =  @"";

        //playBtn.selected = NO;
        self.dogButton.selected =NO;
        self.dogButton1.selected = NO;
       
       //[self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
        self.pageImageView.image = [UIImage imageNamed:@"img-tu"];
         
        [self.pageImageView .layer removeAnimationForKey:@"rotationAnimation"];
        
        [[TMCache sharedCache]setObject:@"img-tu" forKey:@"currentTrackIcon"];

    
        
     
    }else{
        
           // Islocal =NO;
    
            [[TMCache sharedCache] setObject:@"IsOnline" forKey:@"Iflocal"];
  
            
            NSLog(@"strtest1====%@",strtest1);
            
            
            self.strTracid1 = strtest1;
            
            
            //NSLog(@"strtest1===%@",strtest1);
            NSString * exist = @"NO";
            if (self.playSaveDataArray.count>0) {
                
                for (int i=0; i<self.playSaveDataArray.count; i++) {
                    
                    
                    QAlbumDataTrackList *respone = self.playSaveDataArray[i];
                   // NSLog(@"respone-trackId===%@",respone.trackId);
                    if ([respone.trackId isEqualToString:strtest1] ) {
                        self.currentPlaySong = respone;
                        palyIndex =i;
                        exist = @"YES";
                        break;
                    }else{
                        
                       
                    }
                }
            }
            
            
            
            if ([exist isEqualToString:@"YES"]) {
                
                
                NSLog(@"palyIndex111======%ld",(long)palyIndex);
                    if (self.playSaveDataArray.count>0) {
                            resultRespone= self.playSaveDataArray[palyIndex];
                            resultRespone.isPlaying = YES;
                         
                            [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                            self.strTrackListid =resultRespone.trackListId;
                            
                            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resultRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                            
                        
                            [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
                            
                            [[TMCache sharedCache]setObject:resultRespone.trackIcon forKey:@"currentTrackIcon"];
                            
                            if (!IsStrEmpty(resultRespone.trackName)) {
                                
                                
                                NSLog(@"resultRespone.trackName111=====%@",resultRespone.trackName);
                            
                                titelLabel.text = resultRespone.trackName;
                                timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
                                
                                NSLog(@"resultRespone.isCollected22=====%@", resultRespone.isCollected);
                                self.dogButton.selected = [resultRespone.isCollected intValue];
                                self.dogButton1.selected = [ resultRespone.isAddToSongList intValue];
                                
                            }else{
                                
                                titelLabel.text =@"歌曲名称";
                                timeLabel.text  = @" " ;
                            }
                
                    }
                
            }else{
                /**如果当前播发歌曲不再歌曲列表里面 就重新获取数据**/
                [self GetPlayingTrackId];
                //[self getCurrentPlayingTracksId];//获取播放播放列表
            }
        
    }
}

- (void)LoadChlidView
{

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    bgImageView.image = [UIImage imageNamed:@"BG_sjbfq"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    //适配iphone x
    CGFloat myheight;
    if (kDevice_Is_iPhoneX==34) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26+myheight, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_nor"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_sel"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backBtn];
    //适配iphone x
    titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 34+myheight, kDeviceWidth - 150 , 17)];
    
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.font = [UIFont boldSystemFontOfSize:19.0];
    titelLabel.text = @"歌曲名称";
    
    [bgImageView addSubview:titelLabel];
    
    
    
    //适配ipad；
    
    CGFloat pageImageY;
    
    if ([IphoneType IFChangeCoordinates]) {
        
        pageImageY = 100;
        
    }else{
        
        pageImageY = 180;
    }

    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - pageImageY) / 2.0,CGRectGetMaxY(titelLabel.frame) + 70, pageImageY, pageImageY)];
    pageImageView.image = [UIImage imageNamed:@"img-tu"];
    
    [pageImageView.layer setCornerRadius:(pageImageView.frame.size.height/2)];
    [pageImageView.layer setMasksToBounds:YES];
   // pageImageView.layer.borderWidth = 5.0f;
   // pageImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [pageImageView setContentMode:UIViewContentModeScaleAspectFill];
    [pageImageView setClipsToBounds:YES];
    
     NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [self.pageImageView setImageWithURL:[NSURL URLWithString: encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
    
    
    
    [bgImageView addSubview:pageImageView];
    
    self.pageImageView = pageImageView;
    
    
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
    
    rotationAnimation.duration = 1;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = ULLONG_MAX;
    
    timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageImageView.frame) + 25, kDeviceWidth, 12)];
    //timeLabel.text = @"00:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    
    [bgImageView addSubview:timeLabel];
    
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(timeLabel.frame)  + 50,self.view.frame.size.width-40/568.0*KDeviceHeight,60/568.0*KDeviceHeight)];
    containView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:containView];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"icon_sc_nor",@"icon_tj02_nor",@"icon_lb02_nor",@"icon_zj02_nor", nil];
    NSArray *imageArraysel = [NSArray arrayWithObjects:@"icon_sc_sel",@"icon_tjdemand_sel",@"icon_lb02_sel",@"icon_zj02_sel", nil];
    NSArray *titleName = [NSArray arrayWithObjects:@"收藏",@"添加",@"列表",@"专辑", nil];
    
    
    CGRect rect = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(0%4), (40/568.0*KDeviceHeight*(0/4)+0.5)+(0/4)*0.5, (self.view.frame.size.width-40)/4,40/568.0*KDeviceHeight);
    
    //1、从代码创建
    self.dogButton = [[JXButton alloc] initWithFrame:rect];
    [self.dogButton setTitle:titleName[0] forState:UIControlStateNormal];
    [self.dogButton setTitle:titleName[0] forState:UIControlStateSelected];
    
    [self.dogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dogButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    [self.dogButton setImage:[UIImage imageNamed:imageArray[0]] forState:UIControlStateNormal];
    [self.dogButton setImage:[UIImage imageNamed:imageArraysel[0]] forState:UIControlStateSelected];
    
    self.dogButton.tag = 100;
    [self.dogButton addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:self.dogButton];
    
    CGRect rect1 = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(1%4), (40/568.0*KDeviceHeight*(1/4)+0.5)+(1/4)*0.5, (self.view.frame.size.width-40)/4,40/568.0*KDeviceHeight);
    //1、从代码创建
    self.dogButton1 = [[JXButton alloc] initWithFrame:rect1];
    [self.dogButton1 setTitle:titleName[1] forState:UIControlStateNormal];
    [self.dogButton1 setTitle:titleName[1] forState:UIControlStateSelected];
    
    [self.dogButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dogButton1 setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    [self.dogButton1 setImage:[UIImage imageNamed:imageArray[1]] forState:UIControlStateNormal];
    [self.dogButton1 setImage:[UIImage imageNamed:imageArraysel[1]] forState:UIControlStateSelected];
    
    self.dogButton1.tag = 101;
    [self.dogButton1 addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:self.dogButton1];
    
    CGRect rect2 = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(2%4), (40/568.0*KDeviceHeight*(2/4)+0.5)+(2/4)*0.5, (self.view.frame.size.width-40)/4,40/568.0*KDeviceHeight);
    
    //1、从代码创建
    
    self.dogButton2 = [[JXButton alloc] initWithFrame:rect2];
    [ self.dogButton2  setTitle:titleName[2] forState:UIControlStateNormal];
    [self.dogButton2 setTitle:titleName[2] forState:UIControlStateHighlighted];
    
    [ self.dogButton2  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ self.dogButton2  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [ self.dogButton2  setImage:[UIImage imageNamed:imageArray[2]] forState:UIControlStateNormal];
    [ self.dogButton2  setImage:[UIImage imageNamed:imageArraysel[2]] forState:UIControlStateHighlighted];
    
    self.dogButton2.tag = 102;
    [self.dogButton2 addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview: self.dogButton2 ];
    
    CGRect rect3 = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(3%4), (40/568.0*KDeviceHeight*(3/4)+0.5)+(3/4)*0.5, (self.view.frame.size.width-40)/4,40/568.0*KDeviceHeight);
    
    //1、从代码创建
    self.dogButton3 = [[JXButton alloc] initWithFrame:rect3];
    [ self.dogButton3 setTitle:titleName[3] forState:UIControlStateNormal];
    [self.dogButton3 setTitle:titleName[3] forState:UIControlStateHighlighted];
    
    [ self.dogButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ self.dogButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    [ self.dogButton3 setImage:[UIImage imageNamed:imageArray[3]] forState:UIControlStateNormal];
    [ self.dogButton3 setImage:[UIImage imageNamed:imageArraysel[3]] forState:UIControlStateHighlighted];
    
    self.dogButton3.tag = 103;
    [self.dogButton3 addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview: self.dogButton3];
    
    
    
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
    
    //NSLog(@"%ld",(long)btn.tag);
    
    
    
    switch (btn.tag) {
            
        case 100:
            
            [self collectBtnClick];
            
            break;
        case 101:
            
            [self addPlayListView];
            
            break;
            
        case 102:
            
           // NSLog(@"列表");
            
            [self list];
            
            break;
            
        case 103:
            
            //NSLog(@"专辑");
      
            if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]]isEqualToString:@"Islocal"]) {
                
                [self showToastWithString:@"播放的是本地资源!"];
                
            
            }else{
            
            [[AppDelegate appDelegate]suspendButtonHidden:YES];
            //[self.navigationController pushViewController:[QAlbumViewController new] animated:YES];
            
            [self gotoQAlbumView];
                
            }
            
            break;
        default:
            break;
    }
    
}


-(void)gotoQAlbumView{
    
    QAlbumPlayViewController  *QAlbumVC = [[QAlbumPlayViewController alloc] init];
    //NSLog(@"resultRespone.trackListId====%@",resultRespone.trackListId);
    
    if(self.strTrackListid.length == 0)
    {
        [self showToastWithString:@"还没有专辑哦"];
        return;
    }
    
    QAlbumVC.trackListId = self.strTrackListid;
    
    [self.navigationController pushViewController:QAlbumVC animated:YES];
}

-(void)collectBtnClick{
    

    
    if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]]isEqualToString:@"Islocal"]) {
        
        [self showToastWithString:@"播放的是本地资源，不支持收藏!"];
        
        return;
    }
    
    
    
    if (IsStrEmpty( self.currentPlaySong.trackId)) {
        
         [self showToastWithString:@"没有歌曲可收藏哦!"];
        
         return;
    }
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : self.currentPlaySong.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    if ([self.currentPlaySong.isCollected intValue]==0) {
        
        
        [self startLoading];
        
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"收藏成功"];
                
                self.currentPlaySong.isCollected = @"1";
                
                self.dogButton.selected = YES;
                
            }else if([response.statusCode isEqualToString:@"3705"])
            {
                
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                
                
            }
            
            else if([response.statusCode isEqualToString:@"6500"])
            {
                
                self.currentPlaySong.isCollected = @"1";
                self.dogButton.selected = YES;
                [self showToastWithString:response.message];
                
            }
            
            else{
                
                
                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
        }];
        
        
    }else{
        
        
        [self startLoading];
        [QHomeRequestTool CancelFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"取消收藏成功"];
                
                self.dogButton.selected = NO;
                self.currentPlaySong.isCollected = @"0";
            }else if([response.statusCode isEqualToString:@"3705"])
            {
                
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                
                
            }else if([response.statusCode isEqualToString:@"6501"])
            {
                
                self.currentPlaySong.isCollected = @"0";
                self.dogButton.selected = NO;
                [self showToastWithString:response.message];
                
            }else{
                
                
                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
        }];
        
        
    }
    
    
}


-(void)addPlayListView{
    
    
    if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]]isEqualToString:@"Islocal"]) {
        
        [self showToastWithString:@"播放的是本地资源，不支持添加!"];
        
        return;
    }
    
    
//    if (self.playSaveDataArray.count==0) {
//
//
//        [self showToastWithString:@"没有歌曲可添加哦!"];
//
//        return;
//    }
//
    
    if (IsStrEmpty( self.currentPlaySong.trackId)) {
        
        [self showToastWithString:@"没有歌曲可收藏哦!"];
        
        return;
    }
    
    if ([self.currentPlaySong.isAddToSongList intValue]==1) {

        return;
    }
    
//     if ( self.playSaveDataArray.count>0){
//
//        resultRespone = self.playSaveDataArray[palyIndex];
//
//     }
//
//    if ([resultRespone.isAddToSongList intValue]==1) {
//
//
//        return;
//    }
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    tfSheetView.albumPlaystr = @"albumPlaystr";
    [tfSheetView showInView:self.view];
    
    
}




#pragma mark -- QPlayListViewDelegate
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model
{
    
    [self addPlayListsectionIndex:palyIndex selectModel:model];
    
}


- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
   
    
//    resultRespone = self.playSaveDataArray[sectionIndex];
    
    
    
    
//    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : resultRespone.trackId};
    
     NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : self.currentPlaySong.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"添加成功"];
            
            // [self GetRTrackLists];
            
            self.dogButton1.selected = YES;
            resultRespone.isAddToSongList = @"1";
            self.currentPlaySong.isAddToSongList = @"1";
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
}



-(void)list{
    
    
 
     NSLog(@"local======%@ deviceId=====%@",[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]],[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]]isEqualToString:@"Islocal"]) {
        
        [self showToastWithString:@"播放的是本地资源!"];
        
        return;
    }
    
    
    if ( self.playSaveDataArray.count==0) {
        
        
        [self showToastWithString:@"还没有歌曲哦!"];
        
        
    }else{
        
       // NSMutableArray *daoxuArray = [[NSMutableArray alloc]init];
        
//        if ([[[TMCache sharedCache]objectForKey:@"orderBy"]isEqualToString:@"1"]) {
//            
//           // NSLog(@"倒序");
//            
//            daoxuArray= (NSMutableArray *)[[self.playSaveDataArray reverseObjectEnumerator] allObjects];
//            
//        }else{
//        
//            daoxuArray = self.playSaveDataArray;
//        }
        
        
        GYZActionSheet *actionSheet = [[GYZActionSheet alloc] initSheetStyle:GYZSheetStyleDefault playStyle:CyclePlayStyle  SortStyle:OrderStyle itemTitles: self.playSaveDataArray];
        
        actionSheet.titleTextFont = [UIFont systemFontOfSize:18];
        actionSheet.itemTextFont = [UIFont systemFontOfSize:16];
        actionSheet.cancleTextFont = [UIFont systemFontOfSize:16];
        actionSheet.titleTextColor = [UIColor whiteColor];
        actionSheet.itemTextColor =  [UIColor grayColor];//[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
        actionSheet.cancleTextColor = [UIColor grayColor]; //[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
        actionSheet.zActionDelegate = self;
        __weak typeof(self) weakSelf = self;
        [actionSheet didFinishSelectIndex:^(NSInteger index, QAlbumDataTrackList *respone,QplayType*qPlayType, QCustomData*qCustomData) {
            
            self.currentPlaySong = respone;
            titelLabel.text = respone.trackName;
            timeLabel.text  =  [weakSelf getMMSSFromSS:respone.duration];
              NSLog(@"resultRespone.trackName222=====%@",resultRespone.trackName);
            [[TMCache sharedCache]setObject:respone.trackIcon forKey:@"currentTrackIcon"];
            
            if (!IsStrEmpty(qPlayType.value)) {
                  self.qPlayType = qPlayType;
            }
            if (!IsStrEmpty(qCustomData.listId)) {
                self.qCustomData = qCustomData;
            }
          
 
            self.dogButton.selected = [respone.isCollected intValue];
            self.dogButton1.selected = [ respone.isAddToSongList intValue];
            
            if (palyIndex ==index) {
                
                palyIndex =index;
                
                if (IsPlaying) {
                    
                    
                    IsPlaying = NO;
                    
                    playBtn.selected = NO;
//
//                    NSDictionary *dic = @{@"cmd" : @"pause"};
//
//
//                    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                    
                    [self PutDevicesControlMQTT:@"3" ValueStr:@""];
                    
                    
                }else
                {
                    
                    
                    IsPlaying = YES;
                    
                    playBtn.selected = YES;
                    
//                    NSDictionary *dic = @{@"cmd" : @"resume"};
//
//
//
//                    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                    
                     [self PutDevicesControlMQTT:@"4" ValueStr:@""];
                    
                    
                }
                
                
                
                
                
                // return;
            }else{
                
                
                palyIndex =index;
                
                 if ( self.playSaveDataArray.count>0){
                    QAlbumDataTrackList *listRespone = self.playSaveDataArray[palyIndex];
                
                  self.strTrackListid =listRespone.trackListId;
                [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
                //  [self AddDemandListtrackListId:listRespone.trackListId TrackId:listRespone.trackId];
                
//                
//                if ([self.qPlayType.value isEqualToString:@"3"]) {
//                    
//                    // 点播专辑
//                    
//                    [self AddDemandListtrackListId: self.qCustomData.listId  TrackId:listRespone.trackId];
//                    
//                    
//                }else if ([self.qPlayType.value isEqualToString:@"4"]){
//                    
//                    // 点播歌单
//                    
//                    [self AddDemandListSongListId:self.qCustomData.listId  TrackId:listRespone.trackId];
//                    
//                    
//                }else if ([self.qPlayType.value isEqualToString:@"5"]){
//                    
//                    // 点播标签
//                    
//                    [self AddDemandListTagId:self.qCustomData.listId TrackId:listRespone.trackId];
//                    
//                }else if ([self.qPlayType.value isEqualToString:@"6"]){
//                    
//                    // 点播历史
//                    
//                    [self AddDemandListTrackId:listRespone.trackId];
//                    
//                    
//                }else if ([self.qPlayType.value isEqualToString:@"7"]){
//                    
//                    // 点播最爱
//                    
//                    [self AddDemandListFavoriteTrackId:listRespone.trackId];
//                }
                
                
                   [self PutCurrentDemandPlaySwitchTrackId:listRespone.trackId ListId:self.qCustomData.listId Type:self.qPlayType.value];
                
                IsPlaying = YES;
                
                playBtn.selected = YES;
                [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
               
                
                  NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                
                [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage: [UIImage imageNamed:@"img-tu"]];
         
                  [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
                
                 }
            }
            
        }];
        
        
    }
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

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
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
    
    button.selected =  !button.selected;
    
//    if ( self.playSaveDataArray.count==0) {
//        
//        [self showToastWithString:@"还没有歌曲哦!"];
//        
//        return;
//        
//    }
    if (button.selected) {
        
       // NSLog(@"播放");
        
        NSLog(@"palyIndex222=====%ld",(long)palyIndex);
        
     
        
        if (IsPlaying) {
            
            
          //  NSLog(@"播放");
            
//            NSDictionary *dic = @{@"cmd" : @"resume"};
//
//            [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
            
             [self PutDevicesControlMQTT:@"4" ValueStr:@""];
            
            
        }else{
            
            
            
            if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]]isEqualToString:@"Islocal"]) {
                
//                NSDictionary *dic = @{@"cmd" : @"resume"};
//
//                [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                
                 [self PutDevicesControlMQTT:@"4" ValueStr:@""];
                
            }else{

            
           NSLog(@"第一次播放");
            
            if (self.playSaveDataArray.count>0){
            QAlbumDataTrackList *listRespone = self.playSaveDataArray[palyIndex];
            

            
            [self PutCurrentDemandPlaySwitchTrackId:listRespone.trackId ListId:self.qCustomData.listId Type:self.qPlayType.value];
            }
                
        }
            
        }
        
        
        

        
    }else{
        
        
        //NSLog(@"暂停");
        
        // [self.playerView playButtonAction:button];
        
//        NSDictionary *dic = @{@"cmd" : @"pause"};
//
//        [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
        
         [self PutDevicesControlMQTT:@"3" ValueStr:@""];

    }
    
}




// 专辑点播
- (void)AddDemandListtrackListId:(NSString *)trackListId TrackId:(NSString *)trackid
{
    //    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackListId" :trackListId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [QMineRequestTool PostDemandTrackLists:parameter success:^(QSongDevicePlayData *respone) {
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}


// 点播历史点播

- (void)AddDemandListTrackId:(NSString *)trackid
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"], @"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [QHomeRequestTool PostDemandPlayHistory:parameter success:^(QSongDetails *respone) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

//宝贝歌单点播
- (void)AddDemandListSongListId:(NSString *)songListId TrackId:(NSString *)trackid
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"songListId" :songListId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [QMineRequestTool PostDemandTracks:parameter success:^(QSongDetails *respone) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

//宝贝最爱点播
- (void)AddDemandListFavoriteTrackId:(NSString *)trackid
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"], @"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    [QHomeRequestTool PostDemanddeviceFavorite:parameter success:^(QSongDetails *respone) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

//类别
- (void)AddDemandListTagId:(NSString *)tagId TrackId:(NSString *)trackid
{
    //    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"tagId" :tagId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [QCategoryRequestTool PostDemandSourceTags:parameter success:^(QSongDetails *respone) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
//当前播放列表切换歌曲
-(void)PutCurrentDemandPlaySwitchTrackId:(NSString *)trackid ListId:(NSString *)listId Type:(NSString *)type{

    if (IsStrEmpty(trackid)) {
        trackid= @" ";
    }
    if (IsStrEmpty(listId)) {
        listId= @" ";
    } if (IsStrEmpty(type)) {
        type= @" ";
    }
    
     NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"], @"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"trackId" : trackid , @"listId" :listId,@"type" : type};
    
    [QHomeRequestTool PutCurrentDemandPlaySwitchParameter:parameter success:^(QSongDetails *respone) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)preBtnClick:(id)sender
{
    
//    NSDictionary *dic = @{@"cmd" : @"backward"};
//
//    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    
    [self PutDevicesControlMQTT:@"2" ValueStr:@""];
    
   
    IsPlaying = YES;
    
    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];

}

- (void)nextBtnClick:(id)sender

{
//
//    NSDictionary *dic = @{@"cmd" : @"forward"};
//
//
//    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    
    [self PutDevicesControlMQTT:@"1" ValueStr:@""];
    
    IsPlaying = YES;
    
    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
    if ([[[TMCache sharedCache]objectForKey:@"buttonAnimation"] isEqualToString:@"addAnimation"]){
        

        [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }else{
        
        [self.pageImageView .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
     [self GetPlayingTrackId];//获取当前播放歌曲
}




- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // [self.playerView pause];//暂停播放
    
    
    
    
}


@end


