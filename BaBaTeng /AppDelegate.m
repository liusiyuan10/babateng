//
//  AppDelegate.m
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HelpViewController.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "BBTStartPageViewController.h"
#import "BBTLoginViewController.h"

#import "BBTMainTool.h"
#import "QCustomViewController.h"

#import "NetworkPresenterImpl.h"

#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTResultRespone.h"

#import "Header.h"

#import "TMCache.h"

#import "UIButton+AFNetworking.h"

#import "UMMobClick/MobClick.h"

#import "UIButton+WebCache.h"

#import "QHomeRequestTool.h"
#import "QPlayingTrack.h"
#import "QPlayingTrackList.h"

#import "MBProgressHUD.h"

#import <Bugtags/Bugtags.h>

#import <AlipaySDK/AlipaySDK.h>


#import "BPlayTestViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "AppDelegate+EaseMob.h"
#import <UserNotifications/UserNotifications.h>

//#import "TKEduSessionHandle.h"
//#import <HockeySDK/HockeySDK.h>

#import "TKAPPSetConfig.h"

#import "TKEduSessionHandle.h"
#import "TKAFNetworking.h"

#import "LTUpdate.h"

#import "WXApi.h"
#import "WXApiManager.h"

#import "UCSFuncEngine.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



#import <PushKit/PushKit.h>

#import <Intents/Intents.h>


#import "DKLoactionManager.h"

#define CRASH_REPORT    @"http://global.talk-cloud.com/update/public"
#define EaseMobAppKey @"1130181019099346#babateng"


static NSTimeInterval const kUpdateMusicProgressInterval = 0.05;
@interface AppDelegate ()<UCSIMClientDelegate, UCSTCPDelegateBase,ASIHTTPRequestDelegate,UNUserNotificationCenterDelegate,PKPushRegistryDelegate>
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;

@property (nonatomic, strong) NSDictionary * pushInfo; //离线推送的信息
@property (nonatomic, strong) NSDictionary * userActivityInfo;



@end
static AppDelegate *_appDelegate;

@implementation AppDelegate{
    NetworkPresenterImpl *networkPresenter;
    DlnaManager *dlnaManager;
    UIAlertView *networkAlertView;
    
    MBProgressHUD *HUD;
    
}


@synthesize wscPresenter;
@synthesize dlnaScanner;
@synthesize dmrStation;
@synthesize dmrPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //云之讯
    [[NSString stringWithFormat:@"didFinishLaunchingWithOptions : %@", launchOptions] saveTolog];
    
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [[NSString stringWithFormat:@"didFinishLaunchingWithOptions : %@", userInfo.description] saveTolog];
        
        
        [self saveRemotePushInfo:userInfo];
    }

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
     _appDelegate = self;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self prepareAudioSession];
    
//    [self TKYinit];
    //拓课云初始化app设置
    [[TKAPPSetConfig shareInstance] setupAPP];
    

   [NSThread sleepForTimeInterval:1.0];
    
    BOOL isLogin = true;
    BOOL isStart = true;
//    [self changeToHomeViewController];
    
    [self initPresenters];
    networkPresenter = [[NetworkPresenterImpl alloc] initWithVista:self];
    
//    [Bugtags startWithAppKey:@"19bcf259d39ac4eef3415345a6b72495" invocationEvent:BTGInvocationEventBubble];
    
//    [[TMCache sharedCache]setObject:@"success" forKey:@"HuanXinLogin"];
    
    [[TMCache sharedCache] removeObjectForKey:@"HuanXinLogin"];
    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
    
    if ([[TMCache sharedCache] objectForKey:@"userId"] != NULL)
    {
        
        
        [BBTMainTool setUpRootViewController:self.window];
    }
    else
    {

          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
          NSString *entry = [defaults objectForKey:@"APP_FISRT_ENTRY"];
        
        if (IsStrEmpty(entry)||entry.length==0)
        {
        
            [defaults setObject:@"entry" forKey:@"APP_FISRT_ENTRY"];
            
          //这里建议同步存储到磁盘中，但是不是必须的
            [defaults synchronize];
            

            BBTStartPageViewController *BBTVc = [[BBTStartPageViewController alloc] init];
                
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:BBTVc];
            
            self.window.rootViewController = nav;
            
        }else{
             

            BBTLoginViewController *oneVC = [[BBTLoginViewController alloc] init];
            
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];
    

            self.window.rootViewController = nav;
            
        }
        
        
    }
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"babateng";
#else
    apnsCertName = @"babateng";
    
    //环信Demo中使用Bugly收集crash信息，没有使用cocoapods,库存放在ChatDemo-UI3.0/ChatDemo-UI3.0/3rdparty/Bugly.framework，可自行删除
    //如果你自己的项目也要使用bugly，请按照bugly官方教程自行配置
//    [Bugly startWithAppId:nil];
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = EaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
//    [self HuanXingInit];
    
    //向微信注册,发起支付必须注册wxb4ba3c02aa476ea1 wxb0a7f2e8fb5692bc
    [WXApi registerApp:@"wxb0a7f2e8fb5692bc" enableMTA:YES];
    
    [self YZXinit];
    

    
    if (@available(iOS 13.0, *)) {
        
      [[DKLoactionManager sharedManager] getGPS:^(NSString *lat, NSString *lon) {

      }];
        
    }

    
    
    [self.window makeKeyAndVisible];
    
    

    
    
    
    
    return YES;
}

- (void)YZXinit
{
   
    [[WatchDog sharedWatchDog] watchNetReachbility];
    
    [self registePushAndLocalNoti];
    
    [self registPushKit];

    // 设置IM代理对象
    [[UCSIMClient sharedIM] setDelegate:self];
    
    //设置tcp代理
    [[UCSTcpClient sharedTcpClientManager] setTcpDelegate:self];
    
    //    //安装异常捕获
    //    [NSThread detachNewThreadSelector:@selector(startCatchException) toTarget:self withObject:nil];
    //    InstallUncaughtExceptionHandler();
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:UCLoginStateChangedNotication
//                                               object:nil];
//    

    
    //初始化voip功能类
    [UCSFuncEngine getInstance];
    

    
//    [self phoneLogin];
    
}

- (void)phoneLogin
{
    //    NSString *imToken = @"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiOTQ3MjdhYmQ0YjIzNDU0ZDkwOTRkZjU0MTQ3ZjFkNzkiLCJBcHBpZCI6IjkzZTJkMjg5NWU4ZTQ2MmE5NzM3NmJmOGYzNmY1ZDAyIiwiVXNlcmlkIjoiMTgxNDU4NjIxODkifQ==.OUaw6udscJLaq9SiHBAUu7+QJYAeLJNvrGSPUCHquw0=";
    
    NSString *imToken = @"eyJBbGciOiJIUzI1NiIsIkFjY2lkIjoiZDU1ODA5MDJjYWI0ZDg4NTNiMDY2NDRhNTVlZjcyMGEiLCJBcHBpZCI6ImFhMmUyYmM2ZTIyZTRmYmZhZjkyNGZhNzVjMDJkYzA5IiwiVXNlcmlkIjoiMTg1MDMwNTEwOTYifQ==.2cO35BpHOG6JCH5AhKFNg3ZLcwtpVchruFCo5UZvNBs=";
    
    
    [[UCSTcpClient sharedTcpClientManager] login_connect:imToken  success:^(NSString *userId) {
        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录成功"]];
        //        NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接成功\n",_phoneText,[self getNowTime]];
        //        [log2 saveTolog];
        [InfoManager sharedInfoManager].imtoken = imToken;
        [[InfoManager sharedInfoManager] synchronizeToSandBox];
        //        [self connectionSuccessful];
        [[UCSFuncEngine getInstance] creatTimerCheckCon];//开启15秒连接定时检测
    } failure:^(UCSError *error) {
        [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"Login登录失败"]];
        //        NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接失败 error：%zd\n",_phoneText,[self getNowTime],error.code];
        
        //        NSString * log2 = [NSString stringWithFormat:@"%@:%@:TCP链接失败 error：%zd\n",@"123",[self getNowTime],error.code];
        //        [log2 saveTolog];
        //        [self connectionFailed:error.code];
    }];
    
    
}

+(AppDelegate*)shareInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//------------------//收到远程通知后，拉起来电 有参数版本--------------------------------//
- (void)saveRemotePushInfo:(NSDictionary *)userInfo{
    _pushInfo = nil;
    NSString * callid = userInfo[@"e"][@"callid"];
    NSString * vpsId = userInfo[@"e"][@"vid"];
    
    [[NSString stringWithFormat:@"saveRemotePushInfo: %@ %@\n", callid, vpsId] saveTolog];
    _pushInfo =  (callid && vpsId) ? userInfo : nil;
    
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        [self launchCall:_pushInfo];
    }
}

//收到远程通知后，拉起来电
- (void)launchCall:(NSDictionary *)info{
    
    if (_pushInfo == nil)  return;
    
    [[NSString stringWithFormat:@"launchCall:%@", info.description] saveTolog];
    
    NSString * callid = info[@"e"][@"callid"];
    NSString * vpsId = info[@"e"][@"vid"];
    [[UCSFuncEngine getInstance] callIncomingPushRsp:callid withVps:vpsId.integerValue withReason:0];
    
    
    _pushInfo = nil;
}
//------------------//收到远程通知后，拉起来电 有参数版本--------------------------------//


//------------------//收到远程通知后，拉起来电 无参数版本--------------------------------//
- (void)saveRemotePushInfo_NoParameter{
    
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        [self launchCal_NoParameter];
    }
}

//收到远程通知后，拉起来电 无参数版本
- (void)launchCal_NoParameter{
    
    
    [[UCSFuncEngine getInstance] callIncomingPushRsp:0];
    
    
}

//------------------//收到远程通知后，拉起来电 无参数版本--------------------------------//


- (void)saveUserActivity:(NSString *)handle hasVideo:(BOOL)hasVideo{
    NSString *type = hasVideo ? @"2" : @"0";
    _userActivityInfo = @{@"handle":handle, @"type":type};
    if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
        [self launchUserAvtivity];
    }
}

- (void)launchUserAvtivity{
    if (_userActivityInfo == nil) { return ;}
    NSString * handle = _userActivityInfo[@"handle"];
    int  type = [_userActivityInfo[@"type"] intValue];
    [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:handle callType:type callName:handle];
    _userActivityInfo = nil;
}

#pragma mark UCSIMClientDelegate
- (void)didReceiveMessages:(NSArray*)messgeArray
{
    NSLog(@"收到 %ld 条消息", (unsigned long)messgeArray.count);
    if (messgeArray.count == 0) {
        NSAssert(messgeArray.count != 0, @"收到的消息数组为空");
        return;
    }
    
    for (UCSMessage * message  in messgeArray) {
        // 通知聊天界面新消息来了,通知main控制器发送本地通知
        [[NSNotificationCenter defaultCenter] postNotificationName:DidReciveNewMessageNotifacation object:message];
    }
    
    //收到到一个消息数组，刷新一次
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListDidChangedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UnReadMessageCountChangedNotification object:nil];
    });
    
}

// 语音下载完成回调
- (void)didVoiceDownloadSuccessWithMessage:(UCSMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DidRecuveVoiceDownloadStateNotification object:message];
}

// 语音下载失败回调
- (void)didVoiceDownloadFailWithMessage:(UCSMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DidRecuveVoiceDownloadStateNotification object:message];
}

- (void)didReceiveServerError:(UCSError *)error{
    
    NSAssert(error.code != 0, @"服务器返回的错误码不存在");
    
    NSLog(@"收到服务器返回的error%ld, 错误信息%@", (unsigned long)error.code, error.errorDescription);
    if (error.code == ErrorCode_NetworkIsNotConnected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPNoNetWorkNotification];
    }
    
}




- (void)didConnectionStatusChanged:(UCSConnectionStatus)connectionStatus error:(UCSError *)error
{
    switch (connectionStatus) {
        case UCSConnectionStatus_BeClicked:
            [self kickOff];
            break;
        case UCSConnectionStatus_ReConnectFail:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        case UCSConnectionStatus_StartReConnect:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPConnectingNotification];
            break;
        case UCSConnectionStatus_ReConnectSuccess:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            [self launchCall:_pushInfo];
            [self launchUserAvtivity];
            [[UCSFuncEngine getInstance] stopTimerConnect];
            break;
        case UCSConnectionStatus_loginSuccess:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDidConnectNotification];
            [self launchCall:_pushInfo];
            [self launchUserAvtivity];
            break;
        case UCSConnectionStatus_ConnectFail:
            [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectStateNotification object:UCTCPDisConnectNotification];
            break;
        default:
            break;
    }
}

- (void)kickOff
{
    
    [[UCSFuncEngine getInstance] stopTimerCheckCon];//关闭15秒连接定时检测
    // 被踢下线时 防止下次直接后台登录 清空token
    [InfoManager sharedInfoManager].imtoken = nil;
    [[InfoManager sharedInfoManager] synchronizeToSandBox];
    [[NSNotificationCenter defaultCenter] postNotificationName:TCPKickOffNotification object:nil];
    //    _alertView = [[UCAlertView alloc] initWithTitle:@"提示" message:@"当前账号在别处登录了" cancelButtonTitle:nil otherButtonTitles:@"知道了" cancelButtonBlock:^{
    //        [[NSNotificationCenter defaultCenter] postNotificationName:UCLoginStateChangedNotication object:UCLoginStateLoginOutNotification];
    //    } otherButtonBlock:nil];
}

/**
 *  @brief 收到透传数据时回调
 *
 *  @param objcts 透传实体类
 */
- (void)didReceiveTransParentData:(UCSTCPTransParent *)objcts{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UCSNotiTCPTransParent object:objcts];
}






-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    
}

- (void)didRemoveFromDiscussionWithDiscussionId:(NSString *)discussionID{
    
    NSLog(@"你被踢出了讨论组 , 讨论组id为: %@", discussionID);
    [[NSNotificationCenter defaultCenter] postNotificationName:RemovedADiscussionNotification object:discussionID];
}

#pragma mark 通知授权和 apns注册
- (void)registePushAndLocalNoti{
    
    if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(10.0)) {
        [self registLocalNotification];  //获取通知授权
        [[UIApplication sharedApplication] registerForRemoteNotifications];  //注册apns
        
    }else if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0)){
        
        UIApplication *application = [UIApplication sharedApplication];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings]; //获取授权
        
        [application registerForRemoteNotifications];  //注册apns
    }else{
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

#pragma mark - ios10以上获取本地通知和远程通知授权
- (void)registLocalNotification{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  NSLog(@"注册成功11111");
                              }else{
                                  //点击不允许
                                  NSLog(@"注册失败");
                              }
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
        {
            NSLog(@"未选择");
        }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
            NSLog(@"未授权");
        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
            NSLog(@"已授权111111");
        }
    }];
}


//apns  Token获取
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceToken1 = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken1 forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"收到推送token %@", deviceToken1);
    [[NSString stringWithFormat:@"apns_Token_didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken1] saveTolog];
    
    
    // 设置推送环境
    [[UCSTcpClient sharedTcpClientManager] setPushEnvironment:UCSPushEnvironment_Production deviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}





#pragma mark - UNUserNotificationCenterDelegate
//只有在active的状态才会触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [[NSString stringWithFormat:@"willPresentNotification : %@", userInfo.description] saveTolog];
        
        [self saveRemotePushInfo:userInfo];
    }
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

//通知点击回调，本地、远程统一
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
        [[NSString stringWithFormat:@"didReceiveNotificationResponse : %@", userInfo.description] saveTolog];
        
        [self saveRemotePushInfo:userInfo];
        
    }else {
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(); // 系统要求执行这个方法
}





#pragma mark -iOS 10之前收到通知
//调用场景：前台收到离线推送、后台收到离线推送点击进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7以上、iOS 10以下系统，收到远程通知:%@", userInfo);
    [[NSString stringWithFormat:@"didReceiveRemoteNotification : %@", userInfo.description] saveTolog];
    
    [self saveRemotePushInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
//只有active的状态才会触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"iOS 10以下系统，收到本地通知:%@",notification.userInfo );
}



#pragma mark 注册pushkit 和 代理方法
- (void)registPushKit{
    if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0)) {
        PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
        [[NSString stringWithFormat:@"------coming-----registPushKit--------"] saveTolog];
        //    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"向苹果注册PushKit"]];
    }
}
//

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString * _tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSString stringWithFormat:@"pushkit_didUpdatePushCredentials: %@", _tokenStr] saveTolog];
    
    [[UCSTcpClient sharedTcpClientManager] setVoipServiceToken:credentials.token];
    //    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到苹果下发的PushKitDeviceToken"]];
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    
    [[NSString stringWithFormat:@"didReceiveIncomingPushWithPayload: %@", payload.description] saveTolog];
    
    
    if (type == PKPushTypeVoIP) {
        _tmpdictionaryPayload = payload.dictionaryPayload;
        
        WEAKSELF
        
        
        
        
        //容错：当iPhone重启后未输入密码时导致无权限获取沙盒数据，所以每次收到推送时都要加载一下Token数据
        InfoManager * info = [InfoManager sharedInfoManager];
        [info loadDataFromSandBox];
        
        //02
        //     [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush:vpinfo->%@_token->%@",[self getRemotePushInfo:payload.dictionaryPayload],[[InfoManager sharedInfoManager].imtoken substringToIndex:5]]];
        
        
        [[NSString stringWithFormat:@"dictionaryPayload: %@", _tmpdictionaryPayload.description] saveTolog];
        
        NSString *callid = _tmpdictionaryPayload[@"e"][@"callid"];
        
        if (callid) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //03
                [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush开始登录"]];
                
                [[UCSTcpClient sharedTcpClientManager] login_connect:[InfoManager sharedInfoManager].imtoken  success:^(NSString *userId) {
                    //04
                    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"收到VPush登录成功"]];
                    
                    [weakSelf saveRemotePushInfo:[weakSelf.tmpdictionaryPayload copy]];
                    
                    
                    
                    
                    [[UCSFuncEngine getInstance] stopTimerConnect];
                } failure:^(UCSError *error) {
                    //05
                    [[UCSVOIPViewEngine getInstance] debugReleaseShowLocalNotification:[NSString stringWithFormat:@"VPush登录失败,c->%d d->%@",error.code,error.errorDescription]];
                    
                    weakSelf.tmpdictionaryPayload = nil;
                    
                }];
                
                
            });
        }
        
        
    }
    
    
    //    if (UCS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(10.0)){
    //        // 使用 UNUserNotificationCenter 来管理通知
    //        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //
    //        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    //        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    //        content.body = @"voip_service本地通知";
    //        content.sound = [UNNotificationSound defaultSound];
    //
    //        // 在 0.001s 后推送本地推送
    //        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
    //                                                      triggerWithTimeInterval:0.001 repeats:NO];
    //        //创建一个通知请求
    //        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"pushkit"
    //                                                                              content:content trigger:trigger];
    //
    //        //将通知请求添加到通知中心
    //        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    //
    //        }];
    //    }else{
    //        UILocalNotification *localNot = [[UILocalNotification alloc] init];
    //        localNot.fireDate = [NSDate date];
    //        localNot.alertBody = @"voip_service本地通知";
    //        localNot.soundName = UILocalNotificationDefaultSoundName;
    //        localNot.timeZone = [NSTimeZone defaultTimeZone];
    //
    //        [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
    //    }
    //
    
}



#pragma callkit
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    BOOL useCallkit = [[NSUserDefaults standardUserDefaults] boolForKey:USECallKit];
    if (useCallkit == NO) {
        return NO;
    }
    
    
    [@"continueUserActivity restorationHandler" saveTolog];
    
    {
        NSLog(@"userActivity.activityType:%@",userActivity.activityType);
        NSLog(@"userActivity.title:%@",userActivity.title);
        NSLog(@"userActivity.userInfo:%@",userActivity.userInfo);
        NSLog(@"userActivity.requiredUserInfoKeys:%@",userActivity.requiredUserInfoKeys);
        NSLog(@"userActivity.needsSave:%@",[NSNumber numberWithBool:userActivity.needsSave]);
        NSLog(@"userActivity.expirationDate:%@",userActivity.expirationDate);
        NSLog(@"userActivity.keywords:%@",userActivity.keywords);
        NSLog(@"userActivity.supportsContinuationStreams:%@",[NSNumber numberWithBool:userActivity.supportsContinuationStreams]);
        NSLog(@"userActivity.eligibleForHandoff:%@",[NSNumber numberWithBool:userActivity.eligibleForHandoff]);
        NSLog(@"userActivity.eligibleForSearch:%@",[NSNumber numberWithBool:userActivity.eligibleForSearch]);
        NSLog(@"userActivity.eligibleForPublicIndexing:%@",[NSNumber numberWithBool:userActivity.eligibleForPublicIndexing]);
        NSURL *url = userActivity.webpageURL;
        NSLog(@"url.absoluteString:%@",url.absoluteString);
        NSLog(@"url.relativeString:%@",url.relativeString);
        NSLog(@"url.baseURL:%@",url.baseURL);
        NSLog(@"url.absoluteURL:%@",url.absoluteURL);
        NSLog(@"url.scheme:%@",url.scheme);
        NSLog(@"url.resourceSpecifier:%@",url.resourceSpecifier);
        NSLog(@"url.host:%@",url.host);
        NSLog(@"url.port:%@",url.port);
        NSLog(@"url.user:%@",url.user);
        NSLog(@"url.password:%@",url.password);
        NSLog(@"url.path:%@",url.path);
        NSLog(@"url.fragment:%@",url.fragment);
        NSLog(@"url.parameterString:%@",url.parameterString);
        NSLog(@"url.query:%@",url.query);
        NSLog(@"url.relativePath:%@",url.relativePath);
        NSLog(@"url.hasDirectoryPath:%@",[NSNumber numberWithBool:url.hasDirectoryPath]);
    }
    
    
    INInteraction  *interaction = userActivity.interaction;
    INPerson *contact;
    if ([userActivity.activityType isEqualToString:@"INStartAudioCallIntent"]) {
        INStartAudioCallIntent *startAudioCallIntent = (INStartAudioCallIntent *)interaction.intent;
        contact = [startAudioCallIntent.contacts firstObject];
    }else if ([userActivity.activityType isEqualToString:@"INStartVideoCallIntent"]) {
        INStartVideoCallIntent *startVideoCallIntent = (INStartVideoCallIntent *)interaction.intent;
        contact = [startVideoCallIntent.contacts firstObject];
    }else if ([userActivity.activityType isEqualToString:@"INSendMessageIntent"]) {
        INSendMessageIntent *startVideoCallIntent = (INSendMessageIntent *)interaction.intent;
        contact = [startVideoCallIntent.recipients firstObject];
    }
    
    NSString * before_handle = contact.personHandle.value;
    NSLog(@"before_handle %@", before_handle);
    
    //before_handle变量中的手机号格式由：136-1234-5678 转换为 13612345678
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
    NSString *handle = [[before_handle componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    
    
    
    NSLog(@"handle %@", handle);
    
    BOOL hasVideo = NO;
    if ([userActivity.activityType isEqualToString:@"INStartVideoCallIntent"]) {
        hasVideo = YES;
    }
    
    if (handle != nil && handle.length > 0) {
        [self saveUserActivity:handle hasVideo:hasVideo];
    }
    return NO;
}




- (void)HuanXingInit
{

    
//    EMOptions *options = [EMOptions optionsWithAppkey:@"1130181019099346#babateng"];
//
//    options.apnsCertName = @"babateng";
//
//    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
//    if (!error) {
//        NSLog(@"环信初始化成功");
//    }
    
   EMError *error = [[EMClient sharedClient] loginWithUsername:@"15870211220" password:@"123456"];
    if (!error) {
        NSLog(@"环信登录成功");
    }else
    {
        NSLog(@"环信登录失败");
    }
}


- (BOOL)prepareAudioSession {
    // deactivate session
    BOOL success = [[AVAudioSession sharedInstance] setActive:NO error: nil];
    if (!success) {
        NSLog(@"deactivationError");
    }
    // set audio session category AVAudioSessionCategoryPlayAndRecord options AVAudioSessionCategoryOptionAllowBluetooth
    success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    if (!success) {
        NSLog(@"setCategoryError");
    }
    // activate audio session
    success = [[AVAudioSession sharedInstance] setActive:YES error: nil];
    if (!success) {
        NSLog(@"activationError");
    }
    return success;
}


- (UIButton *)button
{
    if (!_button) {
        
        //适配iphone x
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-50) / 2 , [UIScreen mainScreen].bounds.size.height-55-kDevice_Is_iPhoneX, 50, 50);
        self.button.imageView.contentMode = UIViewContentModeScaleToFill;
        [ self.button  setImage:[UIImage imageNamed:@"bar_bfq_nor"]
                       forState:UIControlStateNormal];
        self.button.clipsToBounds=YES;
        
        self.button.layer.cornerRadius=25;
        
        self.button.adjustsImageWhenHighlighted = false;
    }
    return _button;
}

- (void)LoginUser
{
    
    [BBTLoginRequestTool postLoginUserName:[[TMCache sharedCache] objectForKey:@"phoneNumber"] Password:[[TMCache sharedCache] objectForKey:@"password"] newLoginsuccess:^(BBTUserInfoRespone *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [[TMCache sharedCache] setObject:respone.data.userId forKey:@"userId"];
            [[TMCache sharedCache] setObject:respone.data.token forKey:@"token"];
//            [[TMCache sharedCache] setObject:userName forKey:@"phoneNumber"];
//            [[TMCache sharedCache]setObject:password forKey:@"password"];
            
            
            [[TMCache sharedCache]setObject:respone.data.accountStatus forKey:@"accountStatus"];
            [[TMCache sharedCache]setObject:respone.data.bindDeviceNumber forKey:@"bindDeviceNumber"];
            [[TMCache sharedCache]setObject:respone.data.createTime forKey:@"createTime"];
            [[TMCache sharedCache]setObject:respone.data.nickName forKey:@"nickName"];
            [[TMCache sharedCache]setObject:respone.data.onlineStatus forKey:@"onlineStatus"];
            [[TMCache sharedCache]setObject:respone.data.userIcon forKey:@"userIcon"];
            

            
        }else{
            
//            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];

}

- (void)initPresenters {
    
    wscPresenter = [[WscPresenterImpl alloc] init];
    
    dlnaManager = [[DlnaManager alloc] init];
    dlnaScanner = [dlnaManager getDlnaScannerPresenter];
    dmrStation = [dlnaManager getDmrStationPresenter];
    dmrPlayer = [dlnaManager getDmrPlayerPresenter];

    
    [self setGlobalVista];
}


-(void)setGlobalVista{
    if (dmrPlayer) {
        [dmrPlayer setGlobalVista:self];
    }
}
-(void) showNetworkInfo{
    if (!networkAlertView) {
        networkAlertView = [[UIAlertView alloc] initWithTitle:@"没有检测到设备的网络连接！" message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"设置网络", nil];
    }
    [networkAlertView setAlertViewStyle:UIAlertViewStyleDefault];
    [networkAlertView show];
}

+ (AppDelegate *)appDelegate {
    return _appDelegate;
}

-(void)suspendButtonHidden:(BOOL)hidden{
    
    NSLog(@"hidden======= %d",hidden);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:  [[TMCache sharedCache]objectForKey:@"currentTrackIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    [keyWindow addSubview:self.button];
    
    if (hidden) {
        
        for (UIView * view in keyWindow.subviews) {
            if ([view isMemberOfClass:[self.button class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
    
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
    
    self.rotationAnimation.duration = 0.5;
    
    self.rotationAnimation.cumulative = YES;
    
    self.rotationAnimation.repeatCount = ULLONG_MAX;
    
    
    if ([[[TMCache sharedCache]objectForKey:@"buttonAnimation"] isEqualToString:@"addAnimation"]){
        
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    

    [self.button addTarget:self
                    action:@selector(ridingButtonWasPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)suspendButtonEnabled:(BOOL)enabled{

    self.button.enabled =enabled;
}

- (void)AnimationPlay:(NSNotification *)noti
{
    
    //NSLog(@"AppDelegatecurrentTrackIcon===%@",[[TMCache sharedCache]objectForKey:@"currentTrackIcon"]);
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
     NSLog(@"AppDelegatecurrentTrackIconencodedString===%@",encodedString);
    
    if (encodedString.length == 0) {
        
        [self.button setImage:[UIImage imageNamed:@"bar_bfq_nor"] forState:UIControlStateNormal];
    }
    else
    {
         [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
        
    }
    
    

    
    
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    if ([strtest1 isEqualToString:@"playing"]){
        
        [[TMCache sharedCache]setObject:@"addAnimation" forKey:@"buttonAnimation"];
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        
        [[TMCache sharedCache]setObject:@"removeAnimation" forKey:@"buttonAnimation"];
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
}

- (void)NoDeviceAnimationPlay:(NSDictionary *)dic
{
    
    //NSLog(@"AppDelegatecurrentTrackIcon===%@",[[TMCache sharedCache]objectForKey:@"currentTrackIcon"]);
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    NSLog(@"AppDelegatecurrentTrackIconencodedString===%@",encodedString);
    
    if (encodedString.length == 0) {
        
        [self.button setImage:[UIImage imageNamed:@"bar_bfq_nor"] forState:UIControlStateNormal];
    }
    else
    {
        [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
        
    }
    
//    [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"playStatus"]];
    
    if ([strtest1 isEqualToString:@"playing"]){
        
        [[TMCache sharedCache]setObject:@"addAnimation" forKey:@"buttonAnimation"];
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        
        [[TMCache sharedCache]setObject:@"removeAnimation" forKey:@"buttonAnimation"];
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
}


- (void)AnimationOutsidePlay:(NSString*)sign
{
  
    //NSLog(@"999999999999===%@",sign);
    
    if (!IsStrEmpty(sign)&&sign.length>0) {
        
        [self GetPlayingTrackId];
        NSLog(@"8888888888888888888=888888888");
    }
    
   

}



- (void)GetPlayingTrackId
{
    NSString *deviceIdStr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    if (deviceIdStr.length == 0) {
        return;
    }
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
    
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            
            if (trackdata.tracks.count > 0) {
                
                QPlayingTrackList *listdata = trackdata.tracks[0];
                
                
                NSLog(@"88888========================================================================%@",listdata.trackIcon);
                
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                   NSLog(@"88888==========================================================================encodedString==%@",encodedString);
                [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
                
                [[TMCache sharedCache]setObject:listdata.trackIcon forKey:@"currentTrackIcon"];

                
            }else{
             
                [self.button sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
            
                 [[TMCache sharedCache]setObject:@"" forKey:@"currentTrackIcon"];
            }
            
            

            
           [[TMCache sharedCache]setObject:trackdata.mode forKey:@"PlayMode"];
            
        
        }
        else if([respone.statusCode isEqualToString:@"3705"])
        {
            
//            [[HomeViewController getInstance] offDeviceStaues];
            
            
        }
   
        
    } failure:^(NSError *error) {
        

    }];
}



-(void)ridingButtonWasPressed{

    NSLog(@"点击了悬浮按钮啦");
    
    
//    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
//    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0
//        ) {
//      [self AppshowToastWithString:@"您还没有绑定设备，请先绑定设备"];
//            NSLog(@"您还没有绑定设备，请先绑定设备");
//        return;
//    }
//
//    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
//
//    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
//
//        [self AppshowToastWithString:@"设备不在线"];
//        return;
//    }
//
//
//
//    QCustomViewController *loginViewController = [[QCustomViewController alloc] init];
//
//
//    UINavigationController *userNav = [[UINavigationController alloc]
//                                             initWithRootViewController:loginViewController];
//
//
//     [self.window.rootViewController presentViewController:userNav animated:YES completion:^{
//
//
//     } ];
    
    
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0
        ) {
        [self AppshowToastWithString:@"您还没有绑定设备，请先绑定设备"];
        NSLog(@"您还没有绑定设备，请先绑定设备");
        return;
    }
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
        
        if (self.playSaveDataArray.count == 0) {
            [self AppshowToastWithString:@"您还没有播放歌单"];
            
            return;
        }
        
        BPlayTestViewController *bplayC = [BPlayTestViewController sharedInstance];
        
        UINavigationController *userNav = [[UINavigationController alloc]
                                           initWithRootViewController:bplayC];
        userNav.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self.window.rootViewController presentViewController:userNav animated:YES completion:^{
            
            
        } ];
        
    }
    else
    {
        
        
        
        NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];

        if ([HomedeviceStatusStr isEqualToString:@"0"]) {

            [self AppshowToastWithString:@"设备不在线"];
            return;
        }

        
        
        QCustomViewController *loginViewController = [[QCustomViewController alloc] init];
        
         
        UINavigationController *userNav = [[UINavigationController alloc]
                                           initWithRootViewController:loginViewController];
        userNav.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self.window.rootViewController presentViewController:userNav animated:YES completion:^{
            
            
        } ];
        
    }
    

    
}


-(void)AppshowToastWithString:(NSString *)content{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText =content;
    HUD.color = [UIColor blackColor];//[UIColor colorWithRed:196.0/255 green:196.0/255 blue:196.0/255 alpha:1.0f];
    HUD.labelColor = [UIColor whiteColor];
    HUD.margin = 10.f;
    HUD.yOffset = 150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.4f];
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // 实现如下代码，才能使程序处于后台时被杀死，调用applicationWillTerminate:方法
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
    
    if ([TKEduSessionHandle shareInstance].localUser.role == TKUserTypeStudent ||
        [TKEduSessionHandle shareInstance].localUser.role == TKUserTypeTeacher) {
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(YES) completion:nil];
        [TKEduSessionHandle shareInstance].roomMgr.inBackground = YES;
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if ([TKEduSessionHandle shareInstance].localUser.role == TKUserTypeStudent ||
        [TKEduSessionHandle shareInstance].localUser.role == TKUserTypeTeacher) {
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
        [TKEduSessionHandle shareInstance].roomMgr.inBackground = NO;
    }
    [[TKEduSessionHandle shareInstance] sessionHandleApplicationWillEnterForeground];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[TKEduSessionHandle shareInstance] sessionHandleLeaveRoom:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[[TMCache sharedCache]objectForKey:@"buttonAnimation"] isEqualToString:@"addAnimation"]){
        
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
       
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
        
    }

}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                //支付成功,这里放你们想要的操作
                NSLog(@"支付成功了啊9.0");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyCourseSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ForeignShopDetailSuccess" object:nil];

                
            }
            else
            {NSLog(@"支付失败了啊9.0");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyCourseFailure" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ForeignShopDetailFailure" object:nil];
            }
            
        }];
    }else if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }

    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window

{
    
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
        
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
    
}


//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}
//
//+ (AppDelegate *)shareInstance
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}


@end
