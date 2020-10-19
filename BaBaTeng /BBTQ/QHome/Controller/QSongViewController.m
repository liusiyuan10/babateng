//
//  QSongViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSongViewController.h"
#import "Header.h"
#import "RDVTabBarController.h"
#import "BBTHttpTool.h"
//#import "Q2PlayListViewCell.h"
#import "QSongCell.h"

#import "AFNetworking.h"


#import "QMineRequestTool.h"
//#import "QTrackList.h"
//#import "QTrackListResponse.h"
#import "QSongListViewController.h"


#import "QSong.h"
#import "QSongData.h"
#import "QSongDataList.h"

#import "UIImageView+AFNetworking.h"

#import "HomeViewController.h"
#import "NewHomeViewController.h"

@interface QSongViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)  NSMutableArray *trackcountArticles; //推荐列表

@property(strong,nonatomic) UILabel *tableLabel;

@property (nonatomic, strong)   QSongData *qSongData;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   NSString *sign;

@end

@implementation QSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"宝贝歌单";
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.trackcountArticles = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppSongPlay:) name:@"AppSongPlay" object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)AppSongPlay:(NSNotification *)noti
{
    
    [appDelegate AnimationOutsidePlay:self.sign];
    
}



- (void)LoadChlidView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight )style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    self.pageNum = 1;
    [self pullRefresh];
    
    
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 41)];
    //    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    //
    //    self.tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, kDeviceWidth - 38, 12)];
    //    self.tableLabel.text = [NSString stringWithFormat:@"默认列表/%ld",self.trackcountArticles.count];
    //    self.tableLabel.font = [UIFont systemFontOfSize:12.0];
    //    self.tableLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    //    [self.tableView.tableHeaderView addSubview:self.tableLabel];
    
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
    
    if (self.pageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    [QMineRequestTool GetDeviceSongLists:deviceId pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(QSong *respone) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qSongData = respone.data;


            
            self.trackcountArticles = self.qSongData.list;

            
            
            if (self.trackcountArticles.count>0) {

                
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
        
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.trackcountArticles.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSString *CellIdentifier = @"songcellID";
    QSongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[QSongCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //        cell.backgroundColor = [UIColor whiteColor];
    }
    
    QSongDataList *listresponse = [self.trackcountArticles objectAtIndex:indexPath.row];
    
    
    cell.labTip.text = listresponse.deviceSongListName;
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@ 首",listresponse.trackCount];
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listresponse.deviceSongListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"gengduo"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSongDataList *listresponse = [self.trackcountArticles objectAtIndex:indexPath.row];
    
    QSongListViewController *songListVc = [[QSongListViewController alloc]init];
    songListVc.QResponse = listresponse;
    
    [self.navigationController pushViewController:songListVc animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self GetDeviceSongLists];
    
    self.sign = @"QSongViewController";
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
      [super viewWillDisappear:animated];
     // self.sign = @" ";

}

- (void)GetDeviceSongLists
{
    
    
    NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    [self startLoading];
    [QMineRequestTool GetDeviceSongLists:deviceId pageNum:@"1" success:^(QSong *respone) {
        
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qSongData = respone.data;
            NSLog(@"点播历史列表result11=====%@", self.qSongData);
//            [self LoadChlidView];
            
            NSLog(@"点播历史===%lu",(unsigned long)self.qSongData.list.count);
            
            self.trackcountArticles = self.qSongData.list;
            NSLog(@"点播历史1===%lu",(unsigned long) self.trackcountArticles.count);
            
            self.pageStr = respone.data.pages;
            
            
            if (self.trackcountArticles.count>0) {
                
                //            self.tableLabel.text = [NSString stringWithFormat:@"历史点播/%lu",(unsigned long)self.DemandArticles.count];
                
                
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
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
    
    //    [self startLoading];
    //
    //    [QMineRequestTool GetTrackListCountName:@"Customer0223_23" success:^(id response) {
    //        [self stopLoading];
    //
    //        self.trackcountArticles = [QTrackListResponse mj_objectArrayWithKeyValuesArray:response];
    //
    //        if (self.trackcountArticles.count>0) {
    //            self.tableLabel.text = [NSString stringWithFormat:@"默认列表/%ld",self.trackcountArticles.count];
    //            [self.tableView reloadData];
    //
    //        }else{
    //
    //
    //            [self showToastWithString:@"没有数据"];
    //        }
    //
    //
    //
    //    } failure:^(NSError *error) {
    //
    //        [self stopLoading];
    //        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
    //
    //    }];
    
}




@end

