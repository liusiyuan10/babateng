//
//  QCustomViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BPlayTestViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Header.h"

#import "MyButton.h"

#import "QPlayListView.h"

#import "BPlayActionSheet.h"

#import "QAlbumViewController.h"
//#import "QDemandResultRespone.h"
#import "QAlbumDataTrackList.h"
#import "MusicPlayerView.h"

#import "UIImageView+AFNetworking.h"

#import "BAlbumPlayViewController.h"

#import "QHomeRequestTool.h"

#import "QAddSong.h"

#import "JXButton.h"

#import "QSongDataList.h"


@interface BPlayTestViewController ()<BPlayActionSheetDelegate,MusicPlayerViewDelegate,QPlayListViewDelegate>
{

    UIButton *playBtn;
    UIButton *preBtn;
    UIButton *nextBtn;
    UILabel *titelLabel;
    NSInteger palyIndex;
    AppDelegate *appDelegate;
    CABasicAnimation* rotationAnimation;

    QAlbumDataTrackList *resultRespone;
    
    BOOL  IsPlaying;
    
//    BOOL  IsBPlaying;
    
    UIImageView *bgImageView;
    
    
}

@property( nonatomic, strong) JXButton *dogButton;
@property( nonatomic, strong) JXButton *dogButton1;
@property( nonatomic, strong) JXButton *dogButton2;
@property( nonatomic, strong) JXButton *dogButton3;

@property( nonatomic, strong) UIImageView *pageImageView;

//@property(strong,nonatomic) AVPlayer *player;
@property (nonatomic, strong) MusicPlayerView *playerView;

@property (nonatomic, strong)   NSString *strTrackListid;

@end

@implementation BPlayTestViewController


static BPlayTestViewController *_instance = nil;

+ (instancetype)sharedInstance {
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
//        [_instance LoadChlidView];
        
//        [_instance LoadPlayerView];
        
        
    });

    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
       [self LoadChlidView];
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self LoadChlidView];
    

//    timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
    
    
}



- (void)LoadChlidView
{
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //允许转成横屏
//    appDelegate.allowRotation = NO;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    palyIndex =0;
    
    NSLog(@"kDeviceWidth11111111111111======%f",kDeviceWidth);
     NSLog(@"KDeviceHeight11111111111111======%f",KDeviceHeight);
     NSLog(@"self.view.frame.size.width11111111111111======%f",self.view.frame.size.width);
    CGFloat wkDeviceWidth = 0;
    CGFloat wKDeviceHeight = 0;
    wkDeviceWidth = kDeviceWidth;
    wKDeviceHeight = KDeviceHeight;
    
    if (kDeviceWidth == 667) {
        wkDeviceWidth = 375.0;
    }
    if (KDeviceHeight == 375) {
        wKDeviceHeight = 667.0;
    }
    
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wkDeviceWidth, wKDeviceHeight)];
    
    bgImageView.image = [UIImage imageNamed:@"BG_sjbfq"];
    bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:bgImageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_nor"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_shouhui_sel"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgImageView addSubview:backBtn];
    
    titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 34, wkDeviceWidth - 150 , 17)];
    
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.font = [UIFont boldSystemFontOfSize:19.0];
    titelLabel.text = @"歌曲名称";
    
    [bgImageView addSubview:titelLabel];
    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake((wkDeviceWidth - 180) / 2.0,CGRectGetMaxY(titelLabel.frame) + 70, 180, 180)];
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
    
    self.playerView = [[MusicPlayerView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(pageImageView.frame) + 25, wkDeviceWidth-40, 12)];
    self.playerView.musicPlayerDelegate = self;
    // [self.playerView setUp:model];
    [bgImageView addSubview:self.playerView];
    


    
    
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(self.playerView.frame)  + 50,wkDeviceWidth-40/568.0*wKDeviceHeight,60/568.0*wKDeviceHeight)];
    containView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:containView];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"icon_sc_nor",@"icon_tj02_nor",@"icon_lb02_nor",@"icon_zj02_nor", nil];
    NSArray *imageArraysel = [NSArray arrayWithObjects:@"icon_sc_sel",@"icon_tjdemand_sel",@"icon_lb02_sel",@"icon_zj02_sel", nil];
    NSArray *titleName = [NSArray arrayWithObjects:@"收藏",@"添加",@"列表",@"专辑", nil];
    
    CGRect rect = CGRectMake((((wkDeviceWidth-40/568.0*wKDeviceHeight)/4)+0.5)*(0%4), (40/568.0*wKDeviceHeight*(0/4)+0.5)+(0/4)*0.5, (wkDeviceWidth-40)/4,40/568.0*wKDeviceHeight);
    
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
    
    CGRect rect1 = CGRectMake((((wkDeviceWidth-40/568.0*wKDeviceHeight)/4)+0.5)*(1%4), (40/568.0*wKDeviceHeight*(1/4)+0.5)+(1/4)*0.5, (wkDeviceWidth-40)/4,40/568.0*wKDeviceHeight);
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
    
    CGRect rect2 = CGRectMake((((wkDeviceWidth-40/568.0*wKDeviceHeight)/4)+0.5)*(2%4), (40/568.0*wKDeviceHeight*(2/4)+0.5)+(2/4)*0.5, (wkDeviceWidth-40)/4,40/568.0*wKDeviceHeight);
    
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
    
    CGRect rect3 = CGRectMake((((wkDeviceWidth-40/568.0*wKDeviceHeight)/4)+0.5)*(3%4), (40/568.0*wKDeviceHeight*(3/4)+0.5)+(3/4)*0.5, (wkDeviceWidth-40)/4,40/568.0*wKDeviceHeight);
    
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
    
    
    
//    NSLog(@"KDeviceHeight==%f",KDeviceHeight);
//    for(int i=0;i<4;i++)
//    {
//
//        CGRect rect = CGRectMake((((self.view.frame.size.width-40/568.0*KDeviceHeight)/4)+0.5)*(i%4), (60/568.0*KDeviceHeight*(i/4)+0.5)+(i/4)*0.5, (self.view.frame.size.width-40)/4,60/568.0*KDeviceHeight);
//
//
//        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage:imageArray[i] title:titleName[i]  frame:rect type:@"no"];
//        btn.backgroundColor = [UIColor clearColor];
//        [btn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        btn.tag = i+100;
//        [containView addSubview:btn];
//    }
    
    CGFloat playBtnY = wKDeviceHeight - 110 /667.0 *wKDeviceHeight;
    
    playBtn = [[UIButton alloc] initWithFrame:CGRectMake((wkDeviceWidth - 78)/2, playBtnY - 10, 78, 78)];
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_nor"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgImageView addSubview:playBtn];
    
    preBtn = [[UIButton alloc] initWithFrame:CGRectMake((wkDeviceWidth - 78)/2 - 25 - 58, playBtnY, 58, 58)];
    [preBtn setImage:[UIImage imageNamed:@"btn_shanyishou_nor"] forState:UIControlStateNormal];
    [preBtn setImage:[UIImage imageNamed:@"btn_shanyishou_pre"] forState:UIControlStateHighlighted];
    [preBtn addTarget:self action:@selector(preBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:preBtn];
    
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((wkDeviceWidth - 78)/2 + 25 + 78, playBtnY, 58, 58)];
    [nextBtn setImage:[UIImage imageNamed:@"btn_xiayishou_nor"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"btn_xiayishou_pre"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:nextBtn];
    

}



- (void)testPlay:(NSInteger)Index
{

//    IsPlaying = NO;
//    playBtn.selected = NO;
    
//    palyIndex = Index;
//    [playBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    palyIndex = Index;

    NSLog(@"testPlaypalyIndex======%ld",(long)palyIndex);
    
    
    for (int i=0; i< appDelegate.playSaveDataArray.count; i++) {
        
        resultRespone= appDelegate.playSaveDataArray[i];
        resultRespone.isPlaying = NO;
    }

    resultRespone= appDelegate.playSaveDataArray[Index];
    resultRespone.isPlaying = YES;

    
    self.strTrackListid = resultRespone.trackListId;

    self.IsBPlaying = YES;


    if (IsPlaying) {


        VedioModel *model = [[VedioModel alloc]init];
        model.musicURL = resultRespone.playUrl;
        [self.playerView changeMusic:model];
        IsPlaying = YES;

    }else{

        [self playMusic:resultRespone];
    }

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resultRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"img-tu"]];

    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    if (!IsStrEmpty(resultRespone.trackName)) {

        titelLabel.text = resultRespone.trackName;
        // timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
    }else{

        titelLabel.text =@"无数据";
        //timeLabel.text  = @"00:00" ;//[weakSelf getMMSSFromSS:respone.duration];
    }

    playBtn.selected = YES;
    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    
  
}

- (void)testPasue
{
//    [self.playerView pause];
    
    [playBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)detailBtnClick:(UIButton*)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    NSLog(@"%ld",(long)btn.tag);
    
    
    
    switch (btn.tag) {
            
        case 100:
            
             [self collectBtnClick];
//            [self showToastWithString:@"你想收藏啥!"];
            break;
        case 101:
            
            [self addPlayListView];
//            [self showToastWithString:@"你想添加啥!"];
            break;
            
        case 102:
            
            NSLog(@"列表");
            
            [self list];
            
            break;
            
        case 103:
            
            NSLog(@"专辑");
            
//            [[AppDelegate appDelegate]suspendButtonHidden:NO];
            [[AppDelegate appDelegate]suspendButtonHidden:YES];
//            [self.navigationController pushViewController:[QAlbumViewController new] animated:YES];
            [self gotoQAlbumView];
            break;
        default:
            break;
    }
    
}

-(void)collectBtnClick{
    

    
    if (IsStrEmpty(resultRespone.trackId)) {
        
        [self showToastWithString:@"没有歌曲可收藏哦!"];
        
        return;
    }
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : resultRespone.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    if ([resultRespone.isCollected intValue]==0) {
        
        
        [self startLoading];
        
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"收藏成功"];
                
                resultRespone.isCollected = @"1";
                
                self.dogButton.selected = YES;
                
            }
//            else if([response.statusCode isEqualToString:@"3705"])
//            {
//
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//            }
//
//            else if([response.statusCode isEqualToString:@"6500"])
//            {
//
//                self.currentPlaySong.isCollected = @"1";
//                self.dogButton.selected = YES;
//                [self showToastWithString:response.message];
//
//            }
            
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
                resultRespone.isCollected = @"0";
            }
//            else if([response.statusCode isEqualToString:@"3705"])
//            {
//
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//            }else if([response.statusCode isEqualToString:@"6501"])
//            {
//
//                self.currentPlaySong.isCollected = @"0";
//                self.dogButton.selected = NO;
//                [self showToastWithString:response.message];
//
//            }
            else{
                
                
                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
        }];
        
        
    }
    
    
}


-(void)addPlayListView{

    
//    if (appDelegate.playSaveDataArray.count==0) {
//
//
//        [self showToastWithString:@"没有歌曲可添加哦!"];
//
//        return;
//    }
    
    
    
    if (IsStrEmpty(resultRespone.trackId)) {


        [self showToastWithString:@"没有歌曲可添加哦!"];

        return;
    }
    
//    if ( appDelegate.playSaveDataArray.count>0){
//
//        resultRespone = self.playSaveDataArray[palyIndex];
//
//    }
    
    
    if ([resultRespone.isAddToSongList intValue]==1) {
        
        
        return;
    }
    
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
    
    
    
    resultRespone = appDelegate.playSaveDataArray[sectionIndex];
    
    
    
    
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : resultRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"添加成功"];
            
            // [self GetRTrackLists];
            
            self.dogButton1.selected = YES;
            resultRespone.isAddToSongList = @"1";
            
            
        }
//        else if([response.statusCode isEqualToString:@"3705"])
//        {
//
//            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//        }
        else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
}




-(void)gotoQAlbumView{
    
    BAlbumPlayViewController  *QAlbumVC = [[BAlbumPlayViewController alloc] init];
    //NSLog(@"resultRespone.trackListId====%@",resultRespone.trackListId);
    
    if(self.strTrackListid.length == 0)
    {
        [self showToastWithString:@"还没有专辑哦"];
        return;
    }
    
    QAlbumVC.trackListId = self.strTrackListid;
    
    [self.navigationController pushViewController:QAlbumVC animated:YES];
}


-(void)list{
    
    if ( appDelegate.playSaveDataArray.count==0) {

        [self showToastWithString:@"还没有添加歌曲哦!"];

    }else{

        BPlayActionSheet *actionSheet = [[BPlayActionSheet alloc] initSheetStyle:BPlaySheetStyleDefault playStyle:OrderPlayStyle  SortStyle:OrderStyle itemTitles: appDelegate.playSaveDataArray];

        actionSheet.titleTextFont = [UIFont systemFontOfSize:18];
        actionSheet.itemTextFont = [UIFont systemFontOfSize:16];
        actionSheet.cancleTextFont = [UIFont systemFontOfSize:16];
        actionSheet.titleTextColor = [UIColor whiteColor];
        actionSheet.itemTextColor =  [UIColor grayColor];//[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
        actionSheet.cancleTextColor = [UIColor grayColor]; //[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
        actionSheet.zActionDelegate = self;
        

        

        
        [actionSheet didFinishSelectIndex:^(NSInteger index, QAlbumDataTrackList *respone) {
            titelLabel.text = respone.trackName;

            if (palyIndex ==index&&IsPlaying) {

                return;
            }
            palyIndex =index;


            if (IsPlaying) {


                VedioModel *model = [[VedioModel alloc]init];
                model.musicURL = respone.playUrl;
                [self.playerView changeMusic:model];
                IsPlaying = YES;

            }else{

                [self playMusic:respone];
            }

            playBtn.selected = YES;
            [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];

        }];


    }
    
    
}


//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
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

- (void)dealloc {

}






- (void)playBtnClick:(UIButton *)button  {
    button.selected =  !button.selected;
//    button.selected = YES;
    NSLog(@"播放1111");
    if (button.selected) {
        
        NSLog(@"播放111");
        resultRespone= appDelegate.playSaveDataArray[palyIndex];
        resultRespone.isPlaying = YES;
        
        self.strTrackListid = resultRespone.trackListId;
        
        [[TMCache sharedCache]setObject:resultRespone.trackIcon forKey:@"currentTrackIcon"];
        
        if (IsPlaying) {
            
            //[self play];
            
            [self.playerView playButtonAction:button];
            
        }else{
            
            [self playMusic:resultRespone];
        }
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resultRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [self.pageImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"img-tu"]];
        
        [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
        
        if (!IsStrEmpty(resultRespone.trackName)) {
            
            titelLabel.text = resultRespone.trackName;
            // timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
        }else{
            
            titelLabel.text =@"无数据";
            //timeLabel.text  = @"00:00" ;//[weakSelf getMMSSFromSS:respone.duration];
        }
        
        self.IsBPlaying = YES;
        
    }else{
        
        
        NSLog(@"暂停");
        
         self.IsBPlaying = NO;
        NSDictionary *jsonDict = @{@"playStatus" : @"pause"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
        
        [self.playerView playButtonAction:button];
        
        resultRespone= appDelegate.playSaveDataArray[palyIndex];
        resultRespone.isPlaying = NO;
        [self.pageImageView.layer removeAnimationForKey:@"rotationAnimation"];
        //[self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
}

- (void)playMusic:(QAlbumDataTrackList*)playerRespone{
    
    //    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:playerRespone.playUrl]]; //在线
    //
    //    [self  play];
    
    NSLog(@"playerRespone.playUrl==%@",playerRespone.playUrl);
    
    VedioModel *model = [[VedioModel alloc]init];
    model.musicURL =playerRespone.playUrl;
    [self.playerView setUp:model];
//    [[MusicPlayerView sharedInstance] setUp:model];
    IsPlaying = YES;
}

//- (void)play
//{
//
//    [self.player play];
//}
//- (void)pause
//{
//    [self.player pause];
//}


-(void)preBtnClick:(id)sender
{
    NSLog(@"上一首");
    
    resultRespone= appDelegate.playSaveDataArray[palyIndex];
    resultRespone.isPlaying = NO;
    self.strTrackListid = resultRespone.trackListId;
    
    palyIndex = palyIndex-1;
    
    if (palyIndex<0) {
        
        resultRespone= appDelegate.playSaveDataArray[0];
        resultRespone.isPlaying = YES;
        
        
    }else{
        
        resultRespone= appDelegate.playSaveDataArray[palyIndex];
        resultRespone.isPlaying = YES;
    }
    
    
    if (palyIndex<0) {
        
        [self showToastWithString:@"已经到第一首了"];
        palyIndex =0;
        return;
    }
    resultRespone = appDelegate.playSaveDataArray[palyIndex];
    
    
    if (!IsStrEmpty(resultRespone.trackName)) {
        
        titelLabel.text = resultRespone.trackName;
        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
    }else{
        
        titelLabel.text =@"无数据";
        // timeLabel.text  = @"00:00";//[self getMMSSFromSS:resultRespone.duration];
    }
    
    // [self playMusic:resultRespone];
    
    VedioModel *model = [[VedioModel alloc]init];
    model.musicURL = resultRespone.playUrl;
    [self.playerView changeMusic:model];
    IsPlaying = YES;
    
    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)nextBtnClick:(id)sender

{
    NSLog(@"下一首");
    
    resultRespone= appDelegate.playSaveDataArray[palyIndex];
    resultRespone.isPlaying = NO;
    
    self.strTrackListid = resultRespone.trackListId;
    palyIndex = palyIndex+1;
    
    
    
    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
        
        [self showToastWithString:@"已经到最后一首了"];
        
        resultRespone= appDelegate.playSaveDataArray[appDelegate.playSaveDataArray.count-1];
        resultRespone.isPlaying = YES;
        palyIndex =appDelegate.playSaveDataArray.count-1;
        return;
    }else{
        
        resultRespone= appDelegate.playSaveDataArray[palyIndex];
        resultRespone.isPlaying = YES;
        
    }
    
    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
        
        [self showToastWithString:@"已经到最后一首了"];
        
        return;
    }
    resultRespone = appDelegate.playSaveDataArray[palyIndex];
    if (!IsStrEmpty(resultRespone.trackName)) {
        
        titelLabel.text = resultRespone.trackName;
        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
    }else{
        
        titelLabel.text =@"无数据";
        //timeLabel.text  = @"00:00";
    }
    
    // [self playMusic:resultRespone];
    VedioModel *model = [[VedioModel alloc]init];
    model.musicURL = resultRespone.playUrl;
    [self.playerView changeMusic:model];
//    [[MusicPlayerView sharedInstance] changeMusic:model];
    IsPlaying = YES;
    
    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    
    NSLog(@"播放完成哈哈哈");
    
    NSLog(@"下一首");
    
    resultRespone= appDelegate.playSaveDataArray[palyIndex];
    resultRespone.isPlaying = NO;
    self.strTrackListid = resultRespone.trackListId;
    palyIndex = palyIndex+1;

    NSLog(@"playerViewFinishedpalyIndex======%ld",(long)palyIndex);



    if (palyIndex>appDelegate.playSaveDataArray.count-1) {

        resultRespone= appDelegate.playSaveDataArray[appDelegate.playSaveDataArray.count-1];
        resultRespone.isPlaying = YES;
        palyIndex =appDelegate.playSaveDataArray.count-1;

         playBtn.selected = NO;

        [self showToastWithString:@"已经到最后一首了"];



        return;

    }else{

        resultRespone= appDelegate.playSaveDataArray[palyIndex];
        resultRespone.isPlaying = YES;

    }

//    if (palyIndex>appDelegate.playSaveDataArray.count-1) {
//
////        [self showToastWithString:@"已经到最后一首了"];
////        [playBtn setImage:[UIImage imageNamed:@"btn_bofan_nor"] forState:UIControlStateNormal];
////        return;
//
//        palyIndex = 0;
//    }
//
//
//    resultRespone = appDelegate.playSaveDataArray[palyIndex];
//    resultRespone.isPlaying = YES;
    
    if (!IsStrEmpty(resultRespone.trackName)) {

        titelLabel.text = resultRespone.trackName;
        //timeLabel.text  =  [self getMMSSFromSS:resultRespone.duration];
    }else{

        titelLabel.text =@"无数据";
        //timeLabel.text  = @"00:00";
    }

    // [self playMusic:resultRespone];
    VedioModel *model = [[VedioModel alloc]init];
    model.musicURL = resultRespone.playUrl;
    [self.playerView changeMusic:model];
    IsPlaying = YES;

    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"btn_bofan_pre"] forState:UIControlStateSelected];
    [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ( self.IsBPlaying) {
        
         [self.pageImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    else
    {
        [self.pageImageView.layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
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


@end


