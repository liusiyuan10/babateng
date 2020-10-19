//
//  QSearchAlbumListViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "QSearchAlbumListViewController.h"

#import "QResourceResponese.h"
#import "QResourceListResponese.h"

#import "QMineRequestTool.h"
#import "UIImageView+AFNetworking.h"

#import "QAlbumViewController.h"

#import "QAlbumTag.h"
#import "QAlbumTagData.h"

#import "QMPanel.h"
#import "QMPanelList.h"
#import "QMPanelData.h"

#import "HomeViewController.h"
#import "NewHomeViewController.h"
#import "BAlbumViewController.h"
#import "NewQAlbumListCell.h"

#import "QSearchAlbumViewController.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"

#import "QCustomViewController.h"

@interface QSearchAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)       NSMutableArray *albumListarr; //推荐列表

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;

@property(nonatomic, strong)    UILabel *noLabel;

@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;

@end

@implementation QSearchAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.PageNum = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QSearchAlbumResult:) name:@"QSearchAlbumResult" object:nil];
    
    [self LoadChlidView];
    
    
}

- (void)LoadChlidView
{
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64)style:UITableViewStylePlain];
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
    
    [self.view addSubview:self.tableView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //适配iphone x
    
    self.button .frame = CGRectMake(kDeviceWidth / 2 - 30, KDeviceHeight- 165-kDevice_Is_iPhoneX , 50, 50);
    self.button .imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:  [[TMCache sharedCache]objectForKey:@"currentTrackIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    self.button.clipsToBounds=YES;
    
    self.button.layer.cornerRadius=25;
    
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
    
    [self GetResource];
    
    
    
    
}

- (void)QSearchAlbumResult:(NSNotification *)noti
{
    self.searchstr =[noti.userInfo objectForKey:@"SearchStr"];
    
    NSLog(@"sdfsfdsfdsfdf=====%@",self.searchstr);
    
    [self GetResource];
    
}
- (void)GetResource
{
    
    self.PageNum = 1;
    NSDictionary *parameter = @{@"deviceTypeId" : [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20,@"keyword":self.searchstr};
    

    
    [self startLoading];
    
    [QMineRequestTool GetSearchAlbumListParameter:parameter success:^(QMPanel *respone) {
        
            [self stopLoading];
    
            if ([respone.statusCode isEqualToString:@"0"]) {
    
    
                self.albumListarr = (NSMutableArray*)respone.data.list;
    
                if (self.albumListarr.count > 0) {
                    
                    self.tableView.hidden = NO;
                     self.noLabel.hidden = YES;
                    self.pageStr = respone.data.pages;
                    [self.tableView reloadData];
    
                }else if(self.albumListarr.count == 0){
//                    [self showToastWithString:@"暂无内容"];
                    self.tableView.hidden = YES;
                    self.noLabel.hidden = NO;
                }
    
    
    
            }else if([respone.statusCode isEqualToString:@"3705"])
            {
    
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
    
    
            }else{
    
    
                [self showToastWithString:respone.message];
            }
    
    
    } failure:^(NSError *error) {
        
            [self stopLoading];
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    
        
    }];

    //
    
}

- (void)loadMoreData
{
    NSLog(@"更多数据");
    
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
     NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    NSDictionary *parameter = @{@"deviceTypeId" : [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :PageStr,@"pageSize" :@20,@"keyword":self.searchstr};
    
    [self startLoading];
    
    [QMineRequestTool GetSearchAlbumListParameter:parameter success:^(QMPanel *respone) {
        [self stopLoading];

        [self.tableView.mj_footer endRefreshing];

        if ([respone.statusCode isEqualToString:@"0"]) {


            self.pageStr = respone.data.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;

            //            self.albumListarr = (NSMutableArray*)respone.data.list;

            if (array1 > 0) {

                [self.albumListarr addObjectsFromArray:array1];

                [self.tableView reloadData];

            }



        }else if([respone.statusCode isEqualToString:@"3705"])
        {

            [[NewHomeViewController getInstance] KickedOutDeviceStaues];


        }else{


            [self showToastWithString:respone.message];
        }

    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self stopLoading];
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


#pragma mark UITableView + 上拉刷新
- (void)pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.albumListarr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 118;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"newqalbumcarylistcell";
    NewQAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[NewQAlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:254/255.0 green:247/255.0 blue:244/255.0 alpha:1.0];
        
    }
    
    QMPanelList *listRespone = self.albumListarr[indexPath.row];
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
    cell.trackListNameLabel.text = listRespone.trackListName;
    cell.trackListDescriptionLabel.text = listRespone.trackListDescription;
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    QMPanelList *listRespone = self.albumListarr[indexPath.row];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = listRespone.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        
//        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
          QSearchAlbumViewController *QAlbumVC = [[QSearchAlbumViewController alloc] init];
        QAlbumVC.trackListId = listRespone.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    [self.searchBar resignFirstResponder];
    _block();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
