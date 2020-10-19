//
//  NewHomeViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/24.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "NewHomeViewController.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTBind.h"
#import "BBTBindDataList.h"
#import "HEauipmentViewController.h"
#import "QHomeViewController.h"
#import "QCategoryViewController.h"
#import "DropMenuView.h"
#import "AddEquipmentViewController.h"

#import "UIImageView+AFNetworking.h"

#import "PYSearchViewController.h"
#import "QSearchViewController.h"
#import "MQTTKit.h"

#import "BBTBindDeviceDataList.h"
#import "BBTBindFamily.h"
#import "BBTQAlertView.h"

#import "QHomeRequestTool.h"
#import "QPlayingTrack.h"
#import "QPlayingTrackList.h"


#import "BPlayTestViewController.h"
#import "BSearchViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"

#import "MBProgressHUD.h"

#import "DemoCallManager.h"


#import "BBTEquipmentRespone.h"
#import "QSearchResultViewController.h"
#import "XiaoXianModel.h"
#import "XiaoXianDataModel.h"

#define channelOnPeropheralView @"peripheralView"

@interface NewHomeViewController ()<DropMenuDelegate, DropMenuDataSource,PYSearchViewControllerDelegate,EMCallManagerDelegate>
{
    
    BabyBluetooth *baby;
    
}


@property (nonatomic, strong) NSMutableArray *devicearr;
@property (nonatomic, strong) UILabel        *filterLabel;
@property (nonatomic, strong) UIView         *filterView;
@property (nonatomic, strong) UIImageView    *arrowImage;
@property (nonatomic, strong) DropMenuView   *menuDView;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) MQTTClient *client;

@property(strong,nonatomic)CBPeripheral *currPeripheral;

@property (nonatomic, strong) NSMutableArray *services;



@end

@implementation NewHomeViewController


static NewHomeViewController *newhomeViewController;

+(NewHomeViewController *)getInstance{
    
    return newhomeViewController;
}



- (DropMenuView *)menuDView {
    if (!_menuDView && [self.menuArray count] > 0) {
//        _menuDView = [[DropMenuView alloc] initWithOrigin:CGPointMake(0, self.filterView.frame.origin.y + self.filterView.frame.size.height)];

        _menuDView = [[DropMenuView alloc] initWithOrigin:CGPointMake(0, 0)];
        
        _menuDView.transformImageView = self.arrowImage;
        _menuDView.titleLabel = self.filterLabel;
        _menuDView.dataSource = self;
        _menuDView.delegate = self;
    }
    return _menuDView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//      self.automaticallyAdjustsScrollViewInsets = NO;
    
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    newhomeViewController = self;
    self.title = @"首页";
    self.devicearr = [[NSMutableArray alloc] init];
    self.menuArray = [[NSMutableArray alloc] init];
    
//    self.titleColorSelected = [UIColor orangeColor];
    
    self.selectIndex = 1;
    
   self.menuView.backgroundColor = [UIColor orangeColor];
    
//    [self getBindDeviceList];
    
    [[TMCache sharedCache] removeObjectForKey:@"APP_MQTT_ENTRY"];
    
    [self LoadFilterView];
    
    [self setNavigationItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    

        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];

        if ([QdeivceProgramIdStr isEqualToString:@"3"]){

            NSDictionary *jsonDict = @{@"playStatus" : @"pause"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
        }



    [DemoCallManager sharedManager];

    
}



- (void)AnimationPlay:(NSNotification *)noti{
    
    [appDelegate AnimationPlay:noti];
}

- (void)LoadFilterView
{
    
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, kDeviceWidth - 200, 44)];
    
//    self.filterView.backgroundColor = [UIColor redColor];
    
    self.navigationItem.titleView = self.filterView;
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 200, 44)];
//    testBtn.backgroundColor = [UIColor greenColor];
    
    [testBtn addTarget:self action:@selector(testBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.filterView addSubview:testBtn];
    
 
    
//    self.filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, DWidth - 16, 20)];
    self.filterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.filterLabel.textColor = [UIColor whiteColor];
    self.filterLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.filterLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.filterView addSubview:self.filterLabel];
    
//    self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.filterLabel.frame), 16, 8, 8)];
    self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    self.arrowImage.image = [UIImage imageNamed:@"icon_xfx"];
    
    [self.filterView addSubview:self.arrowImage];
    

    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [leftbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_nor"] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_pre"] forState:UIControlStateSelected];
    [leftbutton addTarget:self action:@selector(QSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];

    [rightbutton setTitle:@"添加" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(AddEquipment) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)QSearch
{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"百家姓", @"为什么", @"守株待兔", @"井底之蛙", @"千字文", @"三字经", @"春晓",@"唐诗"];
    // 2. Create a search view controller
    //适配iphone x
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        
        NSString * urlStr = searchText;
        
        //过滤字符串前后的空格
        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //过滤中间空格
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //过滤中间空格
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
            
            BSearchViewController *searchVc = [[BSearchViewController alloc] init];
            searchVc.searchstr = urlStr;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
            
            nav.navigationBar.barTintColor = [UIColor orangeColor];
            [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [searchViewController presentViewController:nav animated:YES completion:nil];
        }else{
            
//            QSearchViewController *searchVc = [[QSearchViewController alloc] init];
            QSearchResultViewController *searchVc = [[QSearchResultViewController alloc] init];
            searchVc.searchstr = urlStr;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
            
            nav.navigationBar.barTintColor = [UIColor orangeColor];
            [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [searchViewController presentViewController:nav animated:YES completion:nil];
        }
        
        
        
    }];
    // 3. Set style for popular search and search history
    
    searchViewController.hotSearchStyle = 2;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    nav.navigationBar.barTintColor = [UIColor orangeColor];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}




-(void)AddEquipment{
    
    AddEquipmentViewController  * addViewControlle = [[AddEquipmentViewController alloc]init];
    addViewControlle.title = @"添加设备";
    
    [self.navigationController pushViewController:addViewControlle animated:YES];
    
    
    
}

- (void)testBtnClicked
{
    NSLog(@"testBtnClicked");
    
     [self.menuDView menuTappedWithSuperView:self.view];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"设备";
        case 1: return @"推荐";
        case 2: return @"分类";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[HEauipmentViewController alloc] init];
        case 1: return [[QHomeViewController alloc] init];
        case 2: return [[QCategoryViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
//    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
//    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
    
     return CGRectMake(0, 0, self.view.frame.size.width, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}







- (void)getBindDeviceList
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20};
    
//       [[TMCache sharedCache] setObject:@"commonDeviceTypeId"  forKey:@"QdeviceTypeId"];
    
    BOOL IsQHomeRefresh = NO;
    NSString *QdeviceTypeIdStr = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    if (QdeviceTypeIdStr.length == 0) {
        IsQHomeRefresh = YES;
    }else
    {
        IsQHomeRefresh = NO;
    }
    
//    [self startLoading];
    
    [BBTEquipmentRequestTool getBinddevice:parameter success:^(BBTBind *respone) {

//        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {

            self.devicearr = respone.data.list;
            
            if (self.devicearr.count>0) {
                
                [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count] forKey:@"bindDeviceNumber"];
            }else{
                
                [[TMCache sharedCache] setObject:@"0" forKey:@"bindDeviceNumber"];
            }

            if(self.devicearr.count > 0)
            {
                
//                 [[TMCache sharedCache] setObject:deviceIdNumStr forKey:@"deviceIdNum"];
                
                NSString *deviceIdNumStr = [[TMCache sharedCache] objectForKey:@"deviceIdNum"];
                NSInteger deviceIdnumN = 0;
                if (deviceIdNumStr.length == 0) {
                     deviceIdnumN = 0;
                }else
                {
                    NSInteger numN = [deviceIdNumStr integerValue];
                    
//                     [[TMCache sharedCache] setObject:@"success" forKey:@"BingdingStr"]
                   NSString *bingdingstr =   [[TMCache sharedCache] objectForKey:@"BingdingStr"];
                    
                    if ([bingdingstr isEqualToString:@"success"]) {
                        
                        deviceIdnumN = 0;
                        
//                        [[TMCache sharedCache] removeObjectForKey:@"BingdingStr"];
                    }else
                    {
                        
                        if (numN >= self.devicearr.count) {
                            deviceIdnumN = 0;
                        }else
                        {
                            deviceIdnumN = numN;
                        }

                        
                    }
                    
                }
                
                BBTBindDataList *binddata = [self.devicearr objectAtIndex:deviceIdnumN];

                [[TMCache sharedCache] setObject:binddata.device.deviceId  forKey:@"deviceId"];
                [[TMCache sharedCache] setObject:binddata.device.deviceName  forKey:@"QdeviceName"];
                [[TMCache sharedCache] setObject:binddata.device.deviceType.deviceTypeId  forKey:@"QdeviceTypeId"];
                 [[TMCache sharedCache] setObject:binddata.device.deviceType.deivceProgramId  forKey:@"QdeivceProgramId"];
                [[TMCache sharedCache] setObject:binddata.device.deviceStatus  forKey:@"HomedeviceStatus"];

                
                [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"storybox/%@/server/page", binddata.device.deviceId]  forKey:@"mKTopic"];

                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)binddata.device.deviceType.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                
                NSString  *netStr = binddata.device.boxinfo.net;
                if (netStr.length == 0 ) {
                    netStr = @"";
                }

                NSDictionary   *jsonDict=@{@"name":binddata.device.deviceName,@"deviceIocn":encodedString,@"deviceStatus":binddata.device.deviceStatus,@"deviceNet":netStr};

              
                
                [[TMCache sharedCache] setObject:encodedString  forKey:@"HomedeviceIocn"];
                
                NSString *removebingdstr =   [[TMCache sharedCache] objectForKey:@"RemoveBind"];
                
                if ([removebingdstr isEqualToString:@"success"]) {
                    
                    [[TMCache sharedCache] removeObjectForKey:@"currentTrackIcon"];
                    [self GetPlayingTrackId];
                    
                    [[TMCache sharedCache] removeObjectForKey:@"RemoveBind"];
                }
                
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];

                if (self.menuArray.count > 0) {

                    [self.menuArray removeAllObjects];
                }
                

                for (int i = 0; i < self.devicearr.count; i++) {

                    BBTBindDataList *binddata = [self.devicearr objectAtIndex:i];
                    FilterTypeModel *model = [[FilterTypeModel alloc] initWithName:binddata.device.deviceName andId:binddata.device.deviceId];

                    [self.menuArray addObject:model];

                }


                self.filterLabel.text = ((FilterTypeModel *)self.menuArray[deviceIdnumN]).filterName;
                
                self.menuDView.filterId = ((FilterTypeModel *)self.menuArray[deviceIdnumN]).filterId;


                CGSize size = [self.filterLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,nil]];
                // 名字的H
                CGFloat nameH = size.height;
                // 名字的W
                CGFloat nameW = size.width;

                CGFloat DWidth = kDeviceWidth - 200;
                if (nameW >DWidth) {
                    nameW = DWidth;
                }
                
//                filterId

                self.filterLabel.frame = CGRectMake((DWidth - nameW - 20)/2.0,11, nameW,nameH);
                self.arrowImage.frame = CGRectMake(CGRectGetMaxX(self.filterLabel.frame) + 4, 16, 8, 8);
                
                self.arrowImage.hidden = NO;

                [self.menuDView reloadData];


                if ([[TMCache sharedCache] objectForKey:@"APP_MQTT_ENTRY"] == nil)
                {
                    NSString *strcount = [NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count];
                    [[TMCache sharedCache] setObject:strcount forKey:@"DeviceArrCount"];


                    [[TMCache sharedCache] setObject:@"MQTT" forKey:@"APP_MQTT_ENTRY"];

                    [self initMQTTkitBindarr:self.devicearr];

                }


                 [self GetMessageBindarr:self.devicearr];

                NSString *devicearrcount = [NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count];
                
                

                if ([devicearrcount isEqualToString:[[TMCache sharedCache] objectForKey:@"DeviceArrCount"]]) {

                }else
                {

                    NSString *strcount = [NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count];
                    [[TMCache sharedCache] setObject:strcount forKey:@"DeviceArrCount"];

                    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {

                    }];

                    [self initMQTTkitBindarr:self.devicearr];
                    [self GetMessageBindarr:self.devicearr];
                }
                
                
                NSString *bingdingstr =   [[TMCache sharedCache] objectForKey:@"BingdingStr"];
                
                if ([bingdingstr isEqualToString:@"success"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"QHomeRefresh" object:self userInfo:nil];
                    [[TMCache sharedCache] removeObjectForKey:@"BingdingStr"];
    
                    [[TMCache sharedCache] removeObjectForKey:@"currentTrackIcon"];
                    [self GetPlayingTrackId];
                }
            
                
                NSString *huanxingloginstr = [[TMCache sharedCache] objectForKey:@"HuanXinLogin"];
                if ([huanxingloginstr isEqualToString:@"success"]) {
                    NSLog(@"环信已经登录成功");
                }
                else
                {
                    for (int i = 0; i < self.devicearr.count; i++) {
                        
                        BBTBindDataList *binddata = [self.devicearr objectAtIndex:i];
                        
                        if ([binddata.device.deviceType.deivceProgramId isEqualToString:@"7"] ) {
                            
                            [self IsHuanXinlogin];
                            
                            break;
                        }
                        
                    }
                }
                
                NSString *YunzhixunLoginstr = [[TMCache sharedCache] objectForKey:@"YunZhiXunLogin"];
                if ([YunzhixunLoginstr isEqualToString:@"success"]) {
                    NSLog(@"云之讯已经登录成功");
                }
                else
                {
                    for (int i = 0; i < self.devicearr.count; i++) {
                        
                        BBTBindDataList *binddata = [self.devicearr objectAtIndex:i];
                        
                        if ([binddata.device.deviceType.deivceProgramId isEqualToString:@"13"] ) {
                            
                            [self GetXiaoxiantokenDeviceId:binddata.device.deviceId];
                            
                            break;
                        }
                        
                    }
                }
                
                



             }
           else
           {

               [[TMCache sharedCache] setObject:@"0"  forKey:@"deviceId"];
               [[TMCache sharedCache] setObject:@"commonDeviceTypeId"  forKey:@"QdeviceTypeId"];
              
               
               if (self.menuArray.count > 0) {
                   
                   [self.menuArray removeAllObjects];
               }
               
                self.filterLabel.text = @"设备";
               
               
               CGSize size = [self.filterLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,nil]];
               // 名字的H
               CGFloat nameH = size.height;
               // 名字的W
               CGFloat nameW = size.width;
               
               CGFloat DWidth = kDeviceWidth - 200;
               
               self.filterLabel.frame = CGRectMake((DWidth - nameW - 20)/2.0,11, nameW,nameH);
               self.arrowImage.hidden = YES;
               [self.menuDView reloadData];
               
               NSDictionary   *jsonDict=@{@"name":@"NODEVICE" , @"deviceIocn":@"deviceIocn" , @"deviceStatus":@"deviceStatus"};
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];
               [[TMCache sharedCache] removeObjectForKey:@"currentTrackIcon"];
               
               NSDictionary  *dicDict=@{@"playStatus":@"pasuse"};
//               [appDelegate NoDeviceAnimationPlay:dicDict];
               
                 [[AppDelegate appDelegate] NoDeviceAnimationPlay:dicDict];


            }
            
            if (IsQHomeRefresh) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QHomeRefresh" object:self userInfo:nil];
                
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"QHomeRefresh" object:self userInfo:nil];//屏蔽这个避免总是刷新
            
            
        }
        else
        {
            //            [self showToastWithString:respone.message];
            
        }

    } failure:^(NSError *error) {
        
    }];

    
}

- (void)GetXiaoxiantokenDeviceId:(NSString *)deviceId
{
    [BBTEquipmentRequestTool GETXiaoXianDeviceId:deviceId success:^(XiaoXianModel *registerRespone) {
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            [self phoneLoginToken:registerRespone.data.loginToken DeviceCode:registerRespone.data.deviceCode];
             [[TMCache sharedCache] setObject:deviceId  forKey:@"XXYYdeviceId"];
        }
        else
        {
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)phoneLoginToken:(NSString *)token DeviceCode:(NSString *)devicecode
{
    
    
    //    NSString *imToken = @"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiZDU1ODA5MDJjYWI0ZDg4NTNiMDY2NDRhNTVlZjcyMGEiLCJBcHBpZCI6ImFhMmUyYmM2ZTIyZTRmYmZhZjkyNGZhNzVjMDJkYzA5IiwiVXNlcmlkIjoiMTg1MDMwNTEwOTYifQ==.2cO35BpHOG6JCH5AhKFNg3ZLcwtpVchruFCo5UZvNBs=";
    
    
    [[UCSTcpClient sharedTcpClientManager] login_connect:token  success:^(NSString *userId) {
        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录成功"]];
        
        NSLog(@"lllllllllllllchenggong ");
        
        [[TMCache sharedCache]setObject:@"success" forKey:@"YunZhiXunLogin"];
        
        [InfoManager sharedInfoManager].imtoken = token;
        [[InfoManager sharedInfoManager] synchronizeToSandBox];
        
        [[UCSFuncEngine getInstance] creatTimerCheckCon];//开启15秒连接定时检测
        
        
        
    } failure:^(UCSError *error) {
        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录失败"]];
        
    }];
    
    
}

- (void)IsHuanXinlogin
{
    
    //
    [BBTEquipmentRequestTool GETHuanxinPhoneNum:[[TMCache sharedCache] objectForKey:@"phoneNumber"] success:^(BBTEquipmentRespone *registerRespone) {
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"huanxingNNNNNNOOOORegisterSuccess");
            
            
            
            [self HuanxinLogin];
            
            
            
        }
        else
        {
            NSLog(@"huanxingNNNNNNOOOORegisterFail");
//            [self showToastWithString:registerRespone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)HuanxinLogin
{
    EMError *error = [[EMClient sharedClient] loginWithUsername:[[TMCache sharedCache] objectForKey:@"phoneNumber"] password:@"123456"];
    if (!error) {
        NSLog(@"环信登录成功111111111");
        
        [[TMCache sharedCache]setObject:@"success" forKey:@"HuanXinLogin"];
    }else
    {
        NSLog(@"环信登录失败");
        
//        [self showToastWithString:@"环信登录失败"];
    }
}


- (void)getRBindDeviceList
{

    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20};
    
//    [self startLoading];
    
    [BBTEquipmentRequestTool getBinddevice:parameter success:^(BBTBind *respone) {
        
//        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicearr = respone.data.list;
            
            if (self.devicearr.count>0) {
                
                [[TMCache sharedCache]setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count] forKey:@"bindDeviceNumber"];
            }else{
                
                
                [[TMCache sharedCache]setObject:@"0" forKey:@"bindDeviceNumber"];
            }
            
            
            if(self.devicearr.count > 0)
            {
                NSLog(@"刷新jiem11111122222333");
                
                NSString *deviceIdNumStr = [[TMCache sharedCache] objectForKey:@"deviceIdNum"];
                NSInteger deviceIdnumN = 0;
                if (deviceIdNumStr.length == 0) {
                    deviceIdnumN = 0;
                }else
                {
                    NSInteger numN = [deviceIdNumStr integerValue];
                    
                    NSString *bingdingstr =   [[TMCache sharedCache] objectForKey:@"BingdingStr"];
                    
                    if ([bingdingstr isEqualToString:@"success"]) {
                        
                        deviceIdnumN = 0;
                        
                        [[TMCache sharedCache] removeObjectForKey:@"BingdingStr"];
                    }else
                    {
                        
                        if (numN >= self.devicearr.count) {
                            deviceIdnumN = 0;
                        }else
                        {
                            deviceIdnumN = numN;
                        }
                        
                        
                    }
                    

                }
                
                BBTBindDataList *binddata = [self.devicearr objectAtIndex:deviceIdnumN];
                
                [[TMCache sharedCache] setObject:binddata.device.deviceId  forKey:@"deviceId"];
                [[TMCache sharedCache] setObject:binddata.device.deviceType.deviceTypeId  forKey:@"QdeviceTypeId"];
                 [[TMCache sharedCache] setObject:binddata.device.deviceName  forKey:@"QdeviceName"];
                [[TMCache sharedCache] setObject:binddata.device.deviceStatus  forKey:@"HomedeviceStatus"];
                 [[TMCache sharedCache] setObject:binddata.device.deviceType.deivceProgramId  forKey:@"QdeivceProgramId"];
                
                [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"storybox/%@/server/page", binddata.device.deviceId]  forKey:@"mKTopic"];
                
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)binddata.device.deviceType.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                
                NSString  *netStr = binddata.device.boxinfo.net;
                if (netStr.length == 0 ) {
                    netStr = @"";
                }
                
                
                
//                NSString *huanxingloginstr = [[TMCache sharedCache] objectForKey:@"HuanXinLogin"];
//                if ([huanxingloginstr isEqualToString:@"success"]) {
//                    NSLog(@"环信已经登录成功");
//                }
//                else
//                {
//                    for (int i = 0; i < self.devicearr.count; i++) {
//
//                        BBTBindDataList *binddata = [self.devicearr objectAtIndex:i];
//
//                        if ([binddata.device.deviceType.deivceProgramId isEqualToString:@"7"]) {
//
//                            [self IsHuanXinlogin];
//
//                            break;
//                        }
//
//                    }
//                }
       
                NSDictionary *jsonDict=@{@"name":binddata.device.deviceName,@"deviceIocn":encodedString,@"deviceStatus":binddata.device.deviceStatus,@"deviceNet":netStr};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];
                
            }else{
                

            }
            
        }
        
    } failure:^(NSError *error) {
        
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    self.navigationController.navigationBar.translucent = NO;
//      [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //去掉分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
//    [self.menuDView backgroundTapped];
    
    [[TMCache sharedCache] setObject:@"1" forKey:@"DeviceElectricity"];
    
    [self getBindDeviceList];
    
    
     [[TMCache sharedCache] removeObjectForKey:@"ISPLAYBLOCK"];

//        [self ConnectHomeBlue];
//        baby.scanForPeripherals().begin();


}

-(NSMutableArray<FilterTypeModel *> *)menu_filterDataArray {
    return self.menuArray;
}




-(void)menu:(DropMenuView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
     BBTBindDataList *binddata = [self.devicearr objectAtIndex:indexPath.row];
    

    
    NSString *deviceIdNumStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [[TMCache sharedCache] setObject:deviceIdNumStr forKey:@"deviceIdNum"];
    
    self.filterLabel.text = ((FilterTypeModel *)self.menuArray[indexPath.row]).filterName;
    
 
    
    CGSize size = [self.filterLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,nil]];
    // 名字的H
    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    
    CGFloat DWidth = kDeviceWidth - 200;

    if (nameW >DWidth) {
        nameW = DWidth;
    }
    
    self.filterLabel.frame = CGRectMake((DWidth - nameW - 20)/2.0,11, nameW,nameH);
    self.arrowImage.frame = CGRectMake(CGRectGetMaxX(self.filterLabel.frame) + 4, 16, 8, 8);
    
    
    [[TMCache sharedCache] setObject:binddata.device.deviceId  forKey:@"deviceId"];
    [[TMCache sharedCache] setObject:binddata.device.deviceType.deviceTypeId  forKey:@"QdeviceTypeId"];
    [[TMCache sharedCache] setObject:binddata.device.deviceName  forKey:@"QdeviceName"];
    [[TMCache sharedCache] setObject:binddata.device.deviceStatus  forKey:@"HomedeviceStatus"];
     [[TMCache sharedCache] setObject:binddata.device.deviceType.deivceProgramId  forKey:@"QdeivceProgramId"];
    
    [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"storybox/%@/server/page", binddata.device.deviceId]  forKey:@"mKTopic"];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)binddata.device.deviceType.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    NSDictionary *jsonDict = @{@"name":binddata.device.deviceName , @"deviceIocn":encodedString ,@"deviceStatus":binddata.device.deviceStatus};
    
     [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HEauipment" object:self userInfo:jsonDict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QHomeRefresh" object:self userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryRefresh" object:self userInfo:nil];
    
    [self GetPlayingTrackId];
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"]){
        
    }
    else{
        
        if ([BPlayTestViewController sharedInstance].IsBPlaying) {
            [[BPlayTestViewController sharedInstance] testPasue];
            
        }
        
    }
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:nil];
    
//     [appDelegate AnimationPlay:nil];
    
//    [[AppDelegate appDelegate] NoDeviceAnimationPlay:nil];
    
    
    
}

- (void)GetPlayingTrackId
{
    NSLog(@"deviceId12345567====%@",[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:nil];
        return;
    }
    

    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
        //        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
    
            
            
            if (trackdata.tracks.count > 0) {
                QPlayingTrackList *listdata = trackdata.tracks[0];
                NSLog(@"QPlayingTrackList1111========================================================================%@",listdata.trackIcon);
                
                [[TMCache sharedCache]setObject:listdata.trackIcon forKey:@"currentTrackIcon"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:nil];
               
            }
            
       
      
        }
        
//        else{
//
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:nil];
//
//        }

   
        
        
        
    } failure:^(NSError *error) {

    }];
}




- (void)initMQTTkitBindarr:(NSArray *)bindarr
{
    
//    NSLog(@"MQTT绑定");
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    //
    NSString *iosclientID = [NSString stringWithFormat:@"IOS_%@_%@",clientID,[[TMCache sharedCache] objectForKey:@"userId"]];
    
    NSLog(@"iosclientID======%@",iosclientID);//=IOS_F13F01BF-4261-4EE4-AD0F-69765D2EC631_152024176157220556
    
    self.client = [[MQTTClient alloc] initWithClientId:iosclientID];
    
    [self.client connectToHost:kMQTTServerHost completionHandler:^(MQTTConnectionReturnCode code) {
        
        if (code == ConnectionAccepted)//连接成功
        {
            
            NSString  *strKTopic3 = [NSString stringWithFormat:@"storybox/%@/system/app",@"server"];
            NSString  *strKTopic4 = [NSString stringWithFormat:@"storybox/%@/server/user",[[TMCache sharedCache] objectForKey:@"userId"]];
            
            for (int i = 0; i < bindarr.count; i++) {
                
                BBTBindDataList *binddata = [bindarr objectAtIndex:i];
                
                for (int j = 0; j < binddata.familys.count; j++) {
                    
                    BBTBindFamily *family = [binddata.familys objectAtIndex:j];
                    
                    NSLog(@"family.familyId===%@",family.familyId);
                    
                    NSString  *strKTopic5 = [NSString stringWithFormat:@"storybox/%@/server/family",family.familyId];
                    
                    // 订阅
                    [self.client subscribe:strKTopic5 withCompletionHandler:^(NSArray *grantedQos) {
                        // The client is effectively subscribed to the topic when this completion handler is called
                        NSLog(@"subscribed to topic %@", strKTopic5);
                        NSLog(@"return:%@",grantedQos);
                    }];
                    
                }
                
                
                NSString  *strKTopic = [NSString stringWithFormat:@"storybox/%@/server/page", binddata.device.deviceId];
                NSString  *strKTopic1 = [NSString stringWithFormat:@"storybox/%@/server",binddata.device.deviceId];
                NSString  *strKTopic2 = [NSString stringWithFormat:@"storybox/%@/client",binddata.device.deviceId];
                
                
                
                //          NSString  *strKTopic2 = [NSString stringWithFormat:@"storybox/%@/client",binddata.familys];
                
                // 订阅
                [self.client subscribe:strKTopic withCompletionHandler:^(NSArray *grantedQos) {
                    // The client is effectively subscribed to the topic when this completion handler is called
                    NSLog(@"subscribed to topic %@", strKTopic);
                    NSLog(@"return:%@",grantedQos);
                }];
                
                // 订阅
                [self.client subscribe:strKTopic1 withCompletionHandler:^(NSArray *grantedQos) {
                    // The client is effectively subscribed to the topic when this completion handler is called
                    NSLog(@"subscribed to topic %@", strKTopic1);
                    NSLog(@"return:%@",grantedQos);
                }];
                
                // 订阅
                [self.client subscribe:strKTopic2 withCompletionHandler:^(NSArray *grantedQos) {
                    // The client is effectively subscribed to the topic when this completion handler is called
                    NSLog(@"subscribed to topic %@", strKTopic2);
                    NSLog(@"return:%@",grantedQos);
                }];
                
                
            }
            
            
            [self.client subscribe:strKTopic3 withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", strKTopic3);
                NSLog(@"return:%@",grantedQos);
            }];
            
            [self.client subscribe:strKTopic4 withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", strKTopic4);
                NSLog(@"return:%@",grantedQos);
            }];
            
            
            
            
            
            
        }
        
    }];
    
}



- (void)GetMessageBindarr:(NSArray *)bindarr
{
    //    __block NSString *messageString = @"";
    
    __block NewHomeViewController *self_c = self;
    
    //MQTTMessage  里面的数据接收到的是二进制，这里框架将其封装成了字符串
    [self.client setMessageHandler:^(MQTTMessage* message)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //接收到消息，更新界面时需要切换回主线程
             
             NSLog(@"yemian%@",message.payloadString);
             NSLog(@"1111topic%@",message.topic);
             
             NSString  *strKTopic3 = [NSString stringWithFormat:@"storybox/%@/system/app",@"server"];
             NSString  *strKTopic4 = [NSString stringWithFormat:@"storybox/%@/server/user",[[TMCache sharedCache] objectForKey:@"userId"]];
             
             
             if([message.topic isEqualToString:strKTopic3])
             {
                 
//                 if ([[[TMCache sharedCache] objectForKey:@"SystemSevenSwitch"]isEqualToString:@"OFF"]) {
//
//                     self_c.ifMessageCenterNotify =NO;
//
//                 }else{
//
//                     self_c.ifMessageCenterNotify =YES;
//                 }
//
                 
          
                 
             }else if([message.topic isEqualToString:strKTopic4])
             {
//                 if ([[[TMCache sharedCache] objectForKey:@"DeviceSevenSwitch"]isEqualToString:@"OFF"]) {
//
//                     self_c.ifMessageCenterNotify =NO;
//
//                 }else{
//
//                     self_c.ifMessageCenterNotify =YES;
//                 }
//
//
//                 [self_c.gangListTable reloadData];
             }
             
             
             
             for (int i = 0; i < bindarr.count; i++) {
                 
                 BBTBindDataList *binddata = [bindarr objectAtIndex:i];
                 
                 for (int j = 0; j < binddata.familys.count; j++) {
                     
                     BBTBindFamily *family = [binddata.familys objectAtIndex:j];
                     
                     NSString  *strKTopic = [NSString stringWithFormat:@"storybox/%@/server/family",family.familyId];
                     
                     
                     NSLog(@"strKTopicfamliy===%@",strKTopic);
                     
                     if([message.topic isEqualToString:strKTopic])
                     {
                         
                         NSLog(@"设备来通知");
                         
                         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                         
                         NSLog(@"微聊的＝＝＝＝%@",jsonDict);
                         
                         QPlayingTrack *respone = [QPlayingTrack mj_objectWithKeyValues:jsonDict];
                         
                         
                         if ([respone.statusCode isEqualToString:@"0"]) {
                             
                             QPlayingTrackData *trackdata = respone.data;
                             
                             NSLog(@"新家的1122222222＝＝＝＝%@",jsonDict);

                             if ([trackdata.deviceId isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceId"]]) {
                                 
                                 NSLog(@"dangqiangppp");
                                 
                                 if (trackdata.tracks.count == 0)
                                 {
                                     
                                     NSLog(@"播放本地歌曲");
                                     
                                     NSDictionary *bendiJsonDict = @{@"trackListId": @"1",@"trackId":@"local",@"type":@"101"};
                                     
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayNext" object:self_c userInfo:bendiJsonDict];
                                     
                                     
                                     [[TMCache sharedCache] setObject:@"Islocal" forKey:[NSString stringWithFormat:@"Iflocal-%@", trackdata.deviceId]];
                                     
                                     NSLog(@"localhome======%@ deviceId=====%@",[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]],[[TMCache sharedCache] objectForKey:@"deviceId"]);
                                     
                                 }else{
                                     
                                     [[TMCache sharedCache] setObject:@"IsOnline" forKey:[NSString stringWithFormat:@"Iflocal-%@", trackdata.deviceId]];

                                     NSString *deivceProgramId = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
                                     if([deivceProgramId isEqualToString:@"5"]||[deivceProgramId isEqualToString:@"6"]||[deivceProgramId isEqualToString:@"8"]||[deivceProgramId isEqualToString:@"9"]||[deivceProgramId isEqualToString:@"10"]||[deivceProgramId isEqualToString:@"11"])
                                     {


                                         NSDictionary *onlineJsonDict = @{@"trackListId": trackdata.listId,@"trackId":trackdata.trackId,@"type":trackdata.playType.value};
                                         
                                         NSLog(@"ssssddddddonlineJsonDict====%@",onlineJsonDict);

                                         NSString *strType = [NSString stringWithFormat:@"%@",[onlineJsonDict objectForKey:@"type"]];



                                         if ( [strType isEqualToString:@"0"]||[strType isEqualToString:@"1"] ||[strType isEqualToString:@"2"] || [strType isEqualToString:@"3"] || [strType isEqualToString:@"4"] || [strType isEqualToString:@"5"] || [strType isEqualToString:@"6"] || [strType isEqualToString:@"7"] || [strType isEqualToString:@"8"] || [strType isEqualToString:@"9"]   ) {

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandAlbum" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandHistory" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayNext" object:self_c userInfo:onlineJsonDict];


                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"QFavorite" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"QSongList" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandCategory" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"GYZSheet" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"QSearch" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchDemandAlbum" object:self_c userInfo:onlineJsonDict];

                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayDemandAlbum" object:self_c userInfo:onlineJsonDict];


                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"AppHomePlay" object:self_c userInfo:onlineJsonDict];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"AppSongPlay" object:self_c userInfo:onlineJsonDict];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"AppCategoryPlay" object:self_c userInfo:onlineJsonDict];




                                         }

                                         
                                     }
                                 }
                             
                                 
                             }else
                             {
                                 
                                 NSLog(@"dangqiangppp");
                                 
                                 if (trackdata.tracks.count == 0)
                                 {
                                     
                                     NSLog(@"播放本地歌曲");
                                     
                                     [[TMCache sharedCache] setObject:@"Islocal" forKey:[NSString stringWithFormat:@"Iflocal-%@", trackdata.deviceId]];
                                     
                                     NSLog(@"localhome======%@ deviceId=====%@",[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]],[[TMCache sharedCache] objectForKey:@"deviceId"]);
                                     
                                 }else{
                                     
                                     [[TMCache sharedCache] setObject:@"IsOnline" forKey:[NSString stringWithFormat:@"Iflocal-%@", trackdata.deviceId ]];
                                 }
                                 
                             }
                             
                             
                         }
                         
                         
                         NSString *createTime = [jsonDict objectForKey:@"createTime"];
                         
                         if (createTime.length != 0) {
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"QChatPlay" object:self_c userInfo:jsonDict];
                         }
                         
//                         if ([[[TMCache sharedCache] objectForKey:@"FamilySevenSwitch"]isEqualToString:@"OFF"]) {
//
//                             self_c.ifMessageCenterNotify =NO;
//
//                         }else{
//
//                             self_c.ifMessageCenterNotify =YES;
//                         }
//
//
//                         [self_c.gangListTable reloadData];
                         
                     }
                     
                 }
                 
                 NSString  *strKTopic = [NSString stringWithFormat:@"storybox/%@/client", binddata.device.deviceId];
                 
                 if([message.topic isEqualToString:strKTopic])
                 {
                     NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                     
                     NSLog(@"jsonDictallllllsdfdfdsfdnn====%@",jsonDict);
                     
                     id bodyDic = [jsonDict objectForKey:@"body"];
                     NSLog(@"jsonDictallllllbodyDic===%@",bodyDic);
                     
                     NSString *onlineStatusStr = @"";
                     
                     if ([bodyDic isKindOfClass:[NSString class]])
                     {
                         
                         onlineStatusStr = @"";
                         
                     }
                     else if([bodyDic isKindOfClass:[NSDictionary class]])
                     {
                         onlineStatusStr = [bodyDic objectForKey:@"onlineStatus"];
                     }
                     
                     
                     
                     
                     NSString *onlineStatus = [jsonDict objectForKey:@"onlineStatus"];
                     
                     if ([onlineStatusStr isEqualToString:@"off"]|| [onlineStatusStr isEqualToString:@"abnormal"]||[onlineStatus isEqualToString:@"off"]|| [onlineStatus isEqualToString:@"abnormal"]) {
                         
                         [[TMCache sharedCache] setObject:binddata.device.deviceName forKey:@"onlinedeviceName"];
                         
                         if ( [binddata.device.deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]] ) {
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"PYSearchOn" object:self_c userInfo:jsonDict];
                             
                         }
                         
                         
                         [self_c getRBindDeviceList];
                         
                         //                        [self_c performSelector:@selector(getRBindDeviceList) withObject:nil afterDelay:1.0];//因设备与服务器的状态不同步，下线故延迟1秒刷新
                     }
                     else if([onlineStatus isEqualToString:@"on"]) {
                         
                         [self_c performSelector:@selector(getRBindDeviceList) withObject:nil afterDelay:2.0];//因设备与服务器的状态不同步，上线故延迟两秒刷新
                         
                     }
                 }
             }
             
             
             
             NSString  *strKTopic = [NSString stringWithFormat:@"storybox/%@/client", [[TMCache sharedCache] objectForKey:@"deviceId"]];
             
             if([message.topic isEqualToString:strKTopic])
             {
                 NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                 
                 NSLog(@"strKTopic========%@  jsonDict3411111======%@",strKTopic,jsonDict);
                 
                 NSDictionary *boxInfo = [[NSDictionary alloc] init];
                 
                 boxInfo = [jsonDict objectForKey:@"boxInfo"];
                 
                 NSString *electricity = [NSString stringWithFormat:@"%@",[boxInfo objectForKey:@"electricity"]];
                 
                 NSLog(@"electricity123433545=====%@",electricity);
                 NSLog(@"electricity.length=====%lu",(unsigned long)electricity.length);
                 if (![electricity isEqualToString:@"(null)"]) {
                     
                     NSLog(@"electricitybuweikong=====%@",electricity);
                     if([electricity rangeOfString:@"-"].location !=NSNotFound)//_roaldSearchText
                     {
                         
                         NSString *strName = [[TMCache sharedCache] objectForKey:@"deviceName"];
                         
                         NSLog(@"strName123433546656=%@",strName);
                         NSLog(@"strNameLength=%lu",(unsigned long)strName.length);
     
                         
                         [[TMCache sharedCache] setObject:@"0" forKey:@"DeviceElectricity"];
                         
                     }
                     else
                     {

                         [[TMCache sharedCache] setObject:@"1" forKey:@"DeviceElectricity"];
                     }
                     
                     
                     
                 }
                 
                 
                 
                    NSLog(@"sssssssjsonDict=========%@",jsonDict);
                 
                 NSString *strType = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"type"]];
                 
                 NSString *playStaus = [jsonDict objectForKey:@"playStatus"];
                 
              
                 
                 NSString *strMode = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"mode"]];
                 
                 if(strMode.length !=0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GYZActionSheetMode" object:self_c userInfo:jsonDict];
                 }
                 
                 NSLog(@"playStaus1111111111122222===%@",playStaus);
                 
                 if (playStaus.length != 0) {
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayStaus" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandHistoryPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandAlbumPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QFavoritePlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QSongListPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandCategoryPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GYZSheetPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QSearchPlay" object:self_c userInfo:jsonDict];
                     
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchDemandAlbumPlay" object:self_c userInfo:jsonDict];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayDemandAlbumPlay" object:self_c userInfo:jsonDict];
                     
                     
                 }
                 

                 if ( [strType isEqualToString:@"0"]||[strType isEqualToString:@"1"] ||[strType isEqualToString:@"2"] || [strType isEqualToString:@"3"] || [strType isEqualToString:@"4"] || [strType isEqualToString:@"5"] || [strType isEqualToString:@"6"] || [strType isEqualToString:@"7"] || [strType isEqualToString:@"8"]|| [strType isEqualToString:@"9"] ||strType.length ==0 ) {

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandAlbum" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandHistory" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayNext" object:self_c userInfo:jsonDict];


                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QFavorite" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QSongList" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandCategory" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GYZSheet" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QSearch" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchDemandAlbum" object:self_c userInfo:jsonDict];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayDemandAlbum" object:self_c userInfo:jsonDict];


                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AppHomePlay" object:self_c userInfo:jsonDict];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AppSongPlay" object:self_c userInfo:jsonDict];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AppCategoryPlay" object:self_c userInfo:jsonDict];




                 }


                 

                 
                 
                 
             }
             
             
             
         });
     }];
    
    
    
}

- (void)SendMessagemKTopic:(NSString *)mktopic Message:(NSDictionary *)message
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [self.client publishData:data toTopic:mktopic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
        NSLog(@"message has been delivered");
    }];
    
}

- (void)disconnectWithmKTopic
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        
    }];
    
}

- (void)KickedOutDeviceStaues
{

    [[AppDelegate appDelegate]suspendButtonEnabled:NO];//设备掉线禁止浮动按钮点击
    
    UIViewController *viewVc = [self getCurrentVC];
    
    NSString *str = [NSString stringWithFormat:@"你已被管理员踢出群聊"];
    NSLog(@"str=======%@", str);
    
    BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:str andWithTag:1 andWithButtonTitle:@"确定"];
    
    [QalertView showInView:viewVc.view];
    
    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            [[AppDelegate appDelegate]suspendButtonEnabled:YES];//点击确定后重新可以点击
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        
    };
    
    
    UIViewController *viewPresentVc = [self getPresentedViewController];
    
    if (viewPresentVc != nil) {
        
        [viewPresentVc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    }
    
    
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        
    }
    
    //    else if(topVC.presentingViewController)
    //    {
    //        topVC = topVC.presentingViewController;
    //    }
    
    return topVC;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");

}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    //       [self.navigationController setNavigationBarHidden:NO animated:YES];
    
     [self.menuDView backgroundTapped];
    
//    [self resetSideBack];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
