//
//  XEWalletViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/9.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEWalletViewController.h"
#import "XERechargeViewController.h"

#import "XESmallTwoViewController.h"
#import "XERechargeRecordViewController.h"
#import "XEWalletDetailViewController.h"
#import "MineRequestTool.h"
#import "WalletModel.h"
#import "WalletDataModel.h"
#import "BBTQAlertView.h"
#import "XEWithdrawalViewController.h"

#import "PanetRequestTool.h"
#import "PanetMineModel.h"
#import "PanetMineDataModel.h"
#import "RealNameViewController.h"

@interface XEWalletViewController ()
{
    BBTQAlertView *_QalertView;
    
}

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UILabel *EarningoneLabel;
@property (nonatomic, strong) UILabel *EarningTwoLabel;
@property (nonatomic, strong) UILabel *EarningThreeLabel;

@property (nonatomic, strong) UILabel *withdrawalLabel;

@property (nonatomic, copy) NSString *authenticationstr;

@property (nonatomic, copy) NSString *enableProfitstr;

@end

@implementation XEWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"余额";
    [self LoadChlidView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (void)LoadChlidView
{
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    
    //    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.headerImageView.image = [UIImage imageNamed:@"bg"];
    
    self.headerImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.headerImageView];
    
    UILabel *EarningLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 39, kDeviceWidth, 11)];
    
    EarningLabel.font = [UIFont systemFontOfSize:11.0];
    EarningLabel.backgroundColor = [UIColor clearColor];
    EarningLabel.textColor = [UIColor colorWithRed:253/255.0 green:254/255.0 blue:253/255.0 alpha:1.0];
    EarningLabel.text = @"昨日收益";
    EarningLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:EarningLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(EarningLabel.frame) + 15, kDeviceWidth, 27)];
    
    priceLabel.font = [UIFont systemFontOfSize:36.0];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.text = @"";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:priceLabel];
    
    self.priceLabel = priceLabel;
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(priceLabel.frame) + 12, kDeviceWidth, 11)];
    
    totalLabel.font = [UIFont systemFontOfSize:11.0];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = [UIColor colorWithRed:253/255.0 green:254/255.0 blue:253/255.0 alpha:1.0];
    totalLabel.text = @"余额:";
    totalLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerImageView addSubview:totalLabel];
    
    self.totalLabel = totalLabel;
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 90)/2.0, CGRectGetMaxY(totalLabel.frame) + 21 , 90, 30)];
    
    detailBtn.backgroundColor = [UIColor whiteColor];
    detailBtn.layer.cornerRadius=15.0f;
    detailBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    [detailBtn setTitle:@"查看明细" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    
    [detailBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerImageView addSubview:detailBtn];
    
    [self loadEarningView];
    
    [self LoadWalletView];
    
//    [self GetWallet];
    
}

- (void)loadEarningView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,186, kDeviceWidth - 32,90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [self.view addSubview:backView];
    
    CGFloat ViewW = (kDeviceWidth - 32 - 2)/3.0;
    
    UIView *EarningoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewW, 90)];
    EarningoneView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:EarningoneView];
    
    self.EarningoneLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
    self.EarningoneLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.EarningoneLabel.backgroundColor = [UIColor clearColor];
    self.EarningoneLabel.text = @"";
    self.EarningoneLabel.textAlignment = NSTextAlignmentCenter;
    self.EarningoneLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [backView addSubview:self.EarningoneLabel];
    
    UILabel *EarningonesubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.EarningoneLabel.frame) + 10, ViewW, 12)];
    EarningonesubLabel.font = [UIFont systemFontOfSize:12.0];
    EarningonesubLabel.backgroundColor = [UIColor clearColor];
    EarningonesubLabel.text = @"7日收益(元)";
    EarningonesubLabel.textAlignment = NSTextAlignmentCenter;
    EarningonesubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [backView addSubview:EarningonesubLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW, 18, 1.0, 90 - 18 -16 )];
    
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    UIView *EarningTwoView = [[UIView alloc] initWithFrame:CGRectMake(ViewW + 1, 0, ViewW, 90)];
    EarningTwoView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:EarningTwoView];
    
    self.EarningTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
    self.EarningTwoLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.EarningTwoLabel.backgroundColor = [UIColor clearColor];
    self.EarningTwoLabel.text = @"";
    self.EarningTwoLabel.textAlignment = NSTextAlignmentCenter;
    self.EarningTwoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [EarningTwoView addSubview:self.EarningTwoLabel];
    
    UILabel *EarningTwosubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.EarningTwoLabel.frame) + 10, ViewW, 12)];
    EarningTwosubLabel.font = [UIFont systemFontOfSize:12.0];
    EarningTwosubLabel.backgroundColor = [UIColor clearColor];
    EarningTwosubLabel.text = @"30天收益(元)";
    EarningTwosubLabel.textAlignment = NSTextAlignmentCenter;
    EarningTwosubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [EarningTwoView addSubview:EarningTwosubLabel];
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW * 2 + 1, 18, 1.0, 90 - 18 -16 )];
    
    line1View.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:line1View];
    
    UIView *EarningThreeView = [[UIView alloc] initWithFrame:CGRectMake( (ViewW + 1) *2, 0, ViewW, 90)];
    EarningThreeView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:EarningThreeView];
    
    self.EarningThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 31, ViewW, 14)];
    self.EarningThreeLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.EarningThreeLabel.backgroundColor = [UIColor clearColor];
    self.EarningThreeLabel.text = @"";
    self.EarningThreeLabel.textAlignment = NSTextAlignmentCenter;
    self.EarningThreeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    [EarningThreeView addSubview:self.EarningThreeLabel];
    
    
    
    UILabel *EarningThreesubLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.EarningThreeLabel.frame) + 10, ViewW, 12)];
    EarningThreesubLabel.font = [UIFont systemFontOfSize:12.0];
    EarningThreesubLabel.backgroundColor = [UIColor clearColor];
    EarningThreesubLabel.text = @"累计收益(元)";
    EarningThreesubLabel.textAlignment = NSTextAlignmentCenter;
    EarningThreesubLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [EarningThreeView addSubview:EarningThreesubLabel];
    
}

- (void)GetWallet
{
    [self startLoading];
    
    [MineRequestTool GetWalletsuccess:^(WalletModel * _Nonnull response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",response.data.yestodayProfit];
            self.totalLabel.text = [NSString stringWithFormat:@"余额:%.2f元",response.data.memberAmount];
            self.EarningoneLabel.text = [NSString stringWithFormat:@"%.2f",response.data.weekProfit];
            self.EarningTwoLabel.text = [NSString stringWithFormat:@"%.2f",response.data.monthProfit];
            
            self.EarningThreeLabel.text = [NSString stringWithFormat:@"%.2f",response.data.allProfit];
            
            
            self.withdrawalLabel.text = [NSString stringWithFormat:@"¥%.2f",response.data.enableProfit];
            
            self.enableProfitstr = [NSString stringWithFormat:@"%.2f",response.data.enableProfit];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}


- (void)getUserScoreCenter
{
    [self startLoading];
    [PanetRequestTool getUserScoreCentersuccess:^(PanetMineModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.authenticationstr = respone.data.authentication;
            
      
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}


- (void)LoadWalletView
{
    
//    CGFloat memberW = (kDeviceWidth - 16 *3)/2.0;
    
//    UIView *memberRuleView = [[UIView alloc] initWithFrame:CGRectMake(16, 292, memberW, 90)];
//
//    memberRuleView.backgroundColor = [UIColor whiteColor];
//
//    memberRuleView.layer.cornerRadius= 15.0f;
//
//    memberRuleView.layer.borderWidth = 1.0;
//    memberRuleView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//    memberRuleView.clipsToBounds = YES;//去除边界
//    memberRuleView.layer.masksToBounds = YES;
//    memberRuleView.userInteractionEnabled = YES;
//    [self.view addSubview:memberRuleView];
//
//    UITapGestureRecognizer *memberRuleViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberRuleViewClick)];
//
//    // 2. 将点击事件添加到label上
//    [memberRuleView addGestureRecognizer:memberRuleViewGestureRecognizer];
//
//    UILabel *memberRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 38, 70, 15)];
//
//    memberRuleLabel.font = [UIFont systemFontOfSize:16.0];
//    memberRuleLabel.backgroundColor = [UIColor clearColor];
//    memberRuleLabel.textColor = MNavBackgroundColor;
//    memberRuleLabel.text = @"小二币";
//    memberRuleLabel.textAlignment = NSTextAlignmentLeft;
//
//    [memberRuleView addSubview:memberRuleLabel];
//
//    UIImageView *memberRuleImageView = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(memberRuleLabel.frame) + 14,18 ,55, 55)];
//
//    [memberRuleImageView setImage:[UIImage imageNamed:@"coin"]];
//
//
//    [memberRuleView addSubview:memberRuleImageView];
    
//    UIView *memberUpgradeView = [[UIView alloc] initWithFrame:CGRectMake( 16, 292, kDeviceWidth - 32, 90)];
//    
//    memberUpgradeView.backgroundColor = MNavBackgroundColor;
//    
//    memberUpgradeView.layer.cornerRadius= 15.0f;
//    
////    memberUpgradeView.layer.borderWidth = 1.0;
////    memberUpgradeView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//    memberUpgradeView.clipsToBounds = YES;//去除边界
//    memberUpgradeView.layer.masksToBounds = YES;
//    memberUpgradeView.userInteractionEnabled = YES;
//    [self.view addSubview:memberUpgradeView];
//    
//    UITapGestureRecognizer *memberUpgradeViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberUpgradeViewClick)];
//    
//    // 2. 将点击事件添加到label上
//    [memberUpgradeView addGestureRecognizer:memberUpgradeViewGestureRecognizer];
//    
//    UILabel *memberUpgradeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 19, 38, 70, 15)];
//    
//    memberUpgradeLabel.font = [UIFont systemFontOfSize:16.0];
//    memberUpgradeLabel.backgroundColor = [UIColor clearColor];
//    memberUpgradeLabel.textColor = [UIColor whiteColor];
//    memberUpgradeLabel.text = @"充值积分";
//    memberUpgradeLabel.textAlignment = NSTextAlignmentLeft;
//    
//    [memberUpgradeView addSubview:memberUpgradeLabel];
//    
//    UIImageView *memberUpgradeImageView = [[UIImageView alloc]initWithFrame:CGRectMake( kDeviceWidth - 32 - 32 -27,25 ,32, 41)];
//    
//    [memberUpgradeImageView setImage:[UIImage imageNamed:@"topup"]];
//    
//    
//    [memberUpgradeView addSubview:memberUpgradeImageView];
    
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16, 292, kDeviceWidth - 32,90)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.view addSubview:back1View];
    
    self.withdrawalLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, 26, 300, 18)];
    self.withdrawalLabel.font = [UIFont boldSystemFontOfSize:24.0];
    self.withdrawalLabel.backgroundColor = [UIColor clearColor];
    self.withdrawalLabel.text = @"";
    self.withdrawalLabel.textAlignment = NSTextAlignmentLeft;
    self.withdrawalLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    [back1View addSubview:self.withdrawalLabel];
    
    
    UILabel *withdLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, CGRectGetMaxY(self.withdrawalLabel.frame) + 12, 80, 11)];
    
    withdLabel.font = [UIFont systemFontOfSize:10.0];
    withdLabel.backgroundColor = [UIColor clearColor];
    withdLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    withdLabel.text = @"可提现金额";
    withdLabel.textAlignment = NSTextAlignmentLeft;
    
    [back1View addSubview:withdLabel];
    
   UIButton *withdBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 32 - 90 -16,24 ,90, 44)];
    //    _phoneView.userInteractionEnabled = NO;
    withdBtn.backgroundColor = MNavBackgroundColor;

    
    [withdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdBtn setTitle:@"提现" forState:UIControlStateNormal];
    
     withdBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
     withdBtn.layer.cornerRadius= 22.0f;
    
     withdBtn.clipsToBounds = YES;//去除边界
    
    [withdBtn addTarget:self action:@selector(withdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [back1View addSubview:withdBtn];
    
}

- (void)withdBtnClicked
{
    
    if ([self.authenticationstr isEqualToString:@"1"]) {
        
        XEWithdrawalViewController *XEWithdrawalVC = [[XEWithdrawalViewController alloc] init];
        XEWithdrawalVC.enableProfitstr =  self.enableProfitstr;
        
        [self.navigationController pushViewController:XEWithdrawalVC animated:YES];
    }
    else
    {
        
    _QalertView = [[BBTQAlertView alloc] initWithRMRZWithMassage:@"你还没有认证收款账号" andWithTag:1 andWithButtonTitle:@"取消",@"立即认证", nil];

    [_QalertView showInView:self.view];

    __block XEWalletViewController *self_c = self;


    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
        RealNameViewController *RealNameVC = [[RealNameViewController alloc] init];
    
        [self_c.navigationController pushViewController:RealNameVC animated:YES];

        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");

        }
    };
    }
    
    
//    _QalertView = [[BBTQAlertView alloc] initWithRMRZWithMassage:@"你还没有认证收款账号" andWithTag:1 andWithButtonTitle:@"取消",@"立即认证", nil];
//
//    [_QalertView showInView:self.view];
//
//    __block XEWalletViewController *self_c = self;
//
//
//    //点击按钮回调方法
//    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//        if (titleBtnTag == 1) {
//
//
//        }
//        if (titleBtnTag == 0) {
//            NSLog(@"sg");
//
//        }
//    };
    


}

- (void)detailBtnClicked
{
    XEWalletDetailViewController *XEWalletDetailVC = [[XEWalletDetailViewController alloc] init];
    
    [self.navigationController pushViewController:XEWalletDetailVC animated:YES];
}


- (void)memberUpgradeViewClick
{
    XERechargeViewController *XERechargeVC = [[XERechargeViewController alloc] init];
    
    [self.navigationController pushViewController:XERechargeVC animated:YES];
}
- (void)memberRuleViewClick
{
    NSLog(@"sfdsfdfdsfdssd");
    
    XESmallTwoViewController *XESmallTwoVC = [[XESmallTwoViewController alloc] init];
    
    [self.navigationController pushViewController:XESmallTwoVC animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    [self GetWallet];
    
    [self getUserScoreCenter];
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
