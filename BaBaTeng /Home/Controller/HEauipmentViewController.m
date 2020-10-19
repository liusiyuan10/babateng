//
//  HEauipmentViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/24.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "HEauipmentViewController.h"

#import "UIImageView+AFNetworking.h"

#import "HEauipmentQuiltViewCell.h"
#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "QMineRequestTool.h"
#import "QModule.h"
#import "QModuleData.h"
#import "QEquipmentViewController.h"

#import "QDemandViewController.h"
#import "QTalkViewController.h"
#import "QFavoriteViewController.h"
#import "QSongViewController.h"
#import "QDeviceControlViewController.h"
#import "AddEquipmentViewController.h"
#import "QChatViewController.h"
#import "QFamilyCallViewController.h"

#import "QMessageViewController.h"
#import "QClockViewController.h"

#import "BBlockViewController.h"
#import "BMoveViewController.h"
#import "BFavoriteViewController.h"
#import "BSongViewController.h"
#import "BTutorialViewController.h"
#import "BVioceViewController.h"
#import "BCalibrateViewController.h"
#import "BBlockStoreViewController.h"

#import "BEquipmentViewController.h"

#import "PCVideoViewController.h"

#import "BBTEquipmentRequestTool.h"
#import "BBTEquipmentRespone.h"
#import "SyncEnglishViewController.h"

#import "SEquipmentViewController.h"
#import "TmallModel.h"
#import "XiaoXianDataModel.h"
#import "XiaoXianModel.h"
#import "PictureBookViewController.h"
#import "PCXXVideoViewController.h"
#import "SCEquipmentViewController.h"

@interface HEauipmentViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView         *deviceView;
@property (nonatomic, strong) UIImageView    *deviceImageView;
@property (nonatomic, strong) UILabel        *devicenameLabel;
@property (nonatomic, strong) UILabel        *deviceonLabel;
@property (nonatomic, strong) UIView         *bgNoDeviceView;
@property (nonatomic, strong) UIView         *bgDeviceView;
@property (nonatomic, strong) UIButton         *noDeviceBtn;

@property (nonatomic, strong)     TMQuiltView *collectionView;
@property (nonatomic)              NSMutableArray *ModuleArray;

@property (nonatomic, strong) UIButton         *NetDeviceBtn;
@property (nonatomic, assign) BOOL isCanSideBack;

@property (nonatomic, strong) UILabel *blueLabel;

@end

@implementation HEauipmentViewController

-(UIButton *)noDeviceBtn
{
    if (_noDeviceBtn == nil) {
        _noDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 40, kDeviceWidth - 120, 356)];
        //        _deviceView.backgroundColor = [UIColor whiteColor];
        
        [_noDeviceBtn addTarget:self action:@selector(noDeviceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgNoDeviceView addSubview:_noDeviceBtn];
    }
    
    return _noDeviceBtn;
}

-(UIView *)bgNoDeviceView
{
    if (_bgNoDeviceView == nil) {
        _bgNoDeviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        //        _deviceView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_bgNoDeviceView];
    }
    
    return _bgNoDeviceView;
}

-(UIView *)bgDeviceView
{
    if (_bgDeviceView == nil) {
        _bgDeviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        
        [self.view addSubview:_bgDeviceView];
    }
    
    return _bgDeviceView;
}

-(UIView *)deviceView
{
    if (_deviceView == nil) {
        _deviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 196 + 15)];
        //        _deviceView.backgroundColor = [UIColor whiteColor];
        
        [self.bgDeviceView addSubview:_deviceView];
    }
    
    return _deviceView;
}

-(UIImageView *)deviceImageView
{
    if (_deviceImageView == nil) {
        _deviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 88)/2.0, 30, 88, 92)];
        
        [self.deviceView addSubview:_deviceImageView];
    }
    
    return _deviceImageView;
}

-(UILabel *)devicenameLabel
{
    if (_devicenameLabel == nil) {
        
        _devicenameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20, CGRectGetMaxY(self.deviceImageView.frame) + 8, kDeviceWidth - 40, 21)];
        
        _devicenameLabel.font = [UIFont systemFontOfSize:15];
        _devicenameLabel.backgroundColor = [UIColor clearColor];
        _devicenameLabel.textColor = [UIColor colorWithRed:114/255.0 green:77/255.0 blue:90/255.0 alpha:1.0];
        _devicenameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.deviceView addSubview:_devicenameLabel];
    }
    
    return _devicenameLabel;
}

-(UIButton *)NetDeviceBtn
{
    if (_NetDeviceBtn == nil) {
        _NetDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 70)/2.0 - 17, CGRectGetMaxY(self.devicenameLabel.frame) + 4, 17, 17)];
 
        _NetDeviceBtn.hidden = YES;
        [self.deviceView addSubview:_NetDeviceBtn];
    }
    
    return _NetDeviceBtn;
}

-(UILabel *)deviceonLabel
{
    if (_deviceonLabel == nil) {
        
        _deviceonLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 70)/2.0, CGRectGetMaxY(self.devicenameLabel.frame) + 4, 70, 17)];
        
        _deviceonLabel.font = [UIFont systemFontOfSize:12];
        _deviceonLabel.backgroundColor = [UIColor clearColor];
        _deviceonLabel.textColor = [UIColor colorWithRed:108/255.0 green:193/255.0 blue:14/255.0 alpha:1.0];
        _deviceonLabel.textAlignment = NSTextAlignmentCenter;
        [self.deviceView addSubview:_deviceonLabel];
    }
    
    return _deviceonLabel;
}


-(UILabel *)blueLabel
{
    if (_blueLabel == nil) {
        
        _blueLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 200)/2.0, CGRectGetMaxY(self.deviceonLabel.frame) + 4, 200, 17)];
        
        _blueLabel.font = [UIFont systemFontOfSize:12];
        _blueLabel.backgroundColor = [UIColor clearColor];
        _blueLabel.textColor = [UIColor colorWithRed:108/255.0 green:193/255.0 blue:14/255.0 alpha:1.0];
        _blueLabel.textAlignment = NSTextAlignmentCenter;
        [self.deviceView addSubview:_blueLabel];
    }
    
    return _blueLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgNoDeviceView.backgroundColor = DefaultBackgroundColor;
    self.bgDeviceView.backgroundColor = DefaultBackgroundColor;
    
    self.deviceView.backgroundColor = [UIColor whiteColor];
    
    [self.noDeviceBtn setImage:[UIImage imageNamed:@"img_bdsb_nor"] forState:UIControlStateNormal];
    [self.noDeviceBtn setImage:[UIImage imageNamed:@"img_bdsb_pre"] forState:UIControlStateHighlighted];
    

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceViewClicked)];
    
    [self.deviceView addGestureRecognizer:singleTap];
    
    self.ModuleArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HEauipment:) name:@"HEauipment" object:nil];
    

    
    [self LoadChlidView];
    
//    [self getModuleSource];
    
//    [self.collectionView reloadData];
    

}

- (void)LoadChlidView
{
    
    
//    // 可以给layout设置全局属性
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    // default is UICollectionViewScrollDirectionVetical
//    //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
//    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    [self.view addSubview:_collectionView];
//    _collectionView.backgroundColor = [UIColor lightGrayColor];
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    // 注册类，是用纯代码生成的collectiviewcell类才行
//    //[_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CellIdentifier"];
//
    
    
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.deviceView.frame),self.view.frame.size.width, self.view.frame.size.height - 64 - CGRectGetMaxY(self.deviceView.frame) - 10)];
    
//    self.collectionView.scrollEnabled = NO;
    self.collectionView.bounces = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.bgDeviceView addSubview:self.collectionView];
    

    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.collectionView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.collectionView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    

}

- (void)HEauipment:(NSNotification *)noti
{
    
    NSString *name = [noti.userInfo objectForKey:@"name"];
    NSString *deviceicon = [noti.userInfo objectForKey:@"deviceIocn"];
    NSString *deviceStatus = [noti.userInfo objectForKey:@"deviceStatus"];
    NSString *deviceNet = [noti.userInfo objectForKey:@"deviceNet"];
    //    deviceNet
    
    if ([name isEqualToString:@"NODEVICE"]) {
        
        self.bgDeviceView.hidden = YES;
        self.bgNoDeviceView.hidden = NO;
        
        
        
        
    }
    else
    {
        
        self.bgNoDeviceView.hidden = YES;
        self.bgDeviceView.hidden = NO;
        
        [self.deviceImageView setImageWithURL:[NSURL URLWithString:deviceicon] placeholderImage:[UIImage imageNamed:@"SB_01"]];
        
        self.devicenameLabel.text =@"完善信息"; //binddata.device.deviceType.deviceTypeName;
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
            
            self.NetDeviceBtn.hidden = YES;
            
            if (appDelegate.currPeripheral != nil && appDelegate.currPeripheral.state == CBPeripheralStateConnected) {
                
                //                if (appDelegate.currPeripheral.state == CBPeripheralStateDisconnected) {
                //                    <#statements#>
                //                }
                self.deviceonLabel.text = @"蓝牙已连接";
                self.blueLabel.text = [NSString stringWithFormat:@"蓝牙名称:%@",appDelegate.currPeripheral.name];
            }
            else
            {
                
                self.deviceonLabel.text = @"蓝牙未连接";
                self.blueLabel.text = @"";
                
            }
            
        }
        else
        {
            
            if ([deviceStatus isEqualToString:@"1"]) {
                
                self.deviceonLabel.text = @"设备在线";
                
                self.NetDeviceBtn.hidden = NO;
                
                if ([deviceNet isEqualToString:@"Mobile"] ||[deviceNet isEqualToString:@"unkown"] ) {
                    [self.NetDeviceBtn setImage:[UIImage imageNamed:@"device-4G"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.NetDeviceBtn setImage:[UIImage imageNamed:@"device-wifi"] forState:UIControlStateNormal];
                }
                
            }
            else
            {
                self.NetDeviceBtn.hidden = YES;
                self.deviceonLabel.text = @"设备不在线";
                
            }
            
            
        }
        
        
        
        
        
        [self getModuleSource];
        
    }
    
    
    
    
}



- (void)noDeviceBtnClicked
{
    AddEquipmentViewController  * addViewControlle = [[AddEquipmentViewController alloc]init];
    addViewControlle.title = @"添加设备";
    
    [self.navigationController pushViewController:addViewControlle animated:YES];
    
}

- (void)deviceViewClicked
{
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"])
    {
        BEquipmentViewController *BEquipmentVC = [[BEquipmentViewController alloc] init];
        
        [self.navigationController pushViewController:BEquipmentVC animated:YES];
    }
    else if([QdeivceProgramIdStr isEqualToString:@"7"])
    {
        SEquipmentViewController *SEquipmentVC = [[SEquipmentViewController alloc] init];
        
        [self.navigationController pushViewController:SEquipmentVC animated:YES];
    }
    else if([QdeivceProgramIdStr isEqualToString:@"13"])
    {
        SCEquipmentViewController *SEquipmentVC = [[SCEquipmentViewController alloc] init];
        
        [self.navigationController pushViewController:SEquipmentVC animated:YES];
    }
    else
    {
        QEquipmentViewController *QEquipmentVC = [[QEquipmentViewController alloc] init];
        
        [self.navigationController pushViewController:QEquipmentVC animated:YES];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getModuleSource
{
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    
    
//    [self startLoading];
    
    [QMineRequestTool getDeviceModulesName:name success:^(QModule *response) {
        
//        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {

            self.ModuleArray = (NSMutableArray*)response.data;

            
            if (self.ModuleArray.count > 0) {
                
//                QModuleData *moduledata = [[QModuleData alloc] init];
//                moduledata.moduleId = @"22";
//                moduledata.deviceModuleName = @"亲子视频";
//                moduledata.deviceTypeId = @"010000";
//                moduledata.deviceModuleIcon = @"";
//
//                [self.ModuleArray addObject:moduledata];
                
                [self.collectionView reloadData];
                
            }
        
            
        }

        else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
//        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
}





//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    
    NSLog(@"self.ModuleArray=======%lu",(unsigned long)self.ModuleArray.count);
    return [self.ModuleArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    HEauipmentQuiltViewCell *cell = (HEauipmentQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"HEauipmentCell"];
    if (!cell) {
        cell = [[HEauipmentQuiltViewCell alloc] initWithReuseIdentifier:@"HEauipmentCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSLog(@"indexPath=====%ld",(long)indexPath.row);

    QModuleData *moduledata = self.ModuleArray[indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)moduledata.deviceModuleIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];


    cell.titleLabel.text = moduledata.deviceModuleName;
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 4;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KDeviceHeight/667*101;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);

    QModuleData *moduledata = self.ModuleArray[indexPath.row];
    
    if ( [moduledata.moduleId isEqualToString:@"1"] ) {
        NSLog(@"点播历史");
        QDemandViewController *QDemandVC = [[QDemandViewController alloc] init];
        QDemandVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QDemandVC animated:YES];
    }else if ([moduledata.moduleId isEqualToString:@"2"]){
        
        NSLog(@"宝贝说说");
        QTalkViewController *QTalkVC = [[QTalkViewController alloc] init];
        QTalkVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QTalkVC animated:YES];
        
    }else if ( [moduledata.moduleId isEqualToString:@"3"] ){
        
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"3"])  {
            
            NSLog(@"宝贝最爱");
            BFavoriteViewController *QFavoriteVC = [[BFavoriteViewController alloc] init];
            QFavoriteVC.title =moduledata.deviceModuleName;
            [self.navigationController pushViewController:QFavoriteVC animated:YES];
        }
        else
        {
            NSLog(@"宝贝最爱");
            QFavoriteViewController *QFavoriteVC = [[QFavoriteViewController alloc] init];
            QFavoriteVC.title =moduledata.deviceModuleName;
            [self.navigationController pushViewController:QFavoriteVC animated:YES];
        }
        
        
        
    }
    else if ( [moduledata.moduleId isEqualToString:@"4"] ){
        
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
            
            NSLog(@"宝贝歌单");
            BSongViewController *QSongVC = [[BSongViewController alloc] init];
            QSongVC.title =moduledata.deviceModuleName;
            [self.navigationController pushViewController:QSongVC animated:YES];
        }
        else
        {
            
            NSLog(@"宝贝歌单");
            QSongViewController *QSongVC = [[QSongViewController alloc] init];
            QSongVC.title =moduledata.deviceModuleName;
            [self.navigationController pushViewController:QSongVC animated:YES];
            
        }
    }
    else if ( [moduledata.moduleId isEqualToString:@"5"] ){
        
        NSLog(@"设备控制");
        QDeviceControlViewController *QDeviceControlVC = [[QDeviceControlViewController alloc] init];
        QDeviceControlVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:QDeviceControlVC animated:YES];
    }
    else if ( [moduledata.moduleId isEqualToString:@"6"] ){

        NSLog(@"亲情电话");

        QFamilyCallViewController *QFamilyControlVC = [[QFamilyCallViewController alloc] init];
        
        QFamilyControlVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QFamilyControlVC animated:YES];
//

    }
    
    else if ( [moduledata.moduleId isEqualToString:@"7"] ){
        
        NSLog(@"微聊");
        QChatViewController *QChatControlVC = [[QChatViewController alloc] init];
        QChatControlVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:QChatControlVC animated:YES];
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"10"] ){
        
        //        NSLog(@"编程模式");

        BBlockViewController *QBlockControlVC = [[BBlockViewController alloc] init];
        
        QBlockControlVC.currPeripheral = appDelegate.currPeripheral;
        QBlockControlVC.babycharacteristic = appDelegate.babycharacteristic;
        QBlockControlVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
        QBlockControlVC->baby = appDelegate->baby;
        
        [self.navigationController pushViewController:QBlockControlVC animated:YES];
        
        
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"11"] ){
        
        //        NSLog(@"运动模式");
        
        
        
        BMoveViewController *QBlockControlVC = [[BMoveViewController alloc] init];
        
        QBlockControlVC.currPeripheral = appDelegate.currPeripheral;
        QBlockControlVC.babycharacteristic = appDelegate.babycharacteristic;
        QBlockControlVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
        QBlockControlVC->baby = appDelegate->baby;
        
        [self.navigationController pushViewController:QBlockControlVC animated:YES];
        
        
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"12"] ){
        
        //          [self showToastWithString:@"语音控制"];
        
        
        BVioceViewController *vioceControlVC = [[BVioceViewController alloc] init];
        vioceControlVC.currPeripheral = appDelegate.currPeripheral;
        vioceControlVC.babycharacteristic = appDelegate.babycharacteristic;
        
        [self.navigationController pushViewController:vioceControlVC animated:YES];
        
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"13"] ){
        
        BTutorialViewController *QBlockControlVC = [[BTutorialViewController alloc] init];
        
        QBlockControlVC.currPeripheral = appDelegate.currPeripheral;
        QBlockControlVC.babycharacteristic = appDelegate.babycharacteristic;
        QBlockControlVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
        QBlockControlVC->baby = appDelegate->baby;
        
        [self.navigationController pushViewController:QBlockControlVC animated:YES];
        
        //        [self showToastWithString:@"编程课堂"];
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"14"] ){
        
        NSLog(@"实时消息");
        QMessageViewController *QMessageControlVC = [[QMessageViewController alloc] init];
        QMessageControlVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:QMessageControlVC animated:YES];
        
    }
    
    else if ( [moduledata.moduleId isEqualToString:@"15"] ){
        
        BCalibrateViewController *QBlockControlVC = [[BCalibrateViewController alloc] init];
        
        QBlockControlVC.currPeripheral = appDelegate.currPeripheral;
        QBlockControlVC.babycharacteristic = appDelegate.babycharacteristic;
        QBlockControlVC.babycharacteristicrevice = appDelegate.babycharacteristicrevice;
        QBlockControlVC->baby = appDelegate->baby;
        
        [self.navigationController pushViewController:QBlockControlVC animated:YES];
        
    }

    else if ( [moduledata.moduleId isEqualToString:@"16"] ){
        
        NSLog(@"实时消息");
        QClockViewController *QClockControlVC = [[QClockViewController alloc] init];
        QClockControlVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:QClockControlVC animated:YES];
        
        
        
        
    }
    else if ( [moduledata.moduleId isEqualToString:@"17"] ){
        
        BBlockStoreViewController *QStoreVC = [[BBlockStoreViewController alloc] init];
        QStoreVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:QStoreVC animated:YES];
        
    }
    else if ( [moduledata.moduleId isEqualToString:@"9"] ){
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"7"])  {
            PCVideoViewController *PCVideoVC = [[PCVideoViewController alloc] init];
    
            [self.navigationController pushViewController:PCVideoVC animated:YES];

        }
        else
        {
             [self GetXiaoxiantoken];
        }
    

        
        
       



    }
    else if ( [moduledata.moduleId isEqualToString:@"18"] ){
        
        NSLog(@"实时消息");
        SyncEnglishViewController *SyncEnglishVC = [[SyncEnglishViewController alloc] init];
        SyncEnglishVC.title = moduledata.deviceModuleName;
        [self.navigationController pushViewController:SyncEnglishVC animated:YES];

    }
    else if ( [moduledata.moduleId isEqualToString:@"19"] ){
        
        [self GetTmallToken];
        
        
        
        
    }
    else if ( [moduledata.moduleId isEqualToString:@"20"] ){
        
        PictureBookViewController *PictureBookVC = [[PictureBookViewController alloc] init];
        PictureBookVC.title = moduledata.deviceModuleName;
        
        [self.navigationController pushViewController:PictureBookVC animated:YES];
        
        
    }
    
    else if (indexPath.row == 19){
        
        NSLog(@"其他按钮");
        
        [self showToastWithString:@"当前版本暂不支持该功能"];
        
        
        
    }

    
}
- (void)GetXiaoxiantoken
{
    [BBTEquipmentRequestTool GETXiaoXianDeviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(XiaoXianModel *registerRespone) {
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
//            [self phoneLoginToken:registerRespone.data.loginToken DeviceCode:registerRespone.data.deviceCode];
            
            PCXXVideoViewController *PCVideoVC = [[PCXXVideoViewController alloc] init];
            
            PCVideoVC.deviceCode = registerRespone.data.deviceCode;
            
            [[TMCache sharedCache] setObject:[[TMCache sharedCache] objectForKey:@"deviceId"]  forKey:@"XXYYdeviceId"];
    
            [self.navigationController pushViewController:PCVideoVC animated:YES];
            
        }
        else
        {

        }
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

//- (void)phoneLoginToken:(NSString *)token DeviceCode:(NSString *)devicecode
//{
//
//
////    NSString *imToken = @"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiZDU1ODA5MDJjYWI0ZDg4NTNiMDY2NDRhNTVlZjcyMGEiLCJBcHBpZCI6ImFhMmUyYmM2ZTIyZTRmYmZhZjkyNGZhNzVjMDJkYzA5IiwiVXNlcmlkIjoiMTg1MDMwNTEwOTYifQ==.2cO35BpHOG6JCH5AhKFNg3ZLcwtpVchruFCo5UZvNBs=";
//
//
//    [[UCSTcpClient sharedTcpClientManager] login_connect:token  success:^(NSString *userId) {
//        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录成功"]];
//
//        NSLog(@"chenggong ");
//
//        [InfoManager sharedInfoManager].imtoken = token;
//        [[InfoManager sharedInfoManager] synchronizeToSandBox];
//
//        [[UCSFuncEngine getInstance] creatTimerCheckCon];//开启15秒连接定时检测
//
//        PCVideoViewController *PCVideoVC = [[PCVideoViewController alloc] init];
//        PCVideoVC.deviceCode = devicecode;
//
//        [self.navigationController pushViewController:PCVideoVC animated:YES];
//
//
//    } failure:^(UCSError *error) {
//        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录失败"]];
//
//    }];
//
//
//}

- (void)GetTmallToken
{
    NSLog(@"ssssss=====%@",[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    [self startLoading];
    [BBTEquipmentRequestTool GetTmallDeviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(TmallModel *respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            if(respone.data.mac.length == 0)
            {
                [self showToastWithString:@"MAC地址不能为空"];
                return ;
            }
            //
            NSString *macstr = [self dealWithString:respone.data.mac.uppercaseString];
            
            NSLog(@"macstr=====%@",macstr);
            
            
            NSString *tmallStr = [NSString stringWithFormat:@"assistant://authinside?token=%@&bizType=%@&bizGroup=%@&mac=%@",respone.data.token,@"BABATENG",@"NHqlssZJ",macstr];
            
            //            NSString *tmallStr = [NSString stringWithFormat:@"assistant://authinside?token=%@&bizType=%@&bizGroup=%@&mac=%@",@"91229e69-b9ca-4fdd-9e4a-129ba5c13cd4",@"BABATENG",@"NHqlssZJ",macstr];
            
            NSLog(@"tmallStr====%@",tmallStr);
            
            BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"assistant://"]];
            
            if (isInstalled) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tmallStr]];
                
                
                
            }else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%A4%A9%E7%8C%AB%E7%B2%BE%E7%81%B5/id1158753204?mt=8"]];
            }
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}


- (NSString *)dealWithString:(NSString *)number
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == 2) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    NSLog(@"%@", doneTitle);
    
    NSString *str1 = [doneTitle substringToIndex:doneTitle.length - 1];//截取掉下标5之前的字符串
    NSLog(@"str1==%@", str1);
    return str1;
}



- (void)IsHuanXinlogin
{

//
    [BBTEquipmentRequestTool GETHuanxinPhoneNum:[[TMCache sharedCache] objectForKey:@"phoneNumber"] success:^(BBTEquipmentRespone *registerRespone) {
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            [[TMCache sharedCache]setObject:@"success" forKey:@"HuanXinRegister"];
            
            NSLog(@"huanxingNNNNNNOOOORegisterSuccess");

           [self HuanxinLogin];
            
            
            
        }
        else
        {
            NSLog(@"huanxingNNNNNNOOOORegisterFail");
            [self showToastWithString:registerRespone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)HuanxinLogin
{
    EMError *error = [[EMClient sharedClient] loginWithUsername:[[TMCache sharedCache] objectForKey:@"phoneNumber"] password:@"123456"];
    if (!error) {
        NSLog(@"环信登录成功");
        
        PCVideoViewController *PCVideoVC = [[PCVideoViewController alloc] init];
//        PCVideoVC.title =moduledata.deviceModuleName;
        [self.navigationController pushViewController:PCVideoVC animated:YES];
        
    }else
    {
        NSLog(@"环信登录失败");
        
        [self showToastWithString:@"环信登录失败"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    

    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    [self forbiddenSideBack];

}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [self resetSideBack];

}



/**

 * 禁用边缘返回

 */

-(void)forbiddenSideBack{

    self.isCanSideBack = NO;

    //关闭ios右滑返回

    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

        self.navigationController.interactivePopGestureRecognizer.delegate=self;

    }

}

/*

 恢复边缘返回

 */

- (void)resetSideBack {

    self.isCanSideBack=YES;

    //开启ios右滑返回

    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

        self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {

    return self.isCanSideBack;

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
