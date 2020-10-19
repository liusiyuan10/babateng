//
//  QEquipmentViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import "QEquipmentViewController.h"
//
//@interface QEquipmentViewController ()
//
//@end
//
//@implementation QEquipmentViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//      self.title = @"设备";
//    // Do any additional setup after loading the view.
//}
//
//@end


#import "BEquipmentViewController.h"
#import "RDVTabBarController.h"
#import "Header.h"
#import "QEquipmentCell.h"
#import "CustomRootViewController.h"
#import "BBTQAlertView.h"

#import "BBTEquipmentRequestTool.h"
#import "BBTEquipmentRespone.h"

#import "QEquipmentNicknameViewController.h"
#import "QEquipmenCompanyViewController.h"

#import "QEquipmentRequestTool.h"
#import "QDevice.h"
#import "QDeviceData.h"
#import "QDeviceBoxinfo.h"
#import "HomeViewController.h"
#import "NewHomeViewController.h"
#import "IBAlertView.h"


@interface BEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BBTQAlertView *_QalertView;
    BBTQAlertView  *_TQalertView;
}


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arraydata;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSMutableArray *iconArray;


@property (nonatomic, strong) UIView *myView;

@property (nonatomic, strong) QDeviceData *devicedata;



@property (nonatomic, strong)   NSString *sign;

@end

@implementation BEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"管理中心";

    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.titleArray  = [NSMutableArray arrayWithObjects:@"设备名称",@"识别号",@"公司信息",@"解除绑定",nil];
    self.arraydata  = [NSMutableArray arrayWithObjects:@"小叮",@"00000000001",@"",nil];
    self.iconArray  = [NSMutableArray arrayWithObjects:@"icon_sbmc",@"icon_xxzx",@"icon_gsxx",@"icon_guanyu",nil];
    

    
    
    [self LoadChlidView];
 
    //适配iphone x
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

//- (void)dealloc {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}






- (void)getDeviceInfo
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
//    [self startLoading];
    
    [QEquipmentRequestTool GetdeviceInfo:parameter success:^(QDevice *respone) {
        
//        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicedata = respone.data;
            
            [self.tableView reloadData];
        }
        else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else if([respone.statusCode isEqualToString:@"6608"])
        {
            

            
            
        }
        
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
//        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}

- (void)LoadChlidView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 209)];
    bgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1.0];
    //    BG_baby
    bgView.image = [UIImage imageNamed:@"BG_baby"];
    //适配iphone x
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 50)/2.0, 35+kDevice_Is_iPhoneX, 50, 20)];

    titleLabel.text = @"设备";
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:titleLabel];
    
    
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 96)/2.0, 66, 96, 96)];
    //        userImageView.backgroundColor = [UIColor redColor];
    [userImageView.layer setCornerRadius:(userImageView.frame.size.height/2)];
    [userImageView.layer setMasksToBounds:YES];
    [userImageView setContentMode:UIViewContentModeScaleAspectFill];
    [userImageView setClipsToBounds:YES];
    userImageView.hidden = YES;
    
    userImageView.image = [UIImage imageNamed:@"img_touxian03"];
    
    [bgView addSubview:userImageView];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight  ) style:UITableViewStyleGrouped];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //    [self.tableView addSubview:bgView];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 208)];
    
    [self.tableView.tableHeaderView addSubview:bgView];
    
    //适配iphone x
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 20+kDevice_Is_iPhoneX, 50, 50)];
    
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    

    
    [self.view addSubview:button];
    
    
    
}


- (void)backFore
{
//    [[CustomRootViewController getInstance]comeback];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)exitBtnClicked
{
    [[TMCache sharedCache]removeObjectForKey:@"nickname"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
     [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    [self getDeviceInfo];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
  
    [super viewWillDisappear:animated];
    //self.sign = @"";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}




//Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Bsetingcell";
    
    QEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QEquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
    }
    
    
    if (indexPath.row == 1||indexPath.row==3) {
        cell.arrow.hidden = YES;
    }
    
    cell.leftImage.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
    cell.labTip.text = [self.titleArray objectAtIndex:indexPath.row];

    switch (indexPath.row) {
        case 0:
 
                cell.subtitleLabel.text = [[TMCache sharedCache] objectForKey:@"QdeviceName"];
//            }
//            else
//            {
//                cell.subtitleLabel.text = self.devicedata.deviceName;
//            }

            break;
            

            
        case 1:
            cell.subtitleLabel.text = self.devicedata.deviceId;
  
            break;
    
            
        default:
            break;
    }
    
    //    cell.subtitleLabel.text = [self.arraydata objectAtIndex:indexPath.row];
    
    
    return cell;
}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 0.1;
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 53;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row == 0) {

        QEquipmentNicknameViewController *nicknameVc = [[QEquipmentNicknameViewController alloc] init];

        nicknameVc.nickname= [[TMCache sharedCache] objectForKey:@"QdeviceName"];;

        [self.navigationController pushViewController:nicknameVc animated:YES];

    }else if (indexPath.row == 2) {

        QEquipmenCompanyViewController *companyVc = [[QEquipmenCompanyViewController alloc] init];

        [self.navigationController pushViewController:companyVc animated:YES];

    }else if (indexPath.row == 3) {
        //        NSLog(@"sfdfdgdg");

        _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要解除绑定吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
        [_QalertView showInView:self.view];

        __block BEquipmentViewController *self_c = self;
        //点击按钮回调方法
        _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
            if (titleBtnTag == 1) {


                NSLog(@"sf");

                [self_c startLoading];
                [BBTEquipmentRequestTool getDeletebinddevice:[[TMCache sharedCache] objectForKey:@"userId"] deviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(BBTEquipmentRespone *respone) {

                    [self_c stopLoading];

                    if ([respone.statusCode isEqualToString:@"0"]) {

                        [[TMCache sharedCache] removeObjectForKey:@"deviceId"];
                        [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];

                        [[TMCache sharedCache] setObject:@"success" forKey:@"RemoveBind"];

                        [self_c showToastWithString:@"解绑成功"];

                        //                        [[CustomRootViewController getInstance] comeback];
                        [self_c.navigationController popViewControllerAnimated:YES];


                    }

                    else{

                        [self_c showToastWithString:respone.message];
                    }

                } failure:^(NSError *error) {

                    [self_c stopLoading];

                }];




            }
            if (titleBtnTag == 0) {
                NSLog(@"sg");

            }
        };
    }

    
}

@end




