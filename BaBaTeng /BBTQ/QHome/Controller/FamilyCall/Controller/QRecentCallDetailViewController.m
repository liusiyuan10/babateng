//
//  QRecentCallDetailViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QRecentCallDetailViewController.h"
#import "QContactDetailCell.h"

#import "QEditContactViewController.h"
#import "QFamilyCallRequestTool.h"

#import "familyPhoneRecordC.h"
#import "familyPhoneRecordCData.h"
#import "familyPhoneRecordCContact.h"
#import "familyPhoneRecordCPhone.h"

#import "UIImageView+AFNetworking.h"

@interface QRecentCallDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) familyPhoneRecordCContact *recordCContact;
@property (nonatomic, strong) QFamilyAllContact *recordCContact;


@property (nonatomic, strong) NSArray *familyPhoneRecords;

@end

@implementation QRecentCallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通话详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.familyPhoneRecords = [NSArray array];
    
//    [self LoadChlidView];
    
    [self GetfamilyPhoneRecordContactsId];
    
}


- (void)LoadChlidView
{
    
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    
    heardView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:heardView];
    
    UIImageView *heardImagview = [[UIImageView alloc] initWithFrame:CGRectMake(18, 27, 64, 64)];
    
    heardImagview.image = [UIImage imageNamed:@"BBZL_icon_touxian"];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.recordCContact.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [heardImagview setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    
    [heardView addSubview:heardImagview];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heardImagview.frame) + 16, 38, 50, 22)];
//    nameLabel.text = @"妈妈";
    nameLabel.text = self.recordCContact.nickName;
    nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [heardView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heardImagview.frame) + 16, CGRectGetMaxY(nameLabel.frame) + 8, 100, 17)];
//    phoneLabel.text = @"16375594360";
    phoneLabel.text = self.recordCContact.phoneNumber;
    phoneLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    phoneLabel.font = [UIFont systemFontOfSize:12.0];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    
    [heardView addSubview:phoneLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 38, 53, 14, 14)];//因为数据不全跳不到编辑联系人界面先屏蔽
    arrowView.image = [UIImage imageNamed:@"icon_more04"];
    
    [heardView addSubview:arrowView];
    
    UITapGestureRecognizer *heardViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heardViewClicked)];
    [heardView addGestureRecognizer:heardViewTap];
    

    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 119, kDeviceWidth, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [heardView addSubview:lineView];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(heardView.frame),kDeviceWidth, KDeviceHeight - CGRectGetMaxY(heardView.frame))];
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    
}

- (void)GetfamilyPhoneRecordContactsId
{
    
     NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"contactsId" : self.contactsId};
    
    
    [self startLoading];
    [QFamilyCallRequestTool GetfamilyPhoneRecordContactsIdParameter:parameter success:^(familyPhoneRecordC *response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
//            [self.tableView reloadData];
            
            self.recordCContact = response.data.familyContacts;
            self.familyPhoneRecords = response.data.familyPhoneRecords;
            
            [self LoadChlidView];
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
}

#pragma mark - 数据源方法
// 每个分组中的数据总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // students数组中元素的数量
    // 取出数组中对应的学员信息
    //    HMStudent *stu = self.dataList[section];
    //    return stu.students.count;
    
    return self.familyPhoneRecords.count;
    
    
}

// 告诉表格控件，每一行cell单元表格的细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"FamilyCallcellDetail";

    QContactDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle
        = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
//        cell.textLabel.text = @"最长通话";
    
    familyPhoneRecordCPhone *recordCPhone = self.familyPhoneRecords[indexPath.row];
    
    NSString *timeStampString  = recordCPhone.startCallTime;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    cell.timeLabel.text = dateString;
    
    if ([recordCPhone.type isEqualToString:@"1"]) {
        
        cell.callTypeLabel.text = @"呼出电话";
        cell.iconView.image = [UIImage imageNamed:@"icon_Exhale"];
    }
    else if ([recordCPhone.type isEqualToString:@"0"])
    {
        cell.callTypeLabel.text = @"未接电话";
        cell.iconView.image = [UIImage imageNamed:@"icon_missed"];
    }
    else if([recordCPhone.type isEqualToString:@"2"])
    {
        cell.callTypeLabel.text = @"呼入电话";
        cell.iconView.image = [UIImage imageNamed:@"icon_Incoming"];
    }
    
    NSString *calltimeStr = [NSString stringWithFormat:@"%ld", [recordCPhone.endCallTime integerValue] - [recordCPhone.startCallTime integerValue]];
    
//    cell.calltimeLabel.text = @"0分 48秒";
    
    cell.calltimeLabel.text = [self getMMSSFromSS:calltimeStr];

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
    
}

- (void)heardViewClicked
{
    QEditContactViewController *QEditContactVC = [[QEditContactViewController alloc] init];
    
//      QEditContactVC.FamilyContact = self.FamilyContact;
    
    
    QEditContactVC.FamilyContact = self.recordCContact;
    [self.navigationController pushViewController:QEditContactVC animated:YES];
    
    NSLog(@"联系人详情");
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue]/1000.0;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    
    NSString *format_time = [NSString stringWithFormat:@"%@分 %@秒",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
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
