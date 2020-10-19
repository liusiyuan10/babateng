//
//  HelpAndFeedBackEquipmentViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2018/1/12.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//
//  AddEquipmentViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/17.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "HelpAndFeedBackEquipmentViewController.h"
#import "EquipmentCell.h"
#import "EquipmentUseHelpViewController.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTEquipmentRespone.h"
#import "BBTResultRespone.h"
#import "BBTDevice.h"
#import "BBTDeviceData.h"
#import "BBTDeviceDataList.h"
#import "HelpViewController.h"
#import "BBTBigFeedBackViewController.h"

#import "UIImageView+AFNetworking.h"

@interface HelpAndFeedBackEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * array;

@property (nonatomic, strong) NSString *pageStr;
@property (nonatomic, assign) NSInteger pageIndx;

@end

@implementation HelpAndFeedBackEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight - 64 ) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
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
    
    self.array = [[NSMutableArray alloc] init];
    
    self.pageIndx = 1;
    
    [self pullRefresh];
    
    [self getdevicetype];//获取设备分类数据
    
    // [self setUpNavigationItem];
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark UITableView + 上拉刷新 默认
- (void) pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}

- (void)loadMoreData
{
    
    self.pageIndx++;
    
    if( self.pageIndx > [self.pageStr integerValue])
    {
        [self.tableView.mj_footer endRefreshing];
        //        [self showToastWithString:@"没有更多的数据"];
        return;
    }
    
    NSNumber *pagenumber = [NSNumber numberWithInteger:self.pageIndx];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :pagenumber,@"pageSize" :@10 ,@"type": @"1"};
    [self startLoading];
    [BBTEquipmentRequestTool getDevicetypeListParameter:parameter success:^(BBTDevice *respone) {
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self.array addObjectsFromArray:respone.data.list];
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self.tableView.mj_footer endRefreshing];
        
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
    
}


#pragma mark - 获取设备分类列表数据
-(void)getdevicetype{
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@10 ,@"type": @"1"};
    [self startLoading];
    [BBTEquipmentRequestTool getDevicetypeListParameter:parameter success:^(BBTDevice *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.array =(NSMutableArray*) respone.data.list;
            
            self.pageStr = respone.data.pages;
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

- (void)setUpNavigationItem
{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    [button setImage:[UIImage imageNamed:@"nav_bangzu"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_bangzu_pre"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(usinghelpAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}


-(void)usinghelpAction{
    
    
    [self.navigationController pushViewController:[EquipmentUseHelpViewController new] animated:YES];
    
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.array.count; // self.array.count;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kDeviceWidth-30, 30)];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.font = [UIFont systemFontOfSize:15.0f];
        headerLabel.textColor = MainFontColorTWO;
        
        headerLabel.text = @"请选择购买的设备";
        
        
        headerLabel.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:headerLabel];
        
        return headerView;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 40;
        
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = @"Identifier";
    
    EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[EquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.bgImageView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
        BBTDeviceDataList *resultRespones = self.array[indexPath.row];
        
        //    cell.leftImage.image = [UIImage imageNamed:@"SB_01"];
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resultRespones.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SB_01"]];
        
        cell.nameLabel.text =resultRespones.deviceTypeName;

    //    cell.onlineLabel.text = resultRespones.type;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90/568.0*KDeviceHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        
        BBTDeviceDataList *resultRespones = self.array[indexPath.row];
        

        if ([self.JumpType isEqualToString:@"helpVc"]) {
            
            
            HelpViewController *helpVc = [[HelpViewController alloc] init];
            helpVc.name = @"使用帮助";
            // NSString *urlStr = [NSString stringWithFormat:@"%@UserAgreement.html",BBT_HTML];
            NSString *urlStr = [NSString stringWithFormat:@"%@helpList.html?deviceTypeId=%@",BBT_HTML,resultRespones.deviceTypeId];
            NSLog(@"使用帮助urlStr====%@",urlStr);
            
            helpVc.URL = [NSURL URLWithString:urlStr];
            
            [self.navigationController pushViewController:helpVc animated:YES];
            
        }else if ([self.JumpType isEqualToString:@"feedBack"]) {
            
            BBTBigFeedBackViewController *configVc = [[BBTBigFeedBackViewController alloc] init];
            configVc.deviceTypeName = resultRespones.deviceTypeName;
            configVc.deviceTypeId = resultRespones.deviceTypeId;
            [self.navigationController pushViewController:configVc animated:YES];
            
        }
        
    
    }
    


//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


-(void)usinghelp{
    
    [self.navigationController pushViewController:[[EquipmentUseHelpViewController alloc]init] animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
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


