//
//  QEquipmenCompanyViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QEquipmenCompanyViewController.h"
#import "QCompanyCell.h"
#import "QEquipmentRequestTool.h"
#import "QDevice.h"
#import "QDeviceData.h"
#import "HomeViewController.h"
#import "NewHomeViewController.h"

@interface QEquipmenCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arraydata;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) QDevice *qDevice;

@property (nonatomic,strong) QDeviceData *qDeviceData;

@end

@implementation QEquipmenCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公司信息";
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.titleArray  = [NSMutableArray arrayWithObjects:@"公司名称",@"售后电话",@"电子邮箱", @"公司地址",nil];
    
    self.arraydata  = [NSMutableArray arrayWithObjects:@"深圳公司",@"40050060000", @"34234565@163.com",@"深圳宝安梧桐岛",nil];
    
    [self LoadChlidView];
    
    [self GetdeviceCompanyInfoDic];
    
}

-(void)GetdeviceCompanyInfoDic{


    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};

     [QEquipmentRequestTool GetdeviceCompanyInfoDic: [[TMCache sharedCache] objectForKey:@"deviceId"] Parameter:parameter success:^(QDevice *respone) {
         
         
         if ([respone.statusCode isEqualToString:@"0"]) {
             
             self.qDeviceData =respone.data;
               NSLog(@"respone.data.companyName==%@",respone.data.companyName);
             [self.tableView reloadData];
             
         }else if([respone.statusCode isEqualToString:@"3705"])
         {
             
             [[NewHomeViewController getInstance] KickedOutDeviceStaues];
             
             
         }else{
         
             [self showToastWithString:respone.message];
         }
     } failure:^(NSError *error) {
         
         [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
         
     }];

}

- (void)LoadChlidView
{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight )style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
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
    
}

- (void)backBtnClicked
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDelegate appDelegate] suspendButtonHidden:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"aboutCell";
    
    QCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    //    cell.labTip.text = @"版本更新";
    //    cell.subtitleLabel.text = @"发现新版本";
    
    
    NSLog(@"self.qDeviceData.companyName==%@",self.qDeviceData.companyName);
    
    cell.labTip.text = [self.titleArray objectAtIndex:indexPath.row];
    
    cell.labTip.numberOfLines = 0;
    
    cell.subtitleLabel.numberOfLines = 0;
    
    if (indexPath.row==0) {
        
            cell.subtitleLabel.text =   self.qDeviceData.companyName;
        
    }else if (indexPath.row==1){
    
            cell.subtitleLabel.text =  self.qDeviceData.contactPhone;

    
    }else if (indexPath.row==2){
        
            cell.subtitleLabel.text = self.qDeviceData.contactEmail;
        
    }else if (indexPath.row==3){
        
            cell.subtitleLabel.text = self.qDeviceData.companyAddress;
        
    }

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65.0;
}

@end
