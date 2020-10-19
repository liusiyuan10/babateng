//
//  XBLearnCardViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBLearnCardViewController.h"
#import "XBLearnCardCell.h"
#import "XBActiveLearnCardViewController.h"

#import "MineRequestTool.h"
#import "LCPlatformModel.h"
#import "LCPlatformDataModel.h"
#import "LCPlatformListModel.h"


@interface XBLearnCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *LearnCardArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;
@property (nonatomic, strong)       NSString *pagetotal;


@property(nonatomic, strong)    UIImageView *noImageView;


@end

@implementation XBLearnCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"卡包";
    
    self.LearnCardArr = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
    
    [self LoadChlidView];
    
//    [self getPlatform];
    
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
    
    

    self.noImageView = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 250)/2.0 ,108, 250 , 210)];
    
    self.noImageView.image = [UIImage imageNamed:@"LeanCardempty"];
    self.noImageView.hidden = YES;
    
    
    [self.view addSubview:self.noImageView];
    
    [self pullRefresh];
    
    [self setNavigationItem];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    
    [rightbutton setTitle:@"激活卡" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)rightbuttonClick
{
//    #import "XBActiveLearnCardViewController.h"
    
    XBActiveLearnCardViewController *XBActiveLearnCardVC = [[XBActiveLearnCardViewController alloc] init];
    
    [self.navigationController pushViewController:XBActiveLearnCardVC animated:YES];
    
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
    
    [MineRequestTool GetAlstudyCardType:@"1" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(LCPlatformModel * _Nonnull response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.LearnCardArr = response.data.list;
            self.pageStr = response.data.pages;
            
            if (self.LearnCardArr.count >0) {
                self.noImageView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else
            {
                self.noImageView.hidden = NO;
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
    
    [MineRequestTool GetAlstudyCardType:@"1" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(LCPlatformModel * _Nonnull response) {
        
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = response.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;
            
            if (array1.count>0) {
                
                [self.LearnCardArr addObjectsFromArray:array1];
                [self.tableView reloadData];
                
            }
            
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.LearnCardArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 180 + 16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"XBLearnCardCellcell";
    
    XBLearnCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XBLearnCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    

    
    LCPlatformListModel *listdata = [self.LearnCardArr objectAtIndex:indexPath.row];
    cell.iconpriceLabel.text = [NSString stringWithFormat:@"¥%@",listdata.cardPrice];
    
    
    if ([listdata.cardType isEqualToString:@"VIP学习卡"]) {
        cell.iconImageview.image = [UIImage imageNamed:@"VIPcard"];
    }
    else if ([listdata.cardType isEqualToString:@"体验卡"])
    {
        cell.iconImageview.image = [UIImage imageNamed:@"Experiencecard"];
    }
    else
    {
        cell.iconImageview.image = [UIImage imageNamed:@"studycard"];
    }
    
    if ([listdata.cardStatus isEqualToString:@"4"])
    {
        
        cell.iconImageview.image = [UIImage imageNamed:@"Expired"];
    }
    
    
    
    
    cell.iconcardLabel.text = listdata.cardType;
    
    cell.iconclassNoLabel.text = [NSString stringWithFormat:@"课时数:%@节",listdata.studyTimes] ;
    
    if ([listdata.cardStatus isEqualToString:@"1"]) {
      
        cell.iconvalidityLabel.text =  @"未激活";
        
    }else if ([listdata.cardStatus isEqualToString:@"2"])
    {
     
        cell.iconvalidityLabel.text =  @"待审核";
    }else if ([listdata.cardStatus isEqualToString:@"3"])
    {
        cell.iconvalidityLabel.text = [NSString stringWithFormat:@"课程有效期:%@",listdata.expireDate];
    }else if ([listdata.cardStatus isEqualToString:@"4"])
    {

         cell.iconvalidityLabel.text =  @"已过期";
    }
    
    
    
    return cell;
    
}




//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    XBLCPlatformDetailViewController *XBLCPlatformDetailVC = [[XBLCPlatformDetailViewController alloc] init];
//
//    [self.navigationController pushViewController:XBLCPlatformDetailVC animated:YES];
//
//
//}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    self.PageNum = 1;
    
    
    [self getPlatform];
    
}

@end
