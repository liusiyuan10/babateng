//
//  QAlbumListViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/16.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QAlbumListViewController.h"

#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "QAlbumListQuiltViewCell.h"

#import "QResourceResponese.h"
#import "QResourceListResponese.h"

#import "QMineRequestTool.h"
#import "UIImageView+AFNetworking.h"

#import "QAlbumViewController.h"

#import "QMPanel.h"
#import "QMPanelList.h"
#import "QMPanelData.h"
#import "HomeViewController.h"
#import "NewHomeViewController.h"

#import "Header.h"

#import "BAlbumViewController.h"

@interface QAlbumListViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>

@property (nonatomic, strong)     TMQuiltView *collectionView;
@property(strong,nonatomic)       NSMutableArray *albumListarr; //推荐列表

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;

@end

@implementation QAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.Albumtitle;
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    //    self.albumListarr = [NSMutableArray arrayWithObjects:@"故事",@"故事",@"故事",@"故事",@"故事",@"故事",@"故事", nil];
    self.PageNum = 1;
    
    [self LoadChlidView];
    
    [self.collectionView reloadData];
    
    
}


#pragma mark UITableView + 上拉刷新 默认
- (void)pullRefresh
{
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}




- (void)LoadChlidView
{
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //    self.collectionView.bounces = NO;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    
    [self pullRefresh];
    
    self.albumListarr = [[NSMutableArray alloc] init];
    
    
    [self GetResource];
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.collectionView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.collectionView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
}

- (void)GetResource
{    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceTypeId" :self.deviceTypeId  ,@"panelId" : self.panelId};
    
    //     NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    
    //    [QMineRequestTool GetPanelTrackLists:<#(NSDictionary *)#> PageNum:<#(NSString *)#> PageSize:<#(NSString *)#> success:<#^(QMPanel *respone)success#> failure:<#^(NSError *error)failure#>]
    
    
    [QMineRequestTool GetPanelTrackLists:parameter PageNum:@"1" PageSize:@"18" success:^(QMPanel *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.albumListarr = (NSMutableArray*)respone.data.list;
            
            if (self.albumListarr.count > 0) {
                self.pageStr = respone.data.pages;
                [self.collectionView reloadData];
                
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
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
    
    
}

- (void)loadMoreData
{
    NSLog(@"更多数据");
    
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceTypeId" :self.deviceTypeId  ,@"panelId" : self.panelId};
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    
    
    [QMineRequestTool GetPanelTrackLists:parameter PageNum:PageStr PageSize:@"18" success:^(QMPanel *respone) {
        [self stopLoading];
        
        [self.collectionView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.pageStr = respone.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;
            
            //            self.albumListarr = (NSMutableArray*)respone.data.list;
            
            if (array1 > 0) {
                
                [self.albumListarr addObjectsFromArray:array1];
                
                [self.collectionView reloadData];
                
            }
            
            
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent  = NO;
    
}

//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.albumListarr count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    QAlbumListQuiltViewCell *cell = (QAlbumListQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[QAlbumListQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    //    cell.picHeight=80;
    
    QMPanelList *listRespone = self.albumListarr[indexPath.row];
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
    
    cell.titleLabel.text = listRespone.trackListName;
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 3;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KDeviceHeight/568*130;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    QMPanelList *listRespone = self.albumListarr[indexPath.row];
    
    NSLog(@"精品推荐");
//    QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
//    QAlbumVC.trackListId = listRespone.trackListId;
//    [self.navigationController pushViewController:QAlbumVC animated:YES];
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"]){
        BAlbumViewController *QAlbumVC = [[BAlbumViewController alloc] init];
        QAlbumVC.trackListId = listRespone.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    else
    {
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = listRespone.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

