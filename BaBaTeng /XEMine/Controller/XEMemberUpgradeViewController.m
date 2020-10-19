//
//  XEMemberUpgradeViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMemberUpgradeViewController.h"

#import "XEUpgradeView.h"
#import "MineRequestTool.h"
#import "UpdateLevelModel.h"
#import "UpdateLevelDataModel.h"
#import "PanetKnInetlCommon.h"


@interface XEMemberUpgradeViewController ()<XEUpgradeViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *UpgradeBtn;

@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, copy) NSString *uplevelIdStr;

@end

@implementation XEMemberUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员升级";
    [self LoadChlidView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)LoadChlidView
{
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64 - 48 - kDevice_IsE_iPhoneX)];
    
    //    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.image = [UIImage imageNamed:@"member_upgrade"];
    
    self.bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bgImageView];
    
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 173)/2.0 ,25, 173, 173)];
    
    if ([self.levelIdStr isEqualToString:@"1"]) {
        
        [iconImageview setImage:[UIImage imageNamed:@"normal_big"]];
        
    }else if ([self.levelIdStr isEqualToString:@"2"])
    {
        [iconImageview setImage:[UIImage imageNamed:@"practicel_big"]];
        
    }else if ([self.levelIdStr isEqualToString:@"3"])
    {
        [iconImageview setImage:[UIImage imageNamed:@"gold_big"]];
    }
    
    
    [self.bgImageView addSubview:iconImageview];
    
    self.iconImageview = iconImageview;
    
    
    UIButton *UpgradeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,KDeviceHeight - 64 - 48,kDeviceWidth, 48)];
    
    UpgradeBtn.backgroundColor = MNavBackgroundColor;
    UpgradeBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [UpgradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UpgradeBtn setTitle:@"充值升级" forState:UIControlStateNormal];
    
    [UpgradeBtn addTarget:self action:@selector(UpgradeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UpgradeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    
    [self.view addSubview:UpgradeBtn];
    
    self.UpgradeBtn = UpgradeBtn;
    
    
    
}
- (void)UpgradeBtnClicked
{
    [self startLoading];
    
    [MineRequestTool GetUpdateLevelsuccess:^(UpdateLevelModel * _Nonnull response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.uplevelIdStr = response.data.levelId;
            
            NSString *priceStr = [NSString stringWithFormat:@"%@积分",response.data.upgradeScore];
        
            XEUpgradeView *tfSheetView = [[XEUpgradeView alloc]init];
        
            tfSheetView.delegate = self;
            tfSheetView.priceStr = priceStr;
            tfSheetView.levelStr = response.data.levelName;
            [tfSheetView showInView:self.view];
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
//    NSInteger total = 3600 * 1;
//    NSString *priceStr = [NSString stringWithFormat:@"%ldsee",(long)total];
//
//    XEUpgradeView *tfSheetView = [[XEUpgradeView alloc]init];
//
//    tfSheetView.delegate = self;
//    tfSheetView.priceStr = priceStr;
//    [tfSheetView showInView:self.view];
}



- (void)XEUpgradeViewBtnClicked:(XEUpgradeView *)view
{
        NSDictionary *parameter = @{@"memberLevel" :  self.uplevelIdStr,@"phoneNumber": [[TMCache sharedCache] objectForKey:@"phoneNumber"], @"nickName": [[TMCache sharedCache] objectForKey:@"nickName"]};
    
    NSLog(@"parameter========%@",parameter);
    
    [MineRequestTool PostMemberUpgradeParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
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
}

- (void)GoToBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
