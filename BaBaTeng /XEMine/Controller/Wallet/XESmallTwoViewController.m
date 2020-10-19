//
//  XESmallTwoViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/9.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XESmallTwoViewController.h"
#import "XESmallTwoCell.h"
#import "MineRequestTool.h"
#import "TwoCurrencyDataModel.h"
#import "TwoCurrencyModel.h"
#import "TwoCurrencyPageInfo.h"
#import "TwoCurrencyListModel.h"
#import "XEMemberRuleViewController.h"


@interface XESmallTwoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong)  NSMutableArray *xesmallTwoArr;
@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@end

@implementation XESmallTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"小二币记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.xesmallTwoArr = [[NSMutableArray alloc] init];
    
    self.pageNum = 1;
    
    [self LoadChlidView];
    
    [self getWalletTwoCurrency];
    
}


- (void)LoadChlidView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 272)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    
    //    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.headerImageView.image = [UIImage imageNamed:@"bg"];
    
    self.headerImageView.userInteractionEnabled = YES;
    
    [headerView addSubview:self.headerImageView];
    
    UILabel *EarningLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 39, kDeviceWidth, 11)];
    
    EarningLabel.font = [UIFont systemFontOfSize:11.0];
    EarningLabel.backgroundColor = [UIColor clearColor];
    EarningLabel.textColor = [UIColor colorWithRed:253/255.0 green:254/255.0 blue:253/255.0 alpha:1.0];
    EarningLabel.text = @"小二币总数";
    EarningLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:EarningLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(EarningLabel.frame) + 15, kDeviceWidth, 27)];
    
    priceLabel.font = [UIFont systemFontOfSize:36.0];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.text = @"5330.56";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(priceLabel.frame) + 12, kDeviceWidth, 11)];
    
    totalLabel.font = [UIFont systemFontOfSize:11.0];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = [UIColor colorWithRed:253/255.0 green:254/255.0 blue:253/255.0 alpha:1.0];
    totalLabel.text = @"其中锁仓数:235622.34see";
    totalLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:totalLabel];
    self.totalLabel = totalLabel;
    
    UILabel *knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.headerImageView.frame) + 29, 250, 23)];
    knowledgeLabel.text = @"收支记录";
    knowledgeLabel.textAlignment = NSTextAlignmentLeft;
    knowledgeLabel.font = [UIFont boldSystemFontOfSize:24.0];
    knowledgeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    knowledgeLabel.backgroundColor = [UIColor clearColor];
    
    
    [headerView addSubview:knowledgeLabel];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 272)];
    
    [self.tableView.tableHeaderView addSubview:headerView];
    
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
    
    [self setNavigationItem];
    
    [self pullRefresh];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"查看规则" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)getWalletTwoCurrency
{
    [self startLoading];
    
    [MineRequestTool GetWalletTwoCurrencypageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(TwoCurrencyModel * _Nonnull response) {
        
        [self stopLoading];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.xesmallTwoArr = response.data.pageInfo.list;
            self.pageStr = response.data.pageInfo.pages;


            self.priceLabel.text =[NSString stringWithFormat:@"%.2f",response.data.rebateValue];

            self.totalLabel.text = [NSString stringWithFormat:@"其中锁仓数:%.2f",response.data.lockedRebateValue];

            [self.tableView reloadData];


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
    
    [MineRequestTool GetWalletTwoCurrencypageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(TwoCurrencyModel * _Nonnull response) {
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.pageStr = response.data.pageInfo.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.pageInfo.list;

            if (array1.count>0) {

                [self.xesmallTwoArr addObjectsFromArray:array1];
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



- (void)rightbuttonClicked
{
    XEMemberRuleViewController *XEMemberRuleVC = [[XEMemberRuleViewController alloc] init];
    
    XEMemberRuleVC.title = @"返分规则";
    XEMemberRuleVC.ruleType = @"2";
    [self.navigationController pushViewController:XEMemberRuleVC animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.xesmallTwoArr.count;
    
    
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
    
    TwoCurrencyListModel *listdata = [self.xesmallTwoArr objectAtIndex:indexPath.row];
    
    cell.noLabel.text = [NSString stringWithFormat:@"+%.2f",listdata.rebateValue];
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
