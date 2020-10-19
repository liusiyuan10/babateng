//
//  IntelligenceViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "IntelligenceViewController.h"
#import "IntelligenceCell.h"

#import "PanetRequestTool.h"
#import "KnowledgeModel.h"
#import "KnowledgeListDataModel.h"
#import "KnowledgeDataModel.h"
#import "KnowledgeInfoModel.h"


@interface IntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *intelligencenoLabel;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   NSMutableArray *intelligenceArr;

@end

@implementation IntelligenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智力记录";
    self.pageNum = 1;
    self.intelligenceArr = [NSMutableArray array];
    [self LoadChlidView];
    
    [self GetIntelligence];
    // Do any additional setup after loading the view.
}


- (void)LoadChlidView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 253 + 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, kDeviceWidth - 32, 209)];
    
    bgImageView.image = [UIImage imageNamed:@"know_intelligence"];
    
    [headerView addSubview:bgImageView];
    
    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 + 16, 18 + 17, kDeviceWidth - 16*2-18, 30)];
    self.intelligencenoLabel.text = @"21";
    self.intelligencenoLabel.textAlignment = NSTextAlignmentLeft;
    self.intelligencenoLabel.font = [UIFont systemFontOfSize:39.0];
    self.intelligencenoLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    self.intelligencenoLabel.backgroundColor = [UIColor clearColor];
    
    
    [bgImageView addSubview:self.intelligencenoLabel];
    
    UILabel *knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(bgImageView.frame) + 15, 250, 23)];
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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 253 + 10)];
    
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
    
    [self pullRefresh];
    
}

- (void)GetIntelligence 
{
    
    [self startLoading];
    
    [PanetRequestTool GetUserScorerecordType:@"2" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(KnowledgeModel * _Nonnull respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.intelligenceArr = respone.data.pageInfo.list;
            
             self.pageStr = respone.data.pageInfo.pages;
            
            self.intelligencenoLabel.text = respone.data.taskValue;
            
            [self.tableView reloadData];
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError * _Nonnull error) {
        
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
    
    [PanetRequestTool GetUserScorerecordType:@"2" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(KnowledgeModel * _Nonnull respone) {
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = respone.data.pageInfo.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.pageInfo.list;
            
            if (array1.count>0) {
                
                
                
                
                [self.intelligenceArr addObjectsFromArray:array1];
                [self.tableView reloadData];
                
            }
            
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.intelligenceArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"intelligencecell";
    IntelligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[IntelligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
//    cell.konwledgeLabel.text = @"签到获得";
//    cell.timeLabel.text = @"2019-02-25 13:22";
//    cell.noLabel.text = @"+3";
    
    KnowledgeListDataModel *listdata = [self.intelligenceArr objectAtIndex:indexPath.row];
    
    cell.konwledgeLabel.text = listdata.itemName;
    cell.timeLabel.text = listdata.createTime;
    
    cell.noLabel.text = [NSString stringWithFormat:@"+%@",listdata.getTaskValue];
    
    return cell;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
