//
//  QAlbumCategoryScrollListViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "QAlbumCategoryScrollListViewController.h"

#import "QResourceResponese.h"
#import "QResourceListResponese.h"

#import "QCategoryRequestTool.h"
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

@interface QAlbumCategoryScrollListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)       NSMutableArray *albumListarr; //推荐列表

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;

@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation QAlbumCategoryScrollListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.PageNum = 1;
    
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

- (void)GetResource
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    //     NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];

    [QCategoryRequestTool getAlbumTagsName:self.categoryid Parameter:parameter PageNum:@"1" PageSize:@"20" success:^(QMPanel *response) {

         [self stopLoading];

         if ([response.statusCode isEqualToString:@"0"]) {


             self.albumListarr = (NSMutableArray*)response.data.list;

             if (self.albumListarr.count > 0) {
                 self.pageStr = response.data.pages;
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
         [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

 
    
//    [QCategoryRequestTool GetPanelTrackLists:parameter PageNum:@"1" PageSize:@"18" success:^(QMPanel *respone) {
//        [self stopLoading];
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//
//            self.albumListarr = (NSMutableArray*)respone.data.list;
//
//            if (self.albumListarr.count > 0) {
//                self.pageStr = respone.data.pages;
//                [self.tableView reloadData];
//
//            }else{
//                [self showToastWithString:@"暂无内容"];
//            }
//
//
//
//        }else if([respone.statusCode isEqualToString:@"3705"])
//        {
//
//            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//        }else{
//
//
//            [self showToastWithString:respone.message];
//        }
//
//    } failure:^(NSError *error) {
//
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
//
//    }];
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
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    
    
   [QCategoryRequestTool getAlbumTagsName:self.categoryid Parameter:parameter PageNum:PageStr PageSize:@"20" success:^(QMPanel *response) {
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            self.pageStr = response.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;
            
            //            self.albumListarr = (NSMutableArray*)respone.data.list;
            
            if (array1 > 0) {
                
                [self.albumListarr addObjectsFromArray:array1];
                
                [self.tableView reloadData];
                
            }
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
    
    
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
        QAlbumViewController *QAlbumVC = [[QAlbumViewController alloc] init];
        QAlbumVC.trackListId = listRespone.trackListId;
        
        
        [self.navigationController pushViewController:QAlbumVC animated:YES];
    }
    
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
