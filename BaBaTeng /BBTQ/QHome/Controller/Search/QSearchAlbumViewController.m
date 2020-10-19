//
//  QSearchAlbumViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/24.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//


#import "QSearchAlbumViewController.h"
#import "QAlbumScrollViewController.h"
#import "QSegmentTool.h"
#import "QMineRequestTool.h"

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"
#import "QAlbumListCell.h"
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

#import "QCustomViewController.h"

#import "QAlbumDetialData.h"
#import "QAlbumDetial.h"

#import "QPlayingTrackList.h"

#import "UIButton+WebCache.h"

#import "NewHomeViewController.h"

#import "BBTCustomViewRequestTool.h"
#import "QSongDetails.h"


@interface QSearchAlbumViewController ()<QSegmentToolCellDelegate,UITableViewDelegate,UITableViewDataSource,QAlbumListCellDelegate,UIGestureRecognizerDelegate,QAlbumDetailViewDelegate,QPlayListViewDelegate,MusicPlayerViewDelegate>{
    
    QAlbumDataTrackList *resultRespone;
}

@property (nonatomic, strong) QSegmentTool *segmentTool;

@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引

@property(assign, nonatomic)NSInteger viewIndex;//当前播放音乐索引

//@property (nonatomic, strong) UIView *BgView1;
//
//@property (nonatomic, strong) UIView *BgView2;

@property (nonatomic, strong) UIView *HeadView;

@property (nonatomic, strong) NSMutableArray *AlbumArray;
@property (nonatomic, strong) NSMutableArray *playSaveArray;
@property (nonatomic, strong) NSMutableArray *headViewArray;
@property (nonatomic, assign) NSInteger PageNum;

@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic, retain)UIScrollView *backScrollView;//添加tab切换效果 chupeng

@property(nonatomic, retain)UIView *leftParamView;

@property(nonatomic, retain)UIScrollView *righParamtView;

@property (nonatomic, strong) UISwipeGestureRecognizer  *swipeRight;

//@property (nonatomic, strong) QAlbumData *QAlbumdata;

@property (nonatomic, strong) QAlbumDetialData *qalbumdetialdata;

@property (nonatomic, strong) QSongDetailsPlayData *qSongDetailsPlayData;

@property (nonatomic, assign) BOOL IsAllAddSong;

@property(nonatomic,strong) MusicPlayerView *playerView;
@property (nonatomic, assign) BOOL     IsDeviceplay;
@property (nonatomic, strong)   NSString *strTracid;

@property (nonatomic, strong)   NSString *playingTracid;
@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;

@property (nonatomic, assign)  BOOL ifpresent;

@end

@implementation QSearchAlbumViewController

- (QSegmentTool *)segmentTool
{
    if (_segmentTool == nil) {
        _segmentTool = [[QSegmentTool alloc] initWithFrame:CGRectMake(0,142 + 23,kDeviceWidth, 65)];
        
        
        _segmentTool.backgroundColor = [UIColor whiteColor];
        
        _segmentTool.delegate = self;
        
        
    }
    
    return _segmentTool;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"专辑详情";
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    
    
    [self.view addSubview:self.backScrollView];
    UIView *segmentation = [[UIView alloc]initWithFrame:CGRectMake(0, 142, kDeviceWidth, 23)];
    segmentation.backgroundColor = BBT_BACKGROUN_COLOR;
    [self.view addSubview:segmentation];
    [self.view addSubview:self.segmentTool];
    [self.segmentTool setNProDetailSixCellInfo];
    self.AlbumArray = [NSMutableArray array];
    self.playSaveArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchDemandAlbum:) name:@"SearchDemandAlbum" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchDemandAlbumPlay:) name:@"SearchDemandAlbumPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    
    
    self.PageNum = 1;
    
    [self GetTrackLists];
    
    [self getTrackListDetail];
    
    
    //    [self LoadChlidView];
    
    
    
    _currentListenSection = -1;
    

//    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    self.IsDeviceplay = YES;
    

    
    
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
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    
    [QMineRequestTool getpagetrackListsId:self.trackListId PageNum:PageStr PageSize:@"10" Parameter:parameter success:^(QAlbum *respone) {
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
                
                [self.tableView reloadData];
                
                          [self GetPlayingTrackId];
                
            }else if([respone.statusCode isEqualToString:@"3705"])
            {
                
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self stopLoading];
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}


- (void)getTrackListDetail
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [self startLoading];
    [QMineRequestTool gettrackListsId:self.trackListId Parameter:parameter success:^(QAlbumDetial *respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qalbumdetialdata = respone.data;
            [self LoadChlidView];
            
            
        }
//        else if([respone.statusCode isEqualToString:@"3705"])
//        {
//            
//            [[HomeViewController getInstance] KickedOutDeviceStaues];
//            
//            
//        }
        else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
}


- (void)autoRefreshing
{
//    NSLog(@"只dsdfdsg");
//  
//    [self performSelector:@selector(GetReTrackLists) withObject:nil afterDelay:1.0];
    
    self.strTracid = nil;
    
    for (int i = 0; i<self.AlbumArray.count; i++)
    {
        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        listRespone.IsDeviceplay = YES;
    }
    
    [self.tableView reloadData];
    
    
    [self performSelector:@selector(GetPlayingTrackId) withObject:nil afterDelay:1.0];
    
    
    
}

- (void)GetPlayingTrackId
{
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        
        return;
    }
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        return;
    }

    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
//    [self startLoading];
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
//        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            
           // self.strTracid = trackdata.trackId;
            
            if (trackdata.tracks.count > 0) {
                QPlayingTrackList *listdata = trackdata.tracks[0];
                self.strTracid =  [listdata.trackId stringByReplacingOccurrencesOfString:@"-" withString:@""];
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
        
//        [self stopLoading];
    }];
}

- (void)SearchDemandAlbumPlay:(NSNotification *)noti
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

//- (void)KeepDemandNorTrackId:(NSString *)trackid
//{
//    int trackIdIndex = -1;
//
//    for (int i = 0; i < self.AlbumArray.count; i++) {
//
//        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
//
//        if ([listRespone.trackId isEqualToString:trackid]) {
//
//            trackIdIndex = i;
//            listRespone.IsDeviceplay = NO;
//        }
//        else
//        {
//            listRespone.IsDeviceplay = YES;
//        }
//
//    }
//
//
//    for(int i = 0;i<[self.headViewArray count];i++)
//    {
//        QHeadView *head = [self.headViewArray objectAtIndex:i];
//
//        if(head.section == trackIdIndex)
//        {
//
//            head.nameLabel.textColor =NavBackgroundColor;
//            head.myImageView.hidden = NO;
//            head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
//            head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
//            head.nameLabel.textColor = [UIColor colorWithRed:245/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
//
//            head.leftImage.selected = YES;
//
//            [self startAnimation:head.myImageView];
//
//        }
//
//    }
//
//}


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

- (void)SearchDemandAlbum:(NSNotification *)noti
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
            
            
        }else{
            
            listRespone.IsDeviceplay = YES;
            
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
            head.leftImage.selected = NO;
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
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    
    [QMineRequestTool getpagetrackListsId:self.trackListId PageNum:@"1" PageSize:@"10" Parameter:parameter success:^(QAlbum *respone) {
        
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
                
                
                [self.tableView reloadData];
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
            
            
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
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    
    [QMineRequestTool getpagetrackListsId:self.trackListId PageNum:@"1" PageSize:@"10" Parameter:parameter success:^(QAlbum *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.AlbumArray = (NSMutableArray*)respone.data.list;
            
            
            if (self.AlbumArray.count>0) {
                
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                
                [self loadModel];
                
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}



- (void)GetTrackLists
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    NSLog(@"sfsdfsdfAlbum%@",[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    
    [QMineRequestTool getpagetrackListsId:self.trackListId PageNum:PageStr PageSize:@"10" Parameter:parameter success:^(QAlbum *respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.AlbumArray = (NSMutableArray*)respone.data.list;
            
            
            
            if (self.AlbumArray.count>0) {
                
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self loadModel];
                
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self stopLoading];
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}

- (void)LoadChlidView
{
    [self LoadHeadView];
    //    [self LoadBgView1];
    //    [self LoadBgView2];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 235 - 50 - kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //[self.setTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
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
    //适配iphone x
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button .frame = CGRectMake(kDeviceWidth / 2 - 30, KDeviceHeight- 55 - CGRectGetMaxY(self.navigationController.navigationBar.frame)-kDevice_Is_iPhoneX, 50, 50);
    self.button .imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    self.button.clipsToBounds=YES;
    
    self.button.layer.cornerRadius=25;
    
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:  encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    [ self.button  addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
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

    
    [self.leftParamView addSubview:self.tableView];
    
    [self LoadRighParamtView];
    
    [self pullRefresh];

    
    [self.view addSubview:self.button];
    
}



- (void)AnimationPlay:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
   
    
    
     NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
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
    
    
    _ifpresent = YES;
    
    QCustomViewController * qCustom = [[QCustomViewController alloc] init];
    
    
    UINavigationController *qCustomrNav = [[UINavigationController alloc]
                                           initWithRootViewController:qCustom];
    
    [qCustomrNav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    qCustomrNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:qCustomrNav animated:YES completion:nil];
    
}

- (void)LoadRighParamtView
{
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kDeviceWidth - 30, KDeviceHeight - 235 - 50)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    CGFloat titleLabelY =  10;
    CGFloat titleLabelX = 15;
    
    titleLabel.numberOfLines = 0;
    
    titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (self.qalbumdetialdata.trackListDescription.length !=0 ) {
        //
        CGSize titleLabelSize = [self.qalbumdetialdata.trackListDescription sizeWithMaxSize:CGSizeMake(kDeviceWidth - titleLabelX *2, MAXFLOAT) fontSize:16];
        
        
        titleLabel.frame = (CGRect){titleLabelX,titleLabelY,kDeviceWidth - titleLabelX *2, titleLabelSize.height + 50};
        
        titleLabel.text = self.qalbumdetialdata.trackListDescription;
        titleLabel.backgroundColor = [UIColor clearColor];
        _righParamtView.contentSize = CGSizeMake(0,titleLabelSize.height + 60);
    }
    else{
        
        titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, kDeviceWidth - titleLabelX *2, 30);
        
        titleLabel.text = @"暂无简介内容";
        _righParamtView.contentSize = CGSizeMake(0,self.backScrollView.frame.size.height/2);
    }
    
    
    
    
    
    
    [self.righParamtView addSubview:titleLabel];
}



- (void)LoadHeadView
{
    
    self.HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 142)];
    
    self.HeadView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.HeadView];
    
    UIImageView *AlbumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    //    AlbumImageView.backgroundColor = [UIColor orangeColor];
    
    //    AlbumImageView.image = [UIImage imageNamed:@"tu_wz"];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.qalbumdetialdata.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [AlbumImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"tu_wz"]];
    
    [self.HeadView addSubview:AlbumImageView];
    
    UILabel *AlbumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, 20, kDeviceWidth-CGRectGetMaxX(AlbumImageView.frame) -45, 40)];
    //    AlbumNameLabel.text = @"专辑名称";
    AlbumNameLabel.text = self.qalbumdetialdata.trackListName;
    AlbumNameLabel.numberOfLines=0;
    AlbumNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    AlbumNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    AlbumNameLabel.backgroundColor = [UIColor clearColor];
    [self.HeadView addSubview:AlbumNameLabel];
    
    UILabel *AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, CGRectGetMaxY(AlbumNameLabel.frame)+ 10, 40, 15)];
    AuthorLabel.text = @"作者:";
    AuthorLabel.font = [UIFont systemFontOfSize:14.0];
    AuthorLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    
    [self.HeadView addSubview:AuthorLabel];
    
    UILabel *AuthorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AuthorLabel.frame) +5, CGRectGetMaxY(AlbumNameLabel.frame) + 10, 100, 15)];
    //    AuthorNameLabel.text = @"张三";
    AuthorNameLabel.text = self.qalbumdetialdata.trackListAuthor;
    
    AuthorNameLabel.font = [UIFont systemFontOfSize:14.0];
    AuthorNameLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    
    [self.HeadView addSubview:AuthorNameLabel];
    
    UILabel *NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, CGRectGetMaxY(AuthorLabel.frame)+ 13, 40, 15)];
    NumberLabel.text = @"数量:";
    NumberLabel.font = [UIFont systemFontOfSize:14.0];
    NumberLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    
    [self.HeadView addSubview:NumberLabel];
    
    UILabel *NumberTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(NumberLabel.frame) +5, CGRectGetMaxY(AuthorLabel.frame) + 13, 100, 15)];
    //    NumberTextLabel.text = @"12";
    NumberTextLabel.text = self.qalbumdetialdata.trackCount;
    NumberTextLabel.font = [UIFont systemFontOfSize:14.0];
    NumberTextLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    
    [self.HeadView addSubview:NumberTextLabel];
    
    [self setNavigationItem];
    
    
}



//- (void)LoadHeadView
//{
//    
//    self.HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 142)];
//    
//    self.HeadView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:self.HeadView];
//    
//    UIImageView *AlbumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
//
////    [AlbumImageView setImageWithURL:[NSURL URLWithString:self.qalbumdetialdata.trackListIcon] placeholderImage:[UIImage imageNamed:@"tu_wz"]];
//    
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.qalbumdetialdata.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//    
//    [AlbumImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"tu_wz"]];
//    
//    [self.HeadView addSubview:AlbumImageView];
//    
//    UILabel *AlbumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, 31, 100, 15)];
//    //    AlbumNameLabel.text = @"专辑名称";
//    AlbumNameLabel.text = self.qalbumdetialdata.trackListName;
//    
//    AlbumNameLabel.font = [UIFont boldSystemFontOfSize:19.0];
//    AlbumNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//    
//    [self.HeadView addSubview:AlbumNameLabel];
//    
//    UILabel *AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, CGRectGetMaxY(AlbumNameLabel.frame)+ 18, 40, 15)];
//    AuthorLabel.text = @"作者:";
//    AuthorLabel.font = [UIFont systemFontOfSize:15.0];
//    AuthorLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
//    
//    [self.HeadView addSubview:AuthorLabel];
//    
//    UILabel *AuthorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AuthorLabel.frame) +5, CGRectGetMaxY(AlbumNameLabel.frame) + 18, 100, 15)];
//    //    AuthorNameLabel.text = @"张三";
//    AuthorNameLabel.text = self.qalbumdetialdata.trackListAuthor;
//    
//    AuthorNameLabel.font = [UIFont systemFontOfSize:15.0];
//    AuthorNameLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
//    
//    [self.HeadView addSubview:AuthorNameLabel];
//    
//    UILabel *NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AlbumImageView.frame) +25, CGRectGetMaxY(AuthorLabel.frame)+ 13, 40, 15)];
//    NumberLabel.text = @"数量:";
//    NumberLabel.font = [UIFont systemFontOfSize:15.0];
//    NumberLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
//    
//    [self.HeadView addSubview:NumberLabel];
//    
//    UILabel *NumberTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(NumberLabel.frame) +5, CGRectGetMaxY(AuthorLabel.frame) + 13, 100, 15)];
//    //    NumberTextLabel.text = @"12";
//    NumberTextLabel.text = self.qalbumdetialdata.trackCount;
//    NumberTextLabel.font = [UIFont systemFontOfSize:15.0];
//    NumberTextLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
//    
//    [self.HeadView addSubview:NumberTextLabel];
//    
//    [self setNavigationItem];
//    
//    
//}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"nav_gd_nor"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_gd_pre"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(QDetail) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

- (void)QDetail
{
    //    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    QAlbumDetailView *tfSheetView = [[QAlbumDetailView alloc]init];
    tfSheetView.albumPlaystr = @"albumPlaystr";
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
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




#pragma mark -
#pragma mark sixCell Delegate
-(void)viewChangeWithType:(BtnSelectTypeCell)type
{
    
    NSLog(@"type==%u",type);
    
    switch (type) {
            
        case SelectLeftBtnCell:
            
            self.swipeRight.enabled = YES;
            
            [self showIntroduceView];
            break;
        case SelectMidBtnCell:
            self.swipeRight.enabled = NO;
            
            [self showBaseView];
            break;
            
        default:
            break;
    }
    
}
#pragma mark -
#pragma sixCell Delegate
-(void)showBaseView
{
    IsListenButton =NO;
    [self.backScrollView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
    
    
    [self.tableView reloadData];
}


-(void)showIntroduceView{
    
    IsListenButton =YES;
    [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    
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





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"albumlistcell";
    
    QAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QAlbumListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.backScrollView) {
        //滑动切换
        
        if(self.backScrollView.contentOffset.x == 0)
        {
            
            [self.segmentTool btnChangeTabAction:self.segmentTool.introduceBtn];
        }
        else if(self.backScrollView.contentOffset.x == kDeviceWidth)
        {
            [self.segmentTool btnChangeTabAction:self.segmentTool.baseInfoBtn];
        }
    }
    
    //IsListenButton = NO;
    //  NSLog(@"拖动");
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
                //               [btn setImage:[UIImage imageNamed:@"icon_shouchang02_nor"] forState:UIControlStateNormal];
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
-(void)qalbumListCell:(QAlbumListCell *)toolbar listening:(BOOL)ifListening
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
    //    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    tfSheetView.albumPlaystr = @"albumPlaystr";
    
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = NO;
    IsListenButton = NO;
    self.viewIndex = view.section;
}

- (void)QHeadViewBtnClicked:(QHeadView *)view leftBtn:(UIButton *)btn
{
    NSLog(@"sfdfdfdfdfd====%d",btn.selected);
    
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
    
    
    btn.selected = !btn.selected;
    
    
    IsRefreshPlay  = YES;
    
    _currentSection = view.section;
    [self palyresetIsplay:btn.selected];
    
    
    
    
}

- (void)AddDemandListtrackListId:(NSString *)trackListId TrackId:(NSString *)trackid
{

    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"listId" :trackListId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"type" :@"3"};
    
    [QMineRequestTool PostGeneralDemandTracks:parameter success:^(QSongDetails *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"点播专辑成功。。。。。。。");
            
        }
        else if([respone.statusCode isEqualToString:@"3705"])
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

//- (void)AddDemandListtrackListId:(NSString *)trackListId TrackId:(NSString *)trackid
//{
//    //    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
//
//    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackListId" :trackListId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
//
//    [QMineRequestTool PostDemandTrackLists:parameter success:^(QSongDevicePlayData *respone) {
//
//        //        self.qSongDetailsPlayData = respone.data;
//        //
//        //        // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        //
//        //        appDelegate.playSaveDataArray = self.qSongDetailsPlayData.tracks;;
//        //
//        //
//        //        resultRespone= appDelegate.playSaveDataArray[_currentSection];
//        //        resultRespone.isPlaying = YES;
//        //
//        //        NSLog(@"888999======%lu", (unsigned long)appDelegate.playSaveDataArray.count);
//        //        NSLog(@"88899911======%lu", (unsigned long)self.qSongDetailsPlayData.tracks.count);
//    } failure:^(NSError *error) {
//
//    }];
//
//}


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
        IsPlaying =NO;
        [self.playerView removeObserver];//注销观察者
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
    
    //    [self GetPlayingTrackId];
    
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    _ifpresent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if (!_ifpresent) {
        _ifpresent =NO;
        if (IsPlaying) {
            IsPlaying =NO;
            [self.playerView removeObserver];//注销观察者
        }
    }
    
   
}


-(UIView *)leftParamView{
    
    if (!_leftParamView) {
        
        _leftParamView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentTool.frame)-18, kDeviceWidth, self.backScrollView.frame.size.height)];
        
        _leftParamView.backgroundColor = [UIColor clearColor];
        
        _leftParamView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        
        
        [self.backScrollView addSubview:_leftParamView];
    }
    
    return _leftParamView;
}

-(UIScrollView *)righParamtView{
    
    if (!_righParamtView) {
        
        _righParamtView = [[UIScrollView alloc] initWithFrame:CGRectMake(kDeviceWidth, CGRectGetMaxY(self.segmentTool.frame)-18, kDeviceWidth, self.backScrollView.frame.size.height/2)];
        
        
        _righParamtView.scrollEnabled = YES;
        _righParamtView.showsVerticalScrollIndicator =  NO;
        _righParamtView.showsHorizontalScrollIndicator = YES;
        
        _righParamtView.pagingEnabled = YES;
        _righParamtView.delegate = self;
        _righParamtView.bounces = YES;
        
        
        _righParamtView.backgroundColor = [UIColor whiteColor];
        _righParamtView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.backScrollView addSubview:_righParamtView];
    }
    
    return _righParamtView;
}


- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        _backScrollView = [[UIScrollView alloc] init];
        
        
        _backScrollView.frame = CGRectMake(0, 35, kDeviceWidth, self.view.size.height - 35);
        _backScrollView.contentSize = CGSizeMake(self.leftParamView.size.width + self.righParamtView.size.width,0);
        //
        _backScrollView.scrollEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator =  NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        //        _backScrollView.alwaysBounceHorizontal = YES;
        _backScrollView.pagingEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.bounces = NO;
        //        _backScrollView.alwaysBounceVertical = YES;
        //        CGRect rc =_backScrollView.frame;
        
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _backScrollView;
}



- (UISwipeGestureRecognizer *)swipeRight
{
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForePage)];
        [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        _swipeRight.delegate = self;
    }
    return _swipeRight;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    
    
}


#pragma mark -- QAlbumDetailViewDelegate
- (void)QDeviceVolumeViewAddBtnClicked:(QAlbumDetailView *)view
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    //    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.albumPlaystr = @"albumPlaystr";
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = YES;
    
    
}

- (void)QDeviceVolumeViewAddFavoriteBtnClicked:(QAlbumDetailView *)view
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
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
    IsPlaying =NO;
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


