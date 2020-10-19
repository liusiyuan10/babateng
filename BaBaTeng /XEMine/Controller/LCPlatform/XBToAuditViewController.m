//
//  XBToAuditViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/30.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBToAuditViewController.h"
#import "XBLCPlatformCellCell.h"
#import "XBLCPlatformDetailViewController.h"
#import "MineRequestTool.h"
#import "LCPlatformModel.h"
#import "LCPlatformDataModel.h"
#import "LCPlatformListModel.h"


@interface XBToAuditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *platformArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;
@property (nonatomic, strong)       NSString *pagetotal;


@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation XBToAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.platformArr = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
    
    [self LoadChlidView];
    
    [self getPlatform];
    
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

- (void)getPlatform
{
    [self startLoading];
    
    [MineRequestTool GetAlstudyCardStatus:@"2" CardType:@"0" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(LCPlatformModel * _Nonnull response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.platformArr = response.data.list;
            self.pageStr = response.data.pages;
            
            if (self.platformArr.count >0) {
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
        
    }];
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    
    [self startLoading];
    
    [MineRequestTool GetAlstudyCardStatus:@"2" CardType:@"0" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(LCPlatformModel * _Nonnull response) {
        
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = response.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;
            
            if (array1.count>0) {
                
                [self.platformArr addObjectsFromArray:array1];
                [self.tableView reloadData];
                
            }
            
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.platformArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 153 + 16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"XBLCPlatformCellCellcell";
    
    XBLCPlatformCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XBLCPlatformCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    
    
    LCPlatformListModel *listdata = [self.platformArr objectAtIndex:indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",listdata.cardPrice] ;
    
    
    cell.platformStaueLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    cell.platformStaueLabel.text = @"待审核";
    
    
    cell.CardNoLabel.text = listdata.cardNo;
    
    cell.ClassNoLabel.text = [NSString stringWithFormat:@"课时数:%@节",listdata.studyTimes] ;
    cell.ValidityLabel.text = [NSString stringWithFormat:@"课程有效期:%@",listdata.expireDate];
     cell.ValidityLabel.hidden = YES;
    
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCPlatformListModel *listdata = [self.platformArr objectAtIndex:indexPath.row];
    
    XBLCPlatformDetailViewController *XBLCPlatformDetailVC = [[XBLCPlatformDetailViewController alloc] init];
    XBLCPlatformDetailVC.listdata = listdata;
    
    [self.navigationController pushViewController:XBLCPlatformDetailVC animated:YES];
    
    
}


@end
