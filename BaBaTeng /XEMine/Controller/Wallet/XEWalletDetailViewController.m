//
//  XEWalletDetailViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/9.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEWalletDetailViewController.h"
#import "XESmallTwoCell.h"
#import "MineRequestTool.h"
#import "WalletDetailDataModel.h"
#import "WalletDetailListModel.h"
#import "WalletDetailModel.h"

@interface XEWalletDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *walletArr;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;
@property(nonatomic, strong)    UILabel *noLabel;
@end

@implementation XEWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收支明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.walletArr = [[NSMutableArray alloc] init];
    
    self.pageNum = 1;
    
    [self LoadChlidView];
    
    [self getWalletDetail];
    
}

- (void)LoadChlidView
{
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

- (void)getWalletDetail
{
    [self startLoading];
    
    [MineRequestTool GetWalletDetailpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(WalletDetailModel * _Nonnull response) {
        
        [self stopLoading];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.walletArr = response.data.list;
            self.pageStr = response.data.pages;

            if (self.walletArr.count > 0) {
                
                self.noLabel.hidden = YES;
                self.tableView.hidden = NO;
                
                [self.tableView reloadData];
            }else
            {
                self.noLabel.hidden = NO;
                self.tableView.hidden = YES;
            }

        }else{

            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
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
    
    //
    
    
    [self startLoading];
    
    [MineRequestTool GetWalletDetailpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(WalletDetailModel * _Nonnull response) {
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = response.data.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;

            if (array1.count>0) {

                [self.walletArr addObjectsFromArray:array1];
                [self.tableView reloadData];

            }

            
        }else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.walletArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"Knowledgecell";
    XESmallTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XESmallTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    WalletDetailListModel *listdata = [self.walletArr objectAtIndex:indexPath.row];
    
    if ([listdata.awardType isEqualToString:@"1"]) {
        
        cell.nameLabel.text = @"自购奖励";
        cell.noLabel.text = [NSString stringWithFormat:@"+%@",listdata.awardMount];
         cell.noLabel.textColor = MNavBackgroundColor;

    }
    else
    {
        if ([listdata.type isEqualToString:@"1"]) {
            cell.nameLabel.text = @"消费奖励";
            cell.noLabel.text = [NSString stringWithFormat:@"+%@",listdata.awardMount];
             cell.noLabel.textColor = MNavBackgroundColor;
        }
        else if ([listdata.type isEqualToString:@"2"])
        {
            cell.nameLabel.text = @"升级奖励";
            cell.noLabel.text = [NSString stringWithFormat:@"+%@",listdata.awardMount];
             cell.noLabel.textColor = MNavBackgroundColor;
        }
        else if ([listdata.type isEqualToString:@"3"])
        {
            cell.nameLabel.text = @"余额提现";
            cell.noLabel.text = [NSString stringWithFormat:@"-%@",listdata.awardMount];
            cell.noLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
        }
    }
    
//    if ([listdata.changeType isEqualToString:@"1"]) {
//        cell.nameLabel.text = @"兑换商品";
//        cell.noLabel.text = [NSString stringWithFormat:@"-%.2f",listdata.changeValue];
//        cell.noLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//
//
//    }else if ([listdata.changeType isEqualToString:@"2"])
//    {
//        cell.nameLabel.text = @"充值";
//        cell.noLabel.text = [NSString stringWithFormat:@"+%.2f",listdata.changeValue];
//        cell.noLabel.textColor = MNavBackgroundColor;
//
//    }else if ([listdata.changeType isEqualToString:@"3"])
//    {
//        cell.nameLabel.text = @"升级";
//        cell.noLabel.text = [NSString stringWithFormat:@"-%.2f",listdata.changeValue];
//         cell.noLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
//    }else if ([listdata.changeType isEqualToString:@"4"])
//    {
//        cell.nameLabel.text = @"分成收益";
//        cell.noLabel.text = [NSString stringWithFormat:@"+%.2f",listdata.changeValue];
//        cell.noLabel.textColor = MNavBackgroundColor;
//    }
//
    
    cell.timeLabel.text = listdata.createTime;
    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    
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
