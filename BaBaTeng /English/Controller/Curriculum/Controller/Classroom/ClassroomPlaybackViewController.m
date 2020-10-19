//
//  ClassroomPlaybackViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/10.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "ClassroomPlaybackViewController.h"
#import "ClassroomPlaybackCell.h"
#import "EnglishRequestTool.h"
#import "ClassroomPlayback.h"
#import "ClassroomPlaybackData.h"
#import "TKEduClassRoom.h"

#import "YGPlayInfo.h"

#import "StudentStyleViewController.h"
#import "HJVideoPlayerController.h"

@interface ClassroomPlaybackViewController ()<UITableViewDelegate,UITableViewDataSource,TKEduRoomDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *ClassroomPlayArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;
@property (nonatomic, strong)       NSString *pagetotal;

@property(nonatomic, strong)    UILabel *noLabel;
@property (nonatomic, strong) NSMutableArray *playInfos;

@end

@implementation ClassroomPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"课程回放";
    
    self.ClassroomPlayArr = [[NSMutableArray alloc] init];
    
    self.playInfos = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
}

- (void)LoadChlidView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64-kDevice_Is_iPhoneX)style:UITableViewStylePlain];
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
    
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, 50, 100, 30)];
    
    noLabel.text = @"暂无内容";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
//    [self pullRefresh];
    
    [self getClassroomPlayback];
    
    
    
    
    
}

//#pragma mark UITableView + 上拉刷新
//- (void)pullRefresh
//{
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    // 设置了底部inset
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    // 忽略掉底部inset
//    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
//}

- (void)getClassroomPlayback
{
    NSLog(@"----------%@",self.serial);
    
    [self startLoading];
    [EnglishRequestTool getteacherCourseplaybackSerial:self.serial success:^(ClassroomPlayback *respone) {
        
        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {

            self.ClassroomPlayArr = respone.data;

//            self.pageStr = respone.data.pages;

            if (self.ClassroomPlayArr.count > 0) {
                
                for (int i = 0; i < self.ClassroomPlayArr.count; i++) {

                    ClassroomPlaybackData *trackList = [self.ClassroomPlayArr objectAtIndex:i];

                    NSLog(@"111111studentName-------%@",trackList.recordTitle);

                    YGPlayInfo *playinfo = [[YGPlayInfo alloc] init];

                    playinfo.url = trackList.httpsPlayPath;
                    playinfo.artist = trackList.recordTitle;
                    playinfo.title = trackList.recordTitle;
                    playinfo.placeholder = @"default_bg_land";


                    [self.playInfos addObject:playinfo];
                }

                

                [self.tableView reloadData];
            }
            else
            {
                
                self.noLabel.hidden = NO;
            }


        }else{

            [self showToastWithString:respone.message];
        }

        

    } failure:^(NSError *error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

    
}

//- (void)loadMoreData
//{
//    NSLog(@"更多数据");
//
//    self.PageNum++;
//
//    if (self.PageNum>[self.pageStr integerValue]) {
//
//        [self.tableView.mj_footer endRefreshing];
//
//        [self showToastWithString:@"没有更多数据了"];
//        return;
//    }
//
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ClassroomPlayArr.count;
    
//    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"ClassroomPlaybackCell";
    ClassroomPlaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[ClassroomPlaybackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    ClassroomPlaybackData *playdata = [self.ClassroomPlayArr objectAtIndex:indexPath.row];

    cell.nameLabel.text = playdata.recordTitle;
    
    cell.timeLabel.text = [self getMMSSFromSS:playdata.duration];

    cell.payBtn.tag = indexPath.row;

    [cell.payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}



- (void)payBtnClicked:(UIButton *)btn
{

    
    YGPlayInfo *playInfo = [self.playInfos objectAtIndex:btn.tag];
    
    
    if (@available(iOS 13.0, *)) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

        [[AppDelegate appDelegate]suspendButtonHidden:YES];
        
        HJVideoPlayerController * videoC = [[HJVideoPlayerController alloc] init];
        [videoC.configModel setOnlyFullScreen:YES];
        [videoC setUrl:playInfo.url ];
        videoC.videoTitle = playInfo.title;
        
        [self.navigationController pushViewController:videoC animated:YES];

       }else {
        StudentStyleViewController *StudentStyleVC = [[StudentStyleViewController alloc] init];
        StudentStyleVC.playInfos = self.playInfos;
        StudentStyleVC.playIndex = btn.tag;

        [self.navigationController pushViewController:StudentStyleVC animated:YES];
    }
    
    
    
}

//- (void)payBtnClicked:(UIButton *)btn
//{
////    ClassroomPlaybackData *playdata = [self.ClassroomPlayArr objectAtIndex:btn.tag];
//
//
////    [self joinRoomSerial:self.serial Path:playdata.playPath];
//
////    [self joinRoomSerial:@"911368700" Path:@"global.talk-cloud.net:8081/d5229a56-9a29-4c96-a6eb-ca8c262e5203-714451384/"];
//
////    [self joinRoomSerial:@"955853115" Path:@"global.talk-cloud.net:8081/bdcc23ed-de68-4edf-8c17-c832d20fc8a4-955853115/"];
//
////    [self joinRoomSerial:@"1134584077" Path:@"global.talk-cloud.net/media/1134584077/11351/1568026808634/1/"];
//}

//- (void)joinRoomSerial:(NSString *)serialstr Path:(NSString *)playpathstr {
//
//    if (serialstr.length == 0 ) {
//
//        [self showToastWithString:@"教室号不能为空"];
//        return;
//    }
//
//    if (playpathstr.length == 0) {
//        [self showToastWithString:@"昵称不能为空"];
//        return;
//
//    }
//
////      @"userrole":@(2),
//
//    NSDictionary *tDict = @{
//                            @"serial"  :serialstr,
//                            @"path"    : playpathstr,
//                            @"playback":@(YES),
//                            @"type":@"0",//房间类型 0 1v1 3 1v多 10
//                            @"userrole":@(2),
//                            @"host" :sHost,
//                            @"clientType" :@(3),//设备类型1 PC
//                            @"port" :sPort,//可省略略
//                            };
//
//
////    NSLog(@"")
//
//    [[TKEduClassRoom shareInstance] joinPlaybackRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:YES];
//
//
//
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
