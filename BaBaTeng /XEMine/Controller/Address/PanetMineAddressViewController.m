//
//  PanetMineAddressViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineAddressViewController.h"
#import "PanetMineAddressCell.h"
#import "PanetMineAddAddressViewController.h"
#import "PanetMineEditAddressViewController.h"

#import "PanetMineAddressDataAddressModel.h"
#import "PanetMineAddressListModel.h"
#import "PanetMineAddressModel.h"
#import "MineRequestTool.h"



@interface PanetMineAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong) NSString *pageStr;

@property (nonatomic, strong)  NSMutableArray *AddressArr;
@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation PanetMineAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的地址";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNum = 1;
    
    [self LoadChlidView];
    

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
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10.5)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
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
    
    [self setNavigationItem];
    
    [self pullRefresh];
    
    
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"新增地址" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(AddAddress) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)GetAddress
{
    
    [self startLoading];
    
    [MineRequestTool getPanetMineaddressnParameter:nil pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]  success:^(PanetMineAddressModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.AddressArr = respone.data.list;
            
            if (self.AddressArr.count == 0) {
                self.noLabel.hidden = NO;
                self.tableView.hidden = YES;
            }
            else
            {
                self.noLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
//
//            self.knowledgenoLabel.text = respone.data.scoreValue;
//            
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
    
    [self startLoading];
    
    [MineRequestTool getPanetMineaddressnParameter:nil pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(PanetMineAddressModel * _Nonnull respone) {

        [self stopLoading];

        [self.tableView.mj_footer endRefreshing];

        if ([respone.statusCode isEqualToString:@"0"]) {

            self.pageStr = respone.data.pages;

            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;

            if (array1.count>0) {




                [self.AddressArr addObjectsFromArray:array1];
                [self.tableView reloadData];

            }



        }else{


            [self showToastWithString:respone.message];
        }

    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    //
    
//
//    [self startLoading];
//
//    [PanetRequestTool GetUserScorerecordType:@"1" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(KnowledgeModel * _Nonnull respone) {
//        [self stopLoading];
//
//        [self.tableView.mj_footer endRefreshing];
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//            self.pageStr = respone.data.pageInfo.pages;
//
//            NSMutableArray *array1 = [[NSMutableArray alloc]init];
//            array1 = respone.data.pageInfo.list;
//
//            if (array1.count>0) {
//
//
//
//
//                [self.KnowledgeArr addObjectsFromArray:array1];
//                [self.tableView reloadData];
//
//            }
//
//
//
//        }else{
//
//
//            [self showToastWithString:respone.message];
//        }
//
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    
    
}


- (void)AddAddress
{
    PanetMineAddAddressViewController * PanetMineAddAddressVC = [[PanetMineAddAddressViewController alloc] init];
    
    
    [self.navigationController pushViewController:PanetMineAddAddressVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.AddressArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 111;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"PanetMineSetingcell";
    
    PanetMineAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[PanetMineAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }

    PanetMineAddressListModel *listdata = [self.AddressArr objectAtIndex:indexPath.row];
    cell.NameLabel.text =listdata.receiverName;
    cell.phonenoLabel.text = listdata.receiverPhone;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", listdata.province,listdata.city,listdata.area,listdata.address];
    
    cell.EditBtn.tag = indexPath.row;
    
    [cell.EditBtn addTarget:self action:@selector(EditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //
    //
    
    if ([self.addressType isEqualToString:@"1"]) {
            PanetMineAddressListModel *listdata = [self.AddressArr objectAtIndex:indexPath.row];
        
            PanetMineEditAddressViewController *PanetMineEditAddressVC = [[PanetMineEditAddressViewController alloc] init];
        
            PanetMineEditAddressVC.listdata = listdata;
        
            [self.navigationController pushViewController:PanetMineEditAddressVC animated:YES];
        
    }
    else if ([self.addressType isEqualToString:@"2"])
    {
        PanetMineAddressListModel *listdata = [self.AddressArr objectAtIndex:indexPath.row];
        
        NSString *addressstr = [NSString stringWithFormat:@"%@ %@ %@ %@", listdata.province,listdata.city,listdata.area,listdata.address];
        
        _block(addressstr,listdata.receiverPhone, listdata.receiverName);
  
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self showToastWithString:@"无效点击"];
    }
    
}

- (void)EditBtnClicked:(UIButton *)btn
{
    PanetMineAddressListModel *listdata = [self.AddressArr objectAtIndex:btn.tag];
    
    PanetMineEditAddressViewController *PanetMineEditAddressVC = [[PanetMineEditAddressViewController alloc] init];
    
    PanetMineEditAddressVC.listdata = listdata;
    
    [self.navigationController pushViewController:PanetMineEditAddressVC animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
//    [self GetAddress];
//
//
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self GetAddress];
    
    
}


@end
