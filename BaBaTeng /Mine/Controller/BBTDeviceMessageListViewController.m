//
//  BBTDeviceMessageListViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/11.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTDeviceMessageListViewController.h"
#import "DeviceMessageListCell.h"
#import "BBTMineRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTUserInfo.h"
#import "QMessage.h"
#import "QMessageDataList.h"
#import "QMessageData.h"
#import "AttributedLbl.h"
#import "MessageModel.h"
#import "MessageTool.h"
@interface BBTDeviceMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

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

@implementation BBTDeviceMessageListViewController

- (MessageTool *)messagetool
{
    if (_messagetool == nil) {
        _messagetool  = [[MessageTool alloc] init];
    }
    return _messagetool;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title  = @"设备通知";
    
    //[self.view addSubview: self.newsBgView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight-64) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self.view addSubview:self.noNewsBgView];
    
    [self.view addSubview:self.promptLabel];
    
    self.promptLabel.hidden  = YES;
    self.noNewsBgView.hidden  = YES;
    
    self.dataArray = [NSMutableArray array];
    
    
    
    // Do any additional setup after loading the view.
    
    [self GETDeviceNotices];
    
    
    self.pageNum=1;
    
    [self pullRefresh];//上拉刷新
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
    
    
    [BBTMineRequestTool GETDeviceNoticespageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] pageSize:@"20" upload:^(QMessage *respone) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qMessageData = respone.data;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            array = respone.data.list;
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            for (int i = 0; i < array.count; i++) {
                
                QMessageDataList *list = [array objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_sb",list.deviceNoticeId];
                model.isRead = @"0";
                model.isShow = @"1";
                model.status = @"1";
                [modelarr addObject:model];
            }
            
            
            
            [self.messagetool insertMessageArr:modelarr];
            
            
            //数据所有数据标注成已读
            [self.messagetool updateMessage:@"update t_message set isShow = 1 where isShow = 0 and status = 1"];
            
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


-(void)GETDeviceNotices{
    
    self.pageNum =1;
    
    [BBTMineRequestTool GETDeviceNoticespageNum:@"1" pageSize:@"20" upload:^(QMessage *respone) {
        
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.qMessageData = respone.data;
            self.dataArray = respone.data.list;
            
            NSMutableArray *modelarr = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.dataArray.count; i++) {
                
                QMessageDataList *list = [self.dataArray objectAtIndex:i];
                
                MessageModel *model = [[MessageModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@_sb",list.deviceNoticeId];
                model.isRead = @"0";
                model.isShow = @"1";
                model.status = @"1";
                [modelarr addObject:model];
            }
            
            
            
            [self.messagetool insertMessageArr:modelarr];
            
            
            //数据所有数据标注成已读
            [self.messagetool updateMessage:@"update t_message set isShow = 1 where isShow = 0 and status = 1"];
            
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
    
    DeviceMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[DeviceMessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    self.resultRespone =  self.dataArray[indexPath.row];
    
    if (self.resultRespone.deviceNoticeContent.length >0) {
        
        // NSLog(@"deviceNoticeContent===%@",self.resultRespone.deviceNoticeContent);
        // NSString* str = @"  十年前，【∫我刚入】行的时候】】】】】，曾经认为自己】】】】将【会永远做一个【C++程序员】【【【【  】】】】";
        NSString *temp = nil;
        NSMutableArray *indexArrayone = [[NSMutableArray alloc]init];
        NSMutableArray *indexArraytwo = [[NSMutableArray alloc]init];
        
        for(int i =0; i < [self.resultRespone.deviceNoticeContent length]; i++)
        {
            temp = [self.resultRespone.deviceNoticeContent substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"["]||[temp isEqualToString:@"【"]) {
                // NSLog(@"第%d个字是:%@", i, temp);
                [indexArrayone addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        for(int i =0; i < [self.resultRespone.deviceNoticeContent length]; i++)
        {
            temp = [self.resultRespone.deviceNoticeContent substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"]"]||[temp isEqualToString:@"】"]) {
                //NSLog(@"第%d个字是:%@", i, temp);
                [indexArraytwo addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        
        
        
        
        if (indexArrayone.count>1&&indexArraytwo.count>1) {
            // NSLog(@"11111111111111==================");
            
            float range;
            float range1;
            float range2;
            float range3;
            
            
            range = [[indexArrayone objectAtIndex:0] floatValue];  // [indexArrayone[0] integerValue];
            
            if ([[indexArraytwo objectAtIndex:0] floatValue]>[[indexArrayone objectAtIndex:0] floatValue]) {
                
                range1= [[indexArraytwo objectAtIndex:0] floatValue]-[[indexArrayone objectAtIndex:0] floatValue]+1;
                
            }else{
                
                range1 = 0;
            }
            
            range2= [[indexArrayone objectAtIndex:1] floatValue];  // [indexArrayone[0] integerValue];
            
            if ([[indexArraytwo objectAtIndex:1] floatValue]>[[indexArrayone objectAtIndex:1] floatValue]) {
                
                range3= [[indexArraytwo objectAtIndex:1] floatValue] - [[indexArrayone objectAtIndex:1] floatValue]+1;
                
                
            }else{
                
                range3 = 0;
            }
            
            
            
            
            if (range1>=0&&range3>=0) {
                
                [AttributedLbl setRichTwoText:cell.subNameLabel titleString:self.resultRespone.deviceNoticeContent textFirstFont:[UIFont systemFontOfSize:16] fontFirstRang:NSMakeRange(range, range1) textFirstColor:[UIColor orangeColor] colorFirstRang:NSMakeRange(range, range1) textSecondFont:[UIFont systemFontOfSize:16] fontSecondRang:NSMakeRange(range2, range3) textSecondColor:[UIColor orangeColor] colorSecondRang:NSMakeRange(range2, range3)];
            }else{
                
                cell.subNameLabel.text = self.resultRespone.deviceNoticeContent;
            }
            
            
        }else{
            
            
            cell.subNameLabel.text = self.resultRespone.deviceNoticeContent;//self.resultRespone.deviceNoticeContent;
            
        }
        
        
    }else{
        
        cell.subNameLabel.text = self.resultRespone.deviceNoticeContent;
        
    }
    
    
    
    cell.dateLabel.text =  self.resultRespone.createTime;
    
    
    return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = @"Identifier";
//
//    DeviceMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell==nil) {
//        cell = [[DeviceMessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    }
//
//    self.resultRespone =  self.dataArray[indexPath.row];
//    cell.dateLabel.text =  self.resultRespone.createTime;
//    cell.subNameLabel.text = self.resultRespone.deviceNoticeContent;
//
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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

//#pragma mark -无消息的背景图片
//- (UIImageView *)noNewsBgView{
//    if (!_noNewsBgView) {
//        //背景图片
//        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        bgView.center = CGPointMake(kDeviceWidth/2,KDeviceHeight/2-64);
//        bgView.contentMode = UIViewContentModeScaleAspectFill;
//        UIImage *bgImage = [UIImage imageNamed:@"icon_zhanwuxiaoxi"];
//        bgView.userInteractionEnabled = YES;
//        bgView.image = bgImage;
//        _noNewsBgView = bgView;
//    }
//    return _noNewsBgView;
//}
//
//- (UILabel *)promptLabel{
//    if (!_promptLabel) {
//        //背景图片
//        UILabel *bgViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
//        bgViewLabel.center = CGPointMake(kDeviceWidth/2,KDeviceHeight/2+50);
//        bgViewLabel.contentMode = UIViewContentModeScaleAspectFill;
//        bgViewLabel.text = @"暂未收到任何消息";
//        bgViewLabel.textAlignment = NSTextAlignmentCenter;
//        bgViewLabel.textColor = [UIColor lightGrayColor];
//        bgViewLabel.font = [UIFont systemFontOfSize:16];
//        _promptLabel = bgViewLabel;
//    }
//    return _promptLabel;
//}


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
