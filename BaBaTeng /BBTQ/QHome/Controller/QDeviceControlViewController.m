//
//  QDeviceControlViewController.m
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QDeviceControlViewController.h"
#import "Header.h"
#import "QDeviceView.h"
#import "QDeviceVolumeView.h"
#import "QMineRequestTool.h"
#import "QDeviceInfoRespone.h"
#import "HomeViewController.h"
#import "QEquipmentRequestTool.h"
#import "QDevice.h"
#import "QDeviceData.h"
#import "QDeviceBoxinfo.h"
#import "BBTQAlertView.h"
#import "DeviceControl.h"
#import "DeviceControlData.h"
#import "NewHomeViewController.h"
#import "BBTCustomViewRequestTool.h"
#import "QAddSong.h"

@interface QDeviceControlViewController ()<UITableViewDataSource,UITableViewDelegate,QDeviceViewDelegate,QDeviceVolumeViewDelegate>
{
    BBTQAlertView *_QalertView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString * lightStr;
@property (nonatomic, strong) NSString * volumeStr;
@property (nonatomic, strong) NSString * timeShutdownStr;
@property (nonatomic,strong)  NSMutableArray *titleArray;
@property (nonatomic, strong) NSString *QDeviceType;

@property (nonatomic, strong) QDeviceData *devicedata;

@property (nonatomic, strong) NSMutableArray *devicecontrolArray;
@property (nonatomic, strong) UIButton *shutdownBtn;

@end

@implementation QDeviceControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"设备控制";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.lightStr = @"较亮";
    
    self.volumeStr = @"10%";
    
    self.timeShutdownStr = @"10分钟";
    self.titleArray  = [NSMutableArray arrayWithObjects:@"音量调整",@"灯光亮度",@"定时关机",@"儿童锁",nil];
    
    self.devicecontrolArray = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
    [self getDeviceController];


    

    
}

- (void)getDeviceInfo
{
    
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        return;
    }
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    [QEquipmentRequestTool GetdeviceInfo:parameter success:^(QDevice *respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicedata = respone.data;
//                    tfSheetView.volumenum = [self.devicedata.boxinfo.volume integerValue];
            self.volumeStr = [NSString stringWithFormat:@"%.f%%", [self.devicedata.boxinfo.volume floatValue]];
            
             NSLog(@"self.volumeStr==== %@", self.volumeStr);
            
            [[TMCache sharedCache] setObject:self.volumeStr forKey:@"DeviceVolume"];
            
//             self.shutdownBtn.enabled = YES;
            
            [self.tableView reloadData];
            
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else if([respone.statusCode isEqualToString:@"6608"])
        {
//            self.shutdownBtn.enabled = NO;
            
            [self showToastWithString:respone.message];
            
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
    
}



- (void)getDeviceController
{
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    
    
    [self startLoading];
    
    [QMineRequestTool getDeviceControllersName:name success:^(DeviceControl *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.devicecontrolArray = response.data;
            

            [self.tableView reloadData];
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
    
        else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
}

- (void)LoadChlidView
{
   self.shutdownBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 180 / 375.0 *kDeviceWidth) / 2.0, 23 / 667.0 * KDeviceHeight, 180 / 375.0 *kDeviceWidth, 180 / 375.0 *kDeviceWidth)];

    [self.shutdownBtn setImage:[UIImage imageNamed:@"btn_gj_nor"] forState:UIControlStateNormal];
    [self.shutdownBtn setImage:[UIImage imageNamed:@"btn_gj_pre"] forState:UIControlStateHighlighted];
    [self.shutdownBtn setImage:[UIImage imageNamed:@"btn_gj_sel"] forState:UIControlStateDisabled];
    [self.shutdownBtn addTarget:self action:@selector(shutdownBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
//    if ([[[TMCache sharedCache]objectForKey:@"switchgear"]isEqualToString:@"OFF"]) {
//
//           self.shutdownBtn.enabled = NO;
//    }else{
//
//          self.shutdownBtn.enabled = YES;
//    }
    
    
 
    [self.view addSubview:self.shutdownBtn];
    
    UILabel *shutdownLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth -50)/2.0, CGRectGetMaxY(self.shutdownBtn.frame) + 13, 50, 16)];
    shutdownLabel.text = @"关机";
    shutdownLabel.font = [UIFont systemFontOfSize:17.0];
    shutdownLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
    ;
    shutdownLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:shutdownLabel];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(shutdownLabel.frame) + 26/ 667.0 * KDeviceHeight,kDeviceWidth , KDeviceHeight - CGRectGetMaxY(shutdownLabel.frame) - 26/ 667.0 * KDeviceHeight - 30 ) style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;

//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.tableView];


    

    
}

- (void)shutdownBtnClicked
{
    //    { cmd:setPoweroff}
    
    //    NSLog(@"sdfddgdgdf");
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要关机吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block QDeviceControlViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
//            NSDictionary *dic = @{@"cmd" : @"setPoweroff"};
//
//            [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
            
            [self_c PutDevicesControlMQTT:@"8" ValueStr:@""];
            
            
            [[TMCache sharedCache]setObject:@"OFF" forKey:@"switchgear"];
            
            self_c.shutdownBtn.enabled = NO;
        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");
            
        }
    };

    
    

    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicecontrolArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0/667 * KDeviceHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *CellIdentifier = @"Devicecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
    
    }
    
    DeviceControlData *controldata= [self.devicecontrolArray objectAtIndex:indexPath.row];
    cell.textLabel.text = controldata.deviceControlName;
    
    if ([controldata.controlId isEqualToString:@"1"]) {
        
         cell.detailTextLabel.text = self.volumeStr;
        
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f%%", [self.devicedata.boxinfo.volume floatValue]];             

        
    }
    else if ([controldata.controlId isEqualToString:@"2"])
    {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
        if ([self.devicedata.boxinfo.babyLocked isEqualToString:@"1"]) {
            switchview.on = YES;
        }
        else
        {
            switchview.on = NO;
        }
        
        [switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
        
    }    else if ([controldata.controlId isEqualToString:@"3"])
    {
        
//        if ([self.devicedata.boxinfo.lightness isEqualToString:@"0"]) {
//
//            self.lightStr = @"不亮";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"1"])
//        {
//            self.lightStr = @"较暗";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"2"])
//        {
//            self.lightStr = @"较亮";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"3"])
//        {
//            self.lightStr = @"最亮";
//        }
//        
//        cell.detailTextLabel.text = self.lightStr;
        
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
        if ([self.devicedata.boxinfo.lightness isEqualToString:@"1"] ||[self.devicedata.boxinfo.lightness isEqualToString:@"2"]  ||[self.devicedata.boxinfo.lightness isEqualToString:@"3"] ) {
            
            switchview.on = YES;
        }
        else if([self.devicedata.boxinfo.lightness isEqualToString:@"0"])
        {
            switchview.on = NO;
        }
        
        [switchview addTarget:self action:@selector(LightswitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;

        
    }    else if ([controldata.controlId isEqualToString:@"4"])
    {
        
        //cell.detailTextLabel.text = self.timeShutdownStr;
        
    }
        
    
//    if (indexPath.row == 0)
//    {
////             cell.detailTextLabel.text = self.volumeStr;
//        
//         cell.detailTextLabel.text = self.devicedata.boxinfo.volume;
//        
//    }else if (indexPath.row == 1)
//    {
//        if ([self.devicedata.boxinfo.lightness isEqualToString:@"0"]) {
//            
//            self.lightStr = @"不亮";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"1"])
//        {
//            self.lightStr = @"较暗";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"2"])
//        {
//            self.lightStr = @"较亮";
//        }
//        else if ([self.devicedata.boxinfo.lightness isEqualToString:@"3"])
//        {
//            self.lightStr = @"最亮";
//        }
//             cell.detailTextLabel.text = self.lightStr;
//        
//    }else if (indexPath.row == 2)
//    {
//             cell.detailTextLabel.text = self.timeShutdownStr;
//    }
//
//    
//    if (indexPath.row == 3) {
//        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
//        switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
//        if ([self.devicedata.boxinfo.babyLocked isEqualToString:@"1"]) {
//            switchview.on = YES;
//        }
//        else
//        {
//            switchview.on = NO;
//        }
//        
//        [switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        cell.accessoryView = switchview;
//    }

    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    DeviceControlData *controldata= [self.devicecontrolArray objectAtIndex:indexPath.row];
    
    if ([controldata.controlId isEqualToString:@"1"]) {
        
        QDeviceVolumeView *tfSheetView = [[QDeviceVolumeView alloc]  init];
        tfSheetView.delegate = self;

        
        [tfSheetView showInView:self.view];
        [[AppDelegate appDelegate]suspendButtonHidden:YES];

        
    }
    
//    else if ([controldata.controlId isEqualToString:@"3"])
//    {
//        
//        QDeviceView *tfSheetView = [[QDeviceView alloc]init];
//        tfSheetView.QDeviceType = @"light";
//        tfSheetView.delegate = self;
//        [tfSheetView initContent];
//        [tfSheetView showInView:self.view];
//        self.QDeviceType = @"light";
//
//        [[AppDelegate appDelegate]suspendButtonHidden:YES];
//        
//    }
//    
    else if ([controldata.controlId isEqualToString:@"4"])
    {
        QDeviceView *tfSheetView = [[QDeviceView alloc]init];
        tfSheetView.QDeviceType = @"guanji";
        tfSheetView.delegate = self;
        [tfSheetView initContent];
        [tfSheetView showInView:self.view];
        self.QDeviceType = @"guanji";

        [[AppDelegate appDelegate]suspendButtonHidden:YES];
    }
    
//    if (indexPath.row == 0) {
//        
//        QDeviceVolumeView *tfSheetView = [[QDeviceVolumeView alloc]init];
//        tfSheetView.delegate = self;
//        [tfSheetView showInView:self.view];
//        [[AppDelegate appDelegate]suspendButtonHidden:YES];
//        
//    }else if (indexPath.row == 1) {
//        
//        QDeviceView *tfSheetView = [[QDeviceView alloc]init];
//        tfSheetView.QDeviceType = @"light";
//        tfSheetView.delegate = self;
//        [tfSheetView initContent];
//        [tfSheetView showInView:self.view];
//        self.QDeviceType = @"light";
//        
//        [[AppDelegate appDelegate]suspendButtonHidden:YES];
//        
//    }else if (indexPath.row == 2)
//    {
//        QDeviceView *tfSheetView = [[QDeviceView alloc]init];
//        tfSheetView.QDeviceType = @"guanji";
//        tfSheetView.delegate = self;
//        [tfSheetView initContent];
//        [tfSheetView showInView:self.view];
//        self.QDeviceType = @"guanji";
//        
//        [[AppDelegate appDelegate]suspendButtonHidden:YES];
//    }

    
    
}

-(void)LightswitchAction:(id)sender
{
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSInteger lightIndex = 0;
    if (isButtonOn) {
        
        NSLog(@"k开关了");
        lightIndex = 1;
        
    }else
    {
        NSLog(@"k开kaile 了");
        lightIndex = 0;
    }



    NSNumber *lightNSNumber = [NSNumber numberWithInteger:lightIndex];

    NSDictionary *infodic = @{@"lightness" : lightNSNumber};

    [self setDeviceInfo:infodic];

    [self.tableView reloadData];

}

-(void)switchAction:(id)sender
{
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSNumber *isonnsmuber = [NSNumber numberWithBool:isButtonOn];
    
    NSDictionary *infodic = @{@"babyLocked" : isonnsmuber };
    
    [self setDeviceInfo:infodic];
    
    if (isButtonOn) {
        
        NSLog(@"开关%@",@"是");
        
    }else {
        NSLog(@"开关%@",@"否");
    }
    
}

#pragma mark QDeviceViewDelegate

- (void)QDeviceViewBtnClicked:(QDeviceView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex
{
//    if ([self.QDeviceType isEqualToString:@"light"]) {
//        
//        self.lightStr = name;
//        
//        NSNumber *lightNSNumber = [NSNumber numberWithInteger:selectindex];
//        
//        NSDictionary *infodic = @{@"lightness" : lightNSNumber};
//        
//        [self setDeviceInfo:infodic];
//        
//        [self.tableView reloadData];
//        
//    }else
//    {
//        self.timeShutdownStr = name;
//        
//        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//        
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//        
//        NSNumber *timenumber = [NSNumber numberWithInteger:[timeSp integerValue]];
//        
//        NSNumber *timeshutdownnumber = [NSNumber numberWithInteger:[self.timeShutdownStr integerValue] * 60];
//        
////        NSLog(@"timeSp:%@",timeSp); //时间戳的值时间戳转时间的方法
//        
//        NSDictionary *dic = @{@"cmd":@"customer",
//                              @"head":@{@"id":@32771,@"sn":timenumber,@"cmd":@"command",@"src":@"server",@"dst":[[TMCache sharedCache] objectForKey:@"deviceId"]},
//                              @"body":@{@"command":@{@"id":@12289,@"cmd":@"shutdown",@"data": timeshutdownnumber }}};
//        
//        
//        [[HomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
//        
//        [self.tableView reloadData];
//    }
    
    
    self.timeShutdownStr = name;

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    NSNumber *timenumber = [NSNumber numberWithInteger:[timeSp integerValue]];

    NSNumber *timeshutdownnumber = [NSNumber numberWithInteger:[self.timeShutdownStr integerValue] * 60];

//        NSLog(@"timeSp:%@",timeSp); //时间戳的值时间戳转时间的方法

//    NSDictionary *dic = @{@"cmd":@"customer",
//                          @"head":@{@"id":@32771,@"sn":timenumber,@"cmd":@"command",@"src":@"server",@"dst":[[TMCache sharedCache] objectForKey:@"deviceId"]},
//                          @"body":@{@"command":@{@"id":@12289,@"cmd":@"shutdown",@"data": timeshutdownnumber }}};
//
//
//    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    NSString *timeshutdownnumberstr = [NSString stringWithFormat:@"%@",timeshutdownnumber];
    [self PutDevicesControlMQTT:@"7" ValueStr:timeshutdownnumberstr];
    
    
    [self.tableView reloadData];

}

- (void)setDeviceInfo:(NSDictionary *)dic
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
//       NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" :@""};
    
    [self startLoading];

    [QEquipmentRequestTool PutdeviceInfoDic:dic Parameter:parameter success:^(QDevice *respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self getDeviceInfo];

        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        
    }];
}

#pragma mark QDeviceVolumeViewDelegate
- (void)QDeviceVolumeViewBtnClicked:(QDeviceView *)view selectName:(NSString *)name
{
    NSLog(@"name====%@",name);
    self.volumeStr = name;
    
     float floatvolume = [self.volumeStr floatValue];
    
    NSLog(@"floatvolume==== %f", floatvolume);
    
    NSNumber *volumeNSNumber = [NSNumber numberWithFloat: (int)(floatvolume / 100 * 100) ];
    
    [[TMCache sharedCache] setObject:name forKey:@"DeviceVolume"];
    
//    NSDictionary *dic = @{@"cmd" : @"setVolume", @"value" : volumeNSNumber};
//
//    [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    
    [self PutDevicesControlMQTT:@"5" ValueStr:volumeNSNumber];
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDeviceInfo];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
}



@end
