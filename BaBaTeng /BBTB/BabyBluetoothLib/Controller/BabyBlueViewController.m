    //
//  ViewController.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyBlueViewController.h"
#import "PeripheralInfo.h"

#import "Header.h"
#import "AppDelegate.h"
#import "BabylBlueCell.h"
//#import "MBProgressHUD.h"

#define channelOnPeropheralView @"peripheralView"

@interface BabyBlueViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    UITableView *tableView;
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    BabyBluetooth *baby;


}

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic, strong) NSMutableArray *services;

//@property (nonatomic, strong) MBProgressHUD *hud;



@end

@implementation BabyBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙列表";
    
    NSLog(@"viewDidLoad");
//    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    
    [self showToastWithString:@"准备打开设备"];
    
    //初始化其他数据 init other
    peripherals = [[NSMutableArray alloc]init];
    peripheralsAD = [[NSMutableArray alloc]init];
    
    self.services = [[NSMutableArray alloc] init];
   
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    [self LoadChlidView];
    

}

- (void)LoadChlidView{
    
    //实例化
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    
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
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 64 - 64, kDeviceWidth, 64)];
    
    footView.backgroundColor = DefaultBackgroundColor;
    
    
    [self.view addSubview:footView];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kDeviceWidth - 100, 54)];
    
    footLabel.font = [UIFont systemFontOfSize:14];
    //    footLabel.backgroundColor = [UIColor redColor];
    footLabel.textColor = [UIColor blackColor];
    footLabel.text = @"温馨提示:蓝牙耳机的蓝牙连接，需要您要设置页面自己连接，点击设置连接蓝牙耳机的蓝牙";
    footLabel.textAlignment = NSTextAlignmentLeft;
    
    footLabel.numberOfLines = 0;
    
    [footView addSubview:footLabel];
    
//    UIButton *SetupBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(footLabel.frame) + 10,10 ,80, 44)];
//    
//    
//    
//    [SetupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [SetupBtn setTitle:@"设置" forState:UIControlStateNormal];
//    
//    SetupBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [SetupBtn addTarget:self action:@selector(SetupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:SetupBtn];


    
}

//- (void)SetupBtnClicked
//{
//    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
//    if ([[UIApplication sharedApplication]canOpenURL:url]) {
//
//        [self.navigationController popViewControllerAnimated:YES];
//        [[UIApplication sharedApplication]openURL:url];
//
//    }
//
//}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
//    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
//    [baby cancelScan];
    
//    baby.scanForPeripherals().stop(1);
}
#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {

            [weakSelf showToastWithString:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        NSLog(@"搜索到了设备1111:%@",peripheral.identifier);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData];
    }];
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
//    //设置设备断开连接的委托
//    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        NSLog(@"设备：%@--断开连接",peripheral.name);
//    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
        for (int i=0;i<peripherals.count;i++) {
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.textLabel.text == peripheral.name) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)peripheral.services.count];
            }
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >2) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelPeripheralConnectionBlock:^(CBCentralManager *centralManager, CBPeripheral *peripheral) {
        NSLog(@"setBlockOnCancelPeripheralConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    /*设置babyOptions
        
        参数分别使用在下面这几个地方，若不使用参数则传nil
        - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
        - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
        - [peripheral discoverServices:discoverWithServices];
        - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
        
        该方法支持channel版本:
            [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
//    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![peripherals containsObject:peripheral]){
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripherals addObject:peripheral];
        [peripheralsAD addObject:advertisementData];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"BabylBlueCellcell";
    BabylBlueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[BabylBlueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    
    
    
    cell.peripheral = peripherals[indexPath.row];
    
//    NSLog(@"cell.peripheral.state11111111===%ld",(long)cell.peripheral.state);
//    if (cell.peripheral.state == CBPeripheralStateConnected) {
////        NSLog(@"cell.peripheral.serviceArray====%lu",(unsigned long)cell.peripheral.serviceArray.count);
//        if (self.services.count >= 2) {
//
//            CBCharacteristic *recivecharacteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:0];
//            CBCharacteristic *characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:0];
//
//            NSLog(@"recivecharacteristic111111=======%@",recivecharacteristic);
//            NSLog(@"characteristic2222222=======%@",characteristic);
//
//        }
//
//    }
    

//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
//    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
//    NSDictionary *ad = [peripheralsAD objectAtIndex:indexPath.row];
//
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//
//    //peripheral名称 peripheral name
//    NSString *localName = [NSString stringWithFormat:@"%@",[ad objectForKey:@"kCBAdvDataLocalName"]];
//    if (!localName) {
//        localName = peripheral.name;
//    }
//    cell.textLabel.text = localName;
//    //信号和服务
//    cell.detailTextLabel.text = @"读取中...";
//    //找到cell并修改detaisText
//    NSArray *serviceUUIDs = [ad objectForKey:@"kCBAdvDataServiceUUIDs"];
//    if (serviceUUIDs) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个service",serviceUUIDs.count];
//    }else{
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"0个service"];
//    }
    
    //次线程读取RSSI和服务数量
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    [baby cancelAllPeripheralsConnection];
    
    
    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PeripheralViewContriller *vc = [[PeripheralViewContriller alloc]init];
//    vc.currPeripheral = [peripherals objectAtIndex:indexPath.row];
//    vc->baby = self->baby;
//    [self.navigationController pushViewController:vc animated:YES];
    self.currPeripheral = [peripherals objectAtIndex:indexPath.row];
    
    [self connectBlue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64.0;
}

#pragma mark 蓝牙连接中
- (void)connectBlue
{
    [self babyPeripheralDelegate];
    
    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];

    [self showToastWithString:@"准备连接设备"];
}

-(void)loadData
{

    [self showToastWithString:@"开始连接设备"];
    [self startLoading];
//    [self.hud showAnimated:YES];
//     [MBProgressHUD showHUDAddedTo:self.view animated:<#(BOOL)#>]
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}

-(void)babyPeripheralDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        
        NSLog(@"连接成功sddsdf");
        
//         [weakSelf.tableView reloadData];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
//            [weakSelf insertSectionToTableView:s];
            NSLog(@"sfdsfsfsdfdfdf=====%@",s);
            
            [weakSelf AddCBService:s];
            
           
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
//        [weakSelf insertRowToTableView:service];
        [weakSelf AddCBPeripheral:service];
        
        
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
        [self SetupCharacteristic];
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
//    [self performSelector:@selector(test) withObject:nil afterDelay:2];
    
}

-(void)AddCBService:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
}


-(void)AddCBPeripheral:(CBService *)service{
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
    }
    
}

- (void)SetupCharacteristic
{
    if (self.services.count >= 2) {

        CBCharacteristic *recivecharacteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:0];
        CBCharacteristic *characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:0];

        NSLog(@"recivecharacteristic111111=======%@",recivecharacteristic);
        NSLog(@"characteristic2222222=======%@",characteristic);

        appDelegate.babycharacteristic = characteristic;
        appDelegate.babycharacteristicrevice = recivecharacteristic;

    }
    appDelegate.currPeripheral = self.currPeripheral;
    appDelegate->baby = self->baby;
    
     [[TMCache sharedCache] setObject:self.currPeripheral.name forKey:@"currPeripheralNAME"];
    
    [self showToastWithString:@"连接成功"];
    
    [self stopLoading];
    
//    [self.hud hideAnimated:YES];
    
     [self.tableView reloadData];
}

@end
