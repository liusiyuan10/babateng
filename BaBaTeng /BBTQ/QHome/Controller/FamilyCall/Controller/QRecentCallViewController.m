//
//  QRecentCallViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/3.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QRecentCallViewController.h"

#import "QRecentCallCell.h"

#import "QFamilyCallRequestTool.h"

#import "QFamilyPhone.h"
#import "QFamilyPhoneData.h"
#import "QFamilyAllPhone.h"
#import "QFamilyUnPhone.h"
#import "QFamilyPPhone.h"

#import "UIImageView+AFNetworking.h"

#import "QRecentCallDetailViewController.h"


@interface QRecentCallViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, strong) UIView *heardView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *PhoneArr;

@property (nonatomic, strong) NSArray *AllPhoneArr;

@property (nonatomic, strong) NSArray *UnPhoneArr;



@end

@implementation QRecentCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝贝通话";
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    self.PhoneArr = [NSArray array];
    self.AllPhoneArr = [NSArray array];
    self.UnPhoneArr = [NSArray array];
    
    [self LoadChlidView];
    
    [self GetfamilyPhoneRecord];
    
    

}

- (void)LoadChlidView
{
    self.heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    self.heardView.backgroundColor = [UIColor orangeColor];

    [self.view addSubview:self.heardView];
    
    [self createSegMentController];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.heardView.frame),kDeviceWidth, KDeviceHeight - CGRectGetMaxY(self.heardView.frame))];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

- (void)GetfamilyPhoneRecord
{
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    [QFamilyCallRequestTool GetfamilyPhoneRecordParameter:parameter success:^(QFamilyPhone *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.AllPhoneArr = response.data.allPhones;
            
            self.UnPhoneArr = response.data.unansweredPhones;
            
//            self.PhoneArr = self.UnPhoneArr;
              self.PhoneArr = self.AllPhoneArr;
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

-(void)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"所有通话",@"未接来电",nil];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];

    segmentedControl.frame = CGRectMake(70, 4, kDeviceWidth - 140, 30);

    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:252/255.0 green:245/255.0 blue:248/255.0 alpha:1];
    //    segmentedControl.tintColor = [UIColor orangeColor];
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;

    segmentedControl.layer.borderWidth = 1.0;

    segmentedControl.layer.cornerRadius = 6.0f;
    segmentedControl.layer.masksToBounds = YES;
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];

    [self.heardView addSubview:segmentedControl];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        NSLog(@"所有通话");
        
         self.PhoneArr = self.AllPhoneArr;
        
        [self.tableView reloadData];
       
    }else if( sender.selectedSegmentIndex == 1 )
    {
         self.PhoneArr = self.UnPhoneArr;
        
        [self.tableView reloadData];
        NSLog(@"未接来电");
    }
}


#pragma mark - 数据源方法
// 如果没有实现，默认为1，分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.PhoneArr.count;
    
}

// 每个分组中的数据总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   QFamilyAllPhone *phone = [self.PhoneArr objectAtIndex:section];
   
    return phone.phones.count;

}

// 告诉表格控件，每一行cell单元表格的细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *CellIdentifier = @"QRecentCallcell";
    
    QRecentCallCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QRecentCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle
        = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    QFamilyAllPhone *phone = [self.PhoneArr objectAtIndex:indexPath.section];
    
    QFamilyPPhone *PPhone = [phone.phones objectAtIndex:indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)PPhone.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    
     cell.FamilyNameLabel.text = [NSString stringWithFormat:@"%@(%@)",PPhone.nickName,PPhone.numberOfCalls];
    
    
    NSString *timeStampString  = PPhone.startCallTime;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString   = [formatter stringFromDate: date];
    
    cell.timeLabel.text = dateString;
    
    if ([PPhone.type isEqualToString:@"1"]) {
        
     cell.callView.image = [UIImage imageNamed:@"icon_Exhale"];
        
    }
    else if ([PPhone.type isEqualToString:@"2"])
    {
        cell.callView.image = [UIImage imageNamed:@"icon_Incoming"];
        
    }else if ([PPhone.type isEqualToString:@"0"])
    {
        
        cell.callView.image = [UIImage imageNamed:@"icon_missed"];
        
    }
 
//    cell.FamilyNameLabel.text = @"妈妈 (2)";
//    cell.timeLabel.text = @"14:20";
    
//     self.callView.image = [UIImage imageNamed:@"icon_missed"];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 44.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44.0)];
    headView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, kDeviceWidth - 32, 20)];
    QFamilyAllPhone *phone = [self.PhoneArr objectAtIndex:section];
//    textLabel.text = @"2017年12月19日";
    textLabel.text = phone.callDate;
    textLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    textLabel.font = [UIFont systemFontOfSize:14.0];
    
    [headView addSubview:textLabel];
    
    return headView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QFamilyAllPhone *phone = [self.PhoneArr objectAtIndex:indexPath.section];
    
    QFamilyPPhone *PPhone = [phone.phones objectAtIndex:indexPath.row];
    
    QRecentCallDetailViewController *QRecentCallDetailVC = [[QRecentCallDetailViewController alloc] init];
    
    //    self.latelyFamilyPhonedata.
    
    QRecentCallDetailVC.contactsId =  PPhone.contactsId;
    
    [self.navigationController pushViewController:QRecentCallDetailVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
