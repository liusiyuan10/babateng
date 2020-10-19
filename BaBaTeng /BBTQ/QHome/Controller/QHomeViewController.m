//
//  QHomeViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QHomeViewController.h"
#import "CustomRootViewController.h"

#import "PYSearch.h"
#import "QSearchViewController.h"

#import "QMineRequestTool.h"
#import "QDeviceInfoRespone.h"

#import "Header.h"
#import "UIImageView+AFNetworking.h"
#import "TMCache.h"
#import "MyButton.h"

#import "NewFYtopbannerViewCell.h"
#import "MJRefresh.h"
#import "SwipeView.h"

#import "QDemandViewController.h"
#import "QTalkViewController.h"
#import "QFavoriteViewController.h"
#import "QSongViewController.h"
#import "QDeviceControlViewController.h"
#import "QAlbumViewController.h"
#import "QAlbumListViewController.h"

#import "QPanel.h"
#import "QPanelData.h"
#import "QPanelDataTrackList.h"
#import "NewBulletin.h"
#import "BBTEquipmentRequestTool.h"
#import "NewBulletinData.h"
#import "BulletinViewController.h"

#import "QModule.h"
#import "QModuleData.h"

#import "HomeViewController.h"

#import "BAlbumViewController.h"

#import "FMHorizontalMenuView.h"

#import <Masonry.h>

#import "NewQAlbumListViewController.h"
#import "OrdeyByQAlbumListViewController.h"

#define KTitleHeight 52
@interface QHomeViewController () <PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,NewFYtopbannerViewCellDelegate,SwipeViewDelegate, SwipeViewDataSource,UIGestureRecognizerDelegate,FMHorizontalMenuViewDelegate,FMHorizontalMenuViewDataSource>
@property (nonatomic,strong)       UITableView     *gangListTable;
@property(nonatomic, strong)       UIImageView     *promptImageView;

@property(strong,nonatomic)        NSMutableArray  *recommendArticles;
@property(strong,nonatomic)        NSMutableArray  *menuDatalistArray;
@property(strong,nonatomic)        NSMutableArray  *ADImageArray;


@property (nonatomic, strong)      NewFYtopbannerViewCell *topCell;
@property (nonatomic, strong)      SwipeView *swipeView;

@property (nonatomic)              NSMutableArray *panelArray;
@property (nonatomic)              NSMutableArray *ModuleArray;

@property (nonatomic, strong)      NSString *sign;

@property(strong,nonatomic) UIView *Newrecommendcontainer;

@property (nonatomic, assign) BOOL isCanSideBack;

@property (nonatomic,strong) FMHorizontalMenuView *menuView;



@end

@implementation QHomeViewController

static QHomeViewController * qHomeViewController;

+(QHomeViewController *) getInstance{
    
    return qHomeViewController;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.sign = @"QHomeViewController";
    
    [appDelegate AnimationOutsidePlay:self.sign];
    
    
    qHomeViewController =self;
    self.view.backgroundColor =DefaultBackgroundColor;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.ModuleArray = [[NSMutableArray alloc] init];
    self.panelArray = [[NSMutableArray alloc] init];
    self.ADImageArray = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppHomePlay:) name:@"AppHomePlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QHomeRefresh:) name:@"QHomeRefresh" object:nil];
    
    [self loadHomeList];
    
    
    
    
    //    [self setNavigationItem];
    
    
    //    [self getPanelSource];
    //
    //    [self getModuleSource];
    //
    //    [self GetBulletinList];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)AppHomePlay:(NSNotification *)noti
{
    
    [appDelegate AnimationOutsidePlay:self.sign];
    
}

- (void)QHomeRefresh:(NSNotification *)noti
{
    
    [self loadNewData];
    
}

- (void)GetBulletinList
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"type" : @"1"};
    
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    
    NSLog(@"bullentinListQdeviceTypeId===%@", name);
    
    
    [BBTEquipmentRequestTool GetNewBulletinDeviceTypeId:name Parameter:parameter success:^(NewBulletin *response) {
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ADImageArray = (NSMutableArray*)response.data;
            
            if (self.ADImageArray.count > 0) {
                
                [self.gangListTable reloadData];
                
            }
            
            
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)loadHomeList
{
    self.gangListTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, KDeviceHeight)];
    self.gangListTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.gangListTable.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.gangListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.gangListTable setSeparatorColor:[UIColor clearColor]];
    [self.gangListTable setShowsVerticalScrollIndicator:NO];
    self.gangListTable.dataSource = self;
    self.gangListTable.delegate = self;
    [self.view addSubview:self.gangListTable];
    
    
    //    self.ADImageArray = [NSMutableArray arrayWithObjects:@"http://img.mp.itc.cn/upload/20160501/66b685aa2e0342a9903ec8f0207235b1_th.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847201131&di=5512240f5cb81c6f45830c064e605003&imgtype=0&src=http%3A%2F%2Frs.xpw888.com%2Frs%2Fprodesc%2Fimgs%2Fimage%2F20160503%2F20160503170153_729.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847201124&di=602e1b57e6d1eb7e6b49cfef13d03372&imgtype=0&src=http%3A%2F%2Fp1.img.cctvpic.com%2Fphotoworkspace%2Fcontentimg%2F2016%2F04%2F08%2F2016040814350285433.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847354488&di=63da147878a452e68fa51ad3d039f9ac&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160525%2Fa6b48f99ce044e5c959f67bd71e67077_th.jpg", nil];
    //
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.gangListTable respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.gangListTable;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
    [self example01];//在viewWillAppear
    
    
}


- (void)getModuleSource
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"type" : @"2"};
    
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    
    NSLog(@"bullentinListQdeviceTypeId===%@", name);
    
    
    [BBTEquipmentRequestTool GetNewBulletinDeviceTypeId:name Parameter:parameter success:^(NewBulletin *response) {
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ModuleArray = (NSMutableArray*)response.data;
            
            
            if (self.ModuleArray.count > 0) {
                
                [self.gangListTable reloadData];
                
            }
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    //    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    //
    //
    //    [self startLoading];
    //
    //    [QMineRequestTool getDeviceModulesName:name success:^(QModule *response) {
    //
    //        [self stopLoading];
    //
    //        if ([response.statusCode isEqualToString:@"0"]) {
    //
    //
    //            self.ModuleArray = (NSMutableArray*)response.data;
    //
    //
    //            if (self.ModuleArray.count > 0) {
    //
    //                [self.gangListTable reloadData];
    //
    //            }
    //
    //
    //
    //        }
    //        else{
    //
    //            [self showToastWithString:response.message];
    //        }
    //
    //    } failure:^(NSError *error) {
    //
    //        [self stopLoading];
    //        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    //
    //
    //    }];
}

- (void)getPanelSource
{
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    
    NSLog(@"namessssssQdeviceTypeId%@",name);
    
    [self startLoading];
    
    [QMineRequestTool getDevicePanelsName:name success:^(QPanel *response) {
        
        [self stopLoading];
        [self.gangListTable.mj_header endRefreshing];
        if ([response.statusCode isEqualToString:@"0"]) {
            //            [self.panelArray removeAllObjects];
            
            self.panelArray = (NSMutableArray*)response.data;
            
            
            if (self.panelArray.count > 0) {
                [self.gangListTable reloadData];
            }
            
            
            
            
            
        }
        //        else if([response.statusCode isEqualToString:@"3705"])
        //        {
        //
        //            [[HomeViewController getInstance] KickedOutDeviceStaues];
        //
        //
        //        }
        else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        [self.gangListTable.mj_header endRefreshing];
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    //    [button setTitle:@"返回" forState:UIControlStateNormal];
    //    [button setTitle:@"返回" forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    //
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_nor"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_pre"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(QSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

- (void)QSearch
{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"百家姓", @"为什么", @"守株待兔", @"井底之蛙", @"千字文", @"三字经", @"春晓"];
    // 2. Create a search view controller
    //适配iphone x
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        
        NSString * urlStr = searchText;
        
        //过滤字符串前后的空格
        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //过滤中间空格
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        QSearchViewController *searchVc = [[QSearchViewController alloc] init];
        searchVc.searchstr = urlStr;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
        
        nav.navigationBar.barTintColor = [UIColor orangeColor];
        [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [searchViewController presentViewController:nav animated:YES completion:nil];
        
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        //
        //
        //        nav.navigationBar.barTintColor = [UIColor orangeColor];
        //
        //        [self presentViewController:nav animated:YES completion:nil];
        
        
    }];
    // 3. Set style for popular search and search history
    
    searchViewController.hotSearchStyle = 2;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    nav.navigationBar.barTintColor = [UIColor orangeColor];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}



-(void)backFore{
    
    [[CustomRootViewController getInstance]comeback];
    
}



#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.gangListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.gangListTable.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
    
    
    [self getModuleSource];//获取设备类型拥有的模块:点播历史、宝贝说说等
    
    [self GetBulletinList];//获取广告列表
    
    [self getPanelSource];//获取设备类型拥有的板块:精品推荐、听故事、学英语等
    
}

//#pragma mark UITableView + 上拉刷新 默认
//- (void)example11
//{
//    self.gangListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    // 设置了底部inset
//    self.gangListTable.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//    // 忽略掉底部inset
//    self.gangListTable.mj_footer.ignoredScrollViewContentInsetBottom =0;
//}
//#pragma mark 上拉加载更多数据
//- (void)loadMoreData
//{
//
//    [self.gangListTable.mj_footer endRefreshing];
//}

#pragma mark === FMHorizontalMenuViewDataSource

/**
 提供数据的数量
 
 @param horizontalMenuView 控件本身
 @return 返回数量
 */
-(NSInteger)numberOfItemsInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView{
    return self.ModuleArray.count;
}

#pragma mark === FMHorizontalMenuViewDelegate
/**
 设置每页的行数 默认 2
 
 @param horizontalMenuView 当前控件
 @return 行数
 */
-(NSInteger)numOfRowsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView{
    return 2;
}

/**
 设置每页的列数 默认 4
 
 @param horizontalMenuView 当前控件
 @return 列数
 */
-(NSInteger)numOfColumnsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView{
    return 5;
}
/**
 当选项被点击回调
 
 @param horizontalMenuView 当前控件
 @param index 点击下标
 */
-(void)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"dianji=====================%ld",(long)index);
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
    NewBulletinData *bulletindata = [self.ModuleArray objectAtIndex:index];
    switch ([bulletindata.contentType intValue]) {
        case 1:
        {
            NSLog(@"html5");
            BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
            
            NSString *urlStr = bulletindata.contentUrl;
            bulletinVc.URL = [NSURL URLWithString:urlStr];
            
            [self.navigationController pushViewController:bulletinVc animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"公告");
            BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.contentKey];
            bulletinVc.URL = [NSURL URLWithString:urlStr];
            
            [self.navigationController pushViewController:bulletinVc animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"专辑");
            
            NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
            
            if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
                BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
                QAlbumVC.trackListId = bulletindata.contentKey;
                
                
                [self.navigationController pushViewController:QAlbumVC animated:YES];
            }
            else
            {
                QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
                QAlbumVC.trackListId = bulletindata.contentKey;
                
                
                [self.navigationController pushViewController:QAlbumVC animated:YES];
            }
            
        }
            break;
        case 4:
        {
            NSLog(@"板块");
            
            //            NewQAlbumListViewController *QAlbumVC = [[NewQAlbumListViewController alloc] init];
            //
            //            QAlbumVC.deviceTypeId = bulletindata.deviceTypeId;
            //            QAlbumVC.panelId = bulletindata.contentKey;
            //            QAlbumVC.Albumtitle = bulletindata.contentName;
            //
            //            [self.navigationController pushViewController:QAlbumVC animated:YES];
            
            OrdeyByQAlbumListViewController *QAlbumVC = [[OrdeyByQAlbumListViewController alloc] init];
            
            QAlbumVC.deviceTypeId =bulletindata.deviceTypeId;
            QAlbumVC.panelId = bulletindata.contentKey;
            QAlbumVC.Albumtitle = bulletindata.contentName;
            
            [self.navigationController pushViewController:QAlbumVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
    
}
/**
 当前菜单的title
 
 @param horizontalMenuView 当前控件
 @param index 下标
 @return 标题
 */
-(NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger)index{
    
    NewBulletinData *bulletindata = [self.ModuleArray objectAtIndex:index];
    
    return bulletindata.recommendTitle;
}
/**
 本地图片
 
 @param horizontalMenuView 当前控件
 @param index 下标
 @return 图片名称
 */
//-(NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView localIconStringForItemAtIndex:(NSInteger)index{
//
////    return @"icon_dbls_nor";
//    return @"图层-30";
//}

/**
 每个菜单的图片地址路径
 
 @param horizontalMenuView 当前控件
 @param index 当前下标
 @return 返回图片的URL路径
 */
- (NSURL *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView iconURLForItemAtIndex:(NSInteger)index
{
    NewBulletinData *bulletindata = [self.ModuleArray objectAtIndex:index];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.contentIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    
    return [NSURL URLWithString:encodedString];
}

-(CGSize)iconSizeForHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView{
    return CGSizeMake(59, 59);
}




#pragma mark --SwipeView 代理函数

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.ModuleArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    QModuleData *moduledata = self.ModuleArray[index];
    
    //    NSArray *titleNameArray = [NSArray arrayWithObjects:@"点播历史",@"宝贝说说",@"宝贝最爱",@"宝贝歌单",@"设备控制",@"其他按钮",nil];
    //    NSArray *imageArray = [NSArray arrayWithObjects:@"icon_dbls_nor",@"icon_bbss_nor",@"icon_bbza_nor",@"icon_bbgd_nor", @"icon_sbkz_nor",@"icon_bbss_nor",nil];
    NSUInteger itemCount;
    if (self.ModuleArray.count>5) {
        
        itemCount=5;
        
    }else{
        
        itemCount=self.ModuleArray.count;
    }
    
    UIView * mview = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width/itemCount, 80)];
    mview.backgroundColor = [UIColor whiteColor];
    
    
    int item = self.view.frame.size.width/itemCount;
    CGRect userIconRect= CGRectMake((item-40)/2,5,40, 40);
    
    
    UIImageView * selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    
    //selerListImage.contentMode = UIViewContentModeScaleToFill;
    selerListImage.contentMode = UIViewContentModeScaleAspectFit;
    selerListImage.backgroundColor = [UIColor clearColor];
    selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //    selerListImage.image = [UIImage imageNamed:imageArray[index]];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)moduledata.deviceModuleIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    
    
    [selerListImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"icon_dbls_nor"]];
    [mview addSubview: selerListImage];
    
    if (self.ModuleArray.count >0) {
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,45,item-10, 30)];
        //UIColor *fontColor=[UIColor colorWithWhite:0.5f alpha:1.0f];
        //    label.text = titleNameArray[index];
        label.text = moduledata.deviceModuleName;
        
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=[UIColor colorWithWhite:0.26 alpha:1.0f];
        label.font=[UIFont systemFontOfSize:13.0f];
        label.backgroundColor = [UIColor clearColor];
        [mview addSubview:label];
        
        
    }
    
    
    
    return mview;
}


#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return self.panelArray.count + 2;
        
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellFullIdentifier = [NSString stringWithFormat:@"HomeFloorCellIdentifier_%ld", (long)indexPath.row];
    //   if (indexPath.section==0) {
    
    UITableViewCell *cell = nil;
    if (indexPath.row==0){
        
        static NSString *cellIndentifier = @"celltop";
        self.topCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        self.topCell = [[NewFYtopbannerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array: self.ADImageArray];
        
        self.topCell.delegate = self;
        return self.topCell;
        
        
    }
    
    else  if (indexPath.row==1){
        
        //普通楼层
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.buttonListContainer];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }
    
    //精品推荐
    else if (indexPath.row==2){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        //[cell.contentView addSubview:self.recommend];
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.Newrecommend];
        //[cell updateViewWithFloorDTO:@"15"];
        
        
        return cell;
    }
    //听故事
    else if (indexPath.row==3){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.ListenStory];
        //[cell.contentView addSubview:self.recommend];
        //[cell updateViewWithFloorDTO:@"15"];
        
        
        return cell;
    }
    //学英语
    else if (indexPath.row==4){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.LearnEnglish];
        
        //[cell updateViewWithFloorDTO:@"15"];
        
        
        return cell;
    }
    else if (indexPath.row==5){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.LearnSong];
        
        
        return cell;
        
        
    }
    else if (indexPath.row==6){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelOne];
        
        
        return cell;
        
        
    }
    else if (indexPath.row==7){
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwo];
        
        
        return cell;
        
        
    }
    else if (indexPath.row==8)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelThree];
        
        
        return cell;
        
    }
    else if (indexPath.row==9)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelFour];
        
        
        return cell;
        
    }
    else if (indexPath.row==10)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelFive];
        
        
        return cell;
        
    }
    else if (indexPath.row==11)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelSix];
        
        
        return cell;
        
    }
    else if (indexPath.row==12)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelSeven];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==13)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelEight];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==14)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelNine];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==15)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==16)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelEleven];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==17)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwelve];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==18)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelThirteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==19)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelFourteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==20)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelFifteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==21)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelSixteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==22)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelSeventeen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==23)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelEighteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==24)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelNineteen];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==25)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwenty];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==26)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentyOne];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==27)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentyTwo];
        
        
        return cell;
        
    }
    
    else if (indexPath.row==28)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentyThree];
        
        
        return cell;
        
    }
    else if (indexPath.row==29)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentyFour];
        
        
        return cell;
        
    }
    else if (indexPath.row==30)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentyFive];
        
        
        return cell;
        
    }
    else if (indexPath.row==31)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentySix];
        
        
        return cell;
        
    }
    
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFullIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFullIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.PanelTwentySix];
        
        
        return cell;
        
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat panelWidth = (kDeviceWidth- 16 * 3)/2+24 + 30;
    
    if (indexPath.row==0){
        return 150/568.0*[[UIScreen mainScreen] bounds].size.height+10
        ;
    }
    
    else if  (indexPath.row==1){
        
        return 208 + 16 + 16;
    }
    
    else if (indexPath.row==2){
        
        QPanelData *paneldata = [self.panelArray objectAtIndex:0];
        
        if (paneldata.trackLists.count >0) {
            NSLog(@"hessssshight====%f",((paneldata.trackLists.count -1)/2 + 1)* panelWidth +10+KTitleHeight+15);
            
            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
        }
        else
            
            return 16+KTitleHeight;
        
    }
    else if (indexPath.row==3){
        
        
        //        return ((kDeviceWidth-24)/3+24)*2+10+KTitleHeight+10+60;
        
        QPanelData *paneldata = [self.panelArray objectAtIndex:1];
        
        if (paneldata.trackLists.count >0) {
            NSLog(@"hessssshight1111====%f",((paneldata.trackLists.count -1)/2 + 1)* panelWidth +10+KTitleHeight+15);
            //            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +10+KTitleHeight+10+60;
            
            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            
        }else
            return KTitleHeight + 16;
        //            return 10+KTitleHeight+10+60;
    }
    else if (indexPath.row==4){
        
        
        QPanelData *paneldata = [self.panelArray objectAtIndex:2];
        
        if (paneldata.trackLists.count >0) {
            
            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
        }else
            
            return KTitleHeight + 16;
        
    }else if (indexPath.row==5){
        
        
        QPanelData *paneldata = [self.panelArray objectAtIndex:3];
        
        if (paneldata.trackLists.count >0) {
            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
        }else
            
            return KTitleHeight + 16;
        
    }
    else if (indexPath.row==6){
        
        
        QPanelData *paneldata = [self.panelArray objectAtIndex:4];
        
        if (paneldata.trackLists.count >0) {
            return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
        }else
            
            return KTitleHeight + 16;
        
    }
    else if (indexPath.row==7){
        
        if (self.panelArray.count > 5) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:5];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    else if (indexPath.row==8){
        
        if (self.panelArray.count > 6) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:6];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    else if (indexPath.row==9){
        
        if (self.panelArray.count > 7) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:7];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    else if (indexPath.row==10){
        
        if (self.panelArray.count > 8) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:8];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    else if (indexPath.row==11){
        
        if (self.panelArray.count > 9) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:9];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==12){
        
        if (self.panelArray.count > 10) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:10];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==13){
        
        if (self.panelArray.count > 11) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:11];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==14){
        
        if (self.panelArray.count > 12) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:12];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==15){
        
        if (self.panelArray.count > 13) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:13];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    
    else if (indexPath.row==16){
        
        if (self.panelArray.count > 14) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:14];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==17){
        
        if (self.panelArray.count > 15) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:15];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==18){
        
        if (self.panelArray.count > 16) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:16];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==19){
        
        if (self.panelArray.count > 17) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:17];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==20){
        
        if (self.panelArray.count > 18) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:18];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==21){
        
        if (self.panelArray.count > 19) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:19];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==22){
        
        if (self.panelArray.count > 20) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:20];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==23){
        
        if (self.panelArray.count > 21) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:21];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==24){
        
        if (self.panelArray.count > 22) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:22];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==25){
        
        if (self.panelArray.count > 23) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:23];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==26){
        
        if (self.panelArray.count > 24) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:24];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==27){
        
        if (self.panelArray.count > 25) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:25];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==28){
        
        if (self.panelArray.count > 26) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:26];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==29){
        
        if (self.panelArray.count > 27) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:27];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==30){
        
        if (self.panelArray.count > 28) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:28];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    else if (indexPath.row==31){
        
        if (self.panelArray.count > 29) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:29];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
    }
    
    
    else
    {
        
        
        
        if (self.panelArray.count > 29) {
            
            QPanelData *paneldata = [self.panelArray objectAtIndex:29];
            
            if (paneldata.trackLists.count >0) {
                return ((paneldata.trackLists.count -1)/2 + 1)* panelWidth +16+KTitleHeight;
            }else
                
                return KTitleHeight + 16;
            
        }
        else
            return 0;
        
        
        
    }
    
    return 0;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}



#pragma mark --按钮菜单

-(UIView*)buttonListContainer{
    
    //    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,80)];
    //    containView.backgroundColor = [UIColor clearColor];
    //
    //    _swipeView =[[SwipeView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    //    _swipeView.alignment = SwipeViewAlignmentEdge;
    //    _swipeView.pagingEnabled = NO;//是否翻页
    //    _swipeView.wrapEnabled = NO;//可循环滚动
    //    _swipeView.delegate = self;
    //    _swipeView.dataSource = self;
    //    _swipeView.itemsPerPage = 3;
    //    _swipeView.truncateFinalPage = YES;
    //    _swipeView.backgroundColor = [UIColor whiteColor];
    //
    //
    //    [containView addSubview:_swipeView];
    
    
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,208 + 16)];
    containView.backgroundColor = [UIColor clearColor];
    //动画样式
    _menuView = [[FMHorizontalMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 208 + 16)];
    
    _menuView.delegate = self;
    _menuView.dataSource = self;
    _menuView.currentPageDotColor = [UIColor orangeColor];
    _menuView.pageControlStyle = FMHorizontalMenuViewPageControlStyleClassic;
    _menuView.pageDotColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    _menuView.backgroundColor = [UIColor whiteColor];
    _menuView.defaultImage = [UIImage imageNamed:@"icon_recommend"];
    //    self.menuView1.hidesForSinglePage = NO;
    [containView addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 208 + 16));
    }];
    
    [_menuView reloadData];
    
    
    
    return containView;
    
    
    
}



#pragma mark 精品推荐
-(UIView*)Newrecommend{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:0];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    
    
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    NSLog(@"panelHeightsssss====%f",panelHeight);
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zcheng.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc] initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(newRecommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        
        
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    
    return  container;
}



#pragma mark 听故事

-(UIView*)ListenStory{
    
    //    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,((kDeviceWidth-24)/3+24)*2+10+KTitleHeight+60)];
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:1];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        //        panelHeight = ((kDeviceWidth-24)/2+24) * listcount +10+KTitleHeight+60;
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight ;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, panelHeight)];
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zcheng.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 1;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton *btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(listenStoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(tempView.frame)+25, kDeviceWidth-12,KTitleHeight)];
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 1;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    return container;
}




#pragma mark 学英语

-(UIView*)LearnEnglish{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:2];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    //    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,((kDeviceWidth-24)/3+24)*2+10+KTitleHeight+60)];
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16, 0,kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    //    titleName.text =@"学英语";//adImageModel.ap_name;
    
    //    QPanelData *paneldata = [self.panelArray objectAtIndex:2];
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 2;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(learnEnglishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //
    //    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(tempView.frame)+25, kDeviceWidth-12,KTitleHeight)];
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 2;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    return container;
}

#pragma mark 听儿歌
-(UIView*)LearnSong{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:3];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    //    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,((kDeviceWidth-24)/3+24)*2+10+KTitleHeight+60)];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    //    titleName.text =@"学英语";//adImageModel.ap_name;
    
    //    QPanelData *paneldata = [self.panelArray objectAtIndex:3];
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 3;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight
                                                 );
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(LearnSongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 3;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    return container;
}


#pragma mark 用户添加模块
-(UIView*)PanelOne{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:4];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    //    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,((kDeviceWidth-24)/3+24)*2+10+KTitleHeight+60)];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    //    titleName.text =@"学英语";//adImageModel.ap_name;
    
    //    QPanelData *paneldata = [self.panelArray objectAtIndex:3];
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 4;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelOneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 4;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}

-(UIView*)PanelTwo{
    
    QPanelData *paneldata = nil;
    NSLog(@"self.panelArray.count===%lu",(unsigned long)self.panelArray.count);
    if (self.panelArray.count > 5) {
        paneldata = [self.panelArray objectAtIndex:5];
    }
    
    
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 5;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 5;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}

-(UIView*)PanelThree{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:6];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 6;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelThreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 6;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}

-(UIView*)PanelFour{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:7];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 7;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelFourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 7;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}

-(UIView*)PanelFive{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:8];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    //
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    //
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 8;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelFiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    //
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 8;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}


-(UIView*)PanelSix{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:9];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 9;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelSixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 9;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}

-(UIView*)PanelSeven{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:10];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 10;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelSevenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 10;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}


-(UIView*)PanelEight{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:11];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 11;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelEightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 11;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    return container;
}


-(UIView*)PanelNine{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:12];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 12;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelNineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 12;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    
    
    
    
    return container;
}


-(UIView*)PanelTen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:13];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    //
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 13;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 13;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}


-(UIView*)PanelEleven{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:14];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    //
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 14;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelElevenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 14;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    //
    
    
    
    return container;
}

-(UIView*)PanelTwelve{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:15];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 15;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwelveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 15;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    
    
    
    
    return container;
}

-(UIView*)PanelThirteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:16];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 16;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelThirteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    //
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 16;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}

-(UIView*)PanelFourteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:17];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 17;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelFourteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 17;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}


-(UIView*)PanelFifteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:18];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 18;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelFifteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 18;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}

-(UIView*)PanelSixteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:19];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 19;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelSixteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    //
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 19;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}

-(UIView*)PanelSeventeen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:20];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];;
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 20;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelSeventeenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    //
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 20;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}

-(UIView*)PanelEighteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:21];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 21;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelEighteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 21;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    
    
    
    
    return container;
}

-(UIView*)PanelNineteen{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:22];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 22;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelNineteenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    //
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 22;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}

-(UIView*)PanelTwenty{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:23];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 23;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 23;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    
    
    
    
    return container;
}



-(UIView*)PanelTwentyOne{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:24];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 24;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyOneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 24;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}



-(UIView*)PanelTwentyTwo{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:25];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 25;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 25;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    //
    //
    
    
    
    return container;
}



-(UIView*)PanelTwentyThree{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:26];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    //
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 26;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyThreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 26;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    //
    
    
    
    
    
    return container;
}



-(UIView*)PanelTwentyFour{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:27];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 27;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyFourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 27;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}



-(UIView*)PanelTwentyFive{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:28];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = 10+KTitleHeight+60;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 28;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentyFiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 28;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    return container;
}



-(UIView*)PanelTwentySix{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:29];
    CGFloat panelHeight = KTitleHeight;
    NSInteger listcount = 0;
    if (paneldata.trackLists.count >0)
    {
        listcount =  ((paneldata.trackLists.count -1)/2 + 1);
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight;
        
    }
    
    else
    {
        panelHeight = 10+KTitleHeight+60;
    }
    
    
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,panelHeight)];
    
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,3, 15)];
    //    titleImageView.image = [UIImage imageNamed:@"icon_zhong.png"];
    //
    //    [tempView addSubview:titleImageView];
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  paneldata.devicePanelName;
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 29;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0f];
    moreLabel.font = [UIFont systemFontOfSize:14.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34,19,9, 15)];
    moreImageView.image = [UIImage imageNamed:@"more_home.png"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    
    for(int i=0;i<paneldata.trackLists.count;i++)
    {
        QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:i];
        
        CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+24 + 30)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+24 + 30);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/2))*(i%2) +(i%2)*6+6,(((kDeviceWidth-24)/2+24)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth-24)/2,(kDeviceWidth-24)/2+24);
        //        CGRect rect = CGRectMake((((kDeviceWidth-24)/3))*(i%3) +(i%3)*6+6,(((kDeviceWidth-24)/3+24)*(i/3)+0.5)+(i/3)*0.5, (kDeviceWidth-24)/3,(kDeviceWidth-24)/3+24);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithImage111:trackList.trackListIcon title:trackList.trackListName frame:rect type:@"no"];
        [btn addTarget:self action:@selector(PanelTwentySixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [imageViewListContainer addSubview:btn];
        
    }
    
    
    
    //    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(imageViewListContainer.frame)+12, kDeviceWidth-12,KTitleHeight)];
    //    //    NSLog(@"fdfdfdfd=======%f", CGRectGetMaxY(imageViewListContainer.frame)+12);
    //
    //    moreButton.layer.cornerRadius = 5;
    //    moreButton.layer.borderWidth =1;
    //    moreButton.clipsToBounds = YES;
    //    moreButton.layer.borderColor =[UIColor colorWithWhite:0.86 alpha:1.0f].CGColor;
    //    moreButton.backgroundColor = [UIColor clearColor];
    //    [moreButton setTitle:@"更 多" forState:UIControlStateNormal];
    //    [moreButton setTitleColor:[UIColor colorWithWhite:0.26 alpha:1.0f] forState:UIControlStateNormal];
    //    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    moreButton.titleLabel.backgroundColor = [UIColor clearColor];
    //    moreButton.tag = 29;
    //    [moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [container addSubview:moreButton];
    
    
    
    
    
    
    return container;
}






#pragma mark 首页广告各种点击函数

-(void)NewdidSelectedTopbannerViewCellIndex:(NSInteger)index{
    
    NSLog(@"点击了首页广告");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    //    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:index];
    //
    //    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
    //
    //    NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    //    bulletinVc.URL = [NSURL URLWithString:urlStr];
    //
    //    [self.navigationController pushViewController:bulletinVc animated:YES];
    
    NewBulletinData *bulletindata = [self.ADImageArray objectAtIndex:index];
    switch ([bulletindata.contentType intValue]) {
        case 1:
        {
            NSLog(@"html5");
            BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
            
            NSString *urlStr = bulletindata.contentUrl;
            bulletinVc.URL = [NSURL URLWithString:urlStr];
            
            [self.navigationController pushViewController:bulletinVc animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"公告");
            BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.contentKey];
            bulletinVc.URL = [NSURL URLWithString:urlStr];
            
            [self.navigationController pushViewController:bulletinVc animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"专辑");
            
            NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
            
            if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
                BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
                QAlbumVC.trackListId = bulletindata.contentKey;
                
                
                [self.navigationController pushViewController:QAlbumVC animated:YES];
            }
            else
            {
                QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
                QAlbumVC.trackListId = bulletindata.contentKey;
                
                
                [self.navigationController pushViewController:QAlbumVC animated:YES];
            }
            
        }
            break;
        case 4:
        {
            NSLog(@"板块");
            
            //            NewQAlbumListViewController *QAlbumVC = [[NewQAlbumListViewController alloc] init];
            //
            //            QAlbumVC.deviceTypeId = bulletindata.deviceTypeId;
            //            QAlbumVC.panelId = bulletindata.contentKey;
            //            QAlbumVC.Albumtitle = bulletindata.contentName;
            //
            //            [self.navigationController pushViewController:QAlbumVC animated:YES];
            
            OrdeyByQAlbumListViewController *QAlbumVC = [[OrdeyByQAlbumListViewController alloc] init];
            
            QAlbumVC.deviceTypeId =bulletindata.deviceTypeId;
            QAlbumVC.panelId = bulletindata.contentKey;
            QAlbumVC.Albumtitle = bulletindata.contentName;
            
            [self.navigationController pushViewController:QAlbumVC animated:YES];
            
            //
        }
            break;
        default:
            break;
    }
    
}


- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    
    QModuleData *moduledata = self.ModuleArray[index];
    
    if ( [moduledata.moduleId isEqualToString:@"1"] ) {
        NSLog(@"点播历史");
        QDemandViewController *QDemandVC = [[QDemandViewController alloc] init];
        QDemandVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QDemandVC animated:YES];
    }else if ([moduledata.moduleId isEqualToString:@"2"]){
        
        NSLog(@"宝贝说说");
        QTalkViewController *QTalkVC = [[QTalkViewController alloc] init];
        QTalkVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QTalkVC animated:YES];
        
    }else if ( [moduledata.moduleId isEqualToString:@"3"] ){
        
        NSLog(@"宝贝最爱");
        QFavoriteViewController *QFavoriteVC = [[QFavoriteViewController alloc] init];
        QFavoriteVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QFavoriteVC animated:YES];
    }
    else if ( [moduledata.moduleId isEqualToString:@"4"] ){
        
        NSLog(@"宝贝歌单");
        QSongViewController *QSongVC = [[QSongViewController alloc] init];
        QSongVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QSongVC animated:YES];
    }
    else if ( [moduledata.moduleId isEqualToString:@"5"] ){
        
        NSLog(@"设备控制");
        QDeviceControlViewController *QDeviceControlVC = [[QDeviceControlViewController alloc] init];
        QDeviceControlVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:QDeviceControlVC animated:YES];
    }
    else if (index==5){
        
        NSLog(@"其他按钮");
        
        
    }
    
    
}


-(void)newRecommendBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:0];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSLog(@"精品推荐");
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
    
}

-(void)listenStoryBtnClick:(UIButton*)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:1];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSLog(@"点击听故事");
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
    
}

-(void)learnEnglishBtnClick:(UIButton*)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:2];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSLog(@"点击学英语");
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)LearnSongBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:3];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelOneBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:4];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwoBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:5];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelThreeBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:6];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelFourBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:7];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelFiveBtnClick:(UIButton *)sender{
    QPanelData *paneldata = [self.panelArray objectAtIndex:8];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
}

-(void)PanelSixBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:9];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelSevenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:10];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelEightBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:11];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelNineBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:12];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:13];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelElevenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:14];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwelveBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:15];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelThirteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:16];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelFourteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:17];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelFifteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:18];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelSixteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:19];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelSeventeenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:20];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelEighteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:21];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelNineteenBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:22];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:23];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyOneBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:24];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyTwoBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:25];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyThreeBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:26];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyFourBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:27];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentyFiveBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:28];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}

-(void)PanelTwentySixBtnClick:(UIButton *)sender{
    
    QPanelData *paneldata = [self.panelArray objectAtIndex:29];
    QPanelDataTrackList *trackList = [paneldata.trackLists objectAtIndex:sender.tag];
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = trackList.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
}



-(void)moreBtnClick:(UIButton *)btn{
    
    NSLog(@"点击更多");
    QPanelData *paneldata = [self.panelArray objectAtIndex:btn.tag];
    //    QAlbumListViewController *QAlbumVC = [[QAlbumListViewController alloc] init];
    //
    //    QAlbumVC.deviceTypeId = paneldata.deviceTypeId;
    //    QAlbumVC.panelId = paneldata.panelId;
    //    QAlbumVC.Albumtitle = paneldata.devicePanelName;
    //
    //    [self.navigationController pushViewController:QAlbumVC animated:YES];
    
    
    
    OrdeyByQAlbumListViewController *QAlbumVC = [[OrdeyByQAlbumListViewController alloc] init];
    
    QAlbumVC.deviceTypeId = paneldata.deviceTypeId;
    QAlbumVC.panelId = paneldata.panelId;
    QAlbumVC.Albumtitle = paneldata.devicePanelName;
    
    [self.navigationController pushViewController:QAlbumVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    self.sign = @"QHomeViewController";
    
    //     [self loadHomeList];
    
    //      [self loadNewData];
    
    //     [self example01];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self forbiddenSideBack];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self resetSideBack];
    
}



/**
 
 * 禁用边缘返回
 
 */

-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    
    //关闭ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        
    }
    
}

/*
 
 恢复边缘返回
 
 */

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    
    //开启ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
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


