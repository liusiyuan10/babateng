//
//  QSearchAlbumViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/24.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//


#import "BSearchAlbumViewController.h"
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

#import "BPlayTestViewController.h"

#import "BAlbumCell.h"

@interface BSearchAlbumViewController ()<QSegmentToolCellDelegate,UITableViewDelegate,UITableViewDataSource,QAlbumListCellDelegate,UIGestureRecognizerDelegate,QAlbumDetailViewDelegate,QPlayListViewDelegate>

@property (nonatomic, strong) QSegmentTool *segmentTool;



@property(assign, nonatomic)NSInteger viewIndex;//当前播放音乐索引



@property (nonatomic, strong) UIView *HeadView;

@property (nonatomic, strong) NSMutableArray *AlbumArray;
@property (nonatomic, strong) NSMutableArray *playSaveArray;

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


@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;

@property (nonatomic, assign)  BOOL ifpresent;

@end

@implementation BSearchAlbumViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    
    self.PageNum = 1;
    
    [self GetTrackLists];
    
    [self getTrackListDetail];
    
    
    //    [self LoadChlidView];

    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                

                
                [self.tableView reloadData];
                
                
            }
//            else if([respone.statusCode isEqualToString:@"3705"])
//            {
//                
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//                
//                
//            }
            else{
                
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
                
                
                [self.tableView reloadData];
                

                
                
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }
        else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else{
            
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

    
    if (encodedString.length == 0) {
        
        [self.button setImage:[UIImage imageNamed:@"bar_bfq_nor"] forState:UIControlStateNormal];
    }
    else
    {
        [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
        
    }
    
    
//    [self.button sd_setImageWithURL:[NSURL URLWithString:  encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
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

- (void)buttonClicked
{
    
//    QCustomViewController * qCustom = [[QCustomViewController alloc] init];
    if (appDelegate.playSaveDataArray.count == 0) {
        [self showToastWithString:@"您还没有播放歌单"];
        
        return;
    }
    
    
    BPlayTestViewController *bplayC = [BPlayTestViewController sharedInstance];
    
    UINavigationController *qCustomrNav = [[UINavigationController alloc]
                                           initWithRootViewController:bplayC];
    
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

    [self.backScrollView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
    
    
    [self.tableView reloadData];
}


-(void)showIntroduceView{
    
  
    [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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

#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 65;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.AlbumArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"qsearchalbumlistcell";
    
    BAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[BAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[indexPath.row];
    
    if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
        
        [cell.rightMiddleImage setEnabled:NO];
    }
    else
    {
        [cell.rightMiddleImage  setEnabled:YES];
    }
    
    cell.nameLabel.text = listRespone.trackName;
    cell.timeLabel.text = [self getMMSSFromSS:listRespone.duration];
    [cell.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:listRespone.trackIcon]];
    
    
    cell.leftImage.tag = indexPath.row;
    
    [cell.leftImage addTarget:self action:@selector(leftImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([listRespone.isCollected isEqualToString:@"1"]) {
        
        cell.rightUpImage.selected = YES;
        
    }
    else
    {
        cell.rightUpImage.selected = NO;
        
    }
    
    cell.rightUpImage.tag = indexPath.row;
    cell.rightMiddleImage.tag = indexPath.row;
    
    [cell.rightUpImage addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.rightMiddleImage addTarget:self action:@selector(rightMiddleImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (void)leftImageClicked:(UIButton *)btn
{

    appDelegate.playSaveDataArray = self.AlbumArray;
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[btn.tag];
    
    
    [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
    
    NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
    
    [[BPlayTestViewController sharedInstance] testPlay:btn.tag];
    
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
                
                [self.tableView reloadData];
                
 
                

                
            }
//            else if([response.statusCode isEqualToString:@"6500"])
//            {
//                
//                listRespone.isCollected = @"1";
//                
//
//                
//                
//                [self showToastWithString:response.message];
//                
//            }
//            else if([response.statusCode isEqualToString:@"3705"])
//            {
//
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//            }
            else{
                
                
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
                [self.tableView reloadData];
      
            }
//            else if([response.statusCode isEqualToString:@"6501"])
//            {
//
//                listRespone.isCollected = @"0";
//
//
//
//                [self showToastWithString:response.message];
//
//            }else if([response.statusCode isEqualToString:@"3705"])
//            {
//
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
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


- (void)rightMiddleImageClick:(UIButton *)btn
{
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
    
    self.viewIndex =btn.tag;
    
    
}


- (void)backForePage
{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    

    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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


@end


