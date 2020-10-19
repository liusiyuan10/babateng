//
//  PanetMineViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineViewController.h"
#import "PanetMineCell.h"
#import "PanetMineAssetViewController.h"
#import "PanetMineSettingViewController.h"
#import "InvitefriendViewController.h"


#import "UIImageView+AFNetworking.h"
#import "RealNameViewController.h"
#import "PanetRequestTool.h"
#import "PanetMineModel.h"
#import "PanetMineDataModel.h"


@interface PanetMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *PanetMineImageArr;
@property (nonatomic, strong) NSArray *PanetMinetitleArr;

@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, strong) UILabel *personalNameLabel;
@property (nonatomic, strong) UILabel *personalSubNameLabel;

@property (nonatomic, copy) NSString *authenticationstr;


@end

@implementation PanetMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.PanetMineImageArr = @[@"PanetMine_money",@"PanetMine_name",@"PanetMine_friends",@"PanetMine_setting"];
    self.PanetMinetitleArr = @[@"我的资产",@"实名认证",@"邀请好友",@"设置" ];
    
    [self LoadChlidView];
    
    [self getUserScoreCenter];
    
}

- (void)LoadChlidView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 151)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
    
    bgImageView.image = [UIImage imageNamed:@"PanetMine_rectangle"];
    
    [headerView addSubview:bgImageView];
    
    self.iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(33,34, 84, 84)];
    self.iconImageview.layer.cornerRadius = 15;
    self.iconImageview.layer.masksToBounds = YES;
//    [self.iconImageview setImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    [self.iconImageview setImageWithURL:[NSURL URLWithString: [[TMCache sharedCache] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    [bgImageView addSubview:self.iconImageview];
    
    
    //
    self.personalNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+16, 51,kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-80,20)];
    [self.personalNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
    self.personalNameLabel.font =  [UIFont boldSystemFontOfSize:21.0f];
//    self.personalNameLabel.numberOfLines = 0;
    self.personalNameLabel.textColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0f];
    self.personalNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgImageView addSubview:self.personalNameLabel];
    
    self.personalSubNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+16, CGRectGetMaxY(self.personalNameLabel.frame) + 18, kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-80,20)];
    
    NSString *deviceName = [NSString stringWithFormat:@"ID:%@",[[TMCache sharedCache] objectForKey:@"userId"]];
    [self.personalSubNameLabel  setText:deviceName];
    self.personalSubNameLabel.font = [UIFont systemFontOfSize:15.0];
    self.personalSubNameLabel.textColor =  [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0f];
    self.personalSubNameLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageView addSubview:self.personalSubNameLabel ];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 151)];
    
    [self.tableView.tableHeaderView addSubview:headerView];
    
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
    
}

- (void)getUserScoreCenter
{
    [self startLoading];
    [PanetRequestTool getUserScoreCentersuccess:^(PanetMineModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.authenticationstr = respone.data.authentication;
            
            [self.tableView reloadData];
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 61.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"PanetMinecell";
    PanetMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[PanetMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    cell.leftImage.image = [UIImage imageNamed: [self.PanetMineImageArr objectAtIndex:indexPath.row] ];
    cell.nameLabel.text = [self.PanetMinetitleArr objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        cell.subLabel.hidden = NO;
        
        
    }
    
    if ([self.authenticationstr isEqualToString:@"1"]) {
        cell.subLabel.text = @"已认证";
        cell.subLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
        
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    switch (indexPath.row) {
        case 0:
        {
            PanetMineAssetViewController *PanetMineAssetVC = [[PanetMineAssetViewController alloc] init];
            PanetMineAssetVC.intelligenceStr = self.intelligenceStr;
            
            [self.navigationController pushViewController:PanetMineAssetVC animated:YES];
        }
            break;
        case 1:
        {
            RealNameViewController *RealNameVC = [[RealNameViewController alloc] init];
            
  
            [self.navigationController pushViewController:RealNameVC animated:YES];
        }
            break;
            
        case 2:
        {
            InvitefriendViewController *InvitefriendVC = [[InvitefriendViewController alloc] init];
            
            InvitefriendVC.inviteCodeStr = self.inviteCodeStr;
            [self.navigationController pushViewController:InvitefriendVC animated:YES];
        }
            break;
        case 3:
        {
            PanetMineSettingViewController *PanetMineSettingVC = [[PanetMineSettingViewController alloc] init];
            
            
            [self.navigationController pushViewController:PanetMineSettingVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
}

@end
