//
//  XEPaymentViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEPaymentViewController.h"
#import "XEPaymentCell.h"
//#import "XEAlbumPayView.h"

#import "XEPaymentDetailViewController.h"

#import "MineRequestTool.h"
#import "XEOrderModel.h"
#import "XEOrderDataModel.h"
#import "XEOrderListModel.h"

#import "UIImageView+AFNetworking.h"
#import "HomeRequestTool.h"
#import "PanetKnInetlCommon.h"


#import "QAlbumPayView.h"

#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"

#import "WXApi.h"

#import "NSString+Hash.h"
#import <AlipaySDK/AlipaySDK.h>

@interface XEPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,QAlbumPayViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *OrderArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;
@property (nonatomic, strong)       NSString *pagetotal;

@property (nonatomic, copy)       NSString *orderid;


@property(nonatomic, strong)    UILabel *noLabel;

@property (nonatomic, copy)   NSString *outTradeNoStr;


@end

@implementation XEPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XEPaymentViewRefresh:) name:@"XEPaymentViewRefresh" object:nil];
    
    self.OrderArr = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
    
    [self LoadChlidView];
    
    [self getOrder];

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

- (void)getOrder
{
    [self startLoading];
    
    [MineRequestTool GetAllmallOrderOrderStatus:@"0" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(XEOrderModel * _Nonnull response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.OrderArr = response.data.list;
            self.pageStr = response.data.pages;
            
            if (self.OrderArr.count >0) {
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

- (void)XEPaymentViewRefresh:(NSNotification *)noti
{
    self.PageNum = 1;
    [self getOrder];
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
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    //
    
    
    [self startLoading];
    
    [MineRequestTool GetAllmallOrderOrderStatus:@"0" pageNum:[NSString stringWithFormat:@"%ld",(long)self.PageNum] success:^(XEOrderModel * _Nonnull response) {
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = response.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = response.data.list;
            
            if (array1.count>0) {
                
                [self.OrderArr addObjectsFromArray:array1];
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
    
    return self.OrderArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 241 + 16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"XEPaymentCellcell";
    XEPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XEPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    XEOrderListModel *listdata = [self.OrderArr objectAtIndex:indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.goodsImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_empty"]];
    
    cell.nameLabel.text = listdata.goodsName;
    
    cell.totalLabel.text = [NSString stringWithFormat:@"共%@件商品",listdata.goodsNumber] ;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",listdata.orderTotalPrice] ;
    
    cell.payBtn.tag = indexPath.row;
    
    [cell.payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XEOrderListModel *listdata = [self.OrderArr objectAtIndex:indexPath.row];
    
    XEPaymentDetailViewController *XEPaymentDetaiVC = [[XEPaymentDetailViewController alloc] init];
    XEPaymentDetaiVC.orderid = listdata.orderId;

    [self.navigationController pushViewController:XEPaymentDetaiVC animated:YES];
}

- (void)payBtnClicked:(UIButton *)btn
{
    XEOrderListModel *listdata = [self.OrderArr objectAtIndex:btn.tag];
    
    self.outTradeNoStr = listdata.orderSn;
    
    QAlbumPayView *tfSheetView = [[QAlbumPayView alloc]init];
    
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
//   self.orderid = listdata.orderId;
//
//
//    NSString *priceStr = [NSString stringWithFormat:@"%.2fsee",listdata.goodsTotalPrice];
//    XEAlbumPayView *tfSheetView = [[XEAlbumPayView alloc]init];
//
//    tfSheetView.delegate = self;
//    tfSheetView.priceStr = priceStr;
//    [tfSheetView showInView:self.view];
    
    
}

#pragma mark -- QAlbumPayViewDelegate
-(void)QAlbumPayViewBtnClicked:(QAlbumPayView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex
{
    
    NSLog(@"selectindex=========%ld",(long)selectindex);
    if(selectindex == 0)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"1" };
        
        
        [self startLoading];
        [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PayCourseOrder *respone) {
            
            [self stopLoading];
            
            if ([respone.statusCode isEqualToString:@"0"]) {
                
                NSString *str = respone.data.bizContent;
                //
                NSLog(@"bizContent===========%@",str);
                
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:str fromScheme:@"BaBaTeng" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslutssssssssssss = %@",resultDic);
                    
                    
                }];
                
                
                
                
            }
            else
            {
                [self showToastWithString:respone.message];
            }
            
            
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
        }];
        
        
        
    }
    else if (selectindex == 1)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"2" };
        
        
        [self startLoading];
        [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PayCourseOrder *respone) {
            
            [self stopLoading];
            
            if ([respone.statusCode isEqualToString:@"0"]) {
                
                NSString *str = respone.data.bizContent;
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                
                req.partnerId           = respone.data.partnerid;
                req.prepayId            = respone.data.prepayid;
                req.nonceStr            = respone.data.noncestr;
                req.timeStamp           = respone.data.timestamp.intValue;
                req.package             = @"Sign=WXPay";
                req.sign                = respone.data.sign;
                
                
                
                NSLog(@"sing==========%@",req.sign);
                
                [WXApi sendReq:req];
                //
                NSLog(@"bizContent===========%@",str);
                
                
            }
            else
            {
                [self showToastWithString:respone.message];
            }
            
            
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
        }];
        
    }else
    {
        [self showToastWithString:@"暂不支持"];
    }
    
}


//- (void)XEAlbumPayViewBtnClicked:(XEAlbumPayView *)view
//{
//
//
//    if (self.orderid.length == 0) {
//
//        [self showToastWithString:@"订单号不能为空"];
//    }
//
//    NSDictionary *parameter = @{@"payType" : @1, @"orderId": self.orderid, @"payNo": @"" };
////
////    [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
////
////        [self stopLoading];
////        if ([respone.statusCode isEqualToString:@"0"]) {
////
////            [self showToastWithString:@"支付成功"];
////            NSLog(@"111111111");
////
////            self.PageNum = 1;
////            [self getOrder];
////
////        }
////        else{
////
////            [self showToastWithString:respone.message];
////        }
////
////    } failure:^(NSError * _Nonnull error) {
////        [self stopLoading];
////        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
////    }];
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

//    [self getOrder];
    
    
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
