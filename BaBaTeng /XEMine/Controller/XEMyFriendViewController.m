//
//  HDMyFriendViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/5/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMyFriendViewController.h"
#import "MineRequestTool.h"

#import "HDMyFriendModel.h"
#import "HDMyFriendDataModel.h"
#import "HDMyFriendListModel.h"
#import "HDMyFriendCell.h"



@interface XEMyFriendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   NSMutableArray *FriendArr;
@property(nonatomic, strong)    UILabel *noLabel;

@property (nonatomic, strong)   UIImageView *bgImageView;
@property(nonatomic, strong)    UILabel *headerLabel;

@end

@implementation XEMyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的朋友";
    
    self.pageNum = 1;
    
    [self LoadChlidView];
    
    [self GetFriend];
    
}

- (void)LoadChlidView
{

    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64 - kDevice_Is_iPhoneX )style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 61)];
//    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];

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
    
    
    
}


- (void)GetFriend
{
    [self startLoading];
    
    [MineRequestTool GetUsersFriendsUserId:[[TMCache sharedCache] objectForKey:@"userId"] pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(HDMyFriendModel *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.FriendArr = response.data.list;
            
            self.pageStr = response.data.pages;
            
            self.headerLabel.text = [NSString stringWithFormat:@"目前有%@个小伙伴和我一起在浩德星球探索。",response.data.total]; 
            
            if (self.FriendArr.count == 0) {
                self.noLabel.hidden = NO;
            }
            else
            {
                self.noLabel.hidden = YES;
            }
            
            
            [self.tableView reloadData];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
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
    
    [self startLoading];
    
    [MineRequestTool GetUsersFriendsUserId:[[TMCache sharedCache] objectForKey:@"userId"] pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(HDMyFriendModel *response) {
        
        [self stopLoading];

        [self.tableView.mj_footer endRefreshing];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.pageStr = response.data.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;

            if (array1.count>0) {




                [self.FriendArr addObjectsFromArray:array1];
                [self.tableView reloadData];

            }



        }else{


            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.FriendArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 86;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"PanetMineSetingcell";
    
    HDMyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[HDMyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
//    PanetMineAddressListModel *listdata = [self.AddressArr objectAtIndex:indexPath.row];
    HDMyFriendListModel *listdata = [self.FriendArr objectAtIndex:indexPath.row];
    
    cell.nameLabel.text =listdata.nickName;
    cell.phoneLabel.text = listdata.phoneNumber;
//    cell.subNameLabel.text = [NSString stringWithFormat:@"推荐%@人",listdata.userCount];
    cell.subNameLabel.hidden= YES;
    cell.arrowImage.hidden = YES;
    
//    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", listdata.province,listdata.city,listdata.area,listdata.address];
    
    return cell;
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //
    //
    

    
}





- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}



@end
