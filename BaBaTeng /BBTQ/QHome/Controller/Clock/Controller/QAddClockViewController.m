//
//  QEditClockViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QAddClockViewController.h"

#import "QEditClockCell.h"

#import "QClockBellViewController.h"
#import "QClockClueViewController.h"

#import "QClockRequestTool.h"

#import "QClockCommon.h"

@interface QAddClockViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//列表Arr
@property(strong,nonatomic)NSArray *titlearray;

@property(strong,nonatomic) NSArray * week_img;
@property(strong,nonatomic) NSArray * unselect_week_img;

//选中时间
@property(strong,nonatomic)NSDate *selectedDate;

//时间picker
@property(strong,nonatomic)UIDatePicker *clockDatePicker;

@property(nonatomic, copy) NSString *clockBellStr;
@property(nonatomic, copy) NSString *clockBellId;
@property(nonatomic, copy) NSString *clockClueStr;
@property(nonatomic, copy) NSString *repeatStr;

@property(nonatomic, copy) NSString *timeStr;

@property (nonatomic,strong) NSMutableArray *weekBtnArr;
@property (nonatomic,strong) NSMutableArray *weekArr;

@property (nonatomic,strong) UIButton *weekAllBtn;

@end

@implementation QAddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"闹钟设置";
    
    self.titlearray=@[@"重复",@"提示语",@"铃声"];
    
//    self.week_img =  @[@"clock_Mo_s",@"clock_Tu_s",@"clock_We_s",@"clock_Th_s",@"clock_Fr_s",@"clock_Sa_s",@"clock_Su_s"];
//    self.unselect_week_img = @[@"clock_Mo_n",@"clock_Tu_n",@"clock_We_n",@"clock_Th_n",@"clock_Fr_n",@"clock_Sa_n",@"clock_Su_n"];
    
    self.week_img =  @[@"clock_Su_s",@"clock_Mo_s",@"clock_Tu_s",@"clock_We_s",@"clock_Th_s",@"clock_Fr_s",@"clock_Sa_s"];
    self.unselect_week_img = @[@"clock_Su_n",@"clock_Mo_n",@"clock_Tu_n",@"clock_We_n",@"clock_Th_n",@"clock_Fr_n",@"clock_Sa_n"];

    
    self.clockBellStr = @"请选择铃声";
    self.clockClueStr = @"请选择提示语";
    
    self.weekBtnArr = [[NSMutableArray alloc] init];
    
    self.weekArr = [[NSMutableArray alloc] init];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QClockBellRefresh:) name:@"QClockBellRefresh" object:nil];
    
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QClockClueRefresh:) name:@"QClockClueRefresh" object:nil];
    
    [self LoadChlidView];
}



- (void)LoadChlidView
{
    [self setUpNavigationItem];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64)style:UITableViewStylePlain];
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
    

}

- (void)QClockBellRefresh:(NSNotification *)noti
{
    self.clockBellStr = [noti.userInfo objectForKey:@"ClockBell"];
    
    self.clockBellId = [noti.userInfo objectForKey:@"ClockBellID"];
    
    [self.tableView reloadData];
}

- (void)QClockClueRefresh:(NSNotification *)noti
{
    self.clockClueStr = [noti.userInfo objectForKey:@"ClockClue"];
    

    [self.tableView reloadData];
}

- (void)setUpNavigationItem
{

    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    [rightbutton setTitle:@"存储" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(storageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.titlearray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 229;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 229)];
    heardView.backgroundColor = DefaultBackgroundColor;
    
    self.clockDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 228)];

    if (self.selectedDate == nil) {
        self.clockDatePicker.date = [NSDate date];
    }
    else
    {
        self.clockDatePicker.date = self.selectedDate;
    }
    


    self.clockDatePicker.datePickerMode = UIDatePickerModeTime;
//
    
    
    self.selectedDate = [self.clockDatePicker date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.timeStr = [dateFormatter stringFromDate:self.selectedDate];
    
    [self.clockDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [heardView addSubview:self.clockDatePicker];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 228, kDeviceWidth, 1)];

    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];

    [heardView addSubview:lineView];
    
    return heardView;
    
    
}

-(void)datePickerValueChanged:(id)sender
{
    self.selectedDate = [self.clockDatePicker date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    [dateFormatter setDateFormat:@"HH:mm"];
    
//     cell.detailLabel.text = [dateFormatter stringFromDate:self.selectedDate];
    self.timeStr = [dateFormatter stringFromDate:self.selectedDate];
    NSLog(@"date: %@", self.selectedDate);
//    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"QEditClockcell";
    
    QEditClockCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[QEditClockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = DefaultBackgroundColor;
        
    }

    cell.titleLabel.text =  self.titlearray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            
        {
            
            cell.subLabel.hidden = YES;
            cell.arrowView.hidden = YES;
            int start_x = 80;
            
            UIButton *weekAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 8, 70, 48)];
            
            [weekAllBtn setImage:[UIImage imageNamed:@"clock_all_n"] forState:UIControlStateNormal];
            [weekAllBtn setImage:[UIImage imageNamed:@"clock_all_s"] forState:UIControlStateSelected];
//            weekAllBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [weekAllBtn addTarget:self action:@selector(weekAllBtnClicked:) forControlEvents: UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:weekAllBtn];
            
            self.weekAllBtn = weekAllBtn;
            
            
            CGFloat buttonW = (kDeviceWidth - 85)/7.0;
            
            for (int v=0; v < 7; v ++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(start_x, 8, 48, 48);
                [button setImage:[UIImage imageNamed:[self.unselect_week_img objectAtIndex:v]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[self.week_img objectAtIndex:v]] forState:UIControlStateSelected];
//                button.imageView.contentMode = UIViewContentModeScaleAspectFit;

                [button addTarget:self action:@selector(setweek:) forControlEvents: UIControlEventTouchUpInside];
                button.tag = v+1;
                [cell.contentView addSubview:button];
//                start_x += 34;
                start_x += buttonW;
                
                [self.weekBtnArr addObject:button];
            }
            
        }
            
            break;
            
        case 1:
        {
            cell.subLabel.text = self.clockClueStr;
        }
            
            break;
        case 2:
        {
            cell.subLabel.text = self.clockBellStr;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void)weekAllBtnClicked:(UIButton *)button
{
    button.selected = !button.selected;
    
     [self.weekArr removeAllObjects];
    
    if (button.selected) {
        
        for (int i = 0; i < 7; i++) {
            
            UIButton *btn = [self.weekBtnArr objectAtIndex:i];
            btn.selected = YES;
             [self.weekArr addObject:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
        }
    }
    else
    {
        for (int i = 0; i < 7; i++) {
            
            UIButton *btn = [self.weekBtnArr objectAtIndex:i];
            btn.selected = NO;
            [self.weekArr removeAllObjects];
        }
    }
    
}
- (void)setweek:(UIButton *) button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.weekArr addObject:[NSString stringWithFormat:@"%ld", (long)button.tag]];
        
        
    }
    else
    {
        
         [self.weekArr removeObject:[NSString stringWithFormat:@"%ld", (long)button.tag]];
        
    }
    
    if (self.weekArr.count>=7) {
        self.weekAllBtn.selected = YES;
    }
    else
    {
        self.weekAllBtn.selected = NO;
    }
    
    
    
}

//将时间字符串转换为HH：mm
-(NSString *)getTimeStrWithNoticeTime:(NSString *)noticeTime{
    NSInteger num = [noticeTime integerValue];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        QClockClueViewController *QClockClueVC = [[QClockClueViewController alloc] init];
        
        QClockClueVC.clockClueStr = self.clockClueStr;
        
        [self.navigationController pushViewController:QClockClueVC animated:YES];
        
    }
    else if (indexPath.row == 2) {
        
        QClockBellViewController *QClockBellVC = [[QClockBellViewController alloc] init];
        
        [self.navigationController pushViewController:QClockBellVC animated:YES];
        
    }
    
}


- (void)storageBtnClicked
{

    for (int i = 0; i < self.weekArr.count; i++) {
        NSString *weekstr = [self.weekArr objectAtIndex:i];
        
        UIButton *btn = [self.weekBtnArr objectAtIndex:[weekstr integerValue] - 1];
        btn.selected = YES;
        
    }
    
    NSMutableArray *arrweek = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        
        UIButton *btn = [self.weekBtnArr objectAtIndex:i];

        
        NSLog(@" btn.selected==========%hhd",btn.selected);
        if (btn.selected) {
           [arrweek addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        
    }
    
    NSLog(@"sfssssssss=======%@",arrweek);

    if (self.timeStr.length == 0) {
        [self showToastWithString:@"请选择时间"];
        return;
    }
    if (self.clockBellId.length == 0) {

        [self showToastWithString:@"请选择铃声"];
        return;
    }
    
//       self.clockClueStr = @"请选择提示语";
    if ([self.clockClueStr isEqualToString:@"请选择提示语"]) {
        
        self.clockClueStr = @"";
    }

    if (arrweek.count == 0) {
        self.repeatStr = @"";
    }else if (arrweek.count == 1)
    {
        self.repeatStr = [NSString stringWithFormat:@"%@",[arrweek objectAtIndex:0]];
    }else if (arrweek.count > 1)
    {
        self.repeatStr = [NSString stringWithFormat:@"%@",[arrweek objectAtIndex:0]];
        for (int i = 1; i < arrweek.count; i++) {

            self.repeatStr  = [NSString stringWithFormat:@"%@,%@",self.repeatStr,[arrweek objectAtIndex:i]];
        }
    }


//    if (self.weekArr.count == 0) {
//        self.repeatStr = @"";
//    }else if (self.weekArr.count == 1)
//    {
//        self.repeatStr = [NSString stringWithFormat:@"%@",[self.weekArr objectAtIndex:0]];
//    }else if (self.weekArr.count > 1)
//    {
//        self.repeatStr = [NSString stringWithFormat:@"%@",[self.weekArr objectAtIndex:0]];
//        for (int i = 1; i < self.weekArr.count; i++) {
//
//            self.repeatStr  = [NSString stringWithFormat:@"%@,%@",self.repeatStr,[self.weekArr objectAtIndex:i]];
//        }
//    }

    NSLog(@"repeat======%@",self.repeatStr);


    NSDictionary *parameter = @{@"enable" : @"1", @"deviceId": [[TMCache sharedCache] objectForKey:@"deviceId"], @"repeat": self.repeatStr,@"songname": self.clockClueStr,@"soundId":self.clockBellId,@"time":self.timeStr};

    [self startLoading];
    [QClockRequestTool AddclockaddClockParameter:parameter success:^(QClockCommon *response) {

        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {

//            [self.navigationController popViewControllerAnimated:YES];

            [self showToastWithString:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{

            [self showToastWithString:response.message];
        }



    } failure:^(NSError *error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];

    }];




    
//    NSString *repeat;
////    NSString *repeat1;
//    for (int i = 0; i < self.weekArr.count; i++) {
//        repeat = [NSString stringWithFormat:@"%@",[self.weekArr objectAtIndex:i]];
//        repeat = [NSString stringWithFormat:@"%@,%@",repeat,[self.weekArr objectAtIndex:i]];
//    }
//
//    NSLog(@"repeat======%@",repeat);

    
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
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
