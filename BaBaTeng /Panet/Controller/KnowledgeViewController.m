//
//  KnowledgeViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "KnowledgeCell.h"
#import "PanetRequestTool.h"
#import "KnowledgeModel.h"
#import "KnowledgeListDataModel.h"
#import "KnowledgeDataModel.h"
#import "KnowledgeInfoModel.h"


@interface KnowledgeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *knowledgenoLabel;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong) NSString *pageStr;

@property (nonatomic, strong)  NSMutableArray *KnowledgeArr;

@property (nonatomic, strong) UILabel *circulatenoLabel;
@property (nonatomic, strong) UILabel *lockednoLabel;


@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"知识豆记录";
    
    self.KnowledgeArr = [NSMutableArray array];
    self.pageNum = 1;
    
    [self LoadChlidView];
    
    [self GetKnowledge];
    
}

- (void)LoadChlidView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 273)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 225)];
    
    bgImageView.image = [UIImage imageNamed:@"KnowledgeBean"];

    [headerView addSubview:bgImageView];
    
    self.knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 + 16, 28 + 17, kDeviceWidth - 18 - 16*2, 30)];
    self.knowledgenoLabel.text = @"";
    self.knowledgenoLabel.textAlignment = NSTextAlignmentLeft;
    self.knowledgenoLabel.font = [UIFont systemFontOfSize:39.0];
    self.knowledgenoLabel.textColor = [UIColor colorWithRed:26/255.0 green:106/255.0 blue:25/255.0 alpha:1.0];
    self.knowledgenoLabel.backgroundColor = [UIColor clearColor];

    
    [bgImageView addSubview:self.knowledgenoLabel];
    
    self.lockednoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 + 16, CGRectGetMaxY(self.knowledgenoLabel.frame) + 16, 250, 11)];
    self.lockednoLabel.text = @"冻结知识豆数:";
    self.lockednoLabel.textAlignment = NSTextAlignmentLeft;
    
    
    self.lockednoLabel.font = [UIFont systemFontOfSize:11.0];
    self.lockednoLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
    self.lockednoLabel.backgroundColor = [UIColor clearColor];
    
    [bgImageView addSubview:self.lockednoLabel];
    
    
    self.circulatenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 + 16, CGRectGetMaxY(self.lockednoLabel.frame) + 6, 250, 11)];
    self.circulatenoLabel.text = @"可流通知识豆数:";
    self.circulatenoLabel.textAlignment = NSTextAlignmentLeft;
    
    
    self.circulatenoLabel.font = [UIFont systemFontOfSize:11.0];
    self.circulatenoLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
    self.circulatenoLabel.backgroundColor = [UIColor clearColor];
    
    [bgImageView addSubview:self.circulatenoLabel];
    
    
    
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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 273)];

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
- (void)GetKnowledge
{
    
    [self startLoading];
    
    [PanetRequestTool GetUserScorerecordType:@"1" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(KnowledgeModel * _Nonnull respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.KnowledgeArr = respone.data.pageInfo.list;
            
            self.pageStr = respone.data.pageInfo.pages;
            
            NSString *konwStr = [NSString stringWithFormat:@"%.5f",respone.data.scoreValue];
            
            self.knowledgenoLabel.text = konwStr;
            
            self.lockednoLabel.text = [NSString stringWithFormat:@"冻结知识豆数:%.5f", respone.data.lockedScore];
            
//            self.circulatenoLabel.text = [NSString stringWithFormat:@"可流通知识豆数:%.5f", respone.data.circulateScore];
            self.circulatenoLabel.hidden = YES;
            
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
    
    [PanetRequestTool GetUserScorerecordType:@"1" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(KnowledgeModel * _Nonnull respone) {
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = respone.data.pageInfo.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.pageInfo.list;
            
            if (array1.count>0) {
                
                
            
                
            [self.KnowledgeArr addObjectsFromArray:array1];
            [self.tableView reloadData];
                
            }
                
      
                
            }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.KnowledgeArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"Knowledgecell";
    KnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[KnowledgeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    KnowledgeListDataModel *listdata = [self.KnowledgeArr objectAtIndex:indexPath.row];
    
//    cell.konwledgeLabel.text = @"英豆兑换";
//    cell.timeLabel.text = @"2019-02-25 13:22";
//    cell.noLabel.text = @"10.25896";
    
    cell.konwledgeLabel.text = listdata.itemName;
    cell.timeLabel.text = listdata.createTime;
    
    if (listdata.getScoreValue > 0.0)
    {
        cell.noLabel.text = [NSString stringWithFormat:@"+%.5f",listdata.getScoreValue];
    }
    else
    {
        cell.noLabel.text = [NSString stringWithFormat:@"%.5f",listdata.getScoreValue];
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
