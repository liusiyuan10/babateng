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


#import "QEquipmentViewController.h"
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


@interface QEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BBTQAlertView *_QalertView;
    BBTQAlertView  *_TQalertView;
}


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arraydata;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSMutableArray *iconArray;

//@property(nonatomic, strong) BBTQAlertView *QalertView;

@property (nonatomic, strong) UIView *myView;

@property (nonatomic, strong) QDeviceData *devicedata;

@property (nonatomic, strong) QDevice *checkDevice;


@property (nonatomic, strong)   NSString *sign;

@end

@implementation QEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"管理中心";

    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.titleArray  = [NSMutableArray arrayWithObjects:@"设备名称",@"剩余电量",@"识别号",@"当前版本",@"固件升级",@"公司信息",@"解除绑定",nil];
    self.arraydata  = [NSMutableArray arrayWithObjects:@"小豚",@"20%",@"00000000001", @"V1.0", @"已经是最新版本", @"",@"",nil];
    self.iconArray  = [NSMutableArray arrayWithObjects:@"icon_sbmc",@"icon_sydl",@"icon_xxzx", @"icon_dqbb", @"icon_gjsj", @"icon_gsxx",@"icon_guanyu",nil];
    

    
    
    [self LoadChlidView];
    
//    [self getDeviceInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppEquipmentPlay:) name:@"AppEquipmentPlay" object:nil];
    
    //适配iphone x
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)AppEquipmentPlay:(NSNotification *)noti
{
    
    [appDelegate AnimationOutsidePlay:self.sign];
    
}


-(void)upgradeDevice{
    
    [QEquipmentRequestTool upgrade:self.devicedata.deviceId upload:^(QDevice *respone) {
        
       if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else if([respone.statusCode isEqualToString:@"0"]){
        
             //[self showToastWithString:@"升级成功!"];
             // self.ifupgrade = YES;
              //[self.tableView reloadData];
            
            // [self checkDeviceVersion];
            
            
        }else{
        
             [self showToastWithString:respone.message];
        }
        
       
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
}

- (void)checkDeviceVersion{
    
    [QEquipmentRequestTool checkDeviceVersion:self.devicedata.deviceId Version:self.devicedata.boxinfo.firmwareVersion upload:^(QDevice *respone) {
        
        if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            
            self.checkDevice =respone;
            
            
            [self.tableView reloadData];
            
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)checkDeviceVersionAgain{
    
    [QEquipmentRequestTool checkDeviceVersion:self.devicedata.deviceId Version:self.devicedata.boxinfo.firmwareVersion upload:^(QDevice *respone) {
        
            if([respone.statusCode isEqualToString:@"3705"])
            {
    
                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
    
    
            }else  if([respone.statusCode isEqualToString:@"0"]){
    
                self.checkDevice =respone;

                [self.tableView reloadData];
  
                if (self.checkDevice.data.isLatestVersion.length == 0 || [self.checkDevice.data.isLatestVersion isEqualToString:@"1"]) {

                    [self showToastWithString:@"已经是最新版本"];

                }else{

                    IBConfigration *configration = [[IBConfigration alloc] init];
                    configration.title = @"温馨提示";
                    configration.message = [NSString stringWithFormat:@"%@",self.checkDevice.data.versionDescription];
                    configration.cancelTitle = @"取消";
                    configration.confirmTitle = @"开始升级";
                    configration.tintColor = [UIColor whiteColor];
                    configration.messageAlignment = NSTextAlignmentLeft;

                    IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index) {
                        if (index == 2) {
                            NSLog(@"点击确定了");
                            [self upgradeDevice];
                        }
                    }];
                    [alerView show];


                }

            }
        else
        {
            [self showToastWithString:respone.message];
        }



   
//        if([respone.statusCode isEqualToString:@"3705"])
//        {
//
//            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//
//
//        }else{
//
//
//
//            self.checkDevice =respone;
//
//
//            [self.tableView reloadData];
//
//
//            NSLog(@"self.checkDevice.statusCode====%@",self.checkDevice.statusCode);
//            if (![self.checkDevice.statusCode isEqualToString:@"0"]) {
//
//                // [self showToastWithString:self.checkDevice.message];
//                [self showToastWithString:@"已经是最新版本"];
//
//
//            }else{
//
//
//                if ([self.checkDevice.data.isLatestVersion isEqualToString:@"1"]) {
//
//                    [self showToastWithString:@"已经是最新版本"];
//
//                }else{
//
//                    IBConfigration *configration = [[IBConfigration alloc] init];
//                    configration.title = @"温馨提示";
//                    configration.message = [NSString stringWithFormat:@"%@",self.checkDevice.data.versionDescription];
//                    configration.cancelTitle = @"取消";
//                    configration.confirmTitle = @"开始升级";
//                    configration.tintColor = [UIColor whiteColor];
//                    configration.messageAlignment = NSTextAlignmentLeft;
//
//                    IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index) {
//                        if (index == 2) {
//                            NSLog(@"点击确定了");
//                            [self upgradeDevice];
//                        }
//                    }];
//                    [alerView show];
//
//
//                }
//
//            }
//
//        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


- (void)getDeviceInfo
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
//    [self startLoading];
    
    [QEquipmentRequestTool GetdeviceInfo:parameter success:^(QDevice *respone) {
        
//        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicedata = respone.data;
            
            [self checkDeviceVersion];//检测设备版本
            
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
    
    //    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 90, kDeviceWidth - 96 - 18- 19, 25)];
    //
    //    nameLabel.font = [UIFont systemFontOfSize:28.0];
    //    nameLabel.textColor = [UIColor whiteColor];
    //    nameLabel.text = @"小巴巴";
    //    nameLabel.textAlignment = NSTextAlignmentLeft;
    //
    //    [bgView addSubview:nameLabel];
    
    //    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, CGRectGetMaxY(nameLabel.frame) + 16, 8, 14)];
    //    //    sexImageView.backgroundColor = [UIColor redColor];
    //    sexImageView.image = [UIImage imageNamed:@"icon_lan"];
    //    [bgView addSubview:sexImageView];
    //
    //
    //
    //
    //    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sexImageView.frame) + 9, CGRectGetMaxY(nameLabel.frame) + 16, 200, 15)];
    //
    //    sexLabel.text = @"2岁4个月";
    //    sexLabel.textAlignment = NSTextAlignmentLeft;
    //    sexLabel.font = [UIFont systemFontOfSize:15.0];
    //    sexLabel.textColor = [UIColor whiteColor];
    //
    //    [bgView addSubview:sexLabel];
    
    
    
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
    
//    [self.tableView reloadData];
    
    self.sign = @"QEquipmentViewController";
    
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
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"setingcell";
    
    QEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QEquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
    }
    
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        cell.arrow.hidden = YES;
    }
    
    cell.leftImage.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
    cell.labTip.text = [self.titleArray objectAtIndex:indexPath.row];
    
    //        self.arraydata  = [NSMutableArray arrayWithObjects:@"小豚",@"20%",@"00000000001", @"V1.0", @"已经是最新版本", @"",@"",nil];
    switch (indexPath.row) {
        case 0:
//            cell.subtitleLabel.text = self.devicedata.deviceName;
            if (self.devicedata.deviceName.length == 0) {
                
                    cell.subtitleLabel.text = [[TMCache sharedCache] objectForKey:@"QdeviceName"];
            }
            else
            {
                cell.subtitleLabel.text = self.devicedata.deviceName;
            }
//            [[TMCache sharedCache] setObject:binddata.device.deviceName  forKey:@"QdeviceName"];
//            cell.subtitleLabel.text = [[TMCache sharedCache] objectForKey:@"QdeviceName"];
            break;
            
        case 1:
//            cell.subtitleLabel.text = self.devicedata.boxinfo.electricity;
            if (!IsStrEmpty(self.devicedata.boxinfo.electricity)) {
                
//                  cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%%",self.devicedata.boxinfo.electricity];
                
                NSString *strtest1 = [self.devicedata.boxinfo.electricity stringByReplacingOccurrencesOfString:@"-" withString:@""];
                //                  cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%%",self.devicedata.boxinfo.electricity];
                
                cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%%",strtest1];
          
            }
          
            break;
            
        case 2:
            cell.subtitleLabel.text = self.devicedata.boxinfo.deviceId;
//            cell.subtitleLabel.text = [[TMCache sharedCache] objectForKey:@"deviceId"];
            
            
            break;
            
        case 3:
//            cell.subtitleLabel.text = self.devicedata.boxinfo.firmwareVersion;
            
            if (!IsStrEmpty(self.devicedata.boxinfo.firmwareVersion)) {
                
                if ([self.devicedata.deviceType.deivceProgramId isEqualToString:@"5"]) {
                    
                    cell.subtitleLabel.text = self.devicedata.boxinfo.firmwareVersion;
                    
                    }
                else
                {
                    NSArray *array = [self.devicedata.boxinfo.firmwareVersion componentsSeparatedByString:@"_"];
                    if (array.count>=3) {
                        cell.subtitleLabel.text =array[1];
                    }
                }
    
                
            }
            
            break;
            
        case 4:
            
            if ([self.checkDevice.data.isLatestVersion isEqualToString:@"1"]) {
                
                cell.subtitleLabel.text = @"已经是最新版本";
                
                
            }else if (![self.checkDevice.statusCode isEqualToString:@"0"]){
            
                 cell.subtitleLabel.text = @"已经是最新版本";
                
            }
            else{
                
                cell.subtitleLabel.text = self.checkDevice.data.firmwareName;
            }
            
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
    
    if (indexPath.row == 6) {
        //        NSLog(@"sfdfdgdg");
        
        _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要解除绑定吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
        [_QalertView showInView:self.view];
        
        __block QEquipmentViewController *self_c = self;
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
//                    else if([respone.statusCode isEqualToString:@"3705"])
//                    {
//                        
//                        [[HomeViewController getInstance] KickedOutDeviceStaues];
//                        
//                        
//                    }
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
    else if (indexPath.row == 4)
    {
        
        
        NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
        
        if ([HomedeviceStatusStr isEqualToString:@"0"]) {
            
            [self showToastWithString:@"设备不在线"];
            return;
        }
        
        [self checkDeviceVersionAgain];
        
          
    }else if (indexPath.row == 0) {
        
        QEquipmentNicknameViewController *nicknameVc = [[QEquipmentNicknameViewController alloc] init];
        
        nicknameVc.nickname= [[TMCache sharedCache] objectForKey:@"QdeviceName"];;
        
        [self.navigationController pushViewController:nicknameVc animated:YES];
        
    }else if (indexPath.row == 5) {
        
        QEquipmenCompanyViewController *companyVc = [[QEquipmenCompanyViewController alloc] init];
        
        [self.navigationController pushViewController:companyVc animated:YES];
        
    }
    
    
    //        _QalertView = [[BBTQAlertView alloc] initWithImage:@"kong" andWithTag:1 andWithButtonTitle:@"取消",@"确定", nil];
    //
    //        [_QalertView showInView:self.view];
    //
    //        //点击按钮回调方法
    //        _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
    //            if (titleBtnTag == 1) {
    //
    //
    //                NSLog(@"确定");
    //            }
    //            if (titleBtnTag == 0) {
    //
    //                NSLog(@"取消");
    //                
    //            }
    //        };
    //    }
}

@end




