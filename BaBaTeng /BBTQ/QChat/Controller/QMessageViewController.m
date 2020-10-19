//
//  QMessageViewController.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QMessageViewController.h"

#import "QChatTool.h"
#import "QMessageCommon.h"
#import "QChatRequestTool.h"
#import "NewHomeViewController.h"

#import "QSXMessage.h"
#import "QSXMessageData.h"

#import "QMessageTool.h"

#import "QChatTool.h"
#import "ICVoiceHud.h"

#import "AFNetworking.h"

#import "ICRecordManager.h"
#import <AVFoundation/AVFoundation.h>

#import "BBTMainTool.h"
#import "BBTQAlertView.h"

@interface QMessageViewController ()<UITableViewDelegate,UITableViewDataSource,QChatToolDelegate,ICRecordManagerDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QChatTool *chatBox;

//@property (nonatomic, strong) QMessageTool *chatBox;

@property (nonatomic, strong) NSMutableArray *QMessageArr;

/** 录音文件名 */
@property (nonatomic, copy) NSString *recordName;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ICVoiceHud *voiceHud;

@property (nonatomic, strong) ICRecordManager *manager;


@end

@implementation QMessageViewController

- (ICVoiceHud *)voiceHud
{
    if (!_voiceHud) {
        _voiceHud = [[ICVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(App_Frame_Width/2, APP_Frame_Height/2);
    }
    return _voiceHud;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (QChatTool*) chatBox
{
    if (_chatBox == nil) {
        _chatBox = [[QChatTool alloc] initWithFrame:CGRectMake(0, KDeviceHeight - HEIGHT_TABBAR - 64, App_Frame_Width, HEIGHT_TABBAR)];
        //        _chatBox.backgroundColor = [UIColor redColor];
        _chatBox.delegate = self;
    }
    return _chatBox;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"实时消息";
    
    UIScrollView *scView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scView;
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.QMessageArr = [[NSMutableArray alloc] init];
    

    [self LoadChlidView];
    
    [self GetTimelyMessages];
    
}

- (void)GetTimelyMessages
{
        NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    [self startLoading];
    [QChatRequestTool GetTimelyMessages:parameter success:^(QSXMessage *respone) {
        
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.QMessageArr = respone.data;
            
            [self.tableView reloadData];

            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}
- (void)LoadChlidView
{
    //适配iphone x
    CGFloat myheight;
    if (kDevice_Is_iPhoneX==34) {
        myheight =40;
    }else{
        
        myheight =0;
        
    }
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 49-myheight)style:UITableViewStylePlain];
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
//    [self dropDownRefresh];

    [self.view addSubview:self.tableView];

    [self.view addSubview:self.chatBox];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.QMessageArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSString *CellIdentifier = @"qmessagecellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.textColor = [UIColor redColor];
    
    QSXMessageData *messagedata = [self.QMessageArr objectAtIndex:indexPath.row];
    cell.textLabel.text = messagedata.message;
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSXMessageData *messagedata = [self.QMessageArr objectAtIndex:indexPath.row];
    self.chatBox.textView.text = messagedata.message;
    
}


#pragma mark --- QChatTool代理
- (void)chatBox:(QChatTool *)chatBox sendTextMessage:(NSString *)textMessage
{
    
    
//    [self sendMessage:textMessage type:QChatMessageSelf recordPath:@""];
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];
    
    if ([HomedeviceStatusStr isEqualToString:@"0"]) {
        
        [self.chatBox.textView resignFirstResponder];
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    if ([self stringContainsEmoji:textMessage]) {
        
        [self.chatBox.textView resignFirstResponder];
        
        [self showToastWithString:@"暂不支持发送表情"];
 
        return;
    }
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"message" :textMessage};
    
    [QChatRequestTool PostTimelyMessagesText:parameter success:^(QMessageCommon *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            [self.chatBox.textView resignFirstResponder];
            self.chatBox.textView.text = @"";
            [self showToastWithString:@"发送成功"];
            
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{

    /** 键盘完全弹出时间 */
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] intValue];
    
    /** 动画趋势 */
    int curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    /** 动画执行完毕frame */
    CGRect keyboard_frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    /** 获取键盘y值 */
    CGFloat keyboard_y = keyboard_frame.origin.y;
    
    /** view上平移的值 */
    CGFloat offset = KDeviceHeight - keyboard_y;
    
    /** 执行动画  */
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
    }];
    
    
//    
//    if (self.messageFrames.count >1) {
//        
//        NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        
//    }
    
    
    
    
}

//判断是否有emoji
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


- (NSString *)currentRecordFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}

- (void)timerInvalue
{
    [_timer invalidate];
    _timer  = nil;
}

#pragma mark - voice & video

- (void)voiceDidCancelRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = YES;
}
- (void)voiceDidStartRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = NO;
    [self timer];
}

// 向外或向里移动
- (void)voiceWillDragout:(BOOL)inside
{
    if (inside) {
        [_timer setFireDate:[NSDate distantPast]];
        _voiceHud.image  = [UIImage imageNamed:@"voice_1"];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.voiceHud.animationImages  = nil;
        self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];
    }
}
- (void)progressChange
{
    AVAudioRecorder *recorder = [[ICRecordManager shareManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    
    
    NSLog(@"power=====%f",power);
    
    NSLog(@"progress=====%f",progress);
    
    
    self.voiceHud.progress = progress;
}

- (void)voiceRecordSoShort
{
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceHud.hidden = YES;
    });
}




#pragma mark --- QChatTool代理
- (void)chatBoxDidStartRecordingVoice:(QChatTool *)chatBox
{
    self.recordName = [self currentRecordFileName];
    
    [[ICRecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {   // 加了录音权限的判断
        } else {
            
            [self voiceDidStartRecording];
        }
    }];
}

- (void)chatBoxDidStopRecordingVoice:(QChatTool *)chatBox
{
    __weak typeof(self) weakSelf = self;
    [[ICRecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:shortRecord]) {
            
      
            [self voiceRecordSoShort];
            
            [[ICRecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {    // send voice message
            
            NSLog(@"recordPath123456789=======%@",recordPath);
            
                [self voiceDidCancelRecording];
            
//            [self sendMessage:@"" type:QChatMessageSelf recordPath:recordPath];
            
            [self postMessageVoiceFile:recordPath];
        }
    }];
}

- (void)chatBoxDidCancelRecordingVoice:(QChatTool *)chatBox
{

    [self voiceDidCancelRecording];
    
    [[ICRecordManager shareManager] removeCurrentRecordFile:self.recordName];
}

- (void)chatBoxDidDrag:(BOOL)inside
{
    
    [self voiceWillDragout:inside];
    
}

- (void)voiceDidPlayFinished
{
    
}

- (void)postMessageVoiceFile:(NSString *)recordPath
{
    
    NSString *HomedeviceStatusStr = [[TMCache sharedCache] objectForKey:@"HomedeviceStatus"];

    if ([HomedeviceStatusStr isEqualToString:@"0"]) {

        [self.chatBox.textView resignFirstResponder];
        [self showToastWithString:@"设备不在线"];
        return;
    }
    
    //用AFN的AFHTTPSessionManager
    AFHTTPSessionManager *sharedManager = [[AFHTTPSessionManager alloc]init];
    sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    sharedManager.requestSerializer.timeoutInterval =20;
    
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    //    NSString *url = [NSString stringWithFormat:@"你的url"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/timelyMessages/devices/%@/voice",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
    // [self startLoading];
    [sharedManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = [NSData dataWithContentsOfFile:recordPath];
        //上传数据:FileData-->data  name-->fileName(固定，和服务器一致)  fileName-->你的语音文件名  mimeType-->我的语音文件type是audio/amr 如果你是图片可能为image/jpeg
        [formData appendPartWithFileData:data name:@"file" fileName:@"amrRecord.wav" mimeType:@"audio/wav"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"sss%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //  [self stopLoading];
        //        NSLog(@"responseObject==========%@",responseObject);
        
        QMessageCommon *respone = [QMessageCommon mj_objectWithKeyValues:responseObject];
        
        NSLog(@"respone======%@",respone);
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"success");

            [self showToastWithString:@"发送成功"];
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else if( [respone.statusCode isEqualToString:@"101"] )
        {
            NSLog(@"未登录或登录已过期");
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:self.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                    [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
        }
        //        else if([respone.statusCode isEqualToString:@"6608"])
        //        {
        //            NSLog(@"sfdlfjldfjdfdf");
        //
        //            [[HomeViewController getInstance] offDeviceStaues];
        //        }
        else
        {
            //            [self.chatBox.textView resignFirstResponder];
            [self showToastWithString:respone.message];

            [self.tableView reloadData];
        }
        
        //        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // [self stopLoading];
        NSLog(@"%@",error);
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];//暂时屏蔽会是键盘弹出框消失
        [self.tableView reloadData];
        
    }];
    
}

////iOS 在开启个人热点后会调用此方法
//
//- (void)viewWillLayoutSubviews{
//    
//
//    [super viewWillLayoutSubviews];
//    
//    
//    
//    
//    [self.view layoutSubviews];
//    
//    
////    _chatBox = [[QChatTool alloc] initWithFrame:CGRectMake(0, KDeviceHeight - HEIGHT_TABBAR - 64, App_Frame_Width, HEIGHT_TABBAR)];
//    _chatBox.frame = CGRectMake(0, KDeviceHeight - HEIGHT_TABBAR - 64 - 20, App_Frame_Width, HEIGHT_TABBAR);
//    
//    
//    NSLog(@"the Screen is %@", NSStringFromCGRect([[UIScreen mainScreen] bounds]));
//    
//    
//    
//    NSLog(@"the VC view frame is %@", NSStringFromCGRect(self.view.frame));
//    
//    
//
//    
//}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
    

    
    
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
