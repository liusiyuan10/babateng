//
//  BeansViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "BeansViewController.h"
#import "BeansCell.h"

#import "PanetRequestTool.h"
#import "KnowledgeModel.h"
#import "KnowledgeListDataModel.h"
#import "KnowledgeDataModel.h"
#import "KnowledgeInfoModel.h"
#import "BeansModel.h"
#import "BeansDataModel.h"
#import "BeansModelDataPage.h"
#import "BeansListDataModel.h"

@interface BeansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)   UILabel *intelligencenoLabel;

@property (nonatomic, strong)   UILabel *beansnoLabel;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   NSMutableArray *BeansArr;

@end

@implementation BeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"英豆记录";
    self.pageNum = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.BeansArr = [NSMutableArray array];
    
    [self LoadChlidView];
    
    [self getBeans];
    // Do any additional setup after loading the view.
}


- (void)LoadChlidView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 294)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 250)];
    
    bgImageView.image = [UIImage imageNamed:@"EnglishBean"];
    
    [headerView addSubview:bgImageView];
    
    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 + 16, 28 + 17, 250, 30)];
    self.intelligencenoLabel.text = @"21";
    self.intelligencenoLabel.textAlignment = NSTextAlignmentLeft;
    self.intelligencenoLabel.font = [UIFont systemFontOfSize:39.0];
    self.intelligencenoLabel.textColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:0/255.0 alpha:1.0];
    self.intelligencenoLabel.backgroundColor = [UIColor clearColor];
    
    
    [bgImageView addSubview:self.intelligencenoLabel];
    
   
    
    self.beansnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 90 -32 , 54, 90, 11)];
    self.beansnoLabel.text = @"1英豆=10知识豆";
    self.beansnoLabel.textAlignment = NSTextAlignmentRight;
    self.beansnoLabel.font = [UIFont systemFontOfSize:11.0];
    self.beansnoLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
    self.beansnoLabel.backgroundColor = [UIColor clearColor];
    
    
    [bgImageView addSubview:self.beansnoLabel];
    
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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 294)];
    
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
- (void)getBeans
{
    [self startLoading];

    [PanetRequestTool getUserScoreEnPeapageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(BeansModel * _Nonnull respone) {
        
        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {

            self.BeansArr = respone.data.page.list;
            self.beansnoLabel.text = respone.data.desc;
            self.intelligencenoLabel.text = [NSString stringWithFormat:@"%.5f",respone.data.peaseValue];

            [self.tableView reloadData];


        }else{


       //
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
    
    [PanetRequestTool getUserScoreEnPeapageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(BeansModel * _Nonnull respone) {
        
        
            [self stopLoading];
    
            [self.tableView.mj_footer endRefreshing];
    
            if ([respone.statusCode isEqualToString:@"0"]) {
    
                self.pageStr = respone.data.page.pages;
    
                NSMutableArray *array1 = [[NSMutableArray alloc]init];
                array1 = respone.data.page.list;
    
                if (array1.count>0) {
    
    
    
    
                    [self.BeansArr addObjectsFromArray:array1];
                    [self.tableView reloadData];
    
                }
    
    
    
            }else{
    
    
                [self showToastWithString:respone.message];
            }
    
    
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.BeansArr.count;
  
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"BeansCellcell";
    BeansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[BeansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    //    cell.konwledgeLabel.text = @"签到获得";
    //    cell.timeLabel.text = @"2019-02-25 13:22";
    //    cell.noLabel.text = @"+3";
    
    BeansListDataModel *listdata = [self.BeansArr objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = @"英豆释放";
    cell.timeLabel.text = listdata.createTime;
    cell.noLabel.text = [NSString stringWithFormat:@"+%.5f",listdata.produceScoreValue];
//         status    0：待领取，1：已领取，2：已过期未领取
    if ([listdata.status isEqualToString:@"0"]) {
        
        cell.subLabel.text = [NSString stringWithFormat:@"待领取知识豆%.5f",listdata.peasValue];
    }
    else  if ([listdata.status isEqualToString:@"1"])
    {cell.subLabel.text = [NSString stringWithFormat:@"获得知识豆%.5f",listdata.peasValue];
        
    }else  if ([listdata.status isEqualToString:@"2"])
    {
        cell.subLabel.text = [NSString stringWithFormat:@"过期未领取%.5f",listdata.peasValue];
    }
    

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
