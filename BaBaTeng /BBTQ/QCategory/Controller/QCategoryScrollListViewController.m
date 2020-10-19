//
//  QCategoryScrollListViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCategoryScrollListViewController.h"
#import "QMineRequestTool.h"

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"
#import "QAlbumListCell.h"
#import <AVFoundation/AVFoundation.h>
#import "QCategoryView.h"
#import "QDemandResultRespone.h"

#import "QCategoryRequestTool.h"

#import "QSourceTag.h"
#import "QSourceTagData.h"
//#import "QSourceTagList.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "QPlayListView.h"

#import "QHomeRequestTool.h"
#import "QSongDataList.h"
#import "QAddSong.h"

#import "HomeViewController.h"

#import "QPlayingTrack.h"
#import "QPlayingTrackData.h"
#import "QSongDetails.h"
#import "QPlayingTrackList.h"
#import "NewHomeViewController.h"
#import "BBTCustomViewRequestTool.h"



@interface QCategoryScrollListViewController ()<UITableViewDataSource,UITableViewDelegate,QAlbumListCellDelegate,QPlayListViewDelegate,MusicPlayerViewDelegate>


@property (nonatomic, strong)     NSMutableArray *headViewArray;
//@property (nonatomic, assign)     NSInteger PageNum;
//@property(strong,nonatomic)       AVPlayer *player;
@property(assign, nonatomic)      NSInteger musicIndex;//当前播放音乐索引
@property(assign, nonatomic)      NSInteger viewIndex;//当前播放音乐索引

@property (nonatomic, strong)   NSString *strTracid;

@property(nonatomic, assign) BOOL  IsDeviceplay1;//是否正在试听
@property (nonatomic, strong)   NSString *strTracid1;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   QSourceTagData *qSourceTagData;

@property (nonatomic, strong) NSString *pageStr;

@end

@implementation QCategoryScrollListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    
    self.Qcateoryarr = [[NSMutableArray alloc] init];
    self.playSaveArray = [[NSMutableArray alloc] init];
    self.pageNum = 1;
//    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    //    [self GetListBrowse:@"253" Page:PageStr Count:@"20"];
    //    [self GetAlbum:@"253" Page:PageStr Count:@"5"];
    
    //    [self GetDemand];
    _currentListenSection = -1;
    NSLog(@"self.categoryid===%@",self.categoryid);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DemandCategory:) name:@"DemandCategory" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DemandCategoryPlay:) name:@"DemandCategoryPlay" object:nil];
    
    [self getSourceTag];
    
    [self LoadChlidView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DropsORCharge) name:@"DropsORCharge" object:nil];
    
    //    QCategoryViewController * QCategoryView = [[QCategoryViewController alloc]init];
    //
    //    self.view =  QCategoryView.childViewControllers[0];
    
    
    
    
}

- (void)autoRefreshing
{
//    NSLog(@"只dsdfdsg");

//    [self performSelector:@selector(getReSourceTag) withObject:nil afterDelay:1.0];
    
    self.strTracid = nil;
    
    for (int i = 0; i<self.Qcateoryarr.count; i++)
    {
        QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
        listRespone.IsDeviceplay = YES;
    }
    
    
    [self.tableView reloadData];
    
//        [self GetPlayingTrackId];//获取当前播放歌曲
    [self performSelector:@selector(GetPlayingTrackId) withObject:nil afterDelay:1.0];
    
    
}

- (void)DropsORCharge
{
    NSLog(@"掉线或者充电通知");
    if (_IsPlaying) {
        _IsPlaying =NO;
        [self.playerView removeObserver];//注销观察者
    }
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
    
//    [self startLoading];
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
//        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            
//            self.strTracid = trackdata.trackId;
            
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


- (void)DemandCategoryPlay:(NSNotification *)noti
{
    
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    
    if ([strtest1 isEqualToString:@"playing"]) {
        
        self.IsDeviceplay1 = YES;
        
    }else
    {
        self.IsDeviceplay1 = NO;
        
    }
    
    int trackIdIndex = -1;
    
    for (int i = 0; i < self.Qcateoryarr.count; i++) {
        
        QAlbumDataTrackList *listRespone  = self.Qcateoryarr[i];
        
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



- (void)KeepDemandNor
{
    int trackIdIndex = -1;
    
    for (int i = 0; i < self.Qcateoryarr.count; i++) {
        
        QAlbumDataTrackList *listRespone  = self.Qcateoryarr[i];
        
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


- (void)DemandCategory:(NSNotification *)noti
{
    
    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"trackId"]];
    
    NSString *strtest1 = [strtest stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"strtest1====%@",strtest1);
    
    
    self.strTracid1  =strtest1;
    int trackIdIndex = -1;
    for (int i = 0; i < self.Qcateoryarr.count; i++) {
        
        //        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
        
        QAlbumDataTrackList *listRespone  = self.Qcateoryarr[i];
        
        if ([listRespone.trackId isEqualToString:strtest1]) {
            
            trackIdIndex = i;
            listRespone.IsDeviceplay = NO;
            self.strTracid = listRespone.trackId;
              [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
        }
        else{
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
//            head.myImageView.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16,19, 14);
            
//            head.nameLabel.frame =  CGRectMake(CGRectGetMaxX(head.myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
             head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
   
            head.leftImage.selected = NO;
//            [self startAnimation:head.myImageView];
            
            
            
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

- (void)getReSourceTag
{
   
    
    self.strTracid = nil;
    NSDictionary *parameter = @{@"pageNum" :@1,@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [self startLoading];
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
//            if (self.Qcateoryarr.count > 0) {
//                [self.Qcateoryarr removeAllObjects];
//            }
            
            
            self.Qcateoryarr = response.data.list;
            

            
            if (self.Qcateoryarr.count>0) {
                
                for (int i = 0; i<self.Qcateoryarr.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                
                
                [self loadModel];
 
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
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

- (void)getRSourceTag
{
    //    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    NSDictionary *parameter = @{@"pageNum" :@1,@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    [self startLoading];
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            

            
            self.Qcateoryarr = response.data.list;
            
            
            if (self.Qcateoryarr.count>0) {
                
                for (int i = 0; i<self.Qcateoryarr.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                [self.tableView reloadData];
    
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
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


- (void)getSourceTag
{
    //    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    NSDictionary *parameter = @{@"pageNum" :@1,@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    NSLog(@"sdfsdfsdSocllListView%@",[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    [self startLoading];
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            self.Qcateoryarr = response.data.list;
            
            self.playSaveArray =response.data.list;
            
            self.pageStr = response.data.pages;

            
            if (self.Qcateoryarr.count>0) {
                
                for (int i = 0; i<self.Qcateoryarr.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self loadModel];
                
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }
        else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else{
            
            
            [self showToastWithString:response.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}

//#pragma mark --获取点播列表
//- (void)GetDemand
//{
//    
//    
//    [self startLoading];
//    
//    [QMineRequestTool GetDemandName:@"13243727535" success:^(id response) {
//        
//        [self stopLoading];
//        
//        self.Qcateoryarr = [QDemandResultRespone mj_objectArrayWithKeyValuesArray:response];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.playSaveDataArray =self.Qcateoryarr;
//        
//        if (self.Qcateoryarr.count>0) {
//            
//            [self loadModel];
//            
//            [self.tableView reloadData];
//            
//        }else{
//            
//            [self showToastWithString:@"没有数据"];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [self stopLoading];
//        
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
//    }];
//}



//- (void)GetAlbum:(NSString *)ualbumId Page:(NSString*)pagenum Count:(NSString *)count{
//
//    NSString *name = [NSString stringWithFormat:@"ualbumId=%@&upagenum=%@&upagecount=20",ualbumId,pagenum];
//
//    [QMineRequestTool getAlbumListName:name success:^(QAlbumResponse *response) {
//
//
//        self.Qcateoryarr = response.result;
//
//        [self loadModel];
//
//        [self.tableView reloadData];
//
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}

- (void)loadModel{
    _currentRow = -1;
    self.headViewArray = [[NSMutableArray alloc] init];
    
    for(int i = 0;i< self.Qcateoryarr.count ;i++)
    {
        QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
//        listRespone.IsDeviceplay = YES;
        
        QHeadView *qheadview = [[QHeadView alloc] init];
        qheadview.delegate = self;
        qheadview.section = i;
        
        if (IsPlayButton&&_currentListenSection==i) {
            
            IsListenButton =YES;
            listRespone.isListening = YES;
            
            
        }
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [qheadview.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString]];
        [qheadview.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
        
        if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
            
            [qheadview.addBtn setEnabled:NO];
        }
        else
        {
            [qheadview.addBtn setEnabled:YES];
        }
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)LoadChlidView
{
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 33 - kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    self.pageNum =1;
    [self pullRefresh];
    
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark UITableView + 上拉刷新
- (void) pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    self.pageNum++;
    
    NSLog(@"[self.qSourceTagData.pages intValue]======%d",[self.qSourceTagData.pages intValue]);
    
    if (self.pageNum >  [self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSDictionary *parameter = @{@"pageNum" :[NSString stringWithFormat:@"%ld", (long)self.pageNum],@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            //            if (self.Qcateoryarr.count > 0) {
            //                [self.Qcateoryarr removeAllObjects];
            //            }
            //
            
            // self.Qcateoryarr = response.data.list;
            
//            
//            NSMutableArray *AlbumReArray = (NSMutableArray*)respone.data.list;
//            
//            
//            if (AlbumReArray.count>0) {
//                
//                for (int i = 0; i<AlbumReArray.count; i++)
//                {
//                    QAlbumDataTrackList *listRespone = AlbumReArray[i];
//                    listRespone.IsDeviceplay = YES;
//                }
//                
//                
//                [self.AlbumArray addObjectsFromArray:AlbumReArray];
//                
//                
//                [self loadModel];
//                [self KeepDemandNor];
//                
//                [self.tableView reloadData];
            
            
            NSMutableArray *QcateoryReArray = (NSMutableArray*)response.data.list;
            
//            [self.Qcateoryarr addObjectsFromArray:response.data.list];
            
            if (QcateoryReArray.count>0) {
                
                for (int i = 0; i< QcateoryReArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = QcateoryReArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self.Qcateoryarr addObjectsFromArray:QcateoryReArray];
                
                [self loadModel];
                
                [self KeepDemandNor];
                
                [self.tableView reloadData];
                
                  [self GetPlayingTrackId];
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
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
    //    return [self.headViewArray objectAtIndex:section];
    
    
    
    QHeadView* headView = [self.headViewArray objectAtIndex:section];
    
    
    if (IsListenButton) {
        
        QAlbumDataTrackList *listRespone  = self.Qcateoryarr[section];
        
        if (listRespone.isListening) {
            NSLog(@"indexPath.section===%ld",section);
            headView.timeView.hidden = YES;
            headView.timeLabel.hidden = YES;
            
            if (self.playerView==nil) {
                
                self.playerView =[[MusicPlayerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.leftImage.frame) + 11, CGRectGetMaxY(headView.nameLabel.frame)+ 12,  kDeviceWidth -120, 15)];
                
                NSLog(@"===================888======================");
                self.playerView.musicPlayerDelegate = self;
                self.playerView.timeNowLabel.textColor =NavBackgroundColor;
                self.playerView.timeTotalLabel.textColor =NavBackgroundColor;
                
                
                //self.playerView.backgroundColor = NavBackgroundColor;
            }
            
            
            NSLog(@"section==%ld",(long)section);
            NSLog(@"_currentListenSection==%ld",(long)_currentListenSection);
            
            if (section==_currentListenSection) {
                
                NSLog(@"======fdsafdsa====一样啊啊啊");
                
            }
            //是否存在正在播放的歌曲
            if (_IsPlaying) {
                
                if (section==_currentListenSection) {
                    
                    [self.playerView playControl];
                    
                }else{
                    _currentListenSection=section;
                    VedioModel *model = [[VedioModel alloc]init];
                    model.musicURL = listRespone.playUrl;
                    [self.playerView changeMusic:model];
                    _IsPlaying = YES;
                    
                }
                
            }else{
                
                _currentListenSection=section;
                VedioModel *model = [[VedioModel alloc]init];
                model.musicURL =listRespone.playUrl;
                [self.playerView setUp:model];
                _IsPlaying = YES;
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
        
        cell.delegate = self;
    }
    
    
    
    
    QHeadView *view = [self.headViewArray objectAtIndex:indexPath.section];
    
    if (view.open) {
        if (indexPath.row == _currentRow) {
            
            
            
        }
    }
    
    QAlbumDataTrackList *listRespone = [self.Qcateoryarr objectAtIndex:indexPath.section];
    
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
    
    cell.collectbtn.tag = indexPath.section;
    [cell.collectbtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
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
    
    QAlbumDataTrackList *listRespone = [self.Qcateoryarr objectAtIndex:btn.tag];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : listRespone.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    if (btn.selected) {
        
        [self startLoading];
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
//
                [self showToastWithString:@"收藏成功"];
                //[btn setImage:[UIImage imageNamed:@"icon_shouchang02_sel"] forState:UIControlStateNormal];
            
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
    
    //[self playMusic];
    
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
//- (void)qalbumListCell:(QAlbumListCell *)toolbar btnClickWithType:(BtnType)btnType
-(void)qalbumListCell:(QAlbumListCell *)toolbar listening:(BOOL)ifListening
{
    
    [[QCategoryListViewController getInstance]stopplay:self.index];
    //实现这个播放，把播放的操作放在一个工具类
    
    for (int i=0; i<self.Qcateoryarr.count; i++) {
        
        QAlbumDataTrackList *listRespone = [self.Qcateoryarr objectAtIndex:i];
        if (listRespone.isListening==YES) {
            
            listRespone.isListening = NO;
            [self.tableView reloadData];
            break;
        }
        
    }
    
    NSLog(@"ifListening==%d",ifListening);
    
    if (ifListening) {
        
        QAlbumDataTrackList *listRespone = self.Qcateoryarr[_currentSection];
        listRespone.isListening = YES;
        
        
        [self.tableView reloadData];
        
        
    }else{
        
        
        QAlbumDataTrackList *listRespone = self.Qcateoryarr[_currentSection];
        listRespone.isListening = NO;
        
        [self.tableView reloadData];
    }
    
    IsListenButton =YES;
    IsPlayButton =ifListening;
    
    
    
    
    //    //实现这个播放，把播放的操作放在一个工具类
    //    switch (btnType) {
    //        case BtnTypePlay:
    //            NSLog(@"BtnTypePlay");
    //            //            [[CZMusicTool sharedCZMusicTool] play];
    //           // [self play];
    //            break;
    //        case BtnTypePause:
    //            NSLog(@"BtnTypePause");
    //            //            [[CZMusicTool sharedCZMusicTool] pause];
    //           // [self pause];
    //            break;
    //        case BtnTypePrevious:
    //            NSLog(@"BtnTypePrevious");
    //
    //            //            [self collect];
    //
    //            break;
    //        default:
    //            break;
    //
    //    }
    
}

//- (void)playMusic
//{
//    QSourceTagList *listRespone = self.Qcateoryarr[self.musicIndex];
//
//    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:listRespone.playUrl]]; //在线
//    NSLog(@"playUrl32%@",listRespone.playUrl);
////
////    //       [self.player play];
//}
//
//- (void)play
//{
//    [self.player play];
//}
//- (void)pause
//{
//    [self.player pause];
//}

#pragma mark QHeadViewDelegate
- (void)QHeadViewAddBtnClicked:(QHeadView *)view
{
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    //    QCategoryView *tfSheetView = [[QCategoryView alloc]init];
    //    tfSheetView.delegate = self;
    //    [tfSheetView showInView:self.view];
    
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
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


- (void)palyresetIsplay:(BOOL)isplay
{
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        QHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            if (isplay) {
                
        
                
                QAlbumDataTrackList *listRespone = self.Qcateoryarr[_currentSection];

                
                if (listRespone.IsDeviceplay) {
                    
                    listRespone.IsDeviceplay = NO;
                    
                   [self AddDemandListTagId:self.categoryid TrackId:listRespone.trackId];
                   self.strTracid = listRespone.trackId;
                    NSLog(@"istRespone.trackIcon2 ==%@",listRespone.trackIcon);
                      [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
//                    //第一次点播的时候添加到播放列表
//                    if (!IsAddPlayList) {
//                        
//                        appDelegate.playSaveDataArray =self.playSaveArray;
//                        
//                        IsAddPlayList = YES;
//                    }
                }
                else
                {
//                    NSDictionary *dic = @{@"cmd" : @"resume"};
//
//                    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
                    
                    [self PutDevicesControlMQTT:@"4" ValueStr:@""];
                }
 

                
                
//                head.nameLabel.textColor =NavBackgroundColor;
//                head.myImageView.hidden = YES;
//
//                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
                
                head.nameLabel.textColor =NavBackgroundColor;
                head.myImageView.hidden = YES;
                
                head.leftImage.selected = NO;
                
                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);

                
            }
            else
            {
                
//                NSDictionary *dic = @{@"cmd" : @"pause"};
//                
//                [[HomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
//                
//                head.nameLabel.textColor =[UIColor blackColor];
//                [head.myImageView stopAnimating];
//                head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
//                head.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//                head.myImageView.hidden = YES;
                
                
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
            
            QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
            listRespone.IsDeviceplay = YES;
           // NSLog(@"istRespone.trackIcon1 ==%@",listRespone.trackIcon);
//                [[TMCache sharedCache]setObject:listRespone.trackIcon forKey:@"currentTrackIcon"];
            head.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            head.myImageView.hidden = YES;
            head.leftImage.selected = NO;
            // [head.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
            
            head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
            
            
//            QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
//            listRespone.IsDeviceplay = YES;
//            
//            head.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//            head.myImageView.hidden = YES;
//            head.leftImage.selected = NO;
////            [head.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
//            
//            head.nameLabel.frame = CGRectMake(CGRectGetMaxX(head.leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(head.leftImage.frame) - 11, 16);
//            
//            
////            resultRespone= appDelegate.playSaveDataArray[i];
////            resultRespone.isPlaying = NO;
            
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

//- (void)backForePage
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    if (_IsPlaying) {
//        [self.playerView removeObserver];//注销观察者
//    }
//}

- (void)AddDemandListTagId:(NSString *)tagId TrackId:(NSString *)trackid
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"listId" :tagId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"type" :@"5"};
    
    [QMineRequestTool PostGeneralDemandTracks:parameter success:^(QSongDetails *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"点播专辑成功。。。。。。。");
            
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


//- (void)AddDemandListTagId:(NSString *)tagId TrackId:(NSString *)trackid
//{
//    //    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
//    
//    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"tagId" :tagId  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
//    
//    [QCategoryRequestTool PostDemandSourceTags:parameter success:^(QSongDetails *respone) {
//        
//        if ([respone.statusCode isEqualToString:@"0"]) {
//            
//            
//            
//        }else if([respone.statusCode isEqualToString:@"3705"])
//        {
//            
//            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//            
//            
//        }
////        else if([respone.statusCode isEqualToString:@"6608"])
////        {
////            NSLog(@"sfdlfjldfjdfdf");
////
////
////            [[HomeViewController getInstance] offDeviceStaues];
////
////
////        }
//        else
//        {
//            
//            [self showToastWithString:respone.message];
//        }
//        
//        
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//          [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//        
//    }];
//    
//}

#pragma mark -- QPlayListViewDelegate
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model
{
    [self addPlayListsectionIndex:self.viewIndex selectModel:model];
    
    
    
}

- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    QAlbumDataTrackList *listRespone = self.Qcateoryarr[sectionIndex];
    
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : listRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            

//            
//            [self getSourceTag];
//
            [self showToastWithString:@"添加成功"];
            
    
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

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
    
    
    [self GetPlayingTrackId];
    
//    if (self.strTracid.length !=0) {
//        //self.strTracid = nil;
//        
//        
//        for (int i = 0; i < self.Qcateoryarr.count; i++) {
//            
//            QAlbumDataTrackList *listrespone1 = [self.Qcateoryarr objectAtIndex:i];
//            
//            if ([listrespone1.trackId isEqualToString:self.strTracid1]&&self.IsDeviceplay1) {
//                
//                listrespone1.isPlaying = YES;
//                listrespone1.IsDeviceplay = NO;
//                
//            }else{
//                
//                
//                listrespone1.isPlaying = NO;
//                listrespone1.IsDeviceplay = NO;
//            }
//            
//            
//            
//        }
//        
//        
//        [self .tableView reloadData];
//    }

    
    
//    if (self.tableView) {
//        
//        BOOL ondemand = NO;
//        
//        if (appDelegate.playSaveDataArray.count>0) {
//            
//            for (int i=0; i<appDelegate.playSaveDataArray.count; i++) {
//                
//                
//                QAlbumDataTrackList *respone = appDelegate.playSaveDataArray[i];
//                
//                if (respone.isPlaying == YES) {
//                    
//                    _currentSection =i;
//                    
//                    IsRefreshPlay = NO;
//                    ondemand = YES;
//                    
//                    break;
//                }
//            }
//        }
//        
//        [self palyresetIsplay:ondemand];
//    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    NSLog(@"即将消失");
   
 
        
    if (_IsPlaying) {
        [self.playerView removeObserver];//注销观察者
    }
        
    

}


#pragma mark MusicPlayerViewDelegate
//播放失败的代理方法
-(void)playerViewFailed{
      _IsPlaying =NO;
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
    if (_IsPlaying) {
        
        
        
        [self.playerView removeObserver];//注销观察者
        _IsPlaying = NO;
        
        //self.playerView=nil;
        for (int i=0; i<self.Qcateoryarr.count; i++) {
            
            QAlbumDataTrackList *listRespone= [self.Qcateoryarr objectAtIndex:i];
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
//
//        if (_IsPlaying) {
//
//
//
//            [self.playerView removeObserver];//注销观察者
//            _IsPlaying = NO;
//
//            for (int i=0; i<self.Qcateoryarr.count; i++) {
//
//                QAlbumDataTrackList *listRespone = [self.Qcateoryarr objectAtIndex:i];
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
