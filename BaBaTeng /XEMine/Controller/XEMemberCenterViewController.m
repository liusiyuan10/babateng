//
//  XEMemberCenterViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMemberCenterViewController.h"
#import "XEMemberUpgradeViewController.h"
#import "XEMemberRuleViewController.h"

#import "XEUpgradeView.h"
#import "MineRequestTool.h"
#import "UpdateLevelModel.h"
#import "UpdateLevelDataModel.h"
#import "PanetKnInetlCommon.h"
#import "XBLCPlatformViewController.h"

@interface XEMemberCenterViewController ()<XEUpgradeViewDelegate>

@property(nonatomic, strong) UILabel *intelligenceLabel;
@property(nonatomic, strong) UILabel *shopintelligenceLabel;
@property(nonatomic, strong) UILabel *basisintelligenceLabel;

@property(nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, copy) NSString *uplevelIdStr;

@end

@implementation XEMemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
}


- (void)LoadChlidView
{
    UIImageView  *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 121)];
    
    headerView.backgroundColor = [UIColor clearColor];
    headerView.image = [UIImage imageNamed:@"memberBG"];
    
    headerView.userInteractionEnabled = YES;
    
    [self.view addSubview:headerView];
    
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 150)/2.0 ,25, 150, 150)];

    if ([self.levelIdStr isEqualToString:@"1"]) {
        
        [iconImageview setImage:[UIImage imageNamed:@"normal_big"]];
        
    }else if ([self.levelIdStr isEqualToString:@"2"])
    {
        [iconImageview setImage:[UIImage imageNamed:@"practicel_big"]];
        
    }else if ([self.levelIdStr isEqualToString:@"3"])
    {
        [iconImageview setImage:[UIImage imageNamed:@"gold_big"]];
    }
    

    [self.view addSubview:iconImageview];
    
    UIImageView *back1View = [[UIImageView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(iconImageview.frame) + 19, kDeviceWidth - 32, 49)];

    back1View.backgroundColor = [UIColor clearColor];
    back1View.image = [UIImage imageNamed:@"platform"];
    back1View.userInteractionEnabled = YES;
    [self.view addSubview:back1View];
    
    
    UITapGestureRecognizer *back1ViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back1ViewClicked)];
    
    // 2. 将点击事件添加到label上
    [back1View addGestureRecognizer:back1ViewGestureRecognizer];
    
    if ([self.agentUserStr isEqualToString:@"0"]) {
        back1View.hidden = YES;
        self.intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(iconImageview.frame) + 23, 120, 16)];
    }
    else
    {
        back1View.hidden = NO;
        
        self.intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(back1View.frame) + 23, 120, 16)];
    }
    
    
    
    self.intelligenceLabel.backgroundColor=[UIColor clearColor];
    self.intelligenceLabel.textAlignment=NSTextAlignmentLeft;
    self.intelligenceLabel.textColor=[UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    self.intelligenceLabel.text = [NSString stringWithFormat:@"智力值: %@", self.intelligenceStr];
    
    self.intelligenceLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    [self.view addSubview:self.intelligenceLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(self.intelligenceLabel.frame) + 16, kDeviceWidth - 32, 90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 10.0f;
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    
    [headerView addSubview:backView];
    
    
    CGFloat backViewW = (kDeviceWidth - 16 *2 -1)/2.0;
    
    UIImageView *balanceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backViewW, 90)];
    
    balanceView.backgroundColor = [UIColor clearColor];
    
    
    balanceView.userInteractionEnabled = YES;
    
    [backView addSubview:balanceView];
    
    self.shopintelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 33, backViewW, 16)];
    
    self.shopintelligenceLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.shopintelligenceLabel.backgroundColor = [UIColor clearColor];
    self.shopintelligenceLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    self.shopintelligenceLabel.text = self.upgradeScoreStr;
    self.shopintelligenceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [balanceView addSubview:self.shopintelligenceLabel];
    
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.shopintelligenceLabel.frame) + 13, backViewW, 12)];
    
    balanceLabel.font = [UIFont systemFontOfSize:12.0];
    balanceLabel.backgroundColor = [UIColor clearColor];
    balanceLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    balanceLabel.text = @"购物智力值";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    
    [balanceView addSubview:balanceLabel];
    
    UIImageView *knowledgeView = [[UIImageView alloc] initWithFrame:CGRectMake(backViewW + 1, 0, backViewW, 90)];
    
    knowledgeView.backgroundColor = [UIColor clearColor];
    
    
    knowledgeView.userInteractionEnabled = YES;
    
    [backView addSubview:knowledgeView];
    
    self.basisintelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 33, backViewW, 16)];
    
    self.basisintelligenceLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.basisintelligenceLabel.backgroundColor = [UIColor clearColor];
    self.basisintelligenceLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.basisintelligenceLabel.text = self.baseScoreStr;
    self.basisintelligenceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [knowledgeView addSubview:self.basisintelligenceLabel];
    
    
    UILabel *knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.basisintelligenceLabel.frame) + 13, backViewW, 12)];
    
    knowledgeLabel.font = [UIFont systemFontOfSize:12.0];
    knowledgeLabel.backgroundColor = [UIColor clearColor];
    knowledgeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    knowledgeLabel.text = @"基础智力值";
    knowledgeLabel.textAlignment = NSTextAlignmentCenter;
    
    [knowledgeView addSubview:knowledgeLabel];
    
//    BBT_Mineicon
    
    UIImageView *backimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame) + 20,kDeviceWidth, 120)];
    //        arrowView.backgroundColor = [UIColor redColor];
    //
    backimageView.image = [UIImage imageNamed:@"BBT_Mineicon"];
    
    [self.view addSubview:backimageView];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 36 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.submitBtn.backgroundColor = MNavBackgroundColor;
    self.submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"申请升级" forState:UIControlStateNormal];
    
    [self.submitBtn addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.submitBtn.layer.cornerRadius= 22.0f;
    
    self.submitBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.submitBtn];
    
    
    
    if ([self.upgradeStatus isEqualToString:@"0"]) {
        
        self.submitBtn.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
        self.submitBtn.enabled = NO;
        
         [self.submitBtn setTitle:@"申请中" forState:UIControlStateNormal];
    }
    
//    if ([self.levelIdStr isEqualToString:@"3"]) {
//
//        self.submitBtn.hidden = YES;
//    }
    
    self.submitBtn.hidden = YES;
    
//    CGFloat memberW = (kDeviceWidth - 16 *3)/2.0;
//
//    UIView *memberRuleView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(iconImageview.frame) + 33, memberW, 90)];
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
//   UILabel *memberRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 38, 70, 15)];
//
//    memberRuleLabel.font = [UIFont systemFontOfSize:16.0];
//    memberRuleLabel.backgroundColor = [UIColor clearColor];
//    memberRuleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    memberRuleLabel.text = @"会员规则";
//    memberRuleLabel.textAlignment = NSTextAlignmentLeft;
//
//    [memberRuleView addSubview:memberRuleLabel];
//
//   UIImageView *memberRuleImageView = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(memberRuleLabel.frame) + 14,18 ,55, 55)];
//
//   [memberRuleImageView setImage:[UIImage imageNamed:@"ruler"]];
//
//
//    [memberRuleView addSubview:memberRuleImageView];
//
//    UIView *memberUpgradeView = [[UIView alloc] initWithFrame:CGRectMake( memberW + 16*2, CGRectGetMaxY(iconImageview.frame) + 33, memberW, 90)];
//
//    memberUpgradeView.backgroundColor = [UIColor whiteColor];
//
//    memberUpgradeView.layer.cornerRadius= 15.0f;
//
//    memberUpgradeView.layer.borderWidth = 1.0;
//    memberUpgradeView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
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
//    UILabel *memberUpgradeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 38, 70, 15)];
//
//    memberUpgradeLabel.font = [UIFont systemFontOfSize:16.0];
//    memberUpgradeLabel.backgroundColor = [UIColor clearColor];
//    memberUpgradeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    memberUpgradeLabel.text = @"会员升级";
//    memberUpgradeLabel.textAlignment = NSTextAlignmentLeft;
//
//    [memberUpgradeView addSubview:memberUpgradeLabel];
//
//    UIImageView *memberUpgradeImageView = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(memberRuleLabel.frame) + 14,18 ,55, 55)];
//
//    [memberUpgradeImageView setImage:[UIImage imageNamed:@"upgrade"]];
//
//
//    [memberUpgradeView addSubview:memberUpgradeImageView];
//
    
    
    [self setNavigationItem];
    
    
}



#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"规则" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(memberRuleViewClick) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)AddSubmit
{
    

    
//    NSInteger upgradeScoreN = [self.upgradeScoreStr integerValue];
//    
//    NSInteger directFriendN = [self.directFriend integerValue];
//    
//    if ([self.levelIdStr isEqualToString:@"1"]) {
//        
//        if (upgradeScoreN < 198 || directFriendN < 5) {
//            
//            [self showToastWithString:@"您还不符合申请条件，无法申请"];
//            
//            return;
//        }
//    }
//    else
//    {
//        if (upgradeScoreN < 2019 || directFriendN > 25) {
//            
//            [self showToastWithString:@"您还不符合申请条件，无法申请"];
//            
//            return;
//        }
//    }
    
     self.submitBtn.enabled = NO;
    
    [MineRequestTool PostMemberUpgradeParameter:nil success:^(PanetKnInetlCommon * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self showToastWithString:@"您的申请已提交"];
            
            
            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];
            
        }else{
            
            self.submitBtn.enabled = YES;
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        self.submitBtn.enabled = YES;
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}

- (void)XEUpgradeViewBtnClicked:(XEUpgradeView *)view
{
    

    [MineRequestTool PostMemberUpgradeParameter:nil success:^(PanetKnInetlCommon * _Nonnull respone) {

        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {

            [self showToastWithString:@"升级成功"];


            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];

        }else{


            [self showToastWithString:respone.message];
        }

    } failure:^(NSError * _Nonnull error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

    }];
    
    
//    NSDictionary *parameter = @{@"memberLevel" :  self.uplevelIdStr,@"phoneNumber": [[TMCache sharedCache] objectForKey:@"phoneNumber"], @"nickName": [[TMCache sharedCache] objectForKey:@"nickName"]};
//
//    NSLog(@"parameter========%@",parameter);
//
//    [MineRequestTool PostMemberUpgradeParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
//
//        [self stopLoading];
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//            [self showToastWithString:@"升级成功"];
//
//
//            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];
//
//        }else{
//
//
//            [self showToastWithString:respone.message];
//        }
//
//    } failure:^(NSError * _Nonnull error) {
//
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
//    }];
    
    
}

- (void)GoToBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//- (void)memberUpgradeViewClick
//{
//
//    XEMemberUpgradeViewController *XEMemberUpgradeVC = [[XEMemberUpgradeViewController alloc] init];
//    XEMemberUpgradeVC.levelIdStr = self.levelIdStr;
//
//    [self.navigationController pushViewController:XEMemberUpgradeVC animated:YES];
//}



- (void)memberRuleViewClick
{
    NSLog(@"sfdsfdfdsfdssd");

    
    XEMemberRuleViewController *XEMemberRuleVC = [[XEMemberRuleViewController alloc] init];
    
    XEMemberRuleVC.title = @"会员规则";
    XEMemberRuleVC.ruleType = @"1";
    [self.navigationController pushViewController:XEMemberRuleVC animated:YES];
}

- (void)back1ViewClicked
{
    XBLCPlatformViewController *XBLCPlatformVC = [[XBLCPlatformViewController alloc] init];
    
    XBLCPlatformVC.pageIndex = 0;
    [self.navigationController pushViewController:XBLCPlatformVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    
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
