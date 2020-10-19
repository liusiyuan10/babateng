//
//  MineViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MineOneCell.h"
#import "MineTwoCell.h"
#import "MineThreeCell.h"
#import "PanetMineAddressViewController.h"

#import "XEOrderViewController.h"

#import "XEMemberCenterViewController.h"
#import "InvitefriendViewController.h"
#import "XEWalletViewController.h"


#import "MineRequestTool.h"
#import "MemberDataModel.h"
#import "MemberModel.h"

#import "XESettingViewController.h"
#import "XEPersonalDataViewController.h"

#import "XEWalletDetailViewController.h"
#import "XESmallTwoViewController.h"

#import "XEMineTwoCell.h"
#import "RealNameViewController.h"

#import "BBTMineRequestTool.h"

#import "PanetMineSettingViewController.h"
#import "BBTUserInfoRespone.h"
#import "MineFourCell.h"
#import "PanetViewController.h"
#import "XEMyFriendViewController.h"
#import "GetIntelligenceViewController.h"
#import "IntelligenceViewController.h"
#import "KnowledgeViewController.h"

#import "XBLearnCardViewController.h"
#import "StudyCardShowModel.h"
#import "StudyCardShowDataModel.h"

@interface XEMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, strong) MemberDataModel *memberdata;

@property (nonatomic, strong) UILabel *personalNameLabel;

@property(nonatomic, copy) NSString *inviteCodeStr;
@property(nonatomic, copy) NSString *etherAddressStr;
@property (nonatomic, copy) NSString *intelligenceStr;
@property(nonatomic, assign) CGFloat currencyValue;
@property(nonatomic, copy) NSString *agentUserStr;

@property (nonatomic, strong) UILabel *balancenoLabel;
@property (nonatomic, strong) UILabel *knowledgenoLabel;

@property (nonatomic, strong)  UILabel *levelNameLabel;
@property (nonatomic, strong)  UIImageView *levelImageview;

@property (nonatomic, strong)  UILabel *intelligenceLabel;

@property (nonatomic, strong) StudyCardShowDataModel *studycarddata;

@end

@implementation XEMineViewController

static XEMineViewController *xemineViewController;

+(XEMineViewController *)getInstance{
    
    return xemineViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
    xemineViewController = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadChlidView];
    
//    [self GETPersonalData];
    

}

- (void)updateImage:(UIImage *)image{
    
    [self.iconImageview setImage:image];
    
    
}

- (void)LoadChlidView
{
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 191 + 20)];
    
    headerView.backgroundColor = [UIColor clearColor];

    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 157)];
    
    bgImageView.image = [UIImage imageNamed:@"mine"];
    
    bgImageView.userInteractionEnabled = YES;
    bgImageView.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:bgImageView];
    
    
    
    
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(16,25, 60, 60)];
    iconImageview.layer.cornerRadius = 15;
    iconImageview.layer.masksToBounds = YES;

    [iconImageview setImageWithURL:[NSURL URLWithString: [[TMCache sharedCache] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"user"]];
    [bgImageView addSubview:iconImageview];
    
    self.iconImageview = iconImageview;
    self.iconImageview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headerViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick)];
    
    // 2. 将点击事件添加到label上
    [self.iconImageview addGestureRecognizer:headerViewGestureRecognizer];

    UILabel *personalNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageview.frame)+16, 38,kDeviceWidth-CGRectGetMaxX(iconImageview.frame)+10-80,17)];
    [personalNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
    personalNameLabel.font =  [UIFont boldSystemFontOfSize:18.0f];
  
    personalNameLabel.textColor = [UIColor whiteColor];
    personalNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgImageView addSubview:personalNameLabel];
    
    self.personalNameLabel = personalNameLabel;
    
    
    UIImageView *levelImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageview.frame)+16,CGRectGetMaxY(self.personalNameLabel.frame) + 8, 22, 22)];

//    levelImageview.backgroundColor = [UIColor redColor];
    
    [bgImageView addSubview:levelImageview];
    
    self.levelImageview = levelImageview;
    
    UILabel *levelNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(levelImageview.frame)+5, CGRectGetMaxY(self.personalNameLabel.frame) + 14,80,10)];
  
    levelNameLabel.text = @"初级学员";
    levelNameLabel.font =  [UIFont systemFontOfSize:10.0f];
    
    levelNameLabel.textColor = [UIColor colorWithRed:254/255.0 green:251/255.0 blue:246/255.0 alpha:1.0];
    levelNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgImageView addSubview:levelNameLabel];
    self.levelNameLabel = levelNameLabel;
    
    
    UIView *intelligenceView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth - 120 + 12, CGRectGetMaxY(self.personalNameLabel.frame) + 8 , 120, 24)];//42
    intelligenceView.backgroundColor = [UIColor whiteColor];
    
    intelligenceView.layer.cornerRadius= 12.0f;
//    intelligenceView.layer.borderWidth = 1.0;
//    intelligenceView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    intelligenceView.clipsToBounds = YES;//去除边界
    intelligenceView.layer.masksToBounds = YES;
    
    
    [headerView addSubview:intelligenceView];
    
    UILabel *intelligenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,  (24 - 10)/2.0, 80,10)];
    
    intelligenceLabel.text = @"智力值 232 ";
    intelligenceLabel.font =  [UIFont systemFontOfSize:10.0f];
    
    intelligenceLabel.textColor = [UIColor colorWithRed:255/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
    intelligenceLabel.textAlignment = NSTextAlignmentLeft;
    
    [intelligenceView addSubview:intelligenceLabel];
    
    UIImageView *arrowinImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(intelligenceLabel.frame), (24 - 7)/2.0, 4, 7)];
    
    //    levelImageview.backgroundColor = [UIColor redColor];
    arrowinImageview.image = [UIImage imageNamed:@"BBT_Mine_front"];
    
    [intelligenceView addSubview:arrowinImageview];
    
//
    
    
    self.intelligenceLabel = intelligenceLabel;
    self.intelligenceLabel.userInteractionEnabled = YES;

    UITapGestureRecognizer *intelligenceLabelGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intelligenceClick)];
    
    // 2. 将点击事件添加到label上
    [intelligenceView addGestureRecognizer:intelligenceLabelGestureRecognizer];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(self.iconImageview.frame) + 17, kDeviceWidth - 32, 90)];
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
    
    UITapGestureRecognizer *balanceViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AssetBtnClicked)];
    
    // 2. 将点击事件添加到label上
    [balanceView addGestureRecognizer:balanceViewGestureRecognizer];
    
    self.balancenoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 33, backViewW, 16)];
    
    self.balancenoLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.balancenoLabel.backgroundColor = [UIColor clearColor];
    self.balancenoLabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    self.balancenoLabel.text = @"￥2323.34";
    self.balancenoLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [balanceView addSubview:self.balancenoLabel];
    
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.balancenoLabel.frame) + 13, backViewW, 12)];
    
    balanceLabel.font = [UIFont systemFontOfSize:12.0];
    balanceLabel.backgroundColor = [UIColor clearColor];
    balanceLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    balanceLabel.text = @"余额";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    
    [balanceView addSubview:balanceLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(backViewW, 18, 1.0, 90 - 18 -16 )];
    
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    
    UIImageView *knowledgeView = [[UIImageView alloc] initWithFrame:CGRectMake(backViewW + 1, 0, backViewW, 90)];
    
    knowledgeView.backgroundColor = [UIColor clearColor];
    
    
    knowledgeView.userInteractionEnabled = YES;
    
    [backView addSubview:knowledgeView];
    
    UITapGestureRecognizer *knowledgeViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(knowledgeViewClicked)];
    
    // 2. 将点击事件添加到label上
    [knowledgeView addGestureRecognizer:knowledgeViewGestureRecognizer];
    
    self.knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 33, backViewW, 16)];
    
    self.knowledgenoLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.knowledgenoLabel.backgroundColor = [UIColor clearColor];
    self.knowledgenoLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.knowledgenoLabel.text = @"211323.34258";
    self.knowledgenoLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [knowledgeView addSubview:self.knowledgenoLabel];
    
    
    UILabel *knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.balancenoLabel.frame) + 13, backViewW, 12)];
    
    knowledgeLabel.font = [UIFont systemFontOfSize:12.0];
    knowledgeLabel.backgroundColor = [UIColor clearColor];
    knowledgeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    knowledgeLabel.text = @"知识豆";
    knowledgeLabel.textAlignment = NSTextAlignmentCenter;
    
    [knowledgeView addSubview:knowledgeLabel];
    


    
    
//    UILabel *personalSubNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageview.frame)+16, CGRectGetMaxY(personalNameLabel.frame) + 8, kDeviceWidth-CGRectGetMaxX(iconImageview.frame)+10-80,10)];
//
//    NSString *deviceName = [NSString stringWithFormat:@"ID:%@",[[TMCache sharedCache] objectForKey:@"userId"]];
//    [personalSubNameLabel  setText:deviceName];
//    personalSubNameLabel.font = [UIFont systemFontOfSize:12.0];
//    personalSubNameLabel.textColor =  [UIColor whiteColor];
//    personalSubNameLabel.textAlignment = NSTextAlignmentLeft;
//    [headerView addSubview:personalSubNameLabel];
    
    
    
    

    
    
    CGFloat TableH = KDeviceHeight - kDevice_IsE_iPhoneX;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,kDeviceWidth, TableH)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 191 + 20)];
    
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
    
//    [self setNavigationItem];
    
}

- (void)GetStudyCardShow
{
    
    [MineRequestTool GetStudyCardShowsuccess:^(StudyCardShowModel * _Nonnull response) {
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.studycarddata = response.data;
            NSLog(@"self.studycarddat=========%@",self.studycarddata.onOff);
            
            [self.tableView reloadData];
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
     
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}

- (void)GetMemberInfo{
    
    [self startLoading];
    
    [MineRequestTool getMembersuccess:^(MemberModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            

            self.memberdata = respone.data;
            
            self.balancenoLabel.text = [NSString stringWithFormat:@"¥%.2f",respone.data.memberAmount];
            
            if ([respone.data.levelId isEqualToString:@"1"]) {
                
                [self.levelImageview setImage:[UIImage imageNamed:@"primary"]];
                self.levelNameLabel.text = respone.data.levelName;
                
            }else if ([respone.data.levelId isEqualToString:@"2"])
            {
                [self.levelImageview setImage:[UIImage imageNamed:@"secondary"]];
                self.levelNameLabel.text = respone.data.levelName;
                
            }else if ([respone.data.levelId isEqualToString:@"3"])
            {
                [self.levelImageview setImage:[UIImage imageNamed:@"thirdary"]];
                self.levelNameLabel.text = respone.data.levelName;
            }
            
            [self.tableView reloadData];
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}

#pragma mark -- 获取个人资料
-(void)GETPersonalData{
    
    
    [self startLoading];
    
    [BBTMineRequestTool GETPersonalData:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            

            self.inviteCodeStr = registerRespone.data.inviteCode;
            NSLog(@"sssss=========%@",self.inviteCodeStr);
            
            
            self.etherAddressStr = registerRespone.data.etherAddress;
            self.currencyValue = registerRespone.data.currencyValue;
            
            self.intelligenceStr = registerRespone.data.intellectValue;
            
            self.intelligenceLabel.text =[NSString stringWithFormat:@"智力值 %@",registerRespone.data.intellectValue];
            self.knowledgenoLabel.text = [NSString stringWithFormat:@"%.5f",registerRespone.data.scoreValue];
            self.agentUserStr = registerRespone.data.agentUser;
           
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
}



#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"设置" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)headerViewClick
{
    [self.navigationController pushViewController:[XEPersonalDataViewController new] animated:YES];
}

- (void)rightbuttonClicked
{
    PanetMineAddressViewController *PanetMineAddressSettingVC = [[PanetMineAddressViewController alloc] init];
    PanetMineAddressSettingVC.addressType = @"1";
    
    [self.navigationController pushViewController:PanetMineAddressSettingVC animated:YES];
    
}

#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0)
    {
        static NSString *cellIndentifier = @"MinecellOne";
        
        
        MineOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[MineOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
//
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.myorderBtn addTarget:self action:@selector(myorderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        UITapGestureRecognizer *paymentViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paymentlBtnClicked)];
//
//        // 2. 将点击事件添加到label上
//        [cell.paymentView addGestureRecognizer:paymentViewGestureRecognizer];
        
        
        [cell.paymentlBtn addTarget:self action:@selector(paymentlBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.receiveBtn addTarget:self action:@selector(receiveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.completedBtn addTarget:self action:@selector(completedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
        
    }
    else if(indexPath.row == 1)
    {
        static NSString *cellIndentifier = @"MinenewcellOne";
        
        
        MineFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[MineFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
        
        UITapGestureRecognizer *panetViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panetViewClick)];
        
        // 2. 将点击事件添加到label上
        [cell.iconImageView addGestureRecognizer:panetViewGestureRecognizer];
        
        cell.iconImageView.image = [UIImage imageNamed:@"BBT_Mine_One"];

        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *cellIndentifier = @"MinecellTwo";
        
        
        XEMineTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[XEMineTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
        
        [cell.AssetBtn addTarget:self action:@selector(AssetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.memberBtn addTarget:self action:@selector(memberBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.FriendBtn addTarget:self action:@selector(FriendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.FriendlistBtn addTarget:self action:@selector(FriendlistBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.RealNameBtn addTarget:self action:@selector(RealNameBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.WalletBtn addTarget:self action:@selector(walletViewClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.LearnCardBtn addTarget:self action:@selector(LearnCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.SettingBtn addTarget:self action:@selector(SettingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if ([self.studycarddata.onOff isEqualToString:@"0"]) {
           cell.LearnCardView.hidden = YES;
        }
        else
        {
            cell.LearnCardView.hidden = NO;
        }
        
        
        
        return cell;
        
        
    }
    else if(indexPath.row == 3)
    {
        static NSString *cellIndentifier = @"MinecellFour";
        
        
        MineFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[MineFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
        
        UITapGestureRecognizer *panetViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberBtnClicked)];
        
        // 2. 将点击事件添加到label上
        [cell.iconImageView addGestureRecognizer:panetViewGestureRecognizer];
        
        cell.iconImageView.image = [UIImage imageNamed:@"BBT_Mine_Two"];
        
        
        
        return cell;
    }
    
    else
    {
        static NSString *cellIndentifierOne = @"MineThreeCellcell";
        MineThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[MineThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        [cell.memberBtn addTarget:self action:@selector(memberBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.FriendBtn addTarget:self action:@selector(FriendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.SettingBtn addTarget:self action:@selector(SettingBtnClicked) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
    }
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
            
            
        case 0:
            return 125;
            break;
            
        case 1:
            if (kDevice_IS_PAD) {
                return 185 + 20;
            }
            else
            {return 118 + 20;
            }
            
            break;
            
        case 2:
            return 180 + 16;
            break;
            
        case 3:
            if (kDevice_IS_PAD) {
                return 185 + 20;
            }
            else
            {return 118 + 20;
            }
            
            break;
            
        default:
            
            return 64;
            break;
    }
    
    
}

- (void)AssetBtnClicked
{
//    PanetDigitalAssetViewController *PanetDigitalAssetVC = [[PanetDigitalAssetViewController alloc] init];
//    PanetDigitalAssetVC.etherAddressStr = self.etherAddressStr;
//    PanetDigitalAssetVC.currencyValue = self.currencyValue;
//
//    [self.navigationController pushViewController:PanetDigitalAssetVC animated:YES];
    
    
    
    XEWalletViewController *XEWalletVC = [[XEWalletViewController alloc] init];


    [self.navigationController pushViewController:XEWalletVC animated:YES];

}


- (void)RealNameBtnClicked
{
//    RealNameViewController *RealNameVC = [[RealNameViewController alloc] init];
//
//    [self.navigationController pushViewController:RealNameVC animated:YES];
    
    PanetMineAddressViewController *PanetMineAddressSettingVC = [[PanetMineAddressViewController alloc] init];
    PanetMineAddressSettingVC.addressType = @"1";
    
    [self.navigationController pushViewController:PanetMineAddressSettingVC animated:YES];
    
}

- (void)FriendlistBtnClicked
{
    XEMyFriendViewController *XEMyFriendVC = [[XEMyFriendViewController alloc] init];
    
    [self.navigationController pushViewController:XEMyFriendVC animated:YES];
    
}

- (void)SeeViewClick
{
    XEWalletDetailViewController *XEWalletDetailVC = [[XEWalletDetailViewController alloc] init];
    
    [self.navigationController pushViewController:XEWalletDetailVC animated:YES];
}


- (void)SmallTwoViewwClick
{
    
    XESmallTwoViewController *XESmallTwoVC = [[XESmallTwoViewController alloc] init];

    [self.navigationController pushViewController:XESmallTwoVC animated:YES];
    
    
    
//    GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
//
//    [self.navigationController pushViewController:GetIntelligenceVC animated:YES];

    
}


- (void)walletViewClick
{
//    XEWalletViewController *XEWalletVC = [[XEWalletViewController alloc] init];
//
//
//    [self.navigationController pushViewController:XEWalletVC animated:YES];
    
    GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
    
    [self.navigationController pushViewController:GetIntelligenceVC animated:YES];
}
- (void)SettingBtnClicked
{
//    XESettingViewController * XESettingVC = [[XESettingViewController alloc] init];
//
//
//    [self.navigationController pushViewController:XESettingVC animated:YES];
    
    
    
    PanetMineSettingViewController * XESettingVC = [[PanetMineSettingViewController alloc] init];


    [self.navigationController pushViewController:XESettingVC animated:YES];
    
}

- (void)FriendBtnClicked
{
    InvitefriendViewController *InvitefriendVC = [[InvitefriendViewController alloc] init];
    InvitefriendVC.inviteCodeStr =  self.inviteCodeStr;
    
    [self.navigationController pushViewController:InvitefriendVC animated:YES];
}
- (void)memberBtnClicked
{
    XEMemberCenterViewController *XEMemberCenterVC = [[XEMemberCenterViewController alloc] init];
    XEMemberCenterVC.levelIdStr = self.memberdata.levelId;
    XEMemberCenterVC.intelligenceStr = self.intelligenceStr;
    XEMemberCenterVC.baseScoreStr = self.memberdata.baseScore;
    XEMemberCenterVC.upgradeScoreStr = self.memberdata.upgradeScore;
    XEMemberCenterVC.directFriend = self.memberdata.directFriend;
    XEMemberCenterVC.upgradeStatus = self.memberdata.upgradeStatus;
    XEMemberCenterVC.agentUserStr = self.agentUserStr;
    
    [self.navigationController pushViewController:XEMemberCenterVC animated:YES];
}
- (void)completedBtnClicked
{
    XEOrderViewController *XEOrderVC = [[XEOrderViewController alloc] init];
    
    XEOrderVC.pageIndex = 3;
    [self.navigationController pushViewController:XEOrderVC animated:YES];
}
- (void)receiveBtnClicked
{
    XEOrderViewController *XEOrderVC = [[XEOrderViewController alloc] init];
    
    XEOrderVC.pageIndex = 2;
    [self.navigationController pushViewController:XEOrderVC animated:YES];
}

- (void)paymentlBtnClicked
{
    XEOrderViewController *XEOrderVC = [[XEOrderViewController alloc] init];
    
    XEOrderVC.pageIndex = 1;
    [self.navigationController pushViewController:XEOrderVC animated:YES];
}

- (void)myorderBtnClicked
{
    XEOrderViewController *XEOrderVC = [[XEOrderViewController alloc] init];
    
    XEOrderVC.pageIndex = 0;
    [self.navigationController pushViewController:XEOrderVC animated:YES];
}

- (void)panetViewClick
{
    PanetViewController *PanetVC = [[PanetViewController alloc] init];
    
    
    [self.navigationController pushViewController:PanetVC animated:YES];
    
}


- (void)intelligenceClick
{
    IntelligenceViewController *IntelligenceVC = [[IntelligenceViewController alloc] init];
    
    
    [self.navigationController pushViewController:IntelligenceVC animated:YES];
}

- (void)knowledgeViewClicked
{
    KnowledgeViewController * KnowledgeVC = [[KnowledgeViewController alloc] init];
    
    
    [self.navigationController pushViewController:KnowledgeVC animated:YES];
    
}

- (void)LearnCardBtnClicked
{
    
    XBLearnCardViewController *XBLearnCardVC = [[XBLearnCardViewController alloc] init];
    
    
    [self.navigationController pushViewController:XBLearnCardVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    //去掉分割线
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self GETPersonalData];
    
    [self GetMemberInfo];
    
    [self GetStudyCardShow];
    
    [self.personalNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
    [self.iconImageview setImageWithURL:[NSURL URLWithString: [[TMCache sharedCache] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"user"]];
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
