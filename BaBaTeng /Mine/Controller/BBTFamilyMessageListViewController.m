//
//  BBTFamilyMessageListViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTFamilyMessageListViewController.h"
#import "FamilyMessageListCell.h"
#import "BBTMineRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTUserInfo.h"
#import "QMessage.h"
#import "QMessageDataList.h"
#import "QMessageData.h"
#import "BBTFamilyMessageDetailsViewController.h"
#import "QinvitationStatus.h"
#import "Qreceiver.h"
#import "Qsender.h"
#import "QFamily.h"
#import "AttributedLbl.h"
#import "MessageTool.h"
@interface BBTFamilyMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataImageArray;


@property (strong, nonatomic) UIImageView  *newsBgView;

@property (strong, nonatomic) UIImageView  *noNewsBgView;

@property (strong, nonatomic) UILabel  *promptLabel;

@property (strong, nonatomic) QMessageDataList *resultRespone;

@property (strong, nonatomic) MessageTool  *messagetool;

@property (nonatomic, assign)   NSInteger pageNum;

@property (nonatomic, strong) QMessageData *qMessageData;

@end

@implementation BBTFamilyMessageListViewController


static BBTFamilyMessageListViewController *bbtFamilyMessageListViewController;

+(BBTFamilyMessageListViewController *)getInstance{
    
    return bbtFamilyMessageListViewController;
}

- (void)returnRefresh{
    
    [self autoRefresh];
}

- (MessageTool *)messagetool
{
    if (_messagetool == nil) {
        _messagetool  = [[MessageTool alloc] init];
    }
    return _messagetool;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title  = @"家人邀请";
    
    //[self.view addSubview: self.newsBgView];
    bbtFamilyMessageListViewController = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight-64) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self.view addSubview:self.noNewsBgView];
    
    [self.view addSubview:self.promptLabel];
    
    self.promptLabel.hidden  = YES;
    self.noNewsBgView.hidden  = YES;
    
    self.dataArray = [NSMutableArray array];
    
    self.pageNum=1;
    [self autoRefresh];
    [self pullRefresh];//上拉刷新
}

#pragma mark UITableView + 下拉刷新 默认
- (void)autoRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
    //  [self connectionData];
    self.pageNum =1;
    [self GETFamilyNotices];
    
}


#pragma mark UITableView + 上拉刷新
- (void) pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    
    self.pageNum++;
    
    NSLog(@"self.pageNum==%ld", (long)self.pageNum);
    NSLog(@"[self.qMessageData.pages intValue]==%d",[self.qMessageData.pages intValue]);
    
    if (self.pageNum>[self.qMessageData.pages intValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    
    
    [BBTMineRequestTool GETFamilyNoticesspageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] pageSize:@"20" upload:^(QMessage *respone) {
        
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            // self.qMessageData = respone.data;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            array = respone.data.list;
            
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            for (int i = 0; i < array.count; i++) {
                
                QMessageDataList *list = [array objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_fm",list.invitationId];
                model.isRead = @"0";
                model.isShow = @"1";
                model.status = @"2";
                [modelarr addObject:model];
            }
            
            
            
            [self.messagetool insertMessageArr:modelarr];
            
            
            //数据所有数据标注成已读
            [self.messagetool updateMessage:@"update t_message set isShow = 1 where isShow = 0 and status = 2"];
            
            [self.dataArray addObjectsFromArray:array];
            
            
            if (self.dataArray.count==0) {
                
                self.promptLabel.hidden  = NO;
                self.noNewsBgView.hidden  = NO;
                self.tableView.hidden = YES;
                
            }else{
                
                self.promptLabel.hidden  = YES;
                self.noNewsBgView.hidden  = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
    
}




-(void)GETFamilyNotices{
    
    [BBTMineRequestTool GETFamilyNoticesspageNum:@"1" pageSize:@"20" upload:^(QMessage *respone) {
        
        
        [self.tableView.mj_header endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qMessageData = respone.data;
            
            self.dataArray = respone.data.list;
            
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.dataArray.count; i++) {
                
                QMessageDataList *list = [self.dataArray objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_fm",list.invitationId];
                model.isRead = @"0";
                model.isShow = @"1";
                model.status = @"2";
                [modelarr addObject:model];
            }
            
            
            
            [self.messagetool insertMessageArr:modelarr];
            
            
            //数据所有数据标注成已读
            [self.messagetool updateMessage:@"update t_message set isShow = 1 where isShow = 0 and status = 2"];
            
            
            
            
            if (self.dataArray.count==0) {
                
                self.promptLabel.hidden  = NO;
                self.noNewsBgView.hidden  = NO;
                self.tableView.hidden = YES;
                
            }else{
                
                self.promptLabel.hidden  = YES;
                self.noNewsBgView.hidden  = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
}





#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    FamilyMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[FamilyMessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    self.resultRespone =  self.dataArray[indexPath.row];
    cell.dateLabel.text =  self.resultRespone.createTime;
    
    
    NSString *str;
    NSUInteger range;
    NSUInteger range1;
    NSUInteger range2;
    NSUInteger range3;
    if ([[[TMCache sharedCache] objectForKey:@"userId"]isEqualToString:self.resultRespone.sender.userId]) {
        
        str= [NSString stringWithFormat:@"我邀请%@加入%@",self.resultRespone.receiver.nickName,self.resultRespone.family.familyName];
        //   NSString *range2str= [NSString stringWithFormat:@"我邀请%@",self.resultRespone.receiver.nickName];
        range =0;
        range1 =1;
        range2 =3;
        range3 =self.resultRespone.receiver.nickName.length;
        
    }else if ([[[TMCache sharedCache] objectForKey:@"userId"]isEqualToString:self.resultRespone.receiver.userId]){
        
        str= [NSString stringWithFormat:@"%@邀请我加入%@",self.resultRespone.sender.nickName,self.resultRespone.family.familyName];
        
        NSString *range2str= [NSString stringWithFormat:@"%@邀请",self.resultRespone.sender.nickName];
        range =0;
        range1 =self.resultRespone.sender.nickName.length;
        range2 =range2str.length;
        range3 =1;
        
    }else{
        
        str= [NSString stringWithFormat:@"%@邀请%@加入%@",self.resultRespone.sender.nickName,self.resultRespone.receiver.nickName,self.resultRespone.family.familyName];;
        
        NSString *range2str= [NSString stringWithFormat:@"%@邀请",self.resultRespone.sender.nickName];
        range =0;
        range1 =self.resultRespone.sender.nickName.length;
        range2 =range2str.length;
        range3 =self.resultRespone.receiver.nickName.length;
    }
    
    
    //   cell.nameLabel.text = str;
    
    
    [AttributedLbl setRichTwoText:cell.nameLabel titleString:str textFirstFont:[UIFont systemFontOfSize:16] fontFirstRang:NSMakeRange(range, range1) textFirstColor:[UIColor orangeColor] colorFirstRang:NSMakeRange(range, range1) textSecondFont:[UIFont systemFontOfSize:16] fontSecondRang:NSMakeRange(range2, range3) textSecondColor:[UIColor orangeColor] colorSecondRang:NSMakeRange(range2, range3)];
    
    cell.subNameLabel.text = self.resultRespone.invitationMessage;
    
    cell.stateLabel.text = self.resultRespone.invitationStatus.text;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 180;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BBTFamilyMessageDetailsViewController *familyMessageDetails = [[BBTFamilyMessageDetailsViewController alloc]init];
    
    familyMessageDetails.qMessageDataList = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:familyMessageDetails animated:YES];
    
    
}



#pragma mark -有消息的背景图片
- (UIImageView *)newsBgView{
    if (!_newsBgView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"BL_xiaoxi04"];
        bgView.userInteractionEnabled = YES;
        bgView.image = bgImage;
        _newsBgView = bgView;
    }
    return _newsBgView;
}


#pragma mark -无消息的背景图片
- (UIImageView *)noNewsBgView{
    if (!_noNewsBgView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-200, 80, 100, 100)];
        //  bgView.center = CGPointMake(kDeviceWidth/2,KDeviceHeight/2-64);
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"icon_zhanwuxiaoxi"];
        bgView.userInteractionEnabled = YES;
        bgView.image = bgImage;
        _noNewsBgView = bgView;
    }
    return _noNewsBgView;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        //背景图片
        UILabel *bgViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kDeviceWidth, 50)];
        // bgViewLabel.center = CGPointMake(kDeviceWidth/2,KDeviceHeight/2+50);
        bgViewLabel.contentMode = UIViewContentModeScaleAspectFill;
        bgViewLabel.text = @"暂未收到任何消息";
        bgViewLabel.textAlignment = NSTextAlignmentCenter;
        bgViewLabel.textColor = [UIColor lightGrayColor];
        bgViewLabel.font = [UIFont systemFontOfSize:16];
        _promptLabel = bgViewLabel;
    }
    return _promptLabel;
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


//获取当前时间戳

-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
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
