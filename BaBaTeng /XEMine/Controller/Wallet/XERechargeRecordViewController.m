//
//  XERechargeRecordViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/9.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XERechargeRecordViewController.h"
#import "XERechargeRecordCell.h"
#import "MineRequestTool.h"
#import "RechargeRecordDataModel.h"
#import "RechargeRecordListModel.h"
#import "RechargeRecordModel.h"
#import "BBTQAlertView.h"

#import "withDrawMoneyRecordModel.h"
#import "withDrawMoneyRecordDataModel.h"
#import "withDrawMoneyRecordListModel.h"

@interface XERechargeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *rechargeArr;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;

@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation XERechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提现记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.rechargeArr = [[NSMutableArray alloc] init];
    
    self.pageNum = 1;
    
    [self LoadChlidView];
    
    [self getREcharge];
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

- (void)getREcharge
{
    [self startLoading];
    
    
    [MineRequestTool GetwithDrawMoneyRecordpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(withDrawMoneyRecordModel * _Nonnull response) {
        
        [self stopLoading];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.rechargeArr = response.data.list;
            self.pageStr = response.data.pages;

            if (self.rechargeArr.count > 0) {

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
    
    [MineRequestTool GetwithDrawMoneyRecordpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(withDrawMoneyRecordModel * _Nonnull response) {
        [self stopLoading];

        [self.tableView.mj_footer endRefreshing];

        if ([response.statusCode isEqualToString:@"0"]) {

            self.pageStr = response.data.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;

            if (array1.count>0) {

                [self.rechargeArr addObjectsFromArray:array1];
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
    
    return self.rechargeArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"Knowledgecell";
    XERechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XERechargeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
//    RechargeRecordListModel *listdata = [self.rechargeArr objectAtIndex:indexPath.row];
    
    withDrawMoneyRecordListModel *listdata = [self.rechargeArr objectAtIndex:indexPath.row];
    
    if ([listdata.applyStatus isEqualToString:@"2"]) {
        cell.nameLabel.text = @"提现失败";
        cell.resonBtn.hidden = NO;
    }else if ([listdata.applyStatus isEqualToString:@"0"])
    {
        cell.nameLabel.text = @"提现中";
        cell.resonBtn.hidden = YES;
    }else
    {
        cell.nameLabel.text = @"提现成功";
        cell.resonBtn.hidden = YES;
    }
    
//    cell.nameLabel.text = @"提现成功";
    
    cell.noLabel.text = [NSString stringWithFormat:@"+%@",listdata.withdrawMoney];
    cell.timeLabel.text = listdata.applyTime;
    
    cell.resonBtn.tag = indexPath.row;
    
    [cell.resonBtn addTarget:self action:@selector(resonBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

- (void)resonBtnClicked:(UIButton *)btn
{
    
    withDrawMoneyRecordListModel *listdata = [self.rechargeArr objectAtIndex:btn.tag];
    
//   RechargeRecordListModel *listdata = [self.rechargeArr objectAtIndex:btn.tag];
    
//    BBTEAlertView *QalertView = [[BBTEAlertView alloc] initWithOneMassage:listdata.verifyRemark andWithTag:1 andWithButtonTitle:@"确定"];
    
    BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"提现失败" andWithMassage:listdata.checkRemark andWithTag:1 andWithButtonTitle:@"确定"];
    [QalertView showInView:self.view];
    
    __block XERechargeRecordViewController *self_c = self;
    
    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
    
            NSLog(@"sdddddddd");
    
    
        }
    };
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
