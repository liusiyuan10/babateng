//
//  QSearchViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSearchViewController.h"

#import "QMineRequestTool.h"

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"
//#import "QAlbumListCell.h"
#import "QSearchCell.h"
#import <AVFoundation/AVFoundation.h>
#import "QPlayListView.h"

#import "QDemandResultRespone.h"

#import "QAlbumDetailView.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "QAlbum.h"
#import "QAlbumData.h"
#import "QAlbumDataTrack.h"
#import "QAlbumDataTrackList.h"

#import "QHomeRequestTool.h"

#import "QSongDataList.h"

#import "QAddSong.h"

#import "MusicPlayerView.h"

#import "HomeViewController.h"

#import "QSongDevicePlayData.h"
#import "QSongDetailsPlayData.h"

#import "QPlayingTrack.h"
#import "QPlayingTrackData.h"

#import "AFNetworking.h"

#import "QHistory.h"

#import "QCustomViewController.h"

#import "QSearchAlbumViewController.h"

#import "UIButton+WebCache.h"

#import "QPlayingTrackList.h"

#import "NewHomeViewController.h"

#import "BBTCustomViewRequestTool.h"

#import "QSongDetails.h"


@interface QSearchViewController ()<UITableViewDelegate,UITableViewDataSource,QSearchCellCellDelegate,UIGestureRecognizerDelegate,QAlbumDetailViewDelegate,QPlayListViewDelegate,MusicPlayerViewDelegate,UISearchBarDelegate>{
    
    QAlbumDataTrackList *resultRespone;
}


@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引

@property(assign, nonatomic)NSInteger viewIndex;//当前播放音乐索引


@property (nonatomic, strong) UIView *HeadView;

@property (nonatomic, strong) NSMutableArray *AlbumArray;
@property (nonatomic, strong) NSMutableArray *playSaveArray;
@property (nonatomic, strong) NSMutableArray *headViewArray;
@property (nonatomic, assign) NSInteger PageNum;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) UISwipeGestureRecognizer  *swipeRight;

@property (nonatomic, strong) QHistoryData *QAlbumdata;
@property (nonatomic, strong) QSongDetailsPlayData *qSongDetailsPlayData;

@property (nonatomic, assign) BOOL IsAllAddSong;

@property(nonatomic,strong) MusicPlayerView *playerView;
@property (nonatomic, assign) BOOL     IsDeviceplay;
@property (nonatomic, strong)   NSString *strTracid;

@property (nonatomic, strong)   NSString *playingTracid;

//@property(nonatomic , strong)UISearchBar * searchBar;
//@property(nonatomic , strong)UIView * headView;

@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;

@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation QSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"专辑详情";
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.AlbumArray = [NSMutableArray array];
    self.playSaveArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QSearch:) name:@"QSearch" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QSearchPlay:) name:@"QSearchPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.PageNum = 1;
    
    NSLog(@"kkkkkkkkk=====%@",self.searchstr);
    
    

    
    [self LoadChlidView];
    
    [self GetTrackLists];
    
    _currentListenSection = -1;
    
    
    self.IsDeviceplay = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QSearchResult:) name:@"QSearchResult" object:nil];
    
    
}

#pragma mark UITableView + 上拉刷新 默认
- (void)pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}

- (void)loadMoreData
{
    
    self.PageNum++;
    
    if( self.PageNum > [self.pageStr integerValue])
    {
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"没有更多数据"];
        
        return;
    }
    
    NSString *PageNumStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :PageNumStr,@"pageSize" :@20,@"keyword":self.searchstr};
    
    
    [self startLoading];
    
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        [self stopLoading];
        [self.tableView.mj_footer endRefreshing];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSMutableArray *AlbumReArray = (NSMutableArray*)respone.data.list;
            
            if (AlbumReArray.count>0) {
                
                for (int i = 0; i<AlbumReArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = AlbumReArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self.AlbumArray addObjectsFromArray:AlbumReArray];
                [self loadModel];
                [self KeepDemandNor];
                
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
                self.headViewArray = [[NSMutableArray alloc] init];
            }
            [self.tableView reloadData];
            [self GetPlayingTrackId];
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[HomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];
    }];
    
    
    
}




- (void)LoadChlidView
{
    
    //NSLog(@"=============%f",CGRectGetMaxY(self.navigationController.navigationBar.frame));
    
    //适配iphone x
    CGFloat myheight;
    if (iPhoneX) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight-kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:self.tableView];
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.tableView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //适配iphone x
    
    self.button .frame = CGRectMake(kDeviceWidth / 2 - 30, KDeviceHeight- 165-kDevice_Is_iPhoneX , 50, 50);
    self.button .imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:  [[TMCache sharedCache]objectForKey:@"currentTrackIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    self.button.clipsToBounds=YES;
    
    self.button.layer.cornerRadius=25;
    
    [self.button  addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.button .adjustsImageWhenHighlighted = false;
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
    
    self.rotationAnimation.duration = 0.5;
    
    self.rotationAnimation.cumulative = YES;
    
    self.rotationAnimation.repeatCount = ULLONG_MAX;
    
    
    
    if ([[[TMCache sharedCache]objectForKey:@"buttonAnimation"] isEqualToString:@"addAnimation"]){
        
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    [self.view addSubview:self.button];
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, 50, 100, 30)];
    
    noLabel.text = @"暂无内容";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
    [self pullRefresh];
    
    
    
}

- (void)QSearchResult:(NSNotification *)noti
{
    self.searchstr =[noti.userInfo objectForKey:@"SearchStr"];
    
    NSLog(@"sdfsfdsfdsfdf=====%@",self.searchstr);
    
    [self GetTrackLists];
    
}

- (void)AnimationPlay:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    NSLog(@"encodedString===%@",encodedString);
    
    [self.button sd_setImageWithURL:[NSURL URLWithString: encodedString ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    if ([strtest1 isEqualToString:@"playing"]){
        
        [[TMCache sharedCache]setObject:@"addAnimation" forKey:@"buttonAnimation"];
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        [[TMCache sharedCache]setObject:@"removeAnimation" forKey:@"buttonAnimation"];
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
    
}

- (void)buttonClicked
{
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0
        ) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        NSLog(@"您还没有绑定设备，请先绑定设备");
        return;
    }
    
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    
    QCustomViewController * qCustom = [[QCustomViewController alloc] init];
    
    
    UINavigationController *qCustomrNav = [[UINavigationController alloc]
                                           initWithRootViewController:qCustom];
    
    [qCustomrNav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
      qCustomrNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:qCustomrNav animated:YES completion:nil];
    
}


- (void)autoRefreshing
{
    NSLog(@"只dsdfdsg");
    //    [self GetRePlayHistories];
    
    [self performSelector:@selector(GetReTrackLists) withObject:nil afterDelay:1.0];
    
    
}

- (void)GetPlayingTrackId
{
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"] || deviceIdstr.length == 0) {
        
        return;
    }
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        return;
    }
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    //[self startLoading];
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
        //[self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            
            //self.strTracid = trackdata.trackId;
            
            if (trackdata.tracks.count > 0) {
                QPlayingTrackList *listdata = trackdata.tracks[0];
                self.strTracid  =  [listdata.trackId stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            
        }
//        else if([respone.statusCode isEqualToString:@"3705"])
//        {
//            
//            [[HomeViewController getInstance] KickedOutDeviceStaues];
//            
//            
//        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        // [self stopLoading];
    }];
}

- (void)QSearchPlay:(NSNotification *)noti
{
    
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    int trackIdIndex = -1;
    
    for (int i = 0; i < self.AlbumArray.count; i++) {
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        
        if ([listRespone.trackId isEqualToString:self.strTracid]) {
            
            trackIdIndex = i;
            listRespone.IsDeviceplay = NO;
        }
        else
        {
            listRespone.IsDeviceplay = YES;
        }
        
    }
    
    NSLog(@"QSearchPlaytrackIdIndex========%d",trackIdIndex);
    
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == trackIdIndex)
        {
            if ([strtest1 isEqualToString:@"playing"])
            {
                head.nameLabel.textColor =NavBackgroundColor;
                head.myImageView.hidden = NO;
                head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
                head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                head.nameLabel.textColor = [UIColor colorWithRed:245/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
                
                head.leftImage.selected = YES;
                [self startAnimation:head.myImageView];
                IsRePalying = YES;
                
            }
            else
            {
                IsRePalying = NO;
                head.nameLabel.textColor = NavBackgroundColor;
                head.myImageView.hidden = YES;
                
                head.leftImage.selected = NO;
                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
                
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
}

- (void)KeepDemandNor
{
    int trackIdIndex = -1;
    
    for (int i = 0; i < self.AlbumArray.count; i++) {
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        
        if ([listRespone.trackId isEqualToString:self.strTracid]) {
            
            trackIdIndex = i;
            listRespone.IsDeviceplay = NO;
        }
        else
        {
            listRespone.IsDeviceplay = YES;
        }
        
    }
    
    
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == trackIdIndex)
        {
            
            if (IsRePalying) {
                
                head.nameLabel.textColor =NavBackgroundColor;
                head.myImageView.hidden = NO;
                head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
                head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                head.nameLabel.textColor = [UIColor colorWithRed:245/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
                
                head.leftImage.selected = YES;
                
                [self startAnimation:head.myImageView];
                
            }
            else
            {
                
                head.nameLabel.textColor = NavBackgroundColor;
                head.myImageView.hidden = YES;
                
                head.leftImage.selected = NO;
                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
            }
            
            
            
        }
        
    }
    
}

- (void)QSearch:(NSNotification *)noti
{
    
    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"trackId"]];
    
    NSString *strtest1 = [strtest stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"strtest1====%@",strtest1);
    
    
    int trackIdIndex = -1;
    for (int i = 0; i < self.AlbumArray.count; i++) {
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        
        if ([listRespone.trackId isEqualToString:strtest1]) {
            
            trackIdIndex = i;
            listRespone.IsDeviceplay = NO;
            self.strTracid = listRespone.trackId;
            
            [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
        }
        else{
            
            listRespone.IsDeviceplay = YES;
            //          self.strTracid = nil;
            
        }
        
    }
    
    if (trackIdIndex == -1) {
        self.strTracid = nil;
    }
    
    NSLog(@"trackIdIndex===%d" , trackIdIndex);
    
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == trackIdIndex)
        {
            
            
            head.nameLabel.textColor =NavBackgroundColor;
            head.myImageView.hidden = YES;
            //                head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
            
            //                head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
            head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
            //                head.nameLabel.textColor = [UIColor colorWithRed:245/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
            
            //               [head.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateNormal];
            head.leftImage.selected = YES;
            //                [self startAnimation:head.myImageView];
            
            
            
        }else {
            
            
            
            head.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            head.myImageView.hidden = YES;
            //            [head.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
            head.leftImage.selected = NO;
            head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
            
            
            
        }
        
    }
    
    [self.tableView reloadData];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)GetRTrackLists
{
    
    //    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20,@"keyword":self.searchstr};
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@2,@"keyword":self.searchstr};
    
    // [self startLoading];
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        // [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            if (self.AlbumArray&&self.AlbumArray.count > 0) {
                
                
                
                self.AlbumArray = [NSMutableArray array];
                
            }
            
            
            self.AlbumArray = (NSMutableArray*) respone.data.list;
            
            
            if (self.AlbumArray.count>0) {
                
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
                self.headViewArray = [[NSMutableArray alloc] init];
            }
            
            [self.tableView reloadData];
            
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}

- (void)GetReTrackLists
{
    
    self.strTracid = nil;
    
    //    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20,@"keyword":self.searchstr};
    //
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@2,@"keyword":self.searchstr};
    // [self startLoading];
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        // [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.QAlbumdata = respone.data;
            
            if (self.AlbumArray .count>0) {
                
                self.AlbumArray  = [[NSMutableArray alloc]init];
            }
            
            self.AlbumArray = (NSMutableArray*)self.QAlbumdata.list;
            
            if (self.AlbumArray.count>0)
            {
                
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self loadModel];
                
                
                
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
                self.headViewArray = [[NSMutableArray alloc] init];
            }
            
            [self.tableView reloadData];
            [self GetPlayingTrackId];
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        // [self stopLoading];
    }];
    
    
}



- (void)GetTrackLists
{
    
    //     NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    self.PageNum = 1;
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20,@"keyword":self.searchstr};
    
    
    [self startLoading];
    
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.QAlbumdata = respone.data;
            self.pageStr = respone.data.pages;
   
            if (self.AlbumArray.count>0) {
                
                self.AlbumArray  = [[NSMutableArray alloc]init];
            }
            
            self.AlbumArray = (NSMutableArray*)self.QAlbumdata.list;
            
            if (self.AlbumArray.count>0) {
                
                self.tableView.hidden = NO;
                self.noLabel.hidden = YES;
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                
                [self loadModel];
                
                [self.tableView reloadData];
                
            }else{
                
                NSLog(@"self.AlbumArray==%lu",(unsigned long)self.AlbumArray.count);
                
//                [self showToastWithString:@"暂无内容"];
                self.headViewArray = [[NSMutableArray alloc] init];
                
                self.tableView.hidden = YES;
                self.noLabel.hidden = NO;
            }
            
            
//            [self.tableView reloadData];
            
            [self GetPlayingTrackId];
            
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];
    }];
    
    
    
}


- (void)loadModel{
    _currentRow = -1;
    self.headViewArray = [[NSMutableArray alloc] init];
    
    for(int i = 0;i< self.AlbumArray.count ;i++)
    {
        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        //        listRespone.IsDeviceplay = YES;
        
        
        QHeadView *qheadview = [[QHeadView alloc] init];
        qheadview.delegate = self;
        qheadview.section = i;
        //        setBackgroundImageForState
        //        [qheadview.leftImage setBackgroundImage:[UIImage imageNamed:<#(nonnull NSString *)#>] forState:<#(UIControlState)#>]
        
        //        [qheadview.leftImage ]
        //        [qheadview.leftImage ]
        
        if (IsPlayButton&&_currentListenSection==i) {
            
            IsListenButton =YES;
            listRespone.isListening = YES;
            
            
        }
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        //        [qheadview.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:listRespone.trackIcon]];
        [qheadview.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString]];
        
        [qheadview.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
        
        NSLog(@"listRespone.isAddToSongList === %@",listRespone.isAddToSongList);
        
        if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
            
            [qheadview.addBtn setEnabled:NO];
        }
        else
        {
            [qheadview.addBtn setEnabled:YES];
        }
        
        //        icon_tjdemand_sel
        qheadview.nameLabel.text = listRespone.trackName;
        qheadview.timeLabel.text = [self getMMSSFromSS:listRespone.duration];
        
        [self.headViewArray addObject:qheadview];
    }
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QHeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?65:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    QHeadView* headView = [self.headViewArray objectAtIndex:section];
    
    
    if (IsListenButton) {
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[section];
        
        if (listRespone.isListening) {
            NSLog(@"indexPath.section===%ld",section);
            headView.timeView.hidden = YES;
            headView.timeLabel.hidden = YES;
            
            if (self.playerView==nil) {
                
                self.playerView =[[MusicPlayerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.leftImage.frame) + 11, CGRectGetMaxY(headView.nameLabel.frame)+ 12,  kDeviceWidth -120, 15)];
                
                
                self.playerView.musicPlayerDelegate = self;
                self.playerView.timeNowLabel.textColor =NavBackgroundColor;
                self.playerView.timeTotalLabel.textColor =NavBackgroundColor;
                
                
                //self.playerView.backgroundColor = NavBackgroundColor;
            }
            
            
            
            //是否存在正在播放的歌曲
            if (IsPlaying) {
                
                if (section==_currentListenSection) {
                    
                    [self.playerView playControl];
                    
                }else{
                    _currentListenSection=section;
                    VedioModel *model = [[VedioModel alloc]init];
                    model.musicURL = listRespone.playUrl;
                    [self.playerView changeMusic:model];
                    IsPlaying = YES;
                    
                }
                
            }else{
                
                _currentListenSection=section;
                VedioModel *model = [[VedioModel alloc]init];
                model.musicURL =listRespone.playUrl;
                [self.playerView setUp:model];
                IsPlaying = YES;
            }
            
            self.playerView.hidden = NO;
            [headView addSubview:self.playerView];
            
            
            
        }else{
            
            // NSLog(@"indexPath.section111===%ld",(long)indexPath.section);
            headView.timeView.hidden = NO;
            headView.timeLabel.hidden = NO;
            // _playerView.hidden = YES;
            
            //   [headView.playerView pause];
            
            if (section==_currentListenSection) {
                _currentListenSection=section;
                [self.playerView pause];
                self.playerView.hidden = YES;
            }
            
        }
        
        
        
        
    }
    
    //if (section==self.AlbumArray.count-1) {
    
    //}
    return headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    QHeadView *headView = [self.headViewArray objectAtIndex:section];
    return headView.open?1:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
    //    return 1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.searchBar resignFirstResponder];
    _block();
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"albumlistcell";
    
    QSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    
    
    
    QHeadView *view = [self.headViewArray objectAtIndex:indexPath.section];
    
    if (view.open) {
        if (indexPath.row == _currentRow) {
            
            
            
        }
    }
    
    
    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:indexPath.section];
    
    cell.collectbtn.tag = indexPath.section;
    cell.detailsbtn.tag = indexPath.section;
    cell.playbtn.selected = listRespone.isListening;
    
//    [cell.collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];
//    [cell.collectbtn setImage:[UIImage imageNamed:@"icon_shouchang02_sel"] forState:UIControlStateSelected];
    
    
    //    NSLog(@"sbbfgffh====%@",listRespone.isCollected);
    
    //    cell.collectbtn.selected = listRespone.isCollected;
    if ([listRespone.isCollected isEqualToString:@"1"]) {
        
        cell.collectbtn.selected = YES;
    
    }
    else
    {
        cell.collectbtn.selected = NO;
     
    }
    
    [cell.collectbtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.detailsbtn addTarget:self action:@selector(detailsbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (void)detailsbtnClick:(UIButton *)btn {
    
    
    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:btn.tag];
    
    QSearchAlbumViewController *AlbumVc = [[QSearchAlbumViewController alloc] init];
    AlbumVc.trackListId =listRespone.trackListId;
    [self.navigationController pushViewController:AlbumVc animated:YES];
    
}

- (void)collectBtnClick:(UIButton *)btn
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    

    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    btn.selected = !btn.selected;
    
    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:btn.tag];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : listRespone.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    if (btn.selected) {
        
        [self startLoading];
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"收藏成功"];
                //[self GetRTrackLists];
                //以前收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
                
                listRespone.isCollected=@"1";
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                
            }else if([response.statusCode isEqualToString:@"6500"])
            {
                
                listRespone.isCollected = @"1";
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                [self showToastWithString:response.message];
                
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
    else
    {
        [self startLoading];
        [QHomeRequestTool CancelFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"取消收藏成功"];
                //               [self GetRTrackLists];
              
                //以前收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
                listRespone.isCollected=@"0";
                
                [self loadModel];
                
                [self KeepDemandNor];
            }else if([response.statusCode isEqualToString:@"6501"])
            {
                
                listRespone.isCollected = @"0";
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                [self showToastWithString:response.message];
                
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
}




-(void)selectedWith:(QHeadView *)view{
    _currentRow = -1;
    IsListenButton = NO;
    if (view.open) {
        for(int i = 0;i<[self.headViewArray count];i++)
        {
            QHeadView *head = [self.headViewArray objectAtIndex:i];
            head.open = NO;
            //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
    
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
            
            self.musicIndex = _currentSection;
            
        }else {
            //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
            
            head.open = NO;
        }
        
    }
    
    [self.tableView reloadData];
    
    //    NSLog(@"dianji%ld",(long)self.musicIndex);
}

#pragma mark 播放工具条的代理
-(void)qalbumListCell:(QSearchCell *)toolbar listening:(BOOL)ifListening
{
    
    //实现这个播放，把播放的操作放在一个工具类
    
    for (int i=0; i<self.AlbumArray.count; i++) {
        
        QAlbumDataTrackList *listRespone= [self.AlbumArray objectAtIndex:i];
        if (listRespone.isListening==YES) {
            
            listRespone.isListening = NO;
            [self.tableView reloadData];
            break;
        }
        
    }
    
    NSLog(@"ifListening==%d",ifListening);
    
    if (ifListening) {
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[_currentSection];
        listRespone.isListening = YES;
        
        
        [self.tableView reloadData];
        
    }else{
        
        
        QAlbumDataTrackList *listRespone = self.AlbumArray[_currentSection];
        listRespone.isListening = NO;
        
        [self.tableView reloadData];
    }
    
    IsListenButton =YES;
    IsPlayButton =ifListening;
    
    
    
}

#pragma mark QHeadViewDelegate
- (void)QHeadViewAddBtnClicked:(QHeadView *)view
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
//    [self.searchBar resignFirstResponder];
    _block();
    
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    //适配iphone x 这里按钮有重叠
    tfSheetView.albumPlaystr = @"albumPlaystr";
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = NO;
    IsListenButton = NO;
    self.viewIndex = view.section;
}

- (void)QHeadViewBtnClicked:(QHeadView *)view leftBtn:(UIButton *)btn
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    NSString *DeviceElectricityStr = [[TMCache sharedCache] objectForKey:@"DeviceElectricity"];
    
    if ([DeviceElectricityStr isEqualToString:@"0"]) {
        
        
        [self showToastWithString:@"充电中"];
        return;
    }
    
    
    
    NSLog(@"sfdfdfdfdfd====%d",btn.selected);
    btn.selected = !btn.selected;
    
    IsRefreshPlay  = YES;
    
    _currentSection = view.section;
    [self palyresetIsplay:btn.selected];
    
    
    
    
}

- (void)AddDemandListtrackListId:(NSString *)trackListId TrackId:(NSString *)trackid
{
    
    if (self.searchstr.length == 0) {
        self.searchstr = @"";
    }
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"listId" :@"1" ,@"keyword" : self.searchstr ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"type" :@"8"};
    
    NSLog(@"self.searchstr======%@",self.searchstr);
    
    [QMineRequestTool PostSeachGeneralDemandTracks:parameter success:^(QSongDetails *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"点ssss播专辑成功。。。。。。。");
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }

        else
        {
            
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
    
}


- (void)palyresetIsplay:(BOOL)isplay
{
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            
            QAlbumDataTrackList *listRespone = self.AlbumArray[_currentSection];
            
            if (isplay) {
                
                if (IsRefreshPlay) {
                    
                    if (listRespone.IsDeviceplay) {
                        
                        listRespone.IsDeviceplay = NO;
                        
                        //                        QAlbumDataTrackList *listRespone = self.AlbumArray[_currentSection];
                        
                        [self AddDemandListtrackListId:listRespone.trackListId TrackId:listRespone.trackId];
                        
                        self.strTracid = listRespone.trackId;
                        
                        [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
                    }
                    else
                    {
//                        NSDictionary *dic = @{@"cmd" : @"resume"};
//
//                        [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                        
                        [self PutDevicesControlMQTT:@"4" ValueStr:@""];
                        
                    }
                    
                }
                
                
                head.nameLabel.textColor =NavBackgroundColor;
                head.myImageView.hidden = YES;
                
                head.leftImage.selected = NO;
                //                head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
                
                //                head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
                //                [self startAnimation:head.myImageView];
                
                
            }
            else
            {
//                NSDictionary *dic = @{@"cmd" : @"pause"};
//
//                [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                
                [self PutDevicesControlMQTT:@"3" ValueStr:@""];
                
                
                [head.myImageView stopAnimating];
                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
                head.nameLabel.textColor = NavBackgroundColor;
                
                head.myImageView.hidden = YES;
                head.leftImage.selected = NO;
                
                
            }
            
            
        }else {
            
            QAlbumDataTrackList *listRespone = self.AlbumArray[i];
            listRespone.IsDeviceplay = YES;
            
            head.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            head.myImageView.hidden = YES;
            head.leftImage.selected = NO;
            // [head.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
            
            head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
            //            resultRespone= appDelegate.playSaveDataArray[i];
            //            resultRespone.isPlaying = NO;
            
            
        }
        
    }
    
    [self.tableView reloadData];
}

-(void)startAnimation:(UIImageView*)cellImageView{
    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"nlk_1"],[UIImage imageNamed:@"nlk_2"],[UIImage imageNamed:@"nlk_3"],[UIImage imageNamed:@"nlk_4"],[UIImage imageNamed:@"nlk_5"], nil];
    
    //imageView的动画图片是数组images
    cellImageView .animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    cellImageView.animationDuration = 3;
    //动画的重复次数，想让它无限循环就赋成0
    cellImageView .animationRepeatCount = 0;
    //开始动画
    [cellImageView startAnimating];
    
}

- (void)backForePage
{
    [self.navigationController popViewControllerAnimated:YES];
    if (IsPlaying) {
        IsPlaying = NO;
        [self.playerView removeObserver];//注销观察者
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self GetPlayingTrackId];
    

//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
//
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.searchBar resignFirstResponder];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    [[AppDelegate appDelegate]suspendButtonHidden:YES];
//
//    if (IsPlaying) {
//        IsPlaying=NO;
//        [self.playerView removeObserver];//注销观察者
//
//    }
    
    // self.navigationController.navigationBar.translucent = NO;
}

#pragma mark -- QAlbumDetailViewDelegate
- (void)QDeviceVolumeViewAddBtnClicked:(QAlbumDetailView *)view
{
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = YES;
    
    
}

- (void)QDeviceVolumeViewAddFavoriteBtnClicked:(QAlbumDetailView *)view
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能收藏"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[0];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackListId" : listRespone.trackListId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    
    [QHomeRequestTool AddAllFavoriteParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            
            [self showToastWithString:@"全部收藏成功"];
            
            // [self GetRTrackLists];
            //以前全部收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
            for (int i=0;i<self.AlbumArray.count; i++) {
                
                QAlbumDataTrackList *listRespone =self.AlbumArray[i];
                
                listRespone.isCollected=@"1";
            }
            
            
            
            [self loadModel];
            
            [self KeepDemandNor];
            
            [self.tableView reloadData];
            
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- QPlayListViewDelegate
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model
{
    
    
    if (self.IsAllAddSong) {
        
        [self addAllPlayListsectionIndex:0 selectModel:model];
        
    }
    else
    {
        [self addPlayListsectionIndex:self.viewIndex selectModel:model];
    }
    
    
    
}


- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能添加"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[sectionIndex];
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : listRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"添加成功"];
            
            //  [self GetRTrackLists];
            
            //以前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
            
            listRespone.isAddToSongList=@"1";
            
            [self loadModel];
            
            [self KeepDemandNor];
            
            
            [self.tableView reloadData];
            
            
            
            
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

- (void)addAllPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能添加"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[sectionIndex];
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackListId" : listRespone.trackListId};
    
    [self startLoading];
    
    [QHomeRequestTool AddAlldeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"全部添加成功"];
            
            // [self GetRTrackLists];
            
            //前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
            
            for (int i=0;i<self.AlbumArray.count; i++) {
                
                QAlbumDataTrackList *listRespone =self.AlbumArray[i];
                
                listRespone.isAddToSongList=@"1";
            }
            
            
            
            [self loadModel];
            
            [self KeepDemandNor];
            
            
            [self.tableView reloadData];
            
            
            
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

#pragma mark MusicPlayerViewDelegate
//播放失败的代理方法
-(void)playerViewFailed{
    IsPlaying=NO;
    NSLog(@"播放失败");
}
//缓存中的代理方法
-(void)playerViewBuffering{
    
    //NSLog(@"缓存中");
}
//播放完毕的代理方法
-(void)playerViewFinished{
    
    NSLog(@"播放完成");
    
    [self.playerView pause];
    [self showToastWithString:@"播放结束!"];
    if (IsPlaying) {
        
        
        
        [self.playerView removeObserver];//注销观察者
        IsPlaying = NO;
        
        //self.playerView=nil;
        for (int i=0; i<self.AlbumArray.count; i++) {
            
            QAlbumDataTrackList *listRespone= [self.AlbumArray objectAtIndex:i];
            if (listRespone.isListening==YES) {
                
                listRespone.isListening = NO;
                [self.tableView reloadData];
                break;
            }
            
        }
        
    }
    
}
//当前播放时间 float currentPlayTime
-(void)playerViewTimeNow:(CGFloat)currentPlayTime{
    
    //NSLog(@"currentPlayTime==%f",currentPlayTime);
//
//    if (currentPlayTime>120) {
//
//        [self.playerView pause];
//        [self showToastWithString:@"试听结束!"];
//        if (IsPlaying) {
//
//
//
//            [self.playerView removeObserver];//注销观察者
//            IsPlaying = NO;
//
//            //self.playerView=nil;
//            for (int i=0; i<self.AlbumArray.count; i++) {
//
//                QAlbumDataTrackList *listRespone= [self.AlbumArray objectAtIndex:i];
//                if (listRespone.isListening==YES) {
//
//                    listRespone.isListening = NO;
//                    [self.tableView reloadData];
//                    break;
//                }
//
//            }
//
//        }
//
//    }
//    else{
//
//        if (IsPlayButton) {
//
//            [self.playerView play];
//
//        }else{
//
//            [self.playerView pause];
//        }
//
//    }
    
    
    if (IsPlayButton) {
        
        [self.playerView play];
        
    }else{
        
        [self.playerView pause];
    }
    
}



@end

