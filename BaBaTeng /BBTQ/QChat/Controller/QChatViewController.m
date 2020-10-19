//
//  QChatViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QChatViewController.h"

#import "QTalkFrame.h"
#import "QTalkCell.h"
#import "QTalk.h"

#import "QChatMessageCell.h"
#import "QChatMessage.h"
#import "QChatMessageFrame.h"

#import "QChatTool.h"
#import "ICVoiceHud.h"



#import "ICRecordManager.h"
#import <AVFoundation/AVFoundation.h>

#import "QmemberViewController.h"
#import "AFNetworking.h"

#import "QChatRequestTool.h"

#import "QChat.h"
#import "QChatData.h"
#import "QChatFamilyMemberUser.h"
#import "QChatFamilyMemberDevice.h"
#import "QChatList.h"
#import "QChatRecordType.h"
#import "QChatFamilyMember.h"
#import "ClearCacheTool.h"

#import "TMCache.h"

#import "MusicPlayerView.h"

#import "VoiceConverter.h"


#import "BBTQAlertView.h"
#import "HomeViewController.h"
#import "BBTMainTool.h"
#import "NewHomeViewController.h"


@interface QChatViewController ()<UITableViewDelegate,UITableViewDataSource,QChatMessageCellDelegate,QChatToolDelegate,MusicPlayerViewDelegate,ICRecordManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *messageFrames;

@property(nonatomic, strong) NSMutableArray *messagearr;

@property(strong,nonatomic)AVPlayer *player;

@property (nonatomic, strong) QChatTool *chatBox;

/** 录音文件名 */
@property (nonatomic, copy) NSString *recordName;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ICVoiceHud *voiceHud;

//@property(strong,nonatomic)AVPlayer *player;
//@property(nonatomic, strong) NSMutableArray *messageFramestest;

@property (nonatomic, assign) NSInteger pageIndx;

@property (nonatomic, strong) UIImageView *voiceImageview;

@property(nonatomic,strong) MusicPlayerView *playerView;

@property (nonatomic, strong) NSString *pageStr;

@property (nonatomic, strong) NSString *userIconstr;
@property (nonatomic, strong) NSString *usernamestr;

@property (nonatomic, strong) ICRecordManager *manager;

@property (nonatomic, copy) NSString *voicePath;

@property (nonatomic, copy) NSString *downPath;

@property (nonatomic,assign) CGRect currentOperateTextRect;

@end

@implementation QChatViewController

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



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"微聊";
    UIScrollView *scView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scView;
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
//          [self loadView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 34, 34)];
    
    [btn setImage:[UIImage imageNamed:@"nav_jiatinchengyuan_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"nav_jiatinchengyuan_pre"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(addcontroller) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(addcontroller)];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
 
    
    [self LoadChlidView];
    
    self.messagearr = [[NSMutableArray alloc] init];
    self.messageFrames = [[NSMutableArray alloc] init];
    
    self.pageIndx = 1;
    
    NSString *cacheSize = [ClearCacheTool getCacheSizeWithFilePath:[[TMCache sharedCache] objectForKey:@"ChatFilePath"]];
    
    NSLog(@"cacheSize======%@",cacheSize);
    
    [self GetMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QChatPlay:) name:@"QChatPlay" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QChatOn:) name:@"QChatOn" object:nil];
    
    IsPlaying = NO;
    self.playerView =[[MusicPlayerView alloc]init];
    self.playerView.musicPlayerDelegate = self;
    
//    [self loadView];
    
//    [self addNotification];
    
 
   
}

//-(void)loadView {
//
//    UIScrollView *scView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.view = scView;
//}


//- (void)addNotification
//
//{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//
//}
//
////键盘弹出
//
//- (void)keyboardWillShow:(NSNotification *)notification
//
//{
//
//    NSDictionary *keyInfo = [notification userInfo];
//
//
//
//    //获取高度
//
//    id keyBoardValue = [keyInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
//
//    CGSize keyBoardSize = [keyBoardValue CGRectValue].size;
//
//    //获取键盘弹出时间
//
//    id keyBoardDurationValue = [keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//
//    //如果键盘盖住文本框，则移动
//
//    CGFloat allH = CGRectGetMaxY(self.currentOperateTextRect)+keyBoardSize.height;
//
//    if (allH > (KDeviceHeight-64)) {
//
//        CGPoint backScrollViewPoint = self.tableView.contentOffset;
//
//        //相差的距离
//
//        backScrollViewPoint.y =   allH - KDeviceHeight;
//
//        //动画效果
//
//        [UIView animateWithDuration:[keyBoardDurationValue floatValue]  animations:^{
//
//            self.tableView.contentOffset = backScrollViewPoint;
//
//        } completion:^(BOOL finished) {
//
//
//
//        }];
//
//
//
//    }
//
//        if (self.messageFrames.count >1) {
//
//            NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
//            [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//
//        }
//
//
//
//
//
//}
//
////键盘隐藏
//
//- (void)keyboardWillHide:(NSNotification *)notification
//
//{
//
//    NSDictionary *keyInfo = [notification userInfo];
//
//    //获取高度
//
//    id keyBoardValue = [keyInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
//
//    CGSize keyBoardSize = [keyBoardValue CGRectValue].size;
//
//    //获取键盘弹出时间
//
//    id keyBoardDurationValue = [keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//
//
//
//    CGPoint backScrollViewPoint = self.tableView.contentOffset;
//
//    backScrollViewPoint.y = -64;
//
//    //动画效果
//
//    [UIView animateWithDuration:[keyBoardDurationValue floatValue]  animations:^{
//
//        self.tableView.contentOffset = backScrollViewPoint;
//
//    } completion:^(BOOL finished) {
//
//
//
//    }];
//
//    if (self.messageFrames.count >1) {
//
//        NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//
//    }
//
//
//}

//#pragma -mark UITextView Delegate
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    //输入框编辑完成,视图恢复到原始状态
//    self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
//}
//
//-(void)textViewDidBeginEditing:(UITextView *)textView{
//
//    CGRect frame = textView.frame;
//
//    //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
//    int offset = (frame.origin.y+62)-(KDeviceHeight-216.0);//键盘高度216
//
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//
//    [UIView setAnimationDuration:0.30f];//动画持续时间
//
//    if (offset>0) {
//        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//        self.view.frame = CGRectMake(0.0f, -offset, kDeviceWidth, KDeviceHeight);
//    }
//    [UIView commitAnimations];
//}


//- (void)QChatOn:(NSNotification *)noti
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}



- (void)QChatPlay:(NSNotification *)noti
{
    [self GetMessage];
}

- (void)GetMessage
{
//    NSNumber *pagenumber = [NSNumber numberWithInteger:self.pageIndx];
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :@1,@"pageSize" :@20};
    
    [self startLoading];
    [QChatRequestTool GetChatInfo:parameter success:^(QChat *respone) {
        [self stopLoading];
         if ([respone.statusCode isEqualToString:@"0"]) {
             
             if (self.messageFrames.count > 0) {
                 
                 [self.messageFrames removeAllObjects];
             }
             
             if (self.messagearr.count > 0) {
                 
                 [self.messagearr removeAllObjects];
             }
             
             self.pageStr = respone.data.pages;
             
             for (int i = 0; i < respone.data.list.count; i++) {
                 
                 QChatList *chatlist = [respone.data.list objectAtIndex:i];
                 
                 QChatFamilyMember *familymember = chatlist.familyMember;
                 
                 QChatMessage *chatmessage = [[QChatMessage alloc] init];
                 
                 
                 
                 if ([familymember.userId isEqualToString: [[TMCache sharedCache] objectForKey:@"userId"]]) {
                     
                     self.userIconstr = familymember.familyMemberIcon;
                     self.usernamestr = familymember.nickName;
                     chatmessage.type = QChatMessageSelf;
                     
                  }
                 else{
                     chatmessage.type = QChatMessageOther;
                 }
                 
                 chatmessage.time = chatlist.createTime;
                 
                 chatmessage.nickName = familymember.nickName;
                 chatmessage.voiceUrl = chatlist.voiceUrl;
                 chatmessage.userIcon = familymember.familyMemberIcon;
                 chatmessage.recordType = chatlist.recordType.value;
                 
                 chatmessage.IsSend = @"1";
                 chatmessage.IsSendDing =@"0";
                 if ([chatmessage.recordType isEqualToString:@"1"]) {
                     chatmessage.text = chatlist.recordData;
                 }
                 else{
                     if (chatmessage.type == QChatMessageSelf) {
                         
                         
                        
                         chatmessage.text = @"                   ";
                     }
                     else
                     {
                         
                        chatmessage.text = @"                   ";
                         
                     }
                     
                 }
                 
                 [self.messagearr addObject:chatmessage];
   
             }
             
             self.messagearr = (NSMutableArray *)[[self.messagearr reverseObjectEnumerator] allObjects];
             
              for (QChatMessage *msg in self.messagearr) {
 
                  QChatMessageFrame *msgFrame = [[QChatMessageFrame alloc] init];
                  msgFrame.message = msg;
 
                  [self.messageFrames addObject:msgFrame];
              }
     
             
             [self.tableView reloadData];
             
             if (self.messageFrames.count >1) {
                 
                 NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
                 [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                 
             }
             
             
             
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
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}


- (void)addcontroller
{
    QmemberViewController *memberVc = [[QmemberViewController alloc]init];
    
    [self.navigationController pushViewController:memberVc animated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
//    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;

////    NSLog(@"sssssssss%@",noti.userInfo);
////
////
////    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
////
////    CGRect frame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
////
////    NSLog(@"frame.origin.y====%f",frame.origin.y);
////
////    NSLog(@"self.view.frame.size.height====%f",self.view.frame.size.height);
////    //适配iphone x
////    CGFloat offsetY;
////    if (kDevice_Is_iPhoneX==34) {
////
////        offsetY = frame.origin.y - self.view.frame.size.height - 64 - 24;
////
////    }else{
////
////        offsetY = frame.origin.y - self.view.frame.size.height - 64;
////    }
////
////    NSLog(@"sssssoffsetY======%f",offsetY);
////    [UIView animateWithDuration:duration animations:^{
////        self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
////    }];

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



    if (self.messageFrames.count >1) {

        NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    }




}
//


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
    self.tableView.allowsSelection = NO;
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
    [self dropDownRefresh];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatBox];
    
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
//    
//    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
//    
//    //        button.backgroundColor = [UIColor whiteColor];
//    
//    [button addTarget:self action:@selector(backForePage) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

#pragma mark UITableView + 下拉刷新 默认
- (void)dropDownRefresh
{
//    __unsafe_unretained __typeof(self) weakSelf = self;
    
    __block QChatViewController *weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
    
    
    
}

-(void)loadNewData{
    
    
    NSLog(@"下拉加载更多聊天消息");
    
    self.pageIndx++;
    
   if( self.pageIndx > [self.pageStr integerValue])
   {
       [self.tableView.mj_header endRefreshing];
       return;
   }
    
    
    
    NSNumber *pagenumber = [NSNumber numberWithInteger:self.pageIndx];
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"pageNum" :pagenumber,@"pageSize" :@20};
    
    
    [self startLoading];
    [QChatRequestTool GetChatInfo:parameter success:^(QChat *respone) {
        
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
        

        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            if (self.messagearr.count > 0) {
                [self.messagearr removeAllObjects];
            }
            
            NSLog(@"respone.data.list.count===%lu",(unsigned long)respone.data.list.count);
            
            for (int i = 0; i < respone.data.list.count; i++) {
                
                QChatList *chatlist = [respone.data.list objectAtIndex:i];
                
                QChatFamilyMember *familymember = chatlist.familyMember;
                
                QChatMessage *chatmessage = [[QChatMessage alloc] init];
                
                
                
                if ([familymember.userId isEqualToString: [[TMCache sharedCache] objectForKey:@"userId"]]) {
                    
                    chatmessage.type = QChatMessageSelf;
                }
                else{
                    chatmessage.type = QChatMessageOther;
                }
                
                chatmessage.time = chatlist.createTime;
                
                chatmessage.nickName = familymember.nickName;
                chatmessage.voiceUrl = chatlist.voiceUrl;
                chatmessage.userIcon = familymember.familyMemberIcon;
                chatmessage.recordType = chatlist.recordType.value;
                chatmessage.IsSend = @"1";
                chatmessage.IsSendDing =@"0";
                if ([chatmessage.recordType isEqualToString:@"1"]) {
                    chatmessage.text = chatlist.recordData;
                }
                else{
                    
                    if (chatmessage.type == QChatMessageSelf) {
                        
                        
                        
                        chatmessage.text = @"                   ";
                    }
                    else
                    {
                        
                        chatmessage.text = @"                   ";
                    
                    }
//                    chatmessage.text = @"                    ";
                    
                }
                
                [self.messagearr addObject:chatmessage];
                
            }
            
            self.messagearr = (NSMutableArray *)[[self.messagearr reverseObjectEnumerator] allObjects];
            
             NSMutableArray *messageFrameArr = [NSMutableArray array];
            
            for (QChatMessage *msg in self.messagearr) {
                
                QChatMessageFrame *msgFrame = [[QChatMessageFrame alloc] init];
                msgFrame.message = msg;
                
                [messageFrameArr addObject:msgFrame];
            }
            
 
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messageFrameArr.count)];
            
            // 把最新的微博数插到最前面
            [self.messageFrames insertObjects:messageFrameArr atIndexes:indexSet];
            
            [self.tableView reloadData];
            
           
            if (messageFrameArr.count>0) {
                
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:messageFrameArr.count inSection:0];
                
                
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:NO];

            }
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];

  

    
    
}

- (QChatTool *) chatBox
{
    if (_chatBox == nil) {
        _chatBox = [[QChatTool alloc] initWithFrame:CGRectMake(0, KDeviceHeight - HEIGHT_TABBAR - 64, App_Frame_Width, HEIGHT_TABBAR)];
//        _chatBox.backgroundColor = [UIColor redColor];
        _chatBox.delegate = self;
    }
    return _chatBox;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建自定义的可重用的cell
//    QTalkCell *cell = [QTalkCell messageCellWithTableView:tableView];
    
    
    QChatMessageCell *cell = [QChatMessageCell messageCellWithTableView:tableView];
    cell.delegate = self;
    
    // 2.给子控件赋值
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    NSLog(@"index=====%ld cell.messageFrame=====%@",(long)indexPath.row, cell.messageFrame.message.text);
    cell.textView.tag = indexPath.row;
    cell.errorBtn.tag = indexPath.row;
    
    // 3.返回
    return cell;
}

#pragma mark - tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QChatMessageFrame *frame = self.messageFrames[indexPath.row];
    
    NSLog(@"frame.rowHeight=====%f",frame.rowHeight);
    
    return frame.rowHeight;
//    return  30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTalkFrame *frame = self.messageFrames[indexPath.row];
    QTalk *talk = frame.message;
    NSLog(@"%@", talk.text);
    
    
}

#pragma mark - talkcell的代理方法
- (void)qtalkerrorBtnCell:(QChatMessageCell *)errorBtnClicked pathIndex:(NSInteger)pathindex
{
    QChatMessageFrame *frame = self.messageFrames[pathindex];
      frame.message.IsSendDing =@"1";
    
      [self.tableView reloadData];
    
    if ([frame.message.recordType isEqualToString:@"1"]) {
        
        NSLog(@"postMessageText");
        [self postMessageText:frame];
        
        
    }
    else
    {
        //         [self postVoiceFile:message.voiceUrl];
        NSLog(@"postVoiceFile");
        [self postVoiceFile:frame];
        

    }
    
    
    
}
- (void)qtalkCell:(QChatMessageCell *)textBtnClicked pathIndex:(NSInteger)pathindex
{
    
  
    
    QChatMessageFrame *frame = self.messageFrames[pathindex];
    QChatMessage *talk = frame.message;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.voiceImageview stopAnimating];
    
    self.voiceImageview = textBtnClicked.voiceView;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;  // 加上这两句，否则声音会很小
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    
    if (talk.type == QChatMessageSelf) {

           [self.manager stopPlayRecorder: self.voicePath];
        
//        NSURL    *urltmpFile = [NSURL URLWithString: talk.voiceUrl];
//        self.player = [[AVPlayer alloc] initWithURL:urltmpFile]; //在线
//
//        [self.player play];

        if (IsPlaying) {
          
            VedioModel *model = [[VedioModel alloc]init];
            model.musicURL = talk.voiceUrl;
            // NSLog(@"talk.voiceUrl===%@",talk.voiceUrl);
      
                
               [self.playerView changeMusic:model];
                IsPlaying = YES;
            
            
        }else{
            
      
            VedioModel *model = [[VedioModel alloc]init];
            model.musicURL =talk.voiceUrl;
           //  NSLog(@"talk.voiceUrl1===%@",talk.voiceUrl);
    
                
                [self.playerView setUp:model];
                IsPlaying = YES;
        
        }
        
        [self startAnimation:textBtnClicked.voiceView ChatMessageType:@"0"];
        
    }
    else{
        
        
    
//        NSURL    *urltmpFile = [NSURL URLWithString: talk.voiceUrl];
//    
//        self.player = [[AVPlayer alloc] initWithURL:urltmpFile]; //在线
//        
//        self.player.volume = 1.0;
//        [self.player play];
        
        if (IsPlaying) {
            
            VedioModel *model = [[VedioModel alloc]init];
            model.musicURL = talk.voiceUrl;
            NSLog(@"talk.voiceUrl==%@",talk.voiceUrl);
            if([talk.voiceUrl hasSuffix:@".amr"]){
                
                if (IsPlaying) {
                    IsPlaying =NO;
                    [self.playerView removeObserver];//注销观察者
                }
                 self.downPath =talk.voiceUrl;
                [self download:talk.voiceUrl];
                
            }else{
                [self.manager stopPlayRecorder: self.voicePath];
                [self.playerView changeMusic:model];
                IsPlaying = YES;
            }
         
            
        
        }else{
        
        
        VedioModel *model = [[VedioModel alloc]init];
        model.musicURL =talk.voiceUrl;
        NSLog(@"talk.voiceUrl1==%@",talk.voiceUrl);
        if([talk.voiceUrl hasSuffix:@".amr"]){
            if (IsPlaying) {
                IsPlaying =NO;
                [self.playerView removeObserver];//注销观察者
            }
             self.downPath =talk.voiceUrl;
            [self download:talk.voiceUrl];
        }else{
            [self.manager stopPlayRecorder: self.voicePath];
            [self.playerView setUp:model];
            IsPlaying = YES;
        }
            
            
     
    }
        [self startAnimation:textBtnClicked.voiceView ChatMessageType:@"1"];
        
   }
    
 
}

- (void)playerFinished:(NSNotification *)noti
{
    
   [self.voiceImageview stopAnimating];
}


-(void)startAnimation:(UIImageView*)cellImageView ChatMessageType:(NSString *)type{
    
    NSArray *images = [[NSArray alloc] init];
    
    if ([type isEqualToString:@"1"]) {
            images=[NSArray arrayWithObjects:[UIImage imageNamed:@"chat_recive_voice1"],[UIImage imageNamed:@"chat_recive_voice2"],[UIImage imageNamed:@"chat_recive_voice3"],[UIImage imageNamed:@"chat_recive_voice4"], nil];
    }
    else
    {
            images=[NSArray arrayWithObjects:[UIImage imageNamed:@"chat_send_voice1"],[UIImage imageNamed:@"chat_send_voice2"],[UIImage imageNamed:@"chat_send_voice3"],[UIImage imageNamed:@"chat_send_voice4"], nil];
    }

    
    //imageView的动画图片是数组images
    cellImageView .animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    cellImageView.animationDuration = 3;
    //动画的重复次数，想让它无限循环就赋成0
    cellImageView .animationRepeatCount = 0;
    //开始动画
    [cellImageView startAnimating];
    
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
- (void)chatBox:(QChatTool *)chatBox sendTextMessage:(NSString *)textMessage
{
    [self sendMessage:textMessage type:QChatMessageSelf recordPath:@""];
    
}

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
            
            //            if ([_delegate respondsToSelector:@selector(voiceRecordSoShort)]) {
            //                [_delegate voiceRecordSoShort];
            //            }
            
            
            //
            
            [self voiceRecordSoShort];
            
            [[ICRecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {    // send voice message
            
            
            //            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendVoiceMessage:)]) {
            //                [_delegate chatBoxViewController:weakSelf sendVoiceMessage:recordPath];
            //            }
            
            
            NSString *stramr = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LocalAudio"]stringByAppendingPathExtension:@"amr"];
            
            [VoiceConverter ConvertWavToAmr:recordPath amrSavePath:stramr];
            
//            [self sendMessage:@"" type:QChatMessageSelf recordPath:recordPath];
            
            
            [self sendMessage:@"" type:QChatMessageSelf recordPath:stramr];
            
        }
    }];
}

- (void)chatBoxDidCancelRecordingVoice:(QChatTool *)chatBox
{
    //    if ([_delegate respondsToSelector:@selector(voiceDidCancelRecording)]) {
    //        [_delegate voiceDidCancelRecording];
    //    }
    
    [self voiceDidCancelRecording];
    
    [[ICRecordManager shareManager] removeCurrentRecordFile:self.recordName];
}

- (void)chatBoxDidDrag:(BOOL)inside
{
    
    //    if ([_delegate respondsToSelector:@selector(voiceWillDragout:)]) {
    //        [_delegate voiceWillDragout:inside];
    //    }
    
    [self voiceWillDragout:inside];
    
}

//#pragma mark - textField的代理
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSLog(@"textField======%@",textField.text);
//    return YES;
//}

- (void) sendMessage:(NSString *)msg type:(QChatMessageType)type recordPath:(NSString *)recordpath
{
    
    AVAudioPlayer *av = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString: recordpath]  error:nil];
    NSString *durationstr = [NSString stringWithFormat:@"%0.1fs        ",av.duration];
    
    // 创建模型对象
    QChatMessage *message = [[QChatMessage alloc] init];
    message.type = type;
    message.userIcon = self.userIconstr;
    message.nickName = self.usernamestr;
    message.IsSend = @"1";
    message.IsSendDing =@"1";
    
    if (msg.length != 0) {
        message.text = msg;
        message.recordType = @"1";
    }else
    {
        message.text = @" 1.8s             ";
        message.recordType = @"4";
    }

    
    message.voiceUrl = recordpath;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    
    ndf.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
//    ndf.dateFormat = @"HH:mm";
    
    message.time = [ndf stringFromDate:date];
    
    // 上一个消息
    QChatMessageFrame *messageFrame = [self.messageFrames lastObject];
    
    //    CZMessage *preMseage = [[self.messageFrames lastObject] message];
    QChatMessage *preMessage = messageFrame.message;
    
    if ([message.time isEqualToString:preMessage.time]) {
        message.hiddenTime = YES;
    }
    
    
    [self voiceDidCancelRecording];

    QChatMessageFrame *msgFrame = [[QChatMessageFrame alloc] init];
    msgFrame.message = message;
    
    
    if ([message.recordType isEqualToString:@"1"]) {
        
        [self postMessageText:msgFrame];
    }
    else
    {
//         [self postVoiceFile:message.voiceUrl];
        
         [self postVoiceFile:msgFrame];
    }
   
    
    [self.messageFrames addObject:msgFrame];
    
    [self.tableView reloadData];
    
    NSIndexPath *pathScoll = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:pathScoll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

//- (void)postMessageText:(NSString *)text
- (void)postMessageText:(QChatMessageFrame *)messagefarme
{
    if ([self stringContainsEmoji:messagefarme.message.text]) {
        
        [self.chatBox.textView resignFirstResponder];
        
         [self showToastWithString:@"暂不支持发送表情"];
        messagefarme.message.IsSend = @"0";
        messagefarme.message.IsSendDing =@"0";
        [self.tableView reloadData];
        
//        [self showToastWithString:@"暂不支持发送表情"];
        return;
    }
   
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"message" : messagefarme.message.text};
    
    NSLog(@"messagefarme.message.text======%@",messagefarme.message.text);
    
    
    //[self startLoading];
    [QChatRequestTool PostChatMessageText:parameter success:^(QChat *respone) {
        
       // [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
           // [self showToastWithString:respone.message];
            
//            messagefarme.message.IsSend = @"0";
//            messagefarme.message.IsSendDing =@"0";
            
            [self.tableView reloadData];
            
        
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
//        else if([respone.statusCode isEqualToString:@"6608"])
//        {
//            NSLog(@"sfdlfjldfjdfdf");
//
//            [[HomeViewController getInstance] offDeviceStaues];
//        }
        else
        {
            [self.chatBox.textView resignFirstResponder];
            [self showToastWithString:respone.message];
            messagefarme.message.IsSend = @"0";
            messagefarme.message.IsSendDing =@"0";
            [self.tableView reloadData];
            

        }
        
    } failure:^(NSError *error) {
        
//        [NSThread sleepForTimeInterval:2.0];
        
       // [self stopLoading];
        
        [self.chatBox.textView resignFirstResponder];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        messagefarme.message.IsSend = @"0";
        messagefarme.message.IsSendDing =@"0";
        
        [self.tableView reloadData];
        
    }];
    
    
}


//- (void)postVoiceFile:(NSString *)filepath
- (void)postVoiceFile:(QChatMessageFrame *)messagefarme
{
    //用AFN的AFHTTPSessionManager
    AFHTTPSessionManager *sharedManager = [[AFHTTPSessionManager alloc]init];
    sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    sharedManager.requestSerializer.timeoutInterval =20;
    
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [sharedManager.requestSerializer setValue: [[TMCache sharedCache] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    //    NSString *url = [NSString stringWithFormat:@"你的url"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/families/devices/%@/familyChatRecords/voice",BBT_HTTP_URL,PROJECT_NAME_APP,[[TMCache sharedCache] objectForKey:@"deviceId"]];
    
   // [self startLoading];
    [sharedManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = [NSData dataWithContentsOfFile:messagefarme.message.voiceUrl];
        //上传数据:FileData-->data  name-->fileName(固定，和服务器一致)  fileName-->你的语音文件名  mimeType-->我的语音文件type是audio/amr 如果你是图片可能为image/jpeg
//        [formData appendPartWithFileData:data name:@"file" fileName:@"amrRecord.wav" mimeType:@"audio/wav"];
        [formData appendPartWithFileData:data name:@"file" fileName:@"amrRecord.amr" mimeType:@"audio/amr"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      //  [self stopLoading];
//        NSLog(@"responseObject==========%@",responseObject);
        
        QChat *respone = [QChat mj_objectWithKeyValues:responseObject];
        
        NSLog(@"respone======%@",respone);
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"success");
            
//            [self showToastWithString:@"success"];
            
//            messagefarme.message.IsSend = @"0";
//            messagefarme.message.IsSendDing =@"0";
            [self.tableView reloadData];
            
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
            
            messagefarme.message.IsSend = @"0";
             messagefarme.message.IsSendDing =@"0";
            [self.tableView reloadData];
        }
        
//        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // [self stopLoading];
        NSLog(@"%@",error);
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];//暂时屏蔽会是键盘弹出框消失
        
        messagefarme.message.IsSend = @"0";
         messagefarme.message.IsSendDing =@"0";
        [self.tableView reloadData];
        
    }];
    
}

- (void)backForePage
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.manager stopPlayRecorder: self.voicePath];
    
    if (IsPlaying) {
        [self.playerView removeObserver];//注销观察者
    }
}

#pragma mark MusicPlayerViewDelegate
//播放失败的代理方法
-(void)playerViewFailed{
    IsPlaying =NO;
    NSLog(@"播放失败111");
}
//缓存中的代理方法
-(void)playerViewBuffering{
    
    //NSLog(@"缓存中");
}
//播放完毕的代理方法
-(void)playerViewFinished{
    
    NSLog(@"播放完成");
    
}

//如果是amr音频久下载
-(void)download:(NSString*)url
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    NSURL *urlStr = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    
 
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
//        NSLog(@"targetPath:%@",targetPath);
//        NSLog(@"fullPath:%@",fullPath);
        
       self.voicePath = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LocalAudio"]stringByAppendingPathExtension:@"wav"];
     
        [VoiceConverter ConvertAmrToWav:fullPath wavSavePath: self.voicePath];
        
        
        if ([VoiceConverter ConvertAmrToWav:fullPath wavSavePath: self.voicePath]==0) {//如果转格式失败，必须再下载并转格式
            
            [self download: self.downPath];
            
        }else{
            
        
        self.manager = [ICRecordManager shareManager];
        
        [self.manager startPlayRecorder: self.voicePath];
       
 
        self.manager.playDelegate =self;
            
        }
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"8==============%@",filePath);
        
        //[self play:[NSString stringWithFormat:@"%@",filePath]];
    }];
    
    //3.执行Task
    [download resume];
    
    
    
}
-(void)voiceDidPlayFinished{
    
     [self.voiceImageview stopAnimating];


}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
     [[AppDelegate appDelegate] suspendButtonHidden:YES];
    
    if (!IsStrEmpty([[TMCache sharedCache]objectForKey:@"GroupCard"])) {
        
        if (self.messageFrames.count>0) {
            
            for (int i=0; i<self.messageFrames.count; i++) {
                
                QChatMessageFrame *messageFrame = self.messageFrames[i];
                
                if (messageFrame.message.type == QChatMessageSelf) {
                   
                    messageFrame.message.nickName = [[TMCache sharedCache]objectForKey:@"GroupCard"];
                }
            }
        }
       
      
        [self.tableView reloadData];
       
    }
    
//    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    
    
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
//    //    _chatBox = [[QChatTool alloc] initWithFrame:CGRectMake(0, KDeviceHeight - HEIGHT_TABBAR - 64, App_Frame_Width, HEIGHT_TABBAR)];
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


- (void)viewWillDisappear:(BOOL)animated{
    
  [super viewWillDisappear:animated];
    
    [[TMCache sharedCache]removeObjectForKey:@"GroupCard"];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
