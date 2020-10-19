//
//  GetIntelligenceViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/27.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "GetIntelligenceViewController.h"
#import "GetIntelligenceCell.h"
#import "AttentionWeChatViewController.h"
#import "InvitefriendViewController.h"
#import "RealNameViewController.h"

#import "PanetRequestTool.h"
#import "GetIntelligenceModel.h"
#import "GetIntelligenceDataModel.h"
#import "PanetKnInetlCommon.h"
#import "BBTMineRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTHShopViewController.h"


@interface GetIntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *intelligencenoLabel;

@property (nonatomic, strong) NSArray *IntelligenceImageArr;
@property (nonatomic, strong) NSArray *IntelligencetitleArr;
@property (nonatomic, strong) NSArray *IntelligencesubtitleArr;
@property (nonatomic, strong) NSArray *IntelligencesubtitlesubArr;

@property (nonatomic, strong) NSMutableArray *IntelligenceArr;


@end

@implementation GetIntelligenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"获取智力加速度";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadChlidView];
    
//    self.IntelligenceImageArr = @[@"intelligence_check_in",@"intelligence_wachat",@"intelligence_friend",@"intelligence_Certification"];
//    self.IntelligencetitleArr = @[@"今日签到",@"关注微信公众号",@"邀请好友",@"实名认证" ];
//    self.IntelligencesubtitleArr = @[@"连续签到获取更多智力值",@"关注可获得智力值", @"每邀请一人获取智力值", @"认证通过获取智力值"];

    self.IntelligenceImageArr = @[@"intelligence_check_in",@"intelligence_friend",@"intelligence_Certification",@"intelligence_mall"];
    self.IntelligencetitleArr = @[@"今日签到",@"邀请好友",@"实名认证" ];
    self.IntelligencesubtitleArr = @[@"连续签到获取更多智力值", @"每邀请一人获取智力值", @"认证通过获取智力值",@"购买商品可获取智力值"];
    
    self.IntelligencesubtitlesubArr = @[@"已完成",@"已完成", @"已完成", @"已完成"];
    [self Getgetintelligence];
    
}

- (void)LoadChlidView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 245)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 225)];
    
    bgImageView.image = [UIImage imageNamed:@"IntelligenceSpeed"];
    
    [headerView addSubview:bgImageView];
    
    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 16, 94, kDeviceWidth - 32, 31)];
    self.intelligencenoLabel.text = self.intelligenceStr;
    self.intelligencenoLabel.textAlignment = NSTextAlignmentCenter;
    self.intelligencenoLabel.font = [UIFont systemFontOfSize:42.0];
    self.intelligencenoLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    self.intelligencenoLabel.backgroundColor = [UIColor clearColor];
    
    
    [bgImageView addSubview:self.intelligencenoLabel];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 245)];
    
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

- (void)Getgetintelligence
{
    
    [self startLoading];
    
    [PanetRequestTool GetUserScoretasksuccess:^(GetIntelligenceModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.IntelligenceArr = respone.data;
            
            if (self.IntelligenceArr.count >2) {
                [self.IntelligenceArr removeObjectAtIndex:1];
            }
            
            GetIntelligenceDataModel *dataModel = [[GetIntelligenceDataModel alloc] init];
            dataModel.taskName = @"商城消费";
//            dataModel.finished = @"0";
            
            [self.IntelligenceArr addObject:dataModel];
            
//            finished = 0;
//            scoreValue = 0;
//            taskName = "\U9080\U8bf7\U597d\U53cb";
//            taskValue = 5;
            
            [self.tableView reloadData];
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.IntelligenceArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 74;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"intelligencecell";
    GetIntelligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[GetIntelligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }

    GetIntelligenceDataModel *dataModel = [self.IntelligenceArr objectAtIndex:indexPath.row];
    
    cell.leftImage.image = [UIImage imageNamed: [self.IntelligenceImageArr objectAtIndex:indexPath.row] ];

    
    cell.nameLabel.text = dataModel.taskName;
    cell.timeLabel.text = [self.IntelligencesubtitleArr objectAtIndex:indexPath.row];
    cell.konwLabel.text = [NSString stringWithFormat:@"+%@知识豆",dataModel.scoreValue];
    
    
    
    cell.intelligenceBtn.tag = indexPath.row;
    
    if (indexPath.row == 1) {
        
        [cell.intelligenceBtn setTitle:[NSString stringWithFormat:@"+%@智力",dataModel.taskValue] forState:UIControlStateNormal];
        cell.intelligenceBtn.enabled = YES;
    }
   else if (indexPath.row == 3) {
    
       
       cell.konwLabel.hidden = YES;
        [cell.intelligenceBtn setTitle:@"立即前往" forState:UIControlStateNormal];
        cell.intelligenceBtn.enabled = YES;
    }
    else
    {
        if ([dataModel.finished isEqualToString:@"1"]) {
            
            [cell.intelligenceBtn setTitle:[self.IntelligencesubtitlesubArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            cell.intelligenceBtn.enabled = NO;
            cell.konwLabel.hidden = YES;
        }
        else
        {
            [cell.intelligenceBtn setTitle:[NSString stringWithFormat:@"+%@智力",dataModel.taskValue] forState:UIControlStateNormal];
            cell.intelligenceBtn.enabled = YES;
        }
        
//        if ([dataModel.scoreValue isEqualToString:@"0"]) {
//            cell.konwLabel.hidden = YES;
//        }
        
    }
    
    if ([dataModel.scoreValue isEqualToString:@"0"]) {
        cell.konwLabel.hidden = YES;
    }
    
   
    
    [cell.intelligenceBtn addTarget:self action:@selector(intelligenceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GetIntelligenceDataModel *dataModel = [self.IntelligenceArr objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
  
        case 1:
        {
            InvitefriendViewController *InvitefriendVC = [[InvitefriendViewController alloc] init];

            InvitefriendVC.inviteCodeStr = self.inviteCodeStr;
            
            [self.navigationController pushViewController:InvitefriendVC animated:YES];
        }
            break;
            
        case 2:
        {
            if ([dataModel.finished isEqualToString:@"1"]) {
                
     
            }
            else
            {
                RealNameViewController *RealNameVC = [[RealNameViewController alloc] init];
                
                
                [self.navigationController pushViewController:RealNameVC animated:YES];
            }
            

        }
            break;
            
        case 3:
        {
            BBTHShopViewController *ShopVC = [[BBTHShopViewController alloc] init];
//            ShopVC.VCType = @"Panet";
            
            [self.navigationController pushViewController:ShopVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}



- (void)intelligenceBtnClicked:(UIButton *)btn
{

    
    switch (btn.tag) {
        case 0:
        {
             GetIntelligenceDataModel *dataModel = [self.IntelligenceArr objectAtIndex:btn.tag];
        
            [self startLoading];
        
            [PanetRequestTool GetUsersignInsuccess:^(PanetKnInetlCommon * _Nonnull respone) {
        
                [self stopLoading];
        
                if ([respone.statusCode isEqualToString:@"0"]) {
        
        
                    dataModel.finished = @"1";
        
                    [self.tableView reloadData];
                    [self GETPersonalData];
        
                }else{
        
        
                    [self showToastWithString:respone.message];
                }
        
            } failure:^(NSError * _Nonnull error) {
        
                [self stopLoading];
                [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
            }];
            NSLog(@"dsfdsdfsdfsdfd");
            
        }
            break;
            
//        case 1:
//        {
//            AttentionWeChatViewController *AttentionWeChatVC = [[AttentionWeChatViewController alloc] init];
//
//
//            [self.navigationController pushViewController:AttentionWeChatVC animated:YES];
//        }
//            break;
            
        case 1:
        {
            InvitefriendViewController *InvitefriendVC = [[InvitefriendViewController alloc] init];
            
            InvitefriendVC.inviteCodeStr = self.inviteCodeStr;
            
            [self.navigationController pushViewController:InvitefriendVC animated:YES];
        }
            break;
            
        case 2:
        {
            RealNameViewController *RealNameVC = [[RealNameViewController alloc] init];
            
            
            [self.navigationController pushViewController:RealNameVC animated:YES];
        }
            break;
            
        case 3:
        {
            BBTHShopViewController *ShopVC = [[BBTHShopViewController alloc] init];
//            ShopVC.VCType = @"Panet";
            
            [self.navigationController pushViewController:ShopVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark -- 获取个人资料
-(void)GETPersonalData{
    
    
    [self startLoading];
    
    [BBTMineRequestTool GETPersonalData:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            
            if (registerRespone.data.intellectValue.length == 0)
            {
                registerRespone.data.intellectValue = @"0";
            }
            
            self.intelligencenoLabel.text =registerRespone.data.intellectValue;
            
            self.inviteCodeStr = registerRespone.data.inviteCode;
    
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    [self GETPersonalData];
    
    
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
