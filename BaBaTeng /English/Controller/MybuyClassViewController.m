//
//  MybuyClassViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/26.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MybuyClassViewController.h"
#import "EnglishRequestTool.h"
#import "Student.h"
#import "CoursePackage.h"
#import "CoursePackageData.h"
#import "MybuyClassCell.h"
#import "UIImageView+AFNetworking.h"
#import "BBTQAlertView.h"

#import "PanetRequestTool.h"
#import "SaveCourseOrder.h"
#import "QAlbumPayView.h"
#import "SaveCourseOrderData.h"
#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ForeignPayRecordViewController.h"

#import "MybuyClassPayResultViewController.h"

#import "WXApi.h"

#import "NSString+Hash.h"

@interface MybuyClassViewController ()<UITableViewDelegate,UITableViewDataSource,QAlbumPayViewDelegate>
{
    BBTQAlertView *_QalertView;

}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *remainLabel;

@property (nonatomic, strong) UILabel *haveLabel;
@property (nonatomic, strong)  NSMutableArray *packageArr;

@property (nonatomic, copy)   NSString *outTradeNoStr;

@end

@implementation MybuyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的课时";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyCourseSuccess:) name:@"BuyCourseSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyCourseFailure:) name:@"BuyCourseFailure" object:nil];
    
    [self LoadChlidView];
    
    [self getStudentDetail];
    
    [self getCoursePackage];
     
}

- (void)BuyCourseSuccess:(NSNotification *)noti
{
    
    
    MybuyClassPayResultViewController *PayResultVC = [[MybuyClassPayResultViewController alloc] init];
    
    [self.navigationController pushViewController:PayResultVC animated:YES];
}


- (void)BuyCourseFailure:(NSNotification *)noti
{
    [self showToastWithString:@"支付失败!"];
}


- (void)LoadChlidView
{
    [self LoadHeadView];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 270 - 16)];
    
    [self.tableView.tableHeaderView addSubview:self.headView];
    
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
    
    [self setNavigationItem];
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"付款记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(Payrecord) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)Payrecord
{
    
    
    ForeignPayRecordViewController *PayRecordControlVC = [[ForeignPayRecordViewController alloc] init];
    
    [self.navigationController pushViewController:PayRecordControlVC animated:YES];
    
    
}


- (void)LoadHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 270 - 16)];
    self.headView.backgroundColor =[UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 104 - 18, 21, 104, 104)];
    
    iconView.layer.cornerRadius = 52; //设置图片圆角的尺度
    iconView.layer.borderWidth = 1.0;
    iconView.layer.borderColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0].CGColor;
    iconView.clipsToBounds = YES;//去除边界
    iconView.layer.masksToBounds = YES; //没这句话它圆不起来
    
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache] objectForKey:@"userIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
//    iconView.image = [UIImage imageNamed:@"Teacher"];
    
    iconView.userInteractionEnabled = YES;
    
    [self.headView  addSubview:iconView];
    
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 46,200, 24)];
    
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    nameLabel.text = @"teahence";
    
    
    [self.headView  addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(nameLabel.frame) + 12,200, 13)];
    
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor colorWithRed:252/255.0 green:156/255.0 blue:32/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
//    timeLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    //    numLabel.textAlignment = NSTextAlignmentRight;
    
    [self.headView  addSubview:timeLabel];
    
    self.timeLabel = timeLabel;
    
    
    
    CGFloat remainW = (kDeviceWidth - 16*3)/2.0;
    UIView *remainView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_iconView.frame) + 21, remainW, 100)];
    
    remainView.layer.cornerRadius= 15.0f;
    
    remainView.layer.borderWidth = 1.0;
    remainView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    remainView.clipsToBounds = YES;//去除边界
    remainView.layer.masksToBounds = YES;
    
    [self.headView addSubview:remainView];
    
    self.remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29,remainW, 22)];
    
    self.remainLabel.font = [UIFont boldSystemFontOfSize:30];
    self.remainLabel.backgroundColor = [UIColor clearColor];
    self.remainLabel.textColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    //    timeLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    self.remainLabel.textAlignment = NSTextAlignmentCenter;
    
    [remainView  addSubview:self.remainLabel];
    
    UILabel *remaintextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remainLabel.frame) + 16,remainW, 12)];
    
    remaintextLabel.font = [UIFont systemFontOfSize:12];
    remaintextLabel.backgroundColor = [UIColor clearColor];
    remaintextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    remaintextLabel.text = @"剩余课时数";
    //    timeLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    remaintextLabel.textAlignment = NSTextAlignmentCenter;
    
    [remainView addSubview:remaintextLabel];
    
    
    UIView *HaveView = [[UIView alloc] initWithFrame:CGRectMake(16 +remainW +16, CGRectGetMaxY(_iconView.frame) + 21, remainW, 100)];
    
    HaveView.layer.cornerRadius= 15.0f;
    
    HaveView.layer.borderWidth = 1.0;
    HaveView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    HaveView.clipsToBounds = YES;//去除边界
    HaveView.layer.masksToBounds = YES;
    
    [self.headView addSubview:HaveView];
    
    self.haveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29,remainW, 22)];
    
    self.haveLabel.font = [UIFont boldSystemFontOfSize:30];
    self.haveLabel.backgroundColor = [UIColor clearColor];
    self.haveLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    //    timeLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    self.haveLabel.textAlignment = NSTextAlignmentCenter;
    
    [HaveView  addSubview:self.haveLabel];
    
    UILabel *havetextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remainLabel.frame) + 16,remainW, 12)];
    
    havetextLabel.font = [UIFont systemFontOfSize:12];
    havetextLabel.backgroundColor = [UIColor clearColor];
    havetextLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    havetextLabel.text = @"已使用课时数";
    //    timeLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    havetextLabel.textAlignment = NSTextAlignmentCenter;
    
    [HaveView addSubview:havetextLabel];
    
    
    [self.view addSubview:self.headView];
    
  
    
    
    
    
}


- (void)getStudentDetail
{
  
    [self startLoading];
    
    [EnglishRequestTool getStudentDetailStudentId:[[TMCache sharedCache] objectForKey:@"userId"] success:^(Student *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            //    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.teareservationdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            //
            //    [iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
//            
            self.nameLabel.text = respone.data.name;
            
            if (respone.data.courseValidity.length == 0) {
                self.timeLabel.text = [NSString stringWithFormat:@"课时有效期:%@",@"--"];
            }
            else
            {self.timeLabel.text = [NSString stringWithFormat:@"课时有效期:%@",respone.data.courseValidity];
            }
            
            self.remainLabel.text = respone.data.totalTimes;
            self.haveLabel.text = respone.data.remainingTimes;

        }else{

            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

- (void)getCoursePackage
{
    
    [self startLoading];
    [EnglishRequestTool getCoursePackageAssignParameter:nil success:^(CoursePackage *respone) {
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.packageArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 232+16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"MybuyClassCellcell";
    MybuyClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[MybuyClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    CoursePackageData *packagedata = [self.packageArr objectAtIndex:indexPath.row];
    
    
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)packagedata.packageImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"mybuyclass"]];
    
    cell.nameLabel.text = packagedata.packageName;
    cell.iocnView.image = [UIImage imageNamed:@"mybuyclass"];
    
    cell.presentLabel.text = [NSString stringWithFormat:@"%@节",packagedata.presentTimes];
    cell.educeMoneyLabel.text = [NSString stringWithFormat:@"¥%@",packagedata.educeMoney];
    NSInteger totaltimes = [packagedata.packageTimes integerValue] + [packagedata.presentTimes integerValue];
    cell.totalLabel.text = [NSString stringWithFormat:@"%ld节",(long)totaltimes];
    cell.unitPriceLabel.text = [NSString stringWithFormat:@"¥%@",packagedata.unitPrice];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",packagedata.totalPrice];
    
    cell.buyBtn.tag = indexPath.row;
    
    [cell.buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

- (void)buyBtnClicked:(UIButton *)btn
{
//    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"请联系客服！" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
//    [_QalertView showInView:self.view];
//    
//    __block MybuyClassViewController *self_c = self;
//    //点击按钮回调方法
//    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//        if (titleBtnTag == 1) {
//            
//            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"18145863529"];
//            CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
//            if (version >= 10.0) {
//                /// 大于等于10.0系统使用此openURL方法
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
//            } else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//            }
//        }
//        if (titleBtnTag == 0) {
//            NSLog(@"sg");
//            
//        }
//    };

    CoursePackageData *packagedata = [self.packageArr objectAtIndex:btn.tag];
    
    
    NSDictionary *parameter = @{@"packageId" :packagedata.packageId  , @"phoneNumber" : [[TMCache sharedCache] objectForKey:@"phoneNumber"] };
    [self startLoading];
    
    [PanetRequestTool PostSaveCourseOrder:parameter OrderFlag:@"2" success:^(SaveCourseOrder *respone) {
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
    
    NSLog(@"selectindex=========%ld",(long)selectindex);
    if(selectindex == 0)
    {
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
    else if (selectindex == 1)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"2" };
        
        
        [self startLoading];
        [EnglishRequestTool PostPayCourseOrder:parameter success:^(PayCourseOrder *respone) {
            
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
    
    
    
//    NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"1" };
//
//
//    [self startLoading];
//    [EnglishRequestTool PostPayCourseOrder:parameter success:^(PayCourseOrder *respone) {
//
//        [self stopLoading];
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//            NSString *str = respone.data.bizContent;
//            //
//            NSLog(@"bizContent===========%@",str);
//
//            // NOTE: 调用支付结果开始支付
//            [[AlipaySDK defaultService] payOrder:str fromScheme:@"XiaoBaoABC" callback:^(NSDictionary *resultDic) {
//                NSLog(@"reslutssssssssssss = %@",resultDic);
//
//
//            }];
//
//
//        }
//        else
//        {
//            [self showToastWithString:respone.message];
//        }
//
//
//
//    } failure:^(NSError *error) {
//
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
//    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
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
