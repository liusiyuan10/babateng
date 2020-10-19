//
//  BBTMessageCenterViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTMessageCenterViewController.h"
#import "PersonalCenterCell.h"
#import "BBTMessageSetViewController.h"
#import "BBTMessageListViewController.h"
#import "BBTDeviceMessageListViewController.h"
#import "BBTQAlertView.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"
#import "BBTFamilyMessageListViewController.h"
#import "MessageTool.h"
#import "QMessageDataList.h"

@interface BBTMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BBTQAlertView *_QalertView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataImageArray;

@property (nonatomic, assign) NSInteger systemMessageNumber;

@property (nonatomic, assign) NSInteger devicMessageNumber;

@property (nonatomic, assign) NSInteger familyMessageNumber;


@property (strong, nonatomic) MessageTool  *messagetool;




@end



@implementation BBTMessageCenterViewController

- (MessageTool *)messagetool
{
    if (_messagetool == nil) {
        _messagetool  = [[MessageTool alloc] init];
    }
    return _messagetool;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
    self.dataArray = [NSMutableArray arrayWithObjects:@"系统消息",@"设备通知",@"家人邀请", nil];
    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_shebeitongzhi",@"icon_shebeifenxiang",@"icon_yaoqin", nil];
    
    
    [self setUpNavigationItem];
    
    [self GETsystemNotices];//系统通知
    [self GETDeviceNotices];//设备通知
    [self GETFamilyNotices];//家人邀请
    // Do any additional setup after loading the view.
    
    // [self test];
    
    
}

//- (void)test
//{
//    NSMutableArray *resultmodel = [self.messagetool selectAllModel:@"select * from t_message where status = 0 and isShow = 1"];
//
//   // NSLog(@"rem888====%@",resultmodel);
//     NSString *sql = @"update t_message set isShow = 1 where isShow = 0 and status = 0 ";
//    [self.messagetool updateMessage:sql];
//
//    NSMutableArray *resultmodel1 = [self.messagetool selectAllModel:@"select * from t_message where status = 0 and isShow = 1"];
//
//  //  NSLog(@"rem999====%@",resultmodel1);
//}


- (void)setUpNavigationItem
{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    [button setImage:[UIImage imageNamed:@"nav_xiaoxishezhi_nor"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_xiaoxishezhi_pre"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(messageSetAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

-(void)messageSetAction{
    
    
    [self.navigationController pushViewController:[BBTMessageSetViewController new] animated:YES];
    
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[PersonalCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *selecetedCellBG = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,60)];
        selecetedCellBG.backgroundColor =SelecetedCellBG;
        selecetedCellBG.clipsToBounds = YES;
        selecetedCellBG.contentMode = UIViewContentModeScaleAspectFill;
        cell.selectedBackgroundView=selecetedCellBG ;
    }
    
    
    
    cell.leftImage.image = [UIImage imageNamed:self.dataImageArray[indexPath.row]];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    
    
    if (indexPath.row==0) {
        
        
        if (self.systemMessageNumber>0&&![[[TMCache sharedCache] objectForKey:@"SystemSevenSwitch"]isEqualToString:@"OFF"]) {
            
            cell.onlineLabel.text = [NSString stringWithFormat:@"%ld条消息",(long)self.systemMessageNumber];
            cell.onlineLabel.textColor = NavBackgroundColor;
            
            [[TMCache sharedCache]setObject: @"YES" forKey:@"systemMessage"];//控制首页new标志
            [[TMCache sharedCache]setObject: @"YES" forKey:@"systemMessage1"];
            
        }else{
            
            cell.onlineLabel.text = @"无新消息";
            cell.onlineLabel.textColor =[UIColor lightGrayColor];
            
            [[TMCache sharedCache]setObject: @"NO" forKey:@"systemMessage"];
            [[TMCache sharedCache]setObject: @"NO" forKey:@"systemMessage1"];
        }
        
        
    }else if (indexPath.row==1){
        
        if (self.devicMessageNumber>0&&![[[TMCache sharedCache] objectForKey:@"DeviceSevenSwitch"]isEqualToString:@"OFF"]) {
            
            cell.onlineLabel.text = [NSString stringWithFormat:@"%ld条消息",(long)self.devicMessageNumber];
            cell.onlineLabel.textColor = NavBackgroundColor;
            [[TMCache sharedCache]setObject: @"YES" forKey:@"devicMessage"];
            [[TMCache sharedCache]setObject: @"YES" forKey:@"devicMessage1"];
            
        }else{
            
            cell.onlineLabel.text = @"无新消息";
            cell.onlineLabel.textColor =[UIColor lightGrayColor];
            
            [[TMCache sharedCache]setObject: @"NO" forKey:@"devicMessage"];
            [[TMCache sharedCache]setObject: @"NO" forKey:@"devicMessage1"];
        }
        
    }else if (indexPath.row==2){
        
        if (self.familyMessageNumber>0&&![[[TMCache sharedCache] objectForKey:@"FamilySevenSwitch"]isEqualToString:@"OFF"]) {
            
            cell.onlineLabel.text = [NSString stringWithFormat:@"%ld条消息",(long)self.familyMessageNumber];
            cell.onlineLabel.textColor = NavBackgroundColor;
            [[TMCache sharedCache]setObject: @"YES" forKey:@"familyMessage"];
            [[TMCache sharedCache]setObject: @"YES" forKey:@"familyMessage1"];
        }else{
            
            cell.onlineLabel.text = @"无新消息";
            cell.onlineLabel.textColor =[UIColor lightGrayColor];
            
            [[TMCache sharedCache]setObject: @"NO" forKey:@"familyMessage"];
            
            [[TMCache sharedCache]setObject: @"NO" forKey:@"familyMessage1"];
        }
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        
        //   if (self.systemMessageNumber>0) {
        
        [self.navigationController pushViewController:[BBTMessageListViewController new] animated:YES];
        
        //        }else{
        //
        //            [self showAlertView];
        //        }
        //
        
    }else if (indexPath.row==1){
        
        
        // if (self.devicMessageNumber>0) {
        
        [self.navigationController pushViewController:[BBTDeviceMessageListViewController new] animated:YES];
        
        // }else{
        
        //   [self showAlertView];
        // }
        
    }else if (indexPath.row==2){
        
        
        //if (self.familyMessageNumber>0) {
        
        [self.navigationController pushViewController:[BBTFamilyMessageListViewController new] animated:YES];
        
        // }else{
        
        //     [self showAlertView];
        // }
        
    }
    
    
    
    
    
    
}


-(void)showAlertView{
    
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"暂无消息" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    //__block BBTMessageCenterViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
        }
        if (titleBtnTag == 0) {
            
            
        }
    };
    
    
}

-(void)GETsystemNotices
{
    
    NSDictionary *bodyDic = @{@"pageNum" : @"1" , @"pageSize":@"20", @"publishTime":[self getNowTimeTimestamp] };
    
    [BBTMineRequestTool GETsystemNoticesbodyDic:bodyDic upload:^(QMessage *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"系统消息列表count============%lu",(unsigned long)respone.data.list.count);
            
            //self.systemMessageNumber = respone.data.list.count;
            
            NSMutableArray *systemarr= respone.data.list;
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < systemarr.count; i++) {
                
                QMessageDataList *list = [systemarr objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_xt",list.systemNoticeId];
                model.isRead = @"0";
                model.isShow = @"0";
                model.status = @"0";
                [modelarr addObject:model];
            }
            
            
            //以未读的信息插入数据
            [self.messagetool insertMessageArr:modelarr];
            //查询数据库未读条数
            self.systemMessageNumber =  [self.messagetool selectAllModel:@"select * from t_message where status = 0 and isShow = 0"].count;
            
            NSLog(@"self.systemMessageNumber==%ld",(long)self.systemMessageNumber);
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        // [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
    
}



-(void)GETDeviceNotices{
    
    [BBTMineRequestTool GETDeviceNoticespageNum:@"1" pageSize:@"20" upload:^(QMessage *respone) {
        
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            //self.dataArray = respone.data.list;
            NSLog(@"查询设备通知列表count============%lu",(unsigned long)respone.data.list.count);
            
            NSMutableArray *systemarr= respone.data.list;
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < systemarr.count; i++) {
                
                QMessageDataList *list = [systemarr objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_sb",list.deviceNoticeId];
                model.isRead = @"0";
                model.isShow = @"0";
                model.status = @"1";
                [modelarr addObject:model];
            }
            
            
            //以未读的信息插入数据
            [self.messagetool insertMessageArr:modelarr];
            //查询数据库未读条数
            self.devicMessageNumber =  [self.messagetool selectAllModel:@"select * from t_message where status = 1 and isShow = 0"].count;
            
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)GETFamilyNotices{
    
    [BBTMineRequestTool GETFamilyNoticesspageNum:@"1" pageSize:@"20" upload:^(QMessage *respone) {
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            //self.dataArray = respone.data.list;
            
            // self.familyMessageNumber = respone.data.list.count;
            NSLog(@"家人邀请列表count============%lu",(unsigned long)respone.data.list.count);
            NSMutableArray *systemarr= respone.data.list;
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < systemarr.count; i++) {
                
                QMessageDataList *list = [systemarr objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_fm",list.invitationId];
                NSLog(@"list.invitationId============%@",list.invitationId);
                model.isRead = @"0";
                model.isShow = @"0";
                model.status = @"2";
                [modelarr addObject:model];
            }
            
            //以未读的信息插入数据
            [self.messagetool insertMessageArr:modelarr];
            //查询数据库未读条数
            self.familyMessageNumber =  [self.messagetool selectAllModel:@"select * from t_message where status = 2 and isShow = 0"].count;
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //查询数据库未读条数
    self.systemMessageNumber =  [self.messagetool selectAllModel:@"select * from t_message where status = 0 and isShow = 0"].count;
    self.devicMessageNumber  =  [self.messagetool selectAllModel:@"select * from t_message where status = 1 and isShow = 0"].count;
    self.familyMessageNumber  =  [self.messagetool selectAllModel:@"select * from t_message where status = 2 and isShow = 0"].count;
    
    [self.tableView reloadData];
    

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
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
