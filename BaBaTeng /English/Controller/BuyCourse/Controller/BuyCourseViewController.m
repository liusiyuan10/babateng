//
//  BuyCourseViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BuyCourseViewController.h"
#import "PayRecordViewController.h"

#import "BuyCourseCell.h"

#import "QAlbumPayView.h"

#import <AlipaySDK/AlipaySDK.h>

#import "EnglishRequestTool.h"
#import "CoursePackage.h"
#import "CoursePackageData.h"
#import "SaveCourseOrder.h"
#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"
#import "SaveCourseOrderData.h"


#import "ExperienceViewController.h"

#import "CoursePayResultViewController.h"

@interface BuyCourseViewController ()<UITableViewDelegate,UITableViewDataSource,QAlbumPayViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  UIButton *selectBtn;

@property (nonatomic, strong)  UIButton *buyBtn;

@property (nonatomic, assign) NSInteger SelectNum;

@property (nonatomic, strong)  NSMutableArray *packageArr;

@property (nonatomic, strong)   NSString *outTradeNoStr;

@end

@implementation BuyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"购买课程";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.SelectNum = -1;
    
    self.packageArr = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyCourseSuccess:) name:@"BuyCourseSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyCourseFailure:) name:@"BuyCourseFailure" object:nil];
    
    [self LoadChlidView];
    
    [self getCoursePackage];
    
}

- (void)BuyCourseSuccess:(NSNotification *)noti
{
//    ExperienceViewController *ExperienceControlVC = [[ExperienceViewController alloc] init];
//
//    [self.navigationController pushViewController:ExperienceControlVC animated:YES];
    
    CoursePayResultViewController *PayResultVC = [[CoursePayResultViewController alloc] init];
    
    [self.navigationController pushViewController:PayResultVC animated:YES];
}


- (void)BuyCourseFailure:(NSNotification *)noti
{
    [self showToastWithString:@"支付失败!"];
}

- (void)getCoursePackage
{
    
    [self startLoading];
    [EnglishRequestTool getCoursePackageParameter:nil success:^(CoursePackage *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.packageArr = respone.data;
            
            [self.tableView reloadData];
            
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
    
    [self setNavigationItem];
    
    
    
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
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 302)/2.0, KDeviceHeight - 66 - 43 - 44 -kDevice_Is_iPhoneX, 302, 66)];
    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"Ebtn_Confirm"] forState:UIControlStateNormal];
    
    [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    [self.buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.buyBtn];
    
}
#pragma mark - NavigationItem
-(void)setNavigationItem{

    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"付款记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(Payrecord) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.packageArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 72 + 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"myteachercell";
    BuyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[BuyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    
//    if (indexPath.row == 0) {
//        cell.courseBtn.selected = YES;
//    }
    
    
    CoursePackageData *packagedata = [self.packageArr objectAtIndex:indexPath.row];
    
    cell.packageLabel.text = packagedata.packageName;
    
    cell.amountLabel.text = [NSString stringWithFormat:@"%@元",packagedata.totalPrice];
    cell.EveryamountLabel.text = [NSString stringWithFormat:@"¥%@/次",packagedata.unitPrice];
    cell.numLabel.text = [NSString stringWithFormat:@"%@次(%@个月)",packagedata.packageTimes,packagedata.validityPeriod];
    cell.givingnumLabel.text = [NSString stringWithFormat:@"赠%@次",packagedata.presentTimes];;
    
    
    
    cell.courseBtn.tag = indexPath.row;
    [cell.courseBtn addTarget:self action:@selector(courseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    _amountLabel.text = @"2500元";
//    _EveryamountLabel.text = @"¥38.5/次";
//    _numLabel.text = @"65次(6个月)";
//    _givingnumLabel.text = @"赠65次";

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    footerView.backgroundColor = [UIColor whiteColor];
    

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 200 -12, 20, 200, 25)];
    label.font = [UIFont boldSystemFontOfSize:18.0];  //UILabel的字体大小
//    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentRight;  //文本对齐方式
    [label setBackgroundColor:[UIColor clearColor]];
    if (self.SelectNum == -1) {
        label.text = @"需支付:0元";
    }
    else
    {
        CoursePackageData *packagedata = [self.packageArr objectAtIndex:self.SelectNum];
        label.text = [NSString stringWithFormat:@"需支付:%@元",packagedata.totalPrice];
    }
    


    [footerView addSubview:label];
    

    
    return  footerView;
}



- (void)courseBtnClicked:(UIButton *)sender   //这里的sender就是cell被点击的btn
{
    NSLog(@"第%ld行被点击",(long)sender.tag);
    
    self.SelectNum = sender.tag;
    
    self.selectBtn.selected = NO;
    
    sender.selected = YES;
    
    self.selectBtn = sender;
    
    [self.tableView reloadData];
    
}

- (void)buyBtnClicked:(UIButton *)btn
{
    if (self.SelectNum == -1) {
        
        [self showToastWithString:@"你还没有选择套餐"];
        
        return;
    }
    
//        NSDictionary *bodydic = @{@"packageId":[parameter objectForKey:@"packageId"], @"phoneNumber":[parameter objectForKey:@"phoneNumber"], @"payType":[parameter objectForKey:@"payType"] };
    
    
     CoursePackageData *packagedata = [self.packageArr objectAtIndex:self.SelectNum];
    
     NSDictionary *parameter = @{@"packageId" :packagedata.packageId , @"phoneNumber" : [[TMCache sharedCache] objectForKey:@"phoneNumber"], @"payType" : @"1" };
    
    [self startLoading];
    [EnglishRequestTool PostSaveCourseOrder:parameter success:^(SaveCourseOrder *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
             self.outTradeNoStr = respone.data.outTradeNo;
            
            QAlbumPayView *tfSheetView = [[QAlbumPayView alloc]init];
            
            tfSheetView.delegate = self;
            [tfSheetView showInView:self.view];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    

}

#pragma mark -- QAlbumPayViewDelegate
-(void)QAlbumPayViewBtnClicked:(QAlbumPayView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex
{
    
//       NSDictionary *bodydic = @{@"payType" : [parameter objectForKey:@"payType"], @"outTradeNo":[parameter objectForKey:@"outTradeNo"] };
    
     NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"1" };
    
    
    [self startLoading];
    [EnglishRequestTool PostPayCourseOrder:parameter success:^(PayCourseOrder *respone) {
        
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

- (void)Payrecord
{
    PayRecordViewController *PayRecordControlVC = [[PayRecordViewController alloc] init];

    [self.navigationController pushViewController:PayRecordControlVC animated:YES];
    
//    ForeignPayRecordViewController *PayRecordControlVC = [[ForeignPayRecordViewController alloc] init];
//
//    [self.navigationController pushViewController:PayRecordControlVC animated:YES];
    
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
