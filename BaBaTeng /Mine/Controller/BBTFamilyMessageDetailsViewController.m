//
//  BBTFamilyMessageDetailsViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTFamilyMessageDetailsViewController.h"
#import "BBTFamilyMessageListViewController.h"
#import "FamilyMessageDetailsCell.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"
#import "QMessageData.h"
#import "QinvitationStatus.h"
#import "Qreceiver.h"
#import "Qsender.h"
#import "QFamily.h"
@interface BBTFamilyMessageDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrayTwo;

@property(nonatomic, strong) QMessageData *qMessageDetails;

@end

@implementation BBTFamilyMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"家人邀请";
    
    //适配iphone x
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight-200-kDevice_Is_iPhoneX) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataArray = [NSMutableArray arrayWithObjects:@"微聊组",@"邀请人",@"被邀请人",@"附言",nil];

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
    
    if ([self.qMessageDataList.invitationStatus.value isEqualToString:@"0"]) {
        
       //  NSLog(@"等待回应");
        
        //判断我是邀请人 就没有邀请和拒绝的操作
        if ([[[TMCache sharedCache] objectForKey:@"userId"]isEqualToString:self.qMessageDataList.sender.userId]) {
        
            UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
            [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
            [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateHighlighted];
            [agreeButton setTitle:@"等待对方回应" forState:UIControlStateNormal];
            [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            agreeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            [self.view addSubview:agreeButton];
            

        
        }else{
        
            
            UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
            [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_lv03_nor"] forState:UIControlStateNormal];
            [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_lv03_pre"] forState:UIControlStateHighlighted];
            [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
            [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            agreeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [agreeButton addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:agreeButton];
            
            UIButton *refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+70, kDeviceWidth - 20, 50)];
            [refuseButton setBackgroundImage:[UIImage imageNamed:@"btn_hong03_nor"] forState:UIControlStateNormal];
            [refuseButton setBackgroundImage:[UIImage imageNamed:@"btn_hong03_pre"] forState:UIControlStateHighlighted];
            [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [ refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            refuseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [refuseButton addTarget:self action:@selector(refuseAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:refuseButton];
            
            

        
        }
        
        
        
        
    }else if ([self.qMessageDataList.invitationStatus.value isEqualToString:@"1"]){
    
         NSLog(@"已同意");
        
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateHighlighted];
        [agreeButton setTitle:@"已同意" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
   
        [self.view addSubview:agreeButton];
        
    
    
    }else if ([self.qMessageDataList.invitationStatus.value isEqualToString:@"2"]){
        
         NSLog(@"已拒绝");
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateHighlighted];
        [agreeButton setTitle:@"已拒绝" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];

        [self.view addSubview:agreeButton];
       
    }else if ([self.qMessageDataList.invitationStatus.value isEqualToString:@"3"]){
        
         NSLog(@"已过期");
        
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
        [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateHighlighted];
        [agreeButton setTitle:@"已过期" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];

        [self.view addSubview:agreeButton];
        
    }
    
     [self autoRefresh];
    
}


#pragma mark UITableView + 下拉刷新 默认
- (void)autoRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
    //  [self connectionData];
  
    [self GETFamilyMessageDetailID];
    
}

-(void)GETFamilyMessageDetailID{

    [BBTMineRequestTool GETFamilyMessageDetailID:self.qMessageDataList.invitationId upload:^(QMessage *respone) {
        
         [self.tableView.mj_header endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qMessageDetails =respone.data;
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];


}

//接受邀请
-(void)agreeAction{
    
     [BBTMineRequestTool PUTFamilyInvitations:self.qMessageDetails.invitationId Status:@"1" upload:^(QMessage *respone) {
         
         
         if ([respone.statusCode isEqualToString:@"0"]) {
             
            // NSLog(@"接受邀请成功");
             
            [self showToastWithString:@"已经接受"];
             
             [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
             
            
             
             
         } else if ([respone.statusCode isEqualToString:@"1401"]) {//已经在家庭圈了
             
                  [self showToastWithString:respone.message];
             
                  [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
             
             
         }else{
             
             [self showToastWithString:respone.message];
         }
         
     } failure:^(NSError *error) {
         
             [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
     }];
    
  
}

-(void)delayMethod{
 
     [[BBTFamilyMessageListViewController getInstance]returnRefresh];

      [self.navigationController popViewControllerAnimated:YES];
}
//拒绝邀请
-(void)refuseAction{

    
     [BBTMineRequestTool PUTFamilyInvitations: self.qMessageDetails.invitationId Status:@"2" upload:^(QMessage *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            // NSLog(@"拒绝邀请成功");
            
            [self showToastWithString:@"已经拒绝"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
        }else{
            
            [self showToastWithString:respone.message];
        }

        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

}
#pragma mark - tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return self.dataArray.count;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
   
    
    FamilyMessageDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[FamilyMessageDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //    self.resultRespone =  self.dataArray[indexPath.row];
        cell.nameLabel.text =  self.dataArray[indexPath.row];
    
    
    if (indexPath.row==0) {
        
        cell.subNameLabel.text = self.qMessageDetails.family.familyName;
        
    }else if (indexPath.row==1){
    
        //判断我是邀请人
        if ([[[TMCache sharedCache] objectForKey:@"userId"]isEqualToString:self.qMessageDataList.sender.userId]) {
        
            cell.subNameLabel.text = @"我";
            
        }else{
        
            cell.subNameLabel.text = self.qMessageDetails.sender.nickName;
        
        }
        
    }else if (indexPath.row==2){
        
       
        //判断被我是邀请人
        if ([[[TMCache sharedCache] objectForKey:@"userId"]isEqualToString:self.qMessageDataList.receiver.userId]) {
            
            cell.subNameLabel.text = @"我";
            
        }else{
            
            cell.subNameLabel.text = self.qMessageDetails.receiver.nickName;
            
        }
        
    }else if (indexPath.row==3){
        
        cell.subNameLabel.text = self.qMessageDetails.invitationMessage;
        
    }
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
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
