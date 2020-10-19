//
//  ForeignPayRecordViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/7.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

//#import "ForeignPayRecordViewController.h"
//
//@interface ForeignPayRecordViewController ()
//
//@end
//
//@implementation ForeignPayRecordViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

#import "ForeignPayRecordViewController.h"

#import "PayRecordCell.h"

#import "PanetRequestTool.h"

#import "QueryPayCourseOrder.h"
#import "QueryPayCourseOrderData.h"

#import "QueryPayCoursePackageData.h"



@interface ForeignPayRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *PayCourseArr;

@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation ForeignPayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"付款记录";
    
    self.PayCourseArr = [[NSMutableArray alloc] init];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
    
    [self getQueryPayCourseOrder];
    
    
}

- (void)getQueryPayCourseOrder
{
    
    [self startLoading];
    [PanetRequestTool getQueryPayCourseOrderParameter:nil OrderFlag:@"2" success:^(QueryPayCourseOrder *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.PayCourseArr = respone.data;
            
            if (self.PayCourseArr.count > 0) {
                [self.tableView reloadData];
            }
            else
            {
                self.noLabel.hidden = NO;
            }
            
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

- (void)LoadChlidView
{
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,10,kDeviceWidth , KDeviceHeight - 10)style:UITableViewStylePlain];
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
    
    noLabel.text = @"暂无记录";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.PayCourseArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 72 + 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"myteachercell";
    PayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[PayRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    QueryPayCourseOrderData *orderdata = [self.PayCourseArr objectAtIndex:indexPath.row];
    
    
    cell.amountLabel.text = [NSString stringWithFormat:@"%@",orderdata.coursePackage.packageName];
    cell.EveryamountLabel.text = [NSString stringWithFormat:@"%@元",orderdata.payMoney];
    cell.timeLabel.text = orderdata.createTime;
    //    cell.givingnumLabel.text = [NSString stringWithFormat:@"%@个月(赠%@次)",orderdata.coursePackage.validityPeriod,orderdata.coursePackage.presentTimes];
    
    if ([orderdata.payType isEqualToString:@"1"]) {
        cell.payTypeLabel.text = @"支付宝支付";
    }
    else
    {
        cell.payTypeLabel.text = @"微信支付";
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
