//
//  QClockViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/27.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockViewController.h"

#import "QClockCell.h"

#import "QAddClockViewController.h"

#import "QClock.h"
#import "QClockData.h"
#import "QClockRequestTool.h"

#import "QClockBellData.h"

#import "QClockCommon.h"

#import "QEditClockViewController.h"

@interface QClockViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView           *bgnoClcokView;
@property (nonatomic, strong) UIButton         *noClockBtn;
@property (nonatomic, strong) UIView           *bgClcokView;
@property (nonatomic, strong) UIButton         *addClockBtn;
/** 定时器 **/
@property (nonatomic, strong) NSTimer *clocktimer;

@property (nonatomic, strong) NSMutableArray *ClockArr;



@end

@implementation QClockViewController

- (NSTimer *)clocktimer
{
    if (!_clocktimer) {
        _clocktimer =[NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(clockChange) userInfo:nil repeats:YES];
    }
    return _clocktimer;
}

- (void)timerInvalue
{
    [_clocktimer invalidate];
    _clocktimer  = nil;
}

-(UIButton *)noClockBtn
{
    if (_noClockBtn == nil) {
        _noClockBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 230)/2.0, (KDeviceHeight - 330)/2.0 - 60, 230, 330)];
        
        [_noClockBtn addTarget:self action:@selector(noClockBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgnoClcokView addSubview:_noClockBtn];
    }
    
    return _noClockBtn;
}

-(UIView *)bgnoClcokView
{
    if (_bgnoClcokView == nil) {
        _bgnoClcokView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        //        _deviceView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_bgnoClcokView];
    }
    
    return _bgnoClcokView;
}

-(UIView *)bgClcokView
{
    if (_bgClcokView == nil) {
        _bgClcokView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
//                _deviceView.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:_bgClcokView];
    }
    
    return _bgClcokView;
}

//-(instancetype)initWithStyle:(UITableViewStyle)style{
//    if (self = [super initWithStyle:style]) {
//        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editCellAction:)];
//        self.navigationItem.leftBarButtonItem = leftBtn;
//        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addCellAction)];
//        self.navigationItem.rightBarButtonItem = rightBtn;
//
//    }
//    return self;
//}




- (void)viewDidLoad {
    [super viewDidLoad];
   
//    self.bgnoClcokView.backgroundColor = DefaultBackgroundColor;
//
//
//

    
//    [self clocktimer];

//    self.ClockArr = [[NSMutableArray alloc] init];
    
    self.ClockArr = [NSMutableArray array];
    
    [self setUpBgNoClockView];
    [self LoadChlidView];
    
//    self.bgClcokView.hidden = YES;
//    self.bgnoClcokView.hidden = NO;
    
//    [self GetClocks];
    
    
}

- (void)LoadChlidView
{

//    [self setUpNavigationItem];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.allowsSelectionDuringEditing = YES;
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
    
    [self.bgClcokView addSubview:self.tableView];
    
    self.addClockBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 64)/2.0, KDeviceHeight - 64 - 24 - 64, 64, 64)];
    
    [self.addClockBtn setImage:[UIImage imageNamed:@"clock_add_n"] forState:UIControlStateNormal];
    [self.addClockBtn setImage:[UIImage imageNamed:@"clock_add_s"] forState:UIControlStateHighlighted];
    
    [self.addClockBtn addTarget:self action:@selector(addClockBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgClcokView addSubview:self.addClockBtn];
    
    
    
    
    
}

- (void)setUpBgNoClockView
{
    
    self.bgnoClcokView.backgroundColor = DefaultBackgroundColor;
    
    [self.noClockBtn setImage:[UIImage imageNamed:@"clock_emptystate"] forState:UIControlStateNormal];
    [self.noClockBtn setImage:[UIImage imageNamed:@"clock_emptystate"] forState:UIControlStateHighlighted];
    
    UIButton *createclockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [createclockBtn setTitle:@"创建闹钟" forState:UIControlStateNormal];
    
    
    createclockBtn.frame = CGRectMake( (kDeviceWidth - 121)/2.0, CGRectGetMaxY(self.noClockBtn.frame) + 22, 121 , 44);
    createclockBtn.backgroundColor = [UIColor clearColor];
    createclockBtn.layer.cornerRadius= 22.0f;
    createclockBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    createclockBtn.layer.borderWidth = 1.5;
    createclockBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    createclockBtn.clipsToBounds = YES;//去除边界
    [createclockBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [createclockBtn addTarget:self action:@selector(addClockBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgnoClcokView addSubview:createclockBtn];
    
}

- (void)setUpNavigationItem
{
//        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editCellAction:)];
//        self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    [rightbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(editCellAction:) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}


- (void)GetClocks
{
    NSDictionary *parameter = @{@"deviceId": [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    [QClockRequestTool getclockGetClocksParameter:parameter success:^(QClock *response) {
        
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ClockArr = response.data;
            
            if (self.ClockArr.count > 0) {
                
                [self setUpNavigationItem];
                self.bgClcokView.hidden = NO;
                self.bgnoClcokView.hidden = YES;
                
                [self.tableView reloadData];
                
            }
            else
            {
            
                self.bgClcokView.hidden = YES;
                self.bgnoClcokView.hidden = NO;
         
            }

            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}

- (void)clockChange
{
    NSLog(@"clockChangepppppppp");
    [self.tableView reloadData];
}

- (void)editCellAction:(UIButton *)barBtn{
    //刷新列表
    [self.tableView reloadData];
    //如果当前正在编辑
    if (self.tableView.editing) {
        [barBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
    else
    {
        [barBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)addClockBtnClicked
{
    QAddClockViewController *QAddClockVC = [[QAddClockViewController alloc] init];

    [self.navigationController pushViewController:QAddClockVC animated:YES];
}




- (void)noClockBtnClicked
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.ClockArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"QClockcell";
    
    QClockCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QClockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        cell.backgroundColor = [UIColor whiteColor];
//
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//
//        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        
        
    }
    
    //如果当前正在编辑
    if (self.tableView.editing) {
        cell.switchview.hidden = YES;
        cell.arrowView.hidden = NO;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.switchview.hidden = NO;
        cell.arrowView.hidden = YES;
//        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    QClockData *clockdata = [self.ClockArr objectAtIndex:indexPath.row];
    
    
//     _timeLabel.text = @"18:00";
//    _tagLabel.text = @"宝宝起床了";
//    cell.timeLabel.text = [self ClockTimeStr:clockdata.time];
    cell.timeLabel.text = clockdata.time;
    cell.tagLabel.text = clockdata.songname;
//    cell.repeatLabel.text = clockdata.repeat;
    
    cell.repeatLabel.text = [self ReapetStr:clockdata.repeat];
    
    if ([clockdata.enable isEqualToString:@"1"]) {
        cell.timeLabel.textColor = [UIColor colorWithRed:4/255.0 green:4/255.0 blue:4/255.0 alpha:1.0];
        cell.tagLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        cell.repeatLabel.textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:83/255.0 alpha:1.0];
        cell.countdownLabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
        cell.switchview.on = YES;
        cell.countdownLabel.hidden = NO;
    }
    else
    {
        cell.timeLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        cell.tagLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        cell.repeatLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        cell.countdownLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        cell.switchview.on = NO;
        cell.countdownLabel.hidden = YES;
    }
    cell.switchview.tag = indexPath.row;
    
    [cell.switchview addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
//     _repeatLabel.text = @"每天";
    
//    [self TodayYearMonthStr];
//    // 时间字符串
//    NSString *montodaystr = [self TodayYearMonthStr];
//
//    NSString *todaystr = [NSString stringWithFormat:@"%@ %@",montodaystr,clockdata.time];
//
//    // 日期格式化类
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式(为了转换成功)
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//    // NSString * -> NSDate *
//    NSDate *fireDate = [fmt dateFromString:todaystr];
//
//    NSDate *today = [NSDate date];
//
//    NSCalendarUnit unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth |kCFCalendarUnitDay |kCFCalendarUnitHour | kCFCalendarUnitMinute ;
//    NSCalendar *calender = [NSCalendar currentCalendar];
//
//    NSDateComponents *day = [calender components:unitFlags fromDate:today toDate:fireDate options:0];
//    cell.countdownLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟后闹铃", (long)[day hour], (long)[day minute]];
    
    
    
    cell.countdownLabel.text = clockdata.clockSound.soundName;
    
    return cell;
}

//- (NSString *)TodayYearMonthStr
//{
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    // 获取当前日期
//    NSDate* dt = [NSDate date];
//    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
//    unsigned unitFlags = NSCalendarUnitYear |
//    NSCalendarUnitMonth |  NSCalendarUnitDay |
//    NSCalendarUnitHour |  NSCalendarUnitMinute |
//    NSCalendarUnitSecond | NSCalendarUnitWeekday;
//    // 获取不同时间字段的信息
//    NSDateComponents* comp = [gregorian components: unitFlags
//                                          fromDate:dt];
//
//    NSString  *str = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)comp.year,(long)comp.month,(long)comp.day];
//
//
//    return str;
//
//}


//- (NSString *)ClockTimeStr:(NSString *)str
//{
////    [self TodayYearMonthStr];
//    // 时间字符串
//    NSString *montodaystr = [self TodayYearMonthStr];
//
//    NSString *todaystr = [NSString stringWithFormat:@"%@ %@",montodaystr,str];
//
//    // 日期格式化类
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式(为了转换成功)
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//    // NSString * -> NSDate *
//    NSDate *fireDate = [fmt dateFromString:todaystr];
//
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"HH:mm"];
//
//    NSString *timestr = [dateFormatter stringFromDate:fireDate];
//
//    return timestr;
//}

//- (NSString *)CountDownStr:(NSString *)str
//{
//
////    [self TodayYearMonthStr];
//    // 时间字符串
//    NSString *montodaystr = [self TodayYearMonthStr];
//
//    NSString *todaystr = [NSString stringWithFormat:@"%@ %@",montodaystr,str];
//
//    // 日期格式化类
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式(为了转换成功)
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
//
//    // NSString * -> NSDate *
//    NSDate *fireDate = [fmt dateFromString:todaystr];
//
//    NSDate *today = [NSDate date];
//
//    NSCalendarUnit unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth |kCFCalendarUnitDay |kCFCalendarUnitHour | kCFCalendarUnitMinute ;
//    NSCalendar *calender = [NSCalendar currentCalendar];
//
//    NSDateComponents *day = [calender components:unitFlags fromDate:today toDate:fireDate options:0];
//    NSString * countdownstr = [NSString stringWithFormat:@"%ld小时%ld分钟后闹铃", (long)[day hour], (long)[day minute]];
//
//
//
//    return countdownstr;
//}

- (NSString *)ReapetStr:(NSString *)str
{

    NSString *weekstr = @"";
    
    NSArray *strarray = [str componentsSeparatedByString:@","];
    if (strarray.count == 0) {
        
        weekstr = @"永不";
    }
    else if(strarray.count == 1)
    {
        NSString *arrstr = [strarray objectAtIndex:0];
        
        switch ([arrstr integerValue]) {
            case 1:
                weekstr = @"周日";
                break;
                
            case 2:
                weekstr = @"周一";
                break;
                
            case 3:
                weekstr = @"周二";
                break;
                
            case 4:
                weekstr = @"周三";
                break;
                
                
            case 5:
                weekstr = @"周四";
                break;
                
            case 6:
                weekstr = @"周五";
                break;
                
            case 7:
                weekstr = @"周六";
                break;
                
            default:
                weekstr = @"永不";
                break;
        }
        
        
    }else if(strarray.count > 1)
    {
        
        NSLog(@"strarraysdfdsfdfd====%@",strarray);
        
        NSString *arrstr = [strarray objectAtIndex:0];
        
        switch ([arrstr integerValue]) {
            case 1:
                weekstr = @"周日";
                break;
                
            case 2:
                weekstr = @"周一";
                break;
                
            case 3:
                weekstr = @"周二";
                break;
                
            case 4:
                weekstr = @"周三";
                break;
                
                
            case 5:
                weekstr = @"周四";
                break;
                
            case 6:
                weekstr = @"周五";
                break;
                
            case 7:
                weekstr = @"周六";
                break;
                
            default:
                weekstr = @"永不";
                break;
        }
        
        
        for (int i = 1; i < strarray.count; i++) {
            
            
            
            NSString *arrstr = [strarray objectAtIndex:i];
            NSString *arrweekstr = @"";
            NSLog(@"arrst==== %@",arrstr);
            
            switch ([arrstr integerValue]) {
                case 1:
                    arrweekstr = @"周日";
                    break;
                    
                case 2:
                    arrweekstr = @"周一";
                    break;
                    
                case 3:
                    arrweekstr = @"周二";
                    break;
                    
                case 4:
                    arrweekstr = @"周三";
                    break;
                    
                    
                case 5:
                    arrweekstr = @"周四";
                    break;
                    
                case 6:
                    arrweekstr = @"周五";
                    break;
                    
                case 7:
                    arrweekstr = @"周六";
                    break;
                    
                default:
                    arrweekstr = @"永不";
                    break;
            }
            
//            weekstr = [NSStrin]
            
            weekstr  = [NSString stringWithFormat:@"%@,%@",weekstr,arrweekstr];
            
            
        }
        
        
        
        
    }
    
    
    NSLog(@"weekstr=================%@",weekstr);
    
    
    
    return weekstr;
}

-(void)changeState:(UISwitch *)noticeSwitch{
    
    BOOL isButtonOn = [noticeSwitch isOn];
    
//    NSInteger lightIndex = 0;
//    if (isButtonOn) {
//
//        NSLog(@"k开关了");
//        lightIndex = 1;
//
//    }else
//    {
//        NSLog(@"k开kaile 了");
//        lightIndex = 0;
//    }
//
//
//
//    NSNumber *lightNSNumber = [NSNumber numberWithBool:isButtonOn];
    
    QClockData *clockdata = [self.ClockArr objectAtIndex:noticeSwitch.tag];
    
    NSString *enablestr = [NSString stringWithFormat:@"%hhd",isButtonOn];
    
    
    NSDictionary *parameter = @{@"enable" : enablestr, @"clockId": clockdata.clockId,@"deviceId":clockdata.deviceId,@"repeat": clockdata.repeat,@"songname": clockdata.songname,@"soundId":clockdata.soundId,@"time":clockdata.time};
    
    NSLog(@"parameter========%@",parameter);
   
    [self startLoading];
    [QClockRequestTool EditclockupdateClockParameter:parameter success:^(QClockCommon *response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
//            [self showToastWithString:@"修改成功"];
            
            if (isButtonOn) {
        
            [self showToastWithString:@"闹钟已打开"];
        
            }else
            {
              [self showToastWithString:@"闹钟已关闭"];
            }
            clockdata.enable = enablestr;
            
            [self.tableView reloadData];

            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
    

    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果当前正在编辑
    if (self.tableView.editing) {
        
//        self.navigationItem.leftBarButtonItem.title = @"编辑";
//        [self.tableView setEditing:NO animated:YES];
//        ClockTableViewController *clockVC = [ClockTableViewController new];
//        LocalNoticeModel *noticeModel = self.dataArr[indexPath.row];
//        clockVC.noticeId = noticeModel.noticeId;
//        [self.navigationController pushViewController:clockVC animated:YES];
        
        QClockData *clockdata = [self.ClockArr objectAtIndex:indexPath.row];
        
        QEditClockViewController *QEditClockVC = [[QEditClockViewController alloc] init];
        
        QEditClockVC.clockdata = clockdata;
        
        [self.navigationController pushViewController:QEditClockVC animated:YES];
        
    }
    else
    {
        
    }
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        // Delete the row from the data source
//        LocalNoticeModel *noticeModel = self.dataArr[indexPath.row];
//        LocalNoticeModelDBTool *noticeDBTool = [LocalNoticeModelDBTool shareInstance];
//        [noticeDBTool deleteModelWithkey:@"Id" value:noticeModel.noticeId];
//        [self.dataArr removeObject:noticeModel];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        QClockData *clockdata = [self.ClockArr objectAtIndex:indexPath.row];
        
        NSDictionary *parameter = @{@"clockId":clockdata.clockId};
        
        [self startLoading];
        
        [QClockRequestTool DeleteclockdeleteClockParameter:parameter success:^(QClockCommon *response) {
            
            [self stopLoading];
            if ([response.statusCode isEqualToString:@"0"]) {
                
                
                [self showToastWithString:@"删除成功"];
                
                [self.ClockArr removeObject:clockdata];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else{
                
                [self showToastWithString:response.message];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    [self GetClocks];
    
    self.tableView.editing = NO;
//    [self clocktimer];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self timerInvalue];
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
