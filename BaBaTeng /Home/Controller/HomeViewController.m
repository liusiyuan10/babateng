 //
//  HomeViewController.m
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomRootViewController.h"
#import "FYtopbannerViewCell.h"
#import "Header.h"
#import "MJRefresh.h"
#import "MyButton.h"
#import "EquipmentCell.h"

#import "HelpViewController.h"
#import "BBTMessageCenterViewController.h"
#import "BBTPersonalCenterViewController.h"
#import "AddEquipmentViewController.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTBind.h"
#import "BBTBindDataList.h"
#import "BBTBindData.h"

#import "MQTTKit.h"

#import "BBTQAlertView.h"

#import "BBTMainTool.h"
#import "Bulletin.h"

#import "BBTEquipmentRespone.h"
#import "BulletinViewController.h"
#import "BulletinData.h"

#import "BBTBindDeviceDataList.h"
#import "BBTBindFamily.h"
#import "UIImageView+AFNetworking.h"

#import "MusicPlayerView.h"
#import "QDevice.h"
#import "IBAlertView.h"
#import <StoreKit/StoreKit.h>

#import "HelpAndFeedBackEquipmentViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,FYtopbannerViewCellDelegate,SKStoreProductViewControllerDelegate>{
    
}

@property (nonatomic,strong)  UITableView   *gangListTable;

@property (nonatomic, strong) FYtopbannerViewCell *topCell;

@property(strong,nonatomic)  NSMutableArray *ADImageArray;

@property (nonatomic, strong) NSMutableArray *devicearr;

@property (nonatomic, strong) MQTTClient *client;

@property (nonatomic, strong) NSString *mKTopic;

@property (nonatomic, strong) NSString *mKTopic1;

@property (nonatomic, strong) NSString *mKTopic2;

@property (nonatomic, assign) BOOL ifMessageCenterNotify;//判断消息中心是否来通知

@property(nonatomic,strong) MusicPlayerView *playerView;

@end

@implementation HomeViewController

static HomeViewController *homeViewController;

+(HomeViewController *)getInstance{
    
    return homeViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    homeViewController = self;
    
    self.title = @"我的设备";
    self.navigationItem.leftBarButtonItem = nil;
    self.devicearr = [[NSMutableArray alloc] init];
    self.ADImageArray = [[NSMutableArray alloc] init];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    

    if ([[[TMCache sharedCache] objectForKey:@"HomeViewNewMessage"]isEqualToString:@"YES"]) {
        
        self.ifMessageCenterNotify  = YES;
        
        
    }else{
        
        
        self.ifMessageCenterNotify =NO;
    }
    
    [[TMCache sharedCache] removeObjectForKey:@"APP_MQTT_ENTRY"];
    
    [self loadHomeList];
    
    
    [[TMCache sharedCache] removeObjectForKey:@"deviceName"];
    
//    [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];
    
//    [[TMCache sharedCache] removeObjectForKey:@"deviceId"];
    
//    [self GetBulletinList];
    
//    [self getBindDeviceList];
    
//    [self GetMessage];
    
    // Do any additional setup after loading the view.
    

   // [self checkAppVersionAgain];
    
}

- (void)AnimationPlay:(NSNotification *)noti{

    [appDelegate AnimationPlay:noti];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkAppVersionAgain{
    
    [BBTEquipmentRequestTool checkAppVersionupload:^(QDevice *respone) {
        
                    
        IBConfigration *configration = [[IBConfigration alloc] init];
        configration.title = @"检测到新版本";
        configration.message = [NSString stringWithFormat:@"%@",respone.data.versionDescription];
        configration.cancelTitle = @"取消";
        configration.confirmTitle = @"开始升级";
        configration.tintColor = [UIColor whiteColor];
        configration.messageAlignment = NSTextAlignmentLeft;
        
        IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index) {
            if (index == 2) {
                NSLog(@"点击确定了");
                [self showToastWithString:@"正在跳转界面,请稍后..."];
                SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
                //设置代理请求为当前控制器本身
                storeProductViewContorller.delegate = self;
                //加载一个新的视图展示
                [storeProductViewContorller loadProductWithParameters:
                 //appId唯一的
                 @{SKStoreProductParameterITunesItemIdentifier : @"1152456714"} completionBlock:^(BOOL result, NSError *error) {
                     //block回调
                     if(error){
                         
                         NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
                     }else{
                         //模态弹出appstore
                         [self presentViewController:storeProductViewContorller animated:YES completion:^{
                             
                         }
                          
                          ];
                     }
                 }];
             
            }
        }];
        [alerView show];
        
                    
        
                
     
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)GetBulletinList
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    [BBTEquipmentRequestTool GetBulletinDeviceTypeId:@"0" Parameter:parameter success:^(Bulletin *response) {
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ADImageArray = response.data;
            
            NSLog(@"self.ADImageArray%@",self.ADImageArray);
            
            [self.gangListTable reloadData];
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)getRBindDeviceList
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@5};
    
    [self startLoading];
    [BBTEquipmentRequestTool getBinddevice:parameter success:^(BBTBind *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicearr = respone.data.list;
            
            if (self.devicearr.count>0) {
                
                [[TMCache sharedCache]setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count] forKey:@"bindDeviceNumber"];
            }else{
                
                
                [[TMCache sharedCache]setObject:@"0" forKey:@"bindDeviceNumber"];
            }
           
            
            if(self.devicearr.count > 0)
            {
            NSLog(@"刷新jiem");
                
             
                
                
            [self.gangListTable reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

- (void)getBindDeviceList
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@5};
    
    [self startLoading];
    [BBTEquipmentRequestTool getBinddevice:parameter success:^(BBTBind *respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.devicearr = respone.data.list;
            
            if (self.devicearr.count>0) {
                
                [[TMCache sharedCache]setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.devicearr.count] forKey:@"bindDeviceNumber"];
            }else{
            
                
                [[TMCache sharedCache]setObject:@"0" forKey:@"bindDeviceNumber"];
            }
           

            
            
            if(self.devicearr.count >= 0)
            {

             
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

                
                //初始化数据的时候把重复弹出框的判断条件清空
                [[TMCache sharedCache]removeObjectForKey:@"IsCharging"];//清空充电弹出框判断条件
                for (int i=0; i<self.devicearr.count; i++) {
                    
                    BBTBindDataList *binddata = [self.devicearr objectAtIndex:i];
                    
                    [[TMCache sharedCache] removeObjectForKey:[NSString stringWithFormat:@"%@",binddata.device.deviceId]];
                }

            }
            
            [self.gangListTable reloadData];
        }
        
//        }else if([respone.statusCode isEqualToString:@"101"]){
//
//            BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示"  andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"取消",@"确定", nil];
//            
//            
//            [QalertView showInView:self.view];
//
//            //点击按钮回调方法
//            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//                if (titleBtnTag == 1) {
//                    
//                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
//                }
//                if (titleBtnTag == 0) {
//                    
//                    
//                    NSLog(@"sg");
//                    
//                    [self exitApplication];
//                            
////                    [[CustomRootViewController getInstance] comeback];
//                    
//                }
//            };
//         
//        }
        else
        {
            
             [self showToastWithString:respone.message];
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

- (void)loadHomeList
{
    self.gangListTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, KDeviceHeight+30)];
    self.gangListTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.gangListTable.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.gangListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.gangListTable setSeparatorColor:[UIColor clearColor]];
    [self.gangListTable setShowsVerticalScrollIndicator:NO];
    self.gangListTable.dataSource = self;
    self.gangListTable.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.gangListTable];
    self.navigationController.navigationBar.translucent = NO;
//    self.ADImageArray = [NSMutableArray arrayWithObjects:@"http://img.mp.itc.cn/upload/20160501/66b685aa2e0342a9903ec8f0207235b1_th.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847201131&di=5512240f5cb81c6f45830c064e605003&imgtype=0&src=http%3A%2F%2Frs.xpw888.com%2Frs%2Fprodesc%2Fimgs%2Fimage%2F20160503%2F20160503170153_729.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847201124&di=602e1b57e6d1eb7e6b49cfef13d03372&imgtype=0&src=http%3A%2F%2Fp1.img.cctvpic.com%2Fphotoworkspace%2Fcontentimg%2F2016%2F04%2F08%2F2016040814350285433.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494847354488&di=63da147878a452e68fa51ad3d039f9ac&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160525%2Fa6b48f99ce044e5c959f67bd71e67077_th.jpg", nil];
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.gangListTable respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.gangListTable;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
    [self example01];
    
    [self example11];
    
    [self setNavigationItem];
    
    
}


#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.gangListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.gangListTable.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
    [self getBindDeviceList];
    [self GetBulletinList];
    [self.gangListTable.mj_header endRefreshing];
    
    
}

#pragma mark UITableView + 上拉刷新 默认
- (void)example11
{
    self.gangListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.gangListTable.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.gangListTable.mj_footer.ignoredScrollViewContentInsetBottom =0;
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    [self.gangListTable.mj_footer endRefreshing];
}



#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    //    [rightbutton setImage:[UIImage imageNamed:@"nav_tianjiashebei"] forState:UIControlStateNormal];
    //    [rightbutton setImage:[UIImage imageNamed:@"nav_tianjiashebei_pre"] forState:UIControlStateSelected];
    [rightbutton setTitle:@"添加" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(AddEquipment) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}


-(void)AddEquipment{
    
    AddEquipmentViewController  * addViewControlle = [[AddEquipmentViewController alloc]init];
    addViewControlle.title = @"添加设备";
    
    [self.navigationController pushViewController:addViewControlle animated:YES];
    
    
    
}

#pragma mark --首页按钮菜单容器

-(UIView*)buttonListContainer{
    
    CGFloat myHeight;
    
    //适配iphone x
    if (iPhoneX) {
        myHeight =75;
        
    }else{
        
        myHeight =85;
        
    }
    
    
    /***
     首页按钮菜单容器
     */
    
    //    NSArray *titleNameArray = [NSArray arrayWithObjects:@"添加设备",@"使用帮助",@"消息中心",nil];
    NSArray *imageNorArray = [NSArray arrayWithObjects:@"sybz_nor",@"xxzx_nor",@"grzx_nor", nil];
    NSArray *imagePreArray = [NSArray arrayWithObjects:@"sybz_pre",@"xxzx_pre",@"grzx_pre", nil];
    
    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,myHeight/568.0*KDeviceHeight)];
    containView.backgroundColor = [UIColor whiteColor];
    
    CGRect buttonListContainerRect=CGRectMake(0,0, self.view.frame.size.width,myHeight/568.0*KDeviceHeight);
    UIView *buttonListContainer = [[UIView alloc]initWithFrame:buttonListContainerRect];
    buttonListContainer.backgroundColor =[UIColor clearColor];
    [containView addSubview:buttonListContainer];
    
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, (self.view.frame.size.width-32)/3,(myHeight-20)/568.0*KDeviceHeight)];
    newImageView.backgroundColor =[UIColor clearColor];;
    
    newImageView.image = [UIImage imageNamed:@"new-2"];
    
    
    if ([[[TMCache sharedCache] objectForKey:@"systemMessage"]isEqualToString:@"NO"]&&[[[TMCache sharedCache] objectForKey:@"devicMessage"]isEqualToString:@"NO"]&&[[[TMCache sharedCache] objectForKey:@"familyMessage"]isEqualToString:@"NO"]) {
        
        self.ifMessageCenterNotify = NO;
        
        //为了不干扰下一次新消息的显示 使用一后晴空
        [[TMCache sharedCache]removeObjectForKey:@"systemMessage"];
        [[TMCache sharedCache]removeObjectForKey:@"devicMessage"];
        [[TMCache sharedCache]removeObjectForKey:@"familyMessage"];
    } else if ([[[TMCache sharedCache] objectForKey:@"systemMessage"]isEqualToString:@"YES"]||[[[TMCache sharedCache] objectForKey:@"devicMessage"]isEqualToString:@"YES"]||[[[TMCache sharedCache] objectForKey:@"familyMessage"]isEqualToString:@"YES"]){
        
        
        self.ifMessageCenterNotify = YES;
        
        //为了不干扰下一次新消息的显示 使用一后晴空
        [[TMCache sharedCache]removeObjectForKey:@"systemMessage"];
        [[TMCache sharedCache]removeObjectForKey:@"devicMessage"];
        [[TMCache sharedCache]removeObjectForKey:@"familyMessage"];
        
    }

    
  
    
    for(int i=0;i<imageNorArray.count;i++)
    {
        
        
        CGRect rect = CGRectMake((((self.view.frame.size.width-32)/3)+8)*(i%3)+8, 10, (self.view.frame.size.width-32)/3,(myHeight-20)/568.0*KDeviceHeight);
        
        MyButton*btn = [[MyButton buttonWithType:UIButtonTypeCustom]initWithimage:imageNorArray[i] heighlightImage:imagePreArray[i] frame:rect];
        [btn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [buttonListContainer addSubview:btn];
        
        if (i==1) {
            
            if (self.ifMessageCenterNotify) {
                
                [btn addSubview:newImageView];
                
                [[TMCache sharedCache]setObject: @"YES" forKey:@"HomeViewNewMessage"];
            }else{
            
                [[TMCache sharedCache]setObject: @"NO" forKey:@"HomeViewNewMessage"];
            }
           
        }
        
        
    }
    
    return containView;
    
}

-(void)detailBtnClick:(id)sender{
    
    
    UIButton *btn = (UIButton*)sender;
    
    NSLog(@"%ld",(long)btn.tag);
    
    if (btn.tag==0) {
        
        
        HelpAndFeedBackEquipmentViewController *helpVc = [[HelpAndFeedBackEquipmentViewController alloc] init];
        helpVc.JumpType = @"helpVc";
        helpVc.title = @"使用帮助";
        [self.navigationController pushViewController:helpVc animated:YES];
        
        
    }else if (btn.tag==1){
        
        [self.navigationController pushViewController:[BBTMessageCenterViewController new] animated:YES];
    }else if (btn.tag==2){
        
        [self.navigationController pushViewController:[BBTPersonalCenterViewController new] animated:YES];
    }
    else if (btn.tag==3){
        
        //  [self.navigationController pushViewController:[MineViewController new] animated:YES];
    }
    
    
    
}

-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index{
    
    NSLog(@"index===%ld",(long)index);
    
    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:index];
    
    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
 
    NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    bulletinVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:bulletinVc animated:YES];
    
    
}

#pragma mark --UITableView 代理函数


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, tableView.frame.size.width, 30)];
        label.font = [UIFont systemFontOfSize:16.0f];  //UILabel的字体大小
        label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = @"设备";
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:label];
        return  headerView;
        
    }else{
        
        
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==2) {
        
        return 40;
        
    }else if (section==1){
        
        return 20;
        
    }else{
        
        return 0;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==2) {
        
        if (self.devicearr.count == 0) {
            return  1;
        }
        else
            return self.devicearr.count;
        
        
    }else {
        
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        static NSString *cellIndentifier = @"celltop";
        
        self.topCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        self.topCell = [[FYtopbannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array: self.ADImageArray];
        
        self.topCell.delegate = self;
        
        return self.topCell;
        
        
    }else if (indexPath.section==1){
        
        static NSString *cellIndentifierOne = @"cellOne";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        
        cell.selectionStyle
        = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.buttonListContainer];
        
        return cell;
        
    }else if (indexPath.section==2){
        
        static NSString *cellIndentifierTwo= @"cellTwo";
        
        EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierTwo];
        
        if (cell==nil) {
            
            cell = [[EquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierTwo];
            
       
        }
        
        cell.topImageView.hidden = YES;
    
        if (self.devicearr.count == 0) {
            
            cell.normalCellBG.image = [UIImage imageNamed:@"list_nosb_nor"];
            
            cell.selecetedCellBG.image = [UIImage imageNamed:@"list_nosb_pre"];
            
     
            
            cell.leftImage.hidden = YES;
//            cell.onlineLabel.hidden = YES;
            cell.nameLabel.hidden = YES;
            
            
        }
        else
        {
            BBTBindDataList *binddata = [self.devicearr objectAtIndex:indexPath.row];
            
            cell.leftImage.hidden = NO;
//            cell.onlineLabel.hidden = YES;
            cell.nameLabel.hidden = NO;
//            cell.nameLabel.frame =CGRectMake(CGRectGetMaxX(cell.leftImage.frame) + 15, 15, 200, 40/568.0*KDeviceHeight);
            

            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)binddata.device.deviceType.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

            [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SB_01"]];

            cell.nameLabel.text =binddata.device.deviceName; //binddata.device.deviceType.deviceTypeName;
            
            if ([binddata.device.deviceStatus isEqualToString:@"0"]) {
                
                cell.normalCellBG.image = [UIImage imageNamed:@"list_lxd_nor"];
                
                cell.selecetedCellBG.image = [UIImage imageNamed:@"list_lx_pre"];
                
            }else
            {
                cell.normalCellBG.image = [UIImage imageNamed:@"list_zx_nor"];
                
                cell.selecetedCellBG.image = [UIImage imageNamed:@"list_zx_pre"];
            }
            
            
        }
 
        return cell;
    }
    
    return [UITableViewCell new];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        return 150/568.0*[[UIScreen mainScreen] bounds].size.height;
        
    }else if (indexPath.section==1){
        //适配iphone x
        
        if (iPhoneX) {
            
            return 75/568.0*KDeviceHeight;
            
        }else{
            
            return 85/568.0*KDeviceHeight;
            
        }
        
        
    }else if (indexPath.section==2){
        //适配iphone x
        if (iPhoneX) {
            return 80/568.0*KDeviceHeight;
            
        }else{
            
            return 90/568.0*KDeviceHeight;
            
        }
        
        
    }
    return 0;
    
}

/**
 *用户点击
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
  if (indexPath.section==2) {

    if (self.devicearr.count == 0) {
        
        AddEquipmentViewController  * addViewControlle = [[AddEquipmentViewController alloc]init];
        
        addViewControlle.title = @"添加设备";
        
        [self.navigationController pushViewController:addViewControlle animated:YES];
        
    }
    else
    {
        BBTBindDataList *binddata = [self.devicearr objectAtIndex:indexPath.row];
        
        [[TMCache sharedCache] setObject:binddata.device.deviceId  forKey:@"deviceId"];
        [[TMCache sharedCache] setObject:binddata.device.deviceType.deviceTypeId  forKey:@"QdeviceTypeId"];
        [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"storybox/%@/server/page", binddata.device.deviceId]  forKey:@"mKTopic"];

        if ([binddata.device.deviceStatus isEqualToString:@"1"]) {
            
            if([binddata.device.boxinfo.electricity rangeOfString:@"-"].location !=NSNotFound)
            {
                
                BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"设备充电中不能使用!" andWithTag:1 andWithButtonTitle:@"确定"];
                
                [QalertView showInView:self.view];
                
                //点击按钮回调方法
                QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                    if (titleBtnTag == 1) {
                        
                      
                    }
                    
                };
                
            }
            else
            {
            
                [[TMCache sharedCache] setObject:binddata.device.deviceName forKey:@"deviceName"];
//              [[TMCache sharedCache] setObject:binddata.device.deviceId forKey:@"deviceID"];
                CustomRootViewController *customController = [[CustomRootViewController alloc]init];
                
                [self.navigationController pushViewController:customController animated:YES];
                
            }
            
        }else
        {
            
            BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"设备已掉线!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            [QalertView showInView:self.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                
                }

            };
        }

    }
    
      
  }
    
    
}


//让tableView可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2) {
        
        
        if (self.devicearr.count == 0) {
            
            return NO;
        }
        else
        {
            return YES;
            
        }

    }else{
    
       return NO;
    }
    
}



/**
 *  只要实现了这个方法，左滑出现Delete按钮的功能就有了
 *  点击了“左滑出现的Delete按钮”会调用这个方法
 */
//IOS9前自定义左滑多个按钮需实现此方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2) {
    
        
        
        // 删除模型
        //    [self.wineArray removeObjectAtIndex:indexPath.row];
        BBTBindDataList *binddata = [self.devicearr objectAtIndex:indexPath.row];
        
        [self startLoading];
        [BBTEquipmentRequestTool getDeletebinddevice:[[TMCache sharedCache] objectForKey:@"userId"] deviceId:binddata.device.deviceId success:^(BBTEquipmentRespone *respone) {
            [self stopLoading];
            if ([respone.statusCode isEqualToString:@"0"]) {
                
                [self.devicearr removeObjectAtIndex:indexPath.row];
                [self.gangListTable reloadData];
                
            }else{
                
                [self showToastWithString:respone.message];
            }
            
        } failure:^(NSError *error) {
             [self stopLoading];
             [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
            
        }];
        
        NSLog(@"我是sf");
        // 刷新
        //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        
    }
    
    
    
    
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    [self getBindDeviceList];
    [self GetBulletinList];
    

    
    [[TMCache sharedCache] removeObjectForKey:@"deviceName"];
//    [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];
//    [[TMCache sharedCache] removeObjectForKey:@"deviceId"];

    [[TMCache sharedCache]setObject:@"ON" forKey:@"switchgear"];//这里还原设备为开机状态，为了控制设备控制界面开关机按钮的状态。
    
    
     // [self.playerView removeObserver];//注销观察者
    
        [[AppDelegate appDelegate]suspendButtonEnabled:YES];//进入首页恢复点击
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [[AppDelegate appDelegate]suspendButtonEnabled:YES];//离开首页恢复点击
}

- (void)initMQTTkitBindarr:(NSArray *)bindarr
{
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
//
    NSString *iosclientID = [NSString stringWithFormat:@"IOS_%@_%@",clientID,[[TMCache sharedCache] objectForKey:@"userId"]];
    
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
    
    __block HomeViewController *self_c = self;
    
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
                 
                 if ([[[TMCache sharedCache] objectForKey:@"SystemSevenSwitch"]isEqualToString:@"OFF"]) {
                     
                     self_c.ifMessageCenterNotify =NO;
                     
                 }else{
                     
                     self_c.ifMessageCenterNotify =YES;
                 }

                 
                 [self_c.gangListTable reloadData];
                 
             }else if([message.topic isEqualToString:strKTopic4])
             {
                 if ([[[TMCache sharedCache] objectForKey:@"DeviceSevenSwitch"]isEqualToString:@"OFF"]) {
                     
                     self_c.ifMessageCenterNotify =NO;
                     
                 }else{
                     
                     self_c.ifMessageCenterNotify =YES;
                 }

                 
                 [self_c.gangListTable reloadData];
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
                         

                         
                         NSString *statusCodestr = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"statusCode"]];
                         
                         if ([statusCodestr isEqualToString:@"0"]) {
                             
                             NSLog(@"新家的＝＝＝＝%@",jsonDict);
                             
                             NSDictionary *dataDic = [jsonDict objectForKey:@"data"];
                             
                             NSArray *tracksArr = [dataDic objectForKey:@"tracks"];
                             
                             NSString *strDeviceId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"deviceId"]];
                             
                             //
                             
                             if ([strDeviceId isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceId"]]) {
                             
                                 NSLog(@"dangqiangppp");
                             
                                 if (tracksArr.count == 0)
                                 {
                                     
                                     NSLog(@"播放本地歌曲");
                                     
                                     NSDictionary *bendiJsonDict = @{@"trackListId": @"1",@"trackId":@"local",@"type":@"101"};
                                     
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayNext" object:self_c userInfo:bendiJsonDict];
                                     
                                     
                                     [[TMCache sharedCache] setObject:@"Islocal" forKey:[NSString stringWithFormat:@"Iflocal-%@", strDeviceId]];
                                     
                                      NSLog(@"localhome======%@ deviceId=====%@",[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]],[[TMCache sharedCache] objectForKey:@"deviceId"]);
                                     
                                 }else{
                                     
                                     [[TMCache sharedCache] setObject:@"IsOnline" forKey:[NSString stringWithFormat:@"Iflocal-%@", strDeviceId]];
                                 }
                                 
                             }else
                             {
                                 
                                 NSLog(@"dangqiangppp");
                                 
                                 if (tracksArr.count == 0)
                                 {
                                     
                                     NSLog(@"播放本地歌曲");
     
                                     [[TMCache sharedCache] setObject:@"Islocal" forKey:[NSString stringWithFormat:@"Iflocal-%@", strDeviceId]];
                                     
                                     NSLog(@"localhome======%@ deviceId=====%@",[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"Iflocal-%@", [[TMCache sharedCache] objectForKey:@"deviceId"]]],[[TMCache sharedCache] objectForKey:@"deviceId"]);
                                     
                                 }else{
                                     
                                     [[TMCache sharedCache] setObject:@"IsOnline" forKey:[NSString stringWithFormat:@"Iflocal-%@", strDeviceId]];
                                 }
                                 
                             }
                             
          
                }
                             
                             
                        NSString *createTime = [jsonDict objectForKey:@"createTime"];
                         
                         if (createTime.length != 0) {
                             
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"QChatPlay" object:self_c userInfo:jsonDict];
                         }
                         
                         if ([[[TMCache sharedCache] objectForKey:@"FamilySevenSwitch"]isEqualToString:@"OFF"]) {
                             
                             self_c.ifMessageCenterNotify =NO;
                             
                         }else{
                             
                             self_c.ifMessageCenterNotify =YES;
                         }

                         
                         [self_c.gangListTable reloadData];
                         
                     }
                     
                 }
                 
                NSString  *strKTopic = [NSString stringWithFormat:@"storybox/%@/client", binddata.device.deviceId];
                 
                 if([message.topic isEqualToString:strKTopic])
                 {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                    
                     NSLog(@"jsonDictallllllsdfdfdsfd====%@",jsonDict);

                     
                     NSString *onlineStatus = [jsonDict objectForKey:@"onlineStatus"];
                     
                     if ([onlineStatus isEqualToString:@"off"]|| [onlineStatus isEqualToString:@"abnormal"]) {
                         
                          [[TMCache sharedCache] setObject:binddata.device.deviceName forKey:@"onlinedeviceName"];
                         
                        if ( [binddata.device.deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]] ) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"PYSearchOn" object:self_c userInfo:jsonDict];
                        
                        }

                         
            
                          [self_c IsOnlineStatusDeviceName:binddata.device.deviceName DeviceId:binddata.device.deviceId];
                         
//                        [self_c performSelector:@selector(DelayOnlineStatusDeviceName) withObject:nil afterDelay:0.3];
                         

                         
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
//                         [m_result isEqual：[NSNUll null]]
//                         if (![strName isEqualToString:@"(null)"])
                         if (strName.length != 0)
                         {
                             
                             NSLog(@"strNamebuweikong=%@",strName);
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"PYSearchOn" object:self_c userInfo:jsonDict];
                             
                             
                             [self_c IsChargingDeviceName:[[TMCache sharedCache] objectForKey:@"deviceName"]];
                             
                             [self_c getRBindDeviceList];
                             
                         }
                         
                     }
                     else
                     {
//                         [self_c performSelector:@selector(getRBindDeviceList) withObject:nil afterDelay:2.0];
                          [self_c getRBindDeviceList];
                     }
                     
                     
                     
                 }

                 
    
                 
                 NSString *strType = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"type"]];
                 
                 NSString *playStaus = [jsonDict objectForKey:@"playStatus"];
                 
                 NSString *strMode = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"mode"]];
                 
                 if(strMode.length !=0)
                 {
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"GYZActionSheetMode" object:self_c userInfo:jsonDict];  
                 }

                 
                 
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
                 
                 
                 if ( [strType isEqualToString:@"0"]||[strType isEqualToString:@"1"] ||[strType isEqualToString:@"2"] || [strType isEqualToString:@"3"] || [strType isEqualToString:@"4"] || [strType isEqualToString:@"5"] || [strType isEqualToString:@"6"] || [strType isEqualToString:@"7"] || [strType isEqualToString:@"8"]    ) {
                     
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
                 
//                 else if ([strType isEqualToString:@"2"])
//                 {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"QCustomPlayON" object:self_c userInfo:jsonDict];
//                     
//                     
//                 }

                 
    
             }
                 
             
             
         });
     }];
    
    
    
}

- (void)initMQTTkitKtopic:(NSString *)ktopic KTopic1:(NSString *)ktopic1 KTopic2:(NSString *)ktopic2
{
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    
    [self.client connectToHost:kMQTTServerHost completionHandler:^(MQTTConnectionReturnCode code) {
        
        if (code == ConnectionAccepted)//连接成功
        {
            
//            #define kTopic  @"storybox/0100000000000005/server/page"
            
            // 订阅
            [self.client subscribe:ktopic withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", ktopic);
                NSLog(@"return:%@",grantedQos);
            }];
            
            // 订阅
            [self.client subscribe:ktopic1 withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", ktopic1);
                NSLog(@"return:%@",grantedQos);
            }];
            
            // 订阅
            [self.client subscribe:ktopic2 withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", ktopic2);
                NSLog(@"return:%@",grantedQos);
            }];
            
            
            
        }else{
            NSLog(@"MQTT 连不上");
        }
        
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

- (void)SendMessage:(NSDictionary *)message
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [self.client publishData:data toTopic:self.mKTopic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
        NSLog(@"message has been delivered");
    }];
    

}

- (void)GetMessage
{
    //    __block NSString *messageString = @"";
    
    __block HomeViewController *self_c = self;
    
    //MQTTMessage  里面的数据接收到的是二进制，这里框架将其封装成了字符串
    [self.client setMessageHandler:^(MQTTMessage* message)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //接收到消息，更新界面时需要切换回主线程
             
             NSLog(@"yemian%@",message.payloadString);
      
             
             if([message.topic isEqualToString:self_c.mKTopic2])
             {
                 NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                 NSLog(@"jsonDict12%@",jsonDict);
                 //                 [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotice" object:self_c userInfo:jsonDict];
                 
             }else if([message.topic isEqualToString:self_c.mKTopic])
             {
                 NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:message.payload options:NSJSONReadingMutableLeaves error:nil];
                 NSLog(@"jsonDict34%@",jsonDict);
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"DemandAlbum" object:self_c userInfo:jsonDict];
                 
                 
             }
             
         });
     }];
    
    
    
}

//- (void)IsOnlineStatus
//{
//    UIViewController *viewVc = [self getTopMostController];
//    
//
//    
//    BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"设备已掉线!" andWithTag:1 andWithButtonTitle:@"确定"];
//    
//    [QalertView showInView:viewVc.view];
//    
//
//    
//    //点击按钮回调方法
//    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
//        if (titleBtnTag == 1) {
//
//            if (viewVc.presentedViewController != nil ) {
//                
//                [viewVc dismissViewControllerAnimated:YES completion:^{
//        
//                }];
//                
//            }
//            else
//            {
//                [[CustomRootViewController getInstance] comeback];
//            }
//    
//        }
//
//    };
//    
//    
//
//    
//}

- (void)DelayOnlineStatusDeviceName
{
    
   //[self IsOnlineStatusDeviceName:[[TMCache sharedCache] objectForKey:@"onlinedeviceName"]];
    
    
}


- (void)IsOnlineStatusDeviceName:(NSString *)deviceName DeviceId:(NSString *)deviceId
{
    
    
    
    if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"%@",deviceId]] isEqualToString:@"showYES"]) {
       
        return;
    }
    
    [[TMCache sharedCache]setObject:@"showYES" forKey:[NSString stringWithFormat:@"%@",deviceId]];
    
    UIViewController *viewVc = [self getCurrentVC];
    
    NSString *str = [NSString stringWithFormat:@"%@已掉线22!",deviceName];
    NSLog(@"1111str=======%@", str);
    
    
    BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:str andWithTag:1 andWithButtonTitle:@"确定"];
    
    
    [QalertView showInView:viewVc.view];
    
    //判断是否是当前正值浏览的设备掉线提示
    NSString *strName = [[TMCache sharedCache] objectForKey:@"deviceName"];
    
    
    if ([deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]] && strName.length != 0) {
        //当前浏览的设备掉线
        
        [[AppDelegate appDelegate]suspendButtonEnabled:NO];
        
    }
    
    
    
    
    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
//            if ([deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]]) {
//                [[CustomRootViewController getInstance] comeback];
//                
//                
//            }
            
            [[TMCache sharedCache]removeObjectForKey:[NSString stringWithFormat:@"%@",deviceId]];//点击确定后弹出狂消失，清空缓存方便下一次掉线及时弹出框
            
          
            
            if ([deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]] && strName.length != 0) {
                
                //                [[CustomRootViewController getInstance] comeback];
                
                [[AppDelegate appDelegate]suspendButtonEnabled:YES];//点击确定后重新可以点击
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DropsORCharge" object:self userInfo:nil];//掉线或者充电通知
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }

        }
        
    };
    
    
    
    if ( [deviceName isEqualToString:[[TMCache sharedCache] objectForKey:@"deviceName"]] ) {
        

        UIViewController *viewPresentVc = [self getPresentedViewController];
        
        if (viewPresentVc != nil) {
            
            [viewPresentVc dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }

        
    }
    
//    UIViewController *viewPresentingVc = [self getpresentingViewController];
//    
//    if (viewPresentingVc != nil) {
//        
//       [viewPresentingVc.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        
//    }
    
    
    //    BBTQAlertView *QPresentalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"设备已掉线!" andWithTag:1 andWithButtonTitle:@"确定"];
    //
    //    [QPresentalertView showInView:viewPresentVc.view];
    //
    //
    //
    //    //点击按钮回调方法
    //    QPresentalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
    //        if (titleBtnTag == 1) {
    //
    //            [viewPresentVc dismissViewControllerAnimated:YES completion:^{
    //
    ////              [[CustomRootViewController getInstance] comeback];
    //                
    //            }];
    ////
    //
    //        }
    //        
    //    };
    
    
}

- (void)IsChargingDeviceName:(NSString *)deviceName
{
    
     [[AppDelegate appDelegate]suspendButtonEnabled:NO];//弹出框后浮动按钮禁止点击
    
    if ([[[TMCache sharedCache]objectForKey:[NSString stringWithFormat:@"IsCharging"]] isEqualToString:@"showYES"]) {
        
        return;
    }
    
    [[TMCache sharedCache]setObject:@"showYES" forKey:@"IsCharging"];
    
    UIViewController *viewVc = [self getCurrentVC];
    
    NSString *str = [NSString stringWithFormat:@"%@充电中，不能使用!",deviceName];
    NSLog(@"str=======%@", str);
    
    BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:str andWithTag:1 andWithButtonTitle:@"确定"];
    
    [QalertView showInView:viewVc.view];
    
    
    
    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
          
             [[AppDelegate appDelegate]suspendButtonEnabled:YES];//点击确定后重新可以点击
            
               [[TMCache sharedCache]removeObjectForKey:@"IsCharging"];//点击确定后弹出狂消失，清空缓存方便下一次充电及时弹出框
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DropsORCharge" object:self userInfo:nil];//掉线或者充电通知
            
                [self.navigationController popToRootViewControllerAnimated:YES];
                

            
        }
        
    };
   
    
    
    UIViewController *viewPresentVc = [self getPresentedViewController];
    
    if (viewPresentVc != nil) {
        
        [viewPresentVc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
        
        
    }

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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DropsORCharge" object:self userInfo:nil];//掉线或者充电通知
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        
    };
    
    
    UIViewController *viewPresentVc = [self getPresentedViewController];
    
    if (viewPresentVc != nil) {
        
        [viewPresentVc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    }
    
    
}


- (void)offDeviceStaues
{
    
    [[AppDelegate appDelegate]suspendButtonEnabled:NO];//设备掉线禁止浮动按钮点击
    
    UIViewController *viewVc = [self getCurrentVC];
    
    NSString *str = [NSString stringWithFormat:@"%@已掉线11!",[[TMCache sharedCache] objectForKey:@"deviceName"]];
    NSLog(@"str=======%@", str);
    
    BBTQAlertView *QalertView = [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:str andWithTag:1 andWithButtonTitle:@"确定"];
    
    [QalertView showInView:viewVc.view];
    
    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
        
              [[AppDelegate appDelegate]suspendButtonEnabled:YES];//点击确定后重新可以点击
            
               [[NSNotificationCenter defaultCenter] postNotificationName:@"DropsORCharge" object:self userInfo:nil];//掉线或者充电通知
            
               [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        
    };
    
    
    UIViewController *viewPresentVc = [self getPresentedViewController];
    
    if (viewPresentVc != nil) {
        
        [viewPresentVc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    }
    
    
}


- (UIViewController *)getTopMostController {
    UIViewController *ctrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (true) {
        if (ctrl.presentedViewController) {
            ctrl = ctrl.presentedViewController;
        } else {
            break;
        }
    }
    return ctrl;
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

- (UIViewController *)getpresentingViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//        
//    }
    
    if(topVC.presentingViewController)
    {
        topVC = topVC.presentingViewController;
    }
    
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



//-------------------------------- 退出程序 -----------------------------------------//

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.backgroundColor = [UIColor whiteColor];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}


//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
