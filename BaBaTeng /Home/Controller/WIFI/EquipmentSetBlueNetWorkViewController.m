//
//  EquipmentSetBlueNetWorkViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentSetBlueNetWorkViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BBTQAlertView.h"

#import "EquipmentBindingViewController.h"

//作为蓝牙扫描其它蓝牙用
static NSString * const ConfigBleName =  @"bleconfig";

@interface EquipmentSetBlueNetWorkViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//作为蓝牙扫描其它蓝牙用
@property (nonatomic, strong) CBCentralManager *manager;
//用于保存被发现设备
@property (nonatomic, strong) NSMutableArray *discoverPeripherals;

@property(nonatomic, strong) UIImageView *cofigView;
@property(nonatomic, strong) BBTQAlertView *QalertView;
@property (nonatomic, strong) UIButton      *cancelBtn;

@end

@implementation EquipmentSetBlueNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title = self.deviceTypeName;
    
    [self LoadChlidView];
    
    [self showConfiging];
    
    //开始蓝牙配网
    [self initBleManager];
    
}


- (void)LoadChlidView
{
    
    //    icon_WIFIBIG_01
    
    self.cofigView = [[UIImageView alloc]initWithFrame:CGRectMake( (kDeviceWidth - 97)/2.0, 120, 97, 97)];
    self.cofigView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"icon_WIFIBIG_01.png"],
                                      [UIImage imageNamed:@"icon_WIFIBIG_02.png"],
                                      [UIImage imageNamed:@"icon_WIFIBIG_03.png"],
                                      [UIImage imageNamed:@"icon_WIFIBIG.png"],
                                      nil];
    [self.cofigView setAnimationDuration:5.0f];
    [self.cofigView setAnimationRepeatCount:0];
    //    [self.cofigView startAnimating];
    [self.view addSubview:self.cofigView];
    
    UILabel *configLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.cofigView.frame) + 20, kDeviceWidth - 100, 20)];
    configLabel.textColor = [UIColor lightGrayColor];
    configLabel.text = @"设备正在连接网络";
    
    configLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:configLabel];
    
    
    
    
    //适配iphone x
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-50)/2, KDeviceHeight - 180-kDevice_Is_iPhoneX, 50, 51)];
    
    //    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
    //    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    
    [ self.cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    
}

-(void)cancelBtnClick{
    
   [self bleConfigStop];
    
    NSArray *pushVCAry=[self.navigationController viewControllers];
    
    
    //下面的pushVCAry.count-3 是让我回到视图1中去
    
    UIViewController *popVC=[pushVCAry objectAtIndex:1];
    
    
    
    [self.navigationController popToViewController:popVC animated:YES];
}

- (void)backForePage
{
    [self bleConfigStop];
    
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)showConfiging{
    [self.cofigView startAnimating];
}



-(void) showConfigSuccess{
    NSLog(@"******showConfigSuccess******");
    
    [self.cofigView stopAnimating];
    
    EquipmentBindingViewController *bindVc = [[EquipmentBindingViewController alloc] init];
    bindVc.deviceTypeName = self.deviceTypeName;
    bindVc.deviceTypeId = self.deviceTypeId;
    bindVc.iconUrl =self.iconUrl;
//    bindVc.deivceProgramId =self.deivceProgramId;
    [self.navigationController pushViewController:bindVc animated:YES];
    
//
//    [self showToastWithString:@"联网成功"];
//
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - BleConfig
//初始化蓝牙中心设备
- (void)initBleManager {
    
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    //持有发现的设备,如果不持有设备会导致CBPeripheralDelegate方法不能正确回调
    self.discoverPeripherals = [[NSMutableArray alloc]init];
    [self showToastWithString:@"准备扫描蓝牙设备"];
    
}

- (void)bleConfigStop {
    self.manager = nil;
    [self.discoverPeripherals removeAllObjects];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff: {
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"通知" message:@"蓝牙未打开,请开启蓝牙。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
            
        }
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [central scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
    
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"当扫描到设备:%@",peripheral.name);
    
    if ([peripheral.name isEqualToString:ConfigBleName]) {
        [self.discoverPeripherals addObject:peripheral];
        NSLog(@"get cofig device ble name = %@", peripheral.name);
        [self showToastWithString:@"发现指定蓝牙设备"];
        //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！！
        [central connectPeripheral:peripheral options:nil];
    }
}
//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{   [self showToastWithString:@"蓝牙连接失败"];
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    [self showToastWithString:@"设备断开蓝牙连接"];
    
    [self showConfigSuccess];
}
//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{   [self showToastWithString:@"蓝牙连接成功"];
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    //设置的peripheral委托CBPeripheralDelegate
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    //停止扫描
    [self.manager stopScan];
}


//- (void)showToastWithMessage:(NSString *)message {
//    [self.view hideToasts];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.view makeToast:message];
//    });
//}


//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"get service uuid = %@",service.UUID);
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristic: %@, properties = %lu",service.UUID,characteristic.UUID, (unsigned long)characteristic.properties);
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC7"]]) {
            
            NSString *wifiNameStr = [NSString stringWithFormat:@"#u%02ld#%@", [self convertToInt:self.wifiName], self.wifiName];
            NSString *passwordStr = [NSString stringWithFormat:@"#p%02ld#%@", [self convertToInt:self.wifiPassword], self.wifiPassword];
            
            NSLog(@"蓝牙发送的wifi信息 = %@\n%@",wifiNameStr,passwordStr);
            
            //            NSString *sendStr = [NSString stringWithFormat:@"%@&&%@",_textFieldWIFI.text, _textFieldPwd.text];
            //            NSData *sendData = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
            [self showToastWithString:@"发送WiFi信息"];
            
            NSData *nameData = [wifiNameStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *passwordData = [passwordStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [peripheral writeValue:nameData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            [peripheral writeValue:passwordData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC8"]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        
    }
}

//计算中英混合字符串的长度
- (long)convertToInt:(NSString*)strtemp {
    long strlength = 0;
    NSString * str = strtemp;
    const char * a = [str UTF8String];
    strlength = strlen(a);
    
    return strlength;
}

//写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic  error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"获得数据 uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    NSLog(@"写入%@成功",characteristic);
}

//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    
    NSData *data = characteristic.value;
    Byte *resultByte = (Byte *)[data bytes];
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC8"]]) {
        [self showToastWithString:@"设备接收到WiFi信息"];
    }
    
    NSLog(@"最终接收到的蓝牙数据 uuid:%@  value:%@, byte = %s",characteristic.UUID,data,resultByte);
    
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
