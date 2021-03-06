//
//  ViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//
//  QDemandViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//
//  BBTDemandViewController.m
//  BaBaTeng
//
//  Created by liu on 17/2/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QFavoriteViewController.h"
#import "RDVTabBarController.h"
#import "Header.h"
#import "QFavoriteCell.h"

#import "QFavoriteRespone.h"
#import "QFavoriteResultRespone.h"
#import "QMineRequestTool.h"
#import "QPlayListView.h"

#import "QHomeRequestTool.h"
#import "QFavorite.h"
#import "QFavoriteData.h"
//#import "QFavoriteDataList.h"
#import "QAlbumDataTrackList.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "QAddSong.h"
#import "QSongDataList.h"
#import "HomeViewController.h"


#import "QPlayingTrack.h"
#import "QPlayingTrackData.h"
#import "QSongDetails.h"

#import "QPlayingTrackList.h"
#import "NewHomeViewController.h"
#import "BBTCustomViewRequestTool.h"


@interface QFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource,QPlayListViewDelegate>
{
    QAlbumDataTrackList *resultRespone2;
    QAlbumDataTrackList *resultRespone1;
}

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)     NSMutableArray *FavoriteArticles; //推荐列表

@property(nonatomic, assign)    NSInteger favoriteIndex;
@property(nonatomic, strong)    UILabel *tableLabel;
@property (nonatomic,strong)    UIButton  *myEditButton;
@property (nonatomic,assign)    BOOL IFEditButton;
@property (strong, nonatomic)   UIView *footerView;
@property (nonatomic, strong)   UIButton *deleteBtn;
@property (nonatomic, strong)   UIButton *selectAllBtn;
@property(nonatomic, strong)   NSMutableArray *deleteArr;//删除数据的数组
@property(nonatomic, strong)   NSMutableArray *deleteArrCount;//记录删除的行数

@property (nonatomic, strong)   NSString *strTracid;


@property(nonatomic, assign) BOOL  IsDeviceplay1;//是否正在试听
@property (nonatomic, strong)   NSString *strTracid1;

@property (nonatomic, assign)   NSInteger pageNum;

@property (nonatomic, strong)   QFavoriteData *qFavoriteData;
@property (nonatomic, strong)   NSString *pageStr;
@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation QFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"宝贝最爱";
    
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    
    
    self.deleteArr = [NSMutableArray array];
    self.deleteArrCount = [NSMutableArray array];
    
    [self LoadChlidView];
    
    self.FavoriteArticles = [[NSMutableArray alloc]init];

    [self getFavoriteList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QFavorite:) name:@"QFavorite" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QFavoritePlay:) name:@"QFavoritePlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [self getFavorite];
    
}
- (void)autoRefreshing
{
//    NSLog(@"只dsdfdsg");
//    [self performSelector:@selector(getReFavoriteList) withObject:nil afterDelay:1.0];
    
    
    self.strTracid = nil;
    self.strTracid1 = nil;
    
    for (int i = 0; i < self.FavoriteArticles.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
        listrespone.IsDeviceplay = YES;
        listrespone.isPlaying = NO;
    }
    [self.tableView reloadData];
 
    [self performSelector:@selector(GetPlayingTrackId) withObject:nil afterDelay:1.0];
    
    
}


- (void)GetPlayingTrackId
{
    
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


- (void)QFavoritePlay:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    
//    if ([strtest1 isEqualToString:@"playing"]) {
//        
//        self.IsDeviceplay1 = YES;
//        
//    }else
//    {
//        self.IsDeviceplay1 = NO;
//        
//    }

    
    for (int i = 0; i < self.FavoriteArticles.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
        NSLog(@"listrespone.trackId======%@,self.strTracid======%@",listrespone.trackId,self.strTracid);
        
        
        if ([listrespone.trackId isEqualToString:self.strTracid]) {
            
            if ([strtest1 isEqualToString:@"playing"]) {
                 IsPlay =YES;
                listrespone.isPlaying = YES;
                listrespone.IsDeviceplay = NO;
                
            }else
            {
                  IsPlay = NO;
                listrespone.isPlaying = NO;
                listrespone.IsDeviceplay = NO;
            }
            
            
        }
        
    }
   
    [self.tableView reloadData];
    
}




- (void)QFavorite:(NSNotification *)noti
{
    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"trackId"]];
    
    NSString *strtest1 = [strtest stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"strtest1====%@",strtest1);
    
    self.strTracid1  =strtest1;
    self.strTracid =strtest1;
    
    for (int i = 0; i < self.FavoriteArticles.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
        
        if ([listrespone.trackId isEqualToString:strtest1]) {
            listrespone.isPlaying = NO;
            listrespone.IsDeviceplay = NO;
            //                        break;
            [[TMCache sharedCache]setObject:listrespone.trackIcon forKey:@"currentTrackIcon"];
        }
        else
        {
            listrespone.isPlaying = NO;
            listrespone.IsDeviceplay = YES;
        }
    }
    
    [self.tableView reloadData];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --收藏列表
- (void)getReFavoriteList
{
    self.strTracid = nil;
    self.strTracid1 = nil;
    
    [self startLoading];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :@1,@"pageSize" :@20};
    
    [self startLoading];
    
    [QHomeRequestTool GetFavoriteParameter:parameter success:^(QFavorite *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            if (self.FavoriteArticles.count > 0) {
                
                [self.FavoriteArticles removeAllObjects];
            }
            
            
            
            
            self.FavoriteArticles = response.data.list;
            
            
            
            if (self.FavoriteArticles.count > 0) {
                
                for (int i = 0; i < self.FavoriteArticles.count; i++) {
                    
                    QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
                    listrespone.IsDeviceplay = YES;
                }
                
                self.myEditButton.hidden = NO;
    
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
            }
            else
            {
                self.myEditButton.hidden = YES;
//                [self showToastWithString:@"暂无内容"];
                
            }
 
            
//            for (int i = 0; i < self.FavoriteArticles.count; i++) {
//                
//                QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
//                listrespone.IsDeviceplay = YES;
//            }
//
//            
//            [self.tableView reloadData];
//            
//            [self GetPlayingTrackId];
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else
        {
            
            [self showToastWithString:response.message];
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
}

#pragma mark --收藏列表
- (void)getFavoriteList
{
    [self startLoading];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :@1,@"pageSize" :@20};
    
    [self startLoading];
    
    [QHomeRequestTool GetFavoriteParameter:parameter success:^(QFavorite *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            if (self.FavoriteArticles.count > 0) {
                
                [self.FavoriteArticles removeAllObjects];
            }
            


            
            self.FavoriteArticles = response.data.list;
            
            self.pageStr = response.data.pages;
     
            
            
            if (self.FavoriteArticles.count > 0) {
                
                for (int i = 0; i < self.FavoriteArticles.count; i++) {
                    
                    QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
                    listrespone.IsDeviceplay = YES;
                }
                
                self.myEditButton.hidden = NO;
              
                [self.tableView reloadData];
                
                [self GetPlayingTrackId];
                
            }
            else
            {
                self.noLabel.hidden = NO;
                self.myEditButton.hidden = YES;
//                [self showToastWithString:@"暂无内容"];
                
            }
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else
        {
            
            [self showToastWithString:response.message];
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        
        
    }];
}


#pragma mark --收藏列表
- (void)getRFavoriteList
{
    [self startLoading];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :@1,@"pageSize" :@5};
    
    [self startLoading];
    
    [QHomeRequestTool GetFavoriteParameter:parameter success:^(QFavorite *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            if (self.FavoriteArticles.count > 0) {
                
                [self.FavoriteArticles removeAllObjects];
            }
            
            self.FavoriteArticles = response.data.list;
            
            if (self.FavoriteArticles.count > 0) {
                
                for (int i = 0; i < self.FavoriteArticles.count; i++) {
                    
                    QAlbumDataTrackList *listrespone = [self.FavoriteArticles objectAtIndex:i];
                    
                    if ([listrespone.trackId isEqualToString:self.strTracid]) {
                        
                        
                        if (IsPlay==YES) {
                            
                            listrespone.isPlaying =YES;
                            
                        }else{
                            
                            listrespone.isPlaying =NO;
                        }
                        
                        
                        //                        break;
                        listrespone.IsDeviceplay = NO;
                    }
                    else
                    {
                        listrespone.isPlaying = NO;
                        listrespone.IsDeviceplay = YES;
                    }
                    
                }
                
                
             
                [self.tableView reloadData];
                
            }
            else
            {
//                [self showToastWithString:@"暂无内容"];
            }
            
            
            
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else
        {
            
            [self showToastWithString:response.message];
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
    }];
}



- (void)LoadChlidView
{
    
    [self setUpNavigationItem];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
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
    
    self.pageNum=1;
    [self pullRefresh];
    
    [self.view addSubview:self.tableView];
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, 50, 100, 30)];
    
    noLabel.text = @"暂无内容";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 41)];
//    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
//    
//    self.tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, kDeviceWidth - 19, 12)];
//    self.tableLabel.text = @"历史点播/6";
//    self.tableLabel.font = [UIFont systemFontOfSize:12.0];
//    self.tableLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
//    [self.tableView.tableHeaderView addSubview:self.tableLabel];
    
    [self setUpFooterView];
    
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
    
    
    
    if (self.pageNum > [self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :[NSString stringWithFormat:@"%ld",(long)self.pageNum],@"pageSize" :@20};
    
    
    
    [QHomeRequestTool GetFavoriteParameter:parameter success:^(QFavorite *response) {
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            self.qFavoriteData =response.data;
            
            self.pageStr = response.data.pages;
            
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;
            
            if (array1.count>0) {
                
                
                
                for (int i = 0; i <array1.count; i++) {
                    
                    QAlbumDataTrackList *listrespone = [array1 objectAtIndex:i];
                    listrespone.IsDeviceplay = YES;
                    
                }
                
                self.myEditButton.hidden = NO;
                [self.FavoriteArticles addObjectsFromArray:array1];
                
                
            }
          
            [self.tableView reloadData];
            
            [self GetPlayingTrackId];
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else
        {
            
            [self showToastWithString:response.message];
            
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络请求失败"];
        
    }];
    
    
    
}



- (void)setUpFooterView
{
    
    //适配iphone x
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight-118-kDevice_Is_iPhoneX*2, kDeviceWidth, 55+kDevice_Is_iPhoneX*2)];
    self.footerView.backgroundColor = [UIColor whiteColor];

    
    
    
    
    //需要画一条横线
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 1)];
    
    topImageView.image = [UIImage imageNamed:@"line.png"];
    
    [self.footerView  addSubview:topImageView];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.selectAllBtn.backgroundColor =[UIColor orangeColor];
    
    self.selectAllBtn.layer.cornerRadius = 15.0f;
    self.selectAllBtn.clipsToBounds = YES;
    [self.selectAllBtn setTitle:@"全 选" forState:UIControlStateNormal];
    
    self.selectAllBtn.frame = CGRectMake((kDeviceWidth-200)/3,12.5, 100, 30);
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.deleteBtn.backgroundColor = [UIColor lightGrayColor];//[UIColor colorWithRed:224.0/255.0f green:22.0/255.0f blue:22.0/255.0f alpha:1];
    self.deleteBtn.clipsToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 15.0f;
    
    [self.deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.deleteBtn.frame = CGRectMake((kDeviceWidth-200)/3*2+100, 12.5, 100,30);
    
    [self.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:self.deleteBtn];
    [self.footerView addSubview:self.selectAllBtn];
    
    [self.view addSubview: self.footerView];
    self.footerView.alpha = 0;
    
    
    
    self.IFEditButton = 0;
    
}

- (void)setUpNavigationItem
{
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:self.myEditButton];
    
    self.navigationItem.rightBarButtonItem = editItem;
    
}

- (UIButton *)myEditButton
{
    if(!_myEditButton)
    {
        _myEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myEditButton.backgroundColor = [UIColor clearColor];
        _myEditButton.frame = CGRectMake(0, 0, 40, 30);
//        _myEditButton.alpha = 1;
//        _myEditButton.clipsToBounds = YES;
//        _myEditButton.layer.cornerRadius =20.0;
//        _myEditButton.layer.borderWidth =1.0;
        _myEditButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [_myEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        _myEditButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_myEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myEditButton addTarget:self action:@selector(goEditButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _myEditButton;
    
}

-(void)goEditButton{
    
    if (self.IFEditButton == 0) {
        self.IFEditButton=1;
        [_myEditButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [[AppDelegate appDelegate]suspendButtonHidden:YES];
        
        self.deleteBtn.backgroundColor = [UIColor lightGrayColor];
        
        self.tableView.frame = CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 120);
        
        
    }else if (self.IFEditButton ==1){
        self.IFEditButton=0;
        [_myEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectAllBtn.selected = NO;
        [self.deleteArr removeAllObjects];
        
        [self.deleteArrCount removeAllObjects];
        
        [[AppDelegate appDelegate]suspendButtonHidden:NO];
        
        self.tableView.frame = CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64);
    }
    //NSLog(@"%d",self.mytableView.editing);
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //self.tableView.editing = !self.tableView.editing;
    
    [self.tableView setEditing:self.IFEditButton animated:YES];
    if (self.FavoriteArticles.count>0) {
        if (self.tableView.editing) {
            [UIView animateWithDuration:0.5 animations:^{
                self.footerView.alpha = 1.0;
                
                
            }];
            
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.footerView.alpha = 0.0;
                
            }];
            
        }
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.FavoriteArticles.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Demcell";
    
    QFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QFavoriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        

        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        
    }
    
    QAlbumDataTrackList *resultRespone = [self.FavoriteArticles objectAtIndex:indexPath.row];
    
    if ([resultRespone.isAddToSongList isEqualToString:@"1"]) {
        
        [cell.rightMiddleImage setEnabled:NO];
    }
    else
    {
        [cell.rightMiddleImage  setEnabled:YES];
    }
      NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resultRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [cell.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString]];
    
    
    cell.nameLabel.text = resultRespone.trackName;
    cell.timeLabel.text = [self getMMSSFromSS:resultRespone.duration];
    
    cell.rightUpImage.tag = indexPath.row;
    cell.rightMiddleImage.tag = indexPath.row;
    
    cell.leftImage.tag = indexPath.row;
    
    cell.leftImage.selected =resultRespone.isPlaying;
    
    if( resultRespone.isPlaying==YES){
        
     
        self.strTracid = resultRespone.trackId;
        
        cell.nameLabel.textColor = NavBackgroundColor;
        cell.myImageView.hidden = NO;
        cell.nameLabel.frame = CGRectMake(CGRectGetMaxX(cell.myImageView.frame) + 8, 16, kDeviceWidth -CGRectGetMaxX(cell.leftImage.frame) - 21  - 40-20, 16);
        // cell.myImageView.frame = CGRectMake(10, 13,19, 14);
        
        [self startAnimation:cell.myImageView];
        
    }else{
        
        if (resultRespone.IsDeviceplay) {
            
            cell.nameLabel.textColor = [UIColor blackColor];
            [cell.myImageView stopAnimating];
            cell.nameLabel.frame = CGRectMake(CGRectGetMaxX( cell.leftImage.frame) + 8, 16, kDeviceWidth -CGRectGetMaxX(cell.leftImage.frame) - 21  - 40-20, 16);
            cell.myImageView.hidden = YES;
            
        }
        else
        {
            cell.nameLabel.textColor = NavBackgroundColor;
            [cell.myImageView stopAnimating];
            cell.nameLabel.frame = CGRectMake(CGRectGetMaxX( cell.leftImage.frame) + 8, 16, kDeviceWidth -CGRectGetMaxX(cell.leftImage.frame) - 21  - 40-20, 16);
            cell.myImageView.hidden = YES;
        }
        
//         cell.nameLabel.textColor = [UIColor blackColor];
//        [cell.myImageView stopAnimating];
//        cell.nameLabel.frame = CGRectMake(CGRectGetMaxX( cell.leftImage.frame) + 8, 16, kDeviceWidth -CGRectGetMaxX(cell.leftImage.frame) - 21  - 40-20, 16);;
//        cell.myImageView.hidden = YES;
    }
    
    
    
    
    [cell.rightUpImage setImage:[UIImage imageNamed:@"icon_tianjia_nor"] forState:UIControlStateNormal];
    
    [cell.leftImage addTarget:self action:@selector(leftImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.rightUpImage addTarget:self action:@selector(rightUpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightMiddleImage addTarget:self action:@selector(rightMiddleClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
//    if(indexPath.row == 0)
//    {
//        cell.selected = YES;
//    }
    
    if (self.tableView.editing) {
        
        [self KeepCurrentSelection];
        
    }
    
    return cell;
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

//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        
        
        [self.deleteArr addObject:[self.FavoriteArticles objectAtIndex:indexPath.row]];
        
        NSString *strRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self.deleteArrCount addObject:strRow];
        
        self.deleteBtn.backgroundColor = [UIColor orangeColor];
        
        if (self.deleteArr.count == self.FavoriteArticles.count)
        {
            [self.selectAllBtn setTitle:@"全不选" forState:UIControlStateNormal];
            self.selectAllBtn.selected = YES;
        }
        
    }
    
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.deleteArr removeObject:[self.FavoriteArticles objectAtIndex:indexPath.row]];
    
    NSString *strRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.deleteArrCount removeObject:strRow];
    
    if (self.deleteArr.count == 0) {
        
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectAllBtn.selected = NO;
        self.deleteBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

//全选
- (void)selectAllBtnClick:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        self.deleteBtn.backgroundColor = [UIColor orangeColor];
        [button setTitle:@"全不选" forState:UIControlStateNormal];
        
        [self.deleteArrCount removeAllObjects];
        
        for (int i = 0; i < self.FavoriteArticles.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            NSString *strRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [self.deleteArrCount addObject:strRow];
            
        }
        
        [self.deleteArr removeAllObjects];
        
        [self.deleteArr addObjectsFromArray:self.FavoriteArticles];
        
    }
    else
    {
        self.deleteBtn.backgroundColor = [UIColor lightGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        for (int i = 0; i < self.FavoriteArticles.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
        [self.deleteArr removeAllObjects];
     [self.deleteArrCount removeAllObjects];
        
    }
    
    
    
}

//删除按钮点击事件
- (void)deleteClick:(UIButton *) button {
    
    if (self.tableView.editing) {
        //删除
        //NSMutableArray *deleteArrTwo = [NSMutableArray array];
        
        if (self.deleteArr.count == 0) {
            return;
        }
        
//        [self.FavoriteArticles removeObjectsInArray:self.deleteArr];
        

        
        
        NSMutableArray *bodyarr = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i < self.deleteArr.count; i++) {
            
            QAlbumDataTrackList *resultRespone = [self.deleteArr objectAtIndex:i];
            
            [bodyarr addObject:resultRespone.trackId];
            
        }
        
       
        
        NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
        
        [self startLoading];
        
        [QHomeRequestTool DeleteFavoriteParameter:parameter bodyArr:bodyarr success:^(QAddSong *response) {
            

            [self stopLoading];


            if ([response.statusCode isEqualToString:@"0"]) {

                [self showToastWithString:@"删除成功"];
                
                [self.FavoriteArticles removeObjectsInArray:self.deleteArr];
                
                [self.deleteArr removeAllObjects];
                
                [self.deleteArrCount removeAllObjects];
              
//                [self.tableView reloadData];
                
                self.tableView.frame = CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64);
                
                self.IFEditButton = 0;
                [self.myEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        
        
                [self showResult];

                


            }else if([response.statusCode isEqualToString:@"3705"])
            {
                
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                
                
            }else{


                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
        }];

        

        
//        self.IFEditButton = 0;
//        [self.myEditButton setTitle:@"编辑" forState:UIControlStateNormal];
//
//
//        [self showResult];
        
        
    }
    else return;
}



-(void)showResult{
    
//    if (self.FavoriteArticles.count==0) {
//        
//        if (self.tableView.editing) {
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                self.footerView.alpha = 0.0;
//                
//            }];
//            
//        }
//        
//        self.tableView.hidden = YES;
//        
//    }else{
//        
//        
//        self.tableView.hidden = NO;
//        [self.tableView reloadData];
//    }
    
    
    if (self.FavoriteArticles.count==0) {
        
        if (self.tableView.editing) {
            
            [UIView animateWithDuration:0.0 animations:^{
                self.footerView.alpha = 0.0;
                
            }];
            
        }
        
        self.myEditButton.hidden = YES;
        
//        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
//        self.selectAllBtn.selected = YES;
        
        self.pageNum =0;
        
         [self loadMoreData];
        
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.selectAllBtn.selected = NO;
        
        //        self.tableView.hidden = YES;
        
        [self.tableView reloadData];
        
    }else{
        
        
        self.tableView.hidden = NO;
    
        [self.tableView reloadData];
    }
    
    [self.tableView setEditing:self.IFEditButton animated:YES];
    if (self.tableView.editing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 1.0;
            
            
        }];
        
    } else {
        [UIView animateWithDuration:0.0 animations:^{
            self.footerView.alpha = 0.0;
            
        }];
        
    }
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
}


- (void)leftImageClicked:(UIButton *)btn
{
    
    
//    resultRespone2= [self.FavoriteArticles objectAtIndex:btn.tag];
//    
//    if (resultRespone2.isPlaying==YES) {
//        
//        resultRespone2.isPlaying = NO;
//        
//        
//    }else{
//        
//        for (int i=0; i<self.FavoriteArticles.count; i++) {
//            
//            resultRespone1= [self.FavoriteArticles objectAtIndex:i];
//            
//            if (resultRespone1.isPlaying==YES) {
//                
//                resultRespone1.isPlaying = NO;
//                
//                break;
//            }
//            
//        }
//        
//        resultRespone2.isPlaying = YES;
//        
//        
//        
//    }
    
    //列表编辑的情况下禁止其他操作
    if (self.tableView.editing) {
        
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
    
    
    
    for (int i=0; i<self.FavoriteArticles.count; i++) {
        
        
        resultRespone1= [self.FavoriteArticles objectAtIndex:i];
        
        resultRespone1.isPlaying = NO;
        
        
    }

    
    for (int i = 0;i<self.FavoriteArticles.count; i++) {
        QAlbumDataTrackList  *resultRespone = [self.FavoriteArticles objectAtIndex:i];
        
        if (i == btn.tag) {
            
        }
        else{
            resultRespone.IsDeviceplay = YES;
        }
    }
    
    QAlbumDataTrackList  *resultRespone = [self.FavoriteArticles objectAtIndex:btn.tag];
    self.strTracid = resultRespone.trackId;
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        if (resultRespone.IsDeviceplay) {
            resultRespone.IsDeviceplay = NO;
           // NSLog(@"sb");
            
            
            [self AddDemandListFavoriteTrackId:resultRespone.trackId];
            
//            //第一次点播的时候添加到播放列表
//            if (!IsAddPlayList) {
//                
//                appDelegate.playSaveDataArray =self.playSaveArray;
//                
//                IsAddPlayList = YES;
//            }
            
        }
        else
        {
            
//            NSDictionary *dic = @{@"cmd" : @"resume"};
//
//
//            [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
            
            [self PutDevicesControlMQTT:@"4" ValueStr:@""];
            
            NSLog(@"sb1");
            
            
        }
        
        NSLog(@"btn.tag==================%ld",(long)btn.tag);
        
//        resultRespone= appDelegate.playSaveDataArray[btn.tag];
//        resultRespone.isPlaying = YES;
        
    }else
    {
        NSLog(@"sb2");
        
//        NSDictionary *dic = @{@"cmd" : @"pause"};
//
//
//
//        [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
        
        [self PutDevicesControlMQTT:@"3" ValueStr:@""];
        
//        resultRespone= appDelegate.playSaveDataArray[btn.tag];
//        resultRespone.isPlaying = NO;
    }
    
    
       [[TMCache sharedCache]setObject:resultRespone.trackIcon forKey:@"currentTrackIcon"];
   
    [self.tableView reloadData];

    
    
    
}





- (void)rightMiddleClicked:(UIButton *)btn
{
    
    //列表编辑的情况下禁止其他操作
    if (self.tableView.editing) {
        
        return;
    }
    
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
    self.favoriteIndex = btn.tag;
    
}

#pragma mark --进行收藏操作
- (void)rightUpClicked:(UIButton *)btn
{
}


#pragma mark - Q3PlayListView
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model{
    
    
    [self addPlayListsectionIndex:self.favoriteIndex selectModel:model];
}

- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
  
    QAlbumDataTrackList *resultRespone = [self.FavoriteArticles objectAtIndex:sectionIndex];
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : resultRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"添加成功"];
            
           // [self getRFavoriteList];
            //前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
   
            resultRespone.isAddToSongList=@"1";
            
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
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

- (void)AddDemandListFavoriteTrackId:(NSString *)trackid
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"listId" :@"1"  ,@"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"type" :@"7"};
    
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

//- (void)AddDemandListFavoriteTrackId:(NSString *)trackid
//{
//    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"], @"trackId" : trackid, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
//    [QHomeRequestTool PostDemanddeviceFavorite:parameter success:^(QSongDetails *respone) {
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
////            //            [self offDeviceStaues];
////
////            [[HomeViewController getInstance] offDeviceStaues];
////
////            //            [self.navigationController popToRootViewControllerAnimated:YES];
////
////        }
//        else
//        {
//
//            [self showToastWithString:respone.message];
//        }
//
//
//    } failure:^(NSError *error) {
//
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
//    }];
//
//}

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
     [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
      [self GetPlayingTrackId];
    
    if (self.strTracid.length !=0) {
        //self.strTracid = nil;
        
        for (int i = 0; i < self.FavoriteArticles.count; i++) {
            
            QAlbumDataTrackList *listrespone1 = [self.FavoriteArticles objectAtIndex:i];
            
            if ([listrespone1.trackId isEqualToString:self.strTracid1]) {
                
                listrespone1.isPlaying = YES;
                listrespone1.IsDeviceplay = NO;
                
            }else{
                
                
                listrespone1.isPlaying = NO;
                listrespone1.IsDeviceplay = YES;
                
            }
        }
        [self .tableView reloadData];
    }

    
}

- (void)RefreshingList
{
    
    [self GetPlayingTrackId];
    
    if (self.strTracid.length !=0) {
        
        //self.strTracid = nil;
        for (int i = 0; i < self.FavoriteArticles.count; i++) {
            
            QAlbumDataTrackList *listrespone1 = [self.FavoriteArticles objectAtIndex:i];
            
            if ([listrespone1.trackId isEqualToString:self.strTracid1]) {
                
                listrespone1.isPlaying = YES;
                listrespone1.IsDeviceplay = NO;
                
            }else{
                
                listrespone1.isPlaying = NO;
                listrespone1.IsDeviceplay = YES;
            }
            
            
        }
        
        [self .tableView reloadData];
    }
}

-(void)KeepCurrentSelection{
    
//     if (self.tableView.editing) {
//
//         for (int i=0; i<3; i++) {
//
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//
//            [self.tableView selectRowAtIndexPath: indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//         }
//
//
//
//    }
    
    
     if (self.tableView.editing) {

         for (int i=0; i< self.deleteArrCount.count; i++) {
             
             NSString *strRow = [self.deleteArrCount objectAtIndex:i];
             

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[strRow integerValue] inSection:0];

            [self.tableView selectRowAtIndexPath: indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
         }

    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
}



@end

