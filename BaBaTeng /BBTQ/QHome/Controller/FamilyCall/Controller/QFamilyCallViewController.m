//
//  QFamilyCallViewController.m
//  BaBaTeng
//
//  Created by liu on 17/12/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QFamilyCallViewController.h"
#import "QFamilyCallCell.h"

#import "QContactViewController.h"
#import "QRecentCallViewController.h"
#import "QRecentCallDetailViewController.h"
#import "QEditContactViewController.h"
#import "QFamilyCallRequestTool.h"

#import "QFamilyCall.h"
#import "QFamilyCallData.h"
#import "QFamilyCalldeviceData.h"
#import "QFamilyCalllatelyFamilyPhoneData.h"
#import "QFamilytopContactData.h"

#import "UIImageView+AFNetworking.h"

#import "QFamilyAllContact.h"

#import "QEditCallPhoneNumViewController.h"




@interface QFamilyCallViewController ()<UITableViewDelegate,UITableViewDataSource,QFamilyCallCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QFamilyCalldeviceData *devicedata;
@property (nonatomic, strong) QFamilyAllContact *latelyFamilyPhonedata;

@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UIImageView *heardImagview;

@property (nonatomic, strong)  UILabel *phoneLabel;

@property (nonatomic, assign)  NSInteger RoeNum;

@property (nonatomic, strong)  UIView *panel;

@property (nonatomic, strong)  UIView *nopanel;

@property (nonatomic, strong) NSArray *topContacts;


//@property (nonatomic, strong) UILabel *FamilyNameLabel;
//@property (nonatomic, strong) UILabel *FamilyNumLabel;
//@property (nonatomic, strong) UIImageView *iconImageView;

//@property (nonatomic, strong) QFamilyCalldeviceData *devicedata;

@end

@implementation QFamilyCallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"亲情电话";
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];

    self.RoeNum = 0;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
    

    
    self.topContacts = [NSArray array];
    [self LoadChlidView];
    
//    [self GetfamilyPhoneInfo];
}

- (void)LoadChlidView
{
    
    UIView *familyCallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120/668.0 *KDeviceHeight)];
    
    familyCallView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:familyCallView];
    
    UIImageView *heardImagview = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 27/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
    
    heardImagview.image = [UIImage imageNamed:@"BBZL_icon_touxian"];
    
    [familyCallView addSubview:heardImagview];
    
    self.heardImagview = heardImagview;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heardImagview.frame) + 8/375.0 *kDeviceWidth, 38 /668.0*KDeviceHeight, 200, 22)];
    nameLabel.text = @"小宝";
//    nameLabel.text = self.devicedata.deviceName;
    nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [familyCallView addSubview:nameLabel];
    
    self.nameLabel = nameLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heardImagview.frame) + 8/375.0 *kDeviceWidth, CGRectGetMaxY(nameLabel.frame) + 8, 100, 17)];
//    phoneLabel.text = @"16375594360";
    phoneLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    phoneLabel.font = [UIFont systemFontOfSize:12.0];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    
    phoneLabel.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneLabelClicked)];
    [phoneLabel addGestureRecognizer:phoneTap];
    
    [familyCallView addSubview:phoneLabel];
    
    self.phoneLabel = phoneLabel;
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), CGRectGetMaxY(nameLabel.frame) + 8, 20, 20)];
    
//    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    [editBtn setImage:[UIImage imageNamed:@"edit_img"] forState:UIControlStateNormal];
    
//    [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [familyCallView addSubview:editBtn];
    
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 119, kDeviceWidth, 1.0)];
//
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//
//    [familyCallView addSubview:lineView];

    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(familyCallView.frame),kDeviceWidth, KDeviceHeight - CGRectGetMaxY(familyCallView.frame))];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)phoneLabelClicked
{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.phoneLabel.text];
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (version >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)editBtnClicked
{
    QEditCallPhoneNumViewController *QEditCallPhoneNumVC = [[QEditCallPhoneNumViewController alloc] init];
    
    QEditCallPhoneNumVC.phoneNumstr = self.devicedata.phoneNumber;
    
    [self.navigationController pushViewController:QEditCallPhoneNumVC animated:YES];
}

-(void)GetfamilyPhoneInfo
{
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    
    [QFamilyCallRequestTool GetfamilyPhoneInfoParameter:parameter success:^(QFamilyCall *response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.devicedata = response.data.device;
            
            self.nameLabel.text = self.devicedata.deviceName;
            
            if (self.devicedata.phoneNumber.length == 0) {
                self.phoneLabel.text = @"请输入设备手机号码";
                self.phoneLabel.userInteractionEnabled = NO;
            }
            else
            {
                self.phoneLabel.text = self.devicedata.phoneNumber;
                self.phoneLabel.userInteractionEnabled = YES;
            }
            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.devicedata.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
            [self.heardImagview setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
            
            self.latelyFamilyPhonedata = response.data.latelyFamilyPhone;
            
            self.topContacts = response.data.topContacts;
            
            
            
            
//            if (response.data.topContacts > 0) {
//
//                self.panel.backgroundColor=  [UIColor whiteColor];
//            }
//            else
//            {
            
//            }
            
            
             [self.tableView reloadData];
            
//            if (self.latelyFamilyPhonedata != nil || response.data.topContacts.count > 0) {
//                self.RoeNum = 1;
//            }else if(self.latelyFamilyPhonedata != nil && response.data.topContacts.count > 0)
//            {
//                self.RoeNum = 2;
//            }
            
           
            
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
    
//    return self.RoeNum;
    
    return 2;
    
    
}

// 告诉表格控件，每一行cell单元表格的细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        
        NSString *CellIdentifier = @"FamilyCallcell";
        
        QFamilyCallCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[QFamilyCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        cell.delegate = self;
        
        cell.heardLabel.text = @"最近通话";

        
        if (self.latelyFamilyPhonedata == nil) {
            cell.cellView.hidden = YES;
            cell.nocellView.hidden = NO;
        }else
        {
            cell.cellView.hidden = NO;
            cell.nocellView.hidden = YES;
        }
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.latelyFamilyPhonedata.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [cell.iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
        
        cell.FamilyNameLabel.text = self.latelyFamilyPhonedata.nickName;
        cell.FamilyNumLabel.text = self.latelyFamilyPhonedata.phoneNumber;
        
        NSString *timeStampString  = self.latelyFamilyPhonedata.startCallTime;
        
        // iOS 生成的时间戳是10位
        NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
        
        cell.inboundLabel.text = dateString;
        
        NSString *calltimeStr = [NSString stringWithFormat:@"%d", [self.latelyFamilyPhonedata.endCallTime integerValue] - [self.latelyFamilyPhonedata.startCallTime integerValue]];
        
        [cell.moreBtn addTarget:self action:@selector(moreCallBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
        
        
//        cell.BreatheoutLabel.text = @"20分10秒";
        
//        self.BreatheoutView.image
        
        if ([self.latelyFamilyPhonedata.type isEqualToString:@"1"]) {
            
       
            cell.BreatheoutView.image = [UIImage imageNamed:@"icon_Exhale"];
        }
        else if ([self.latelyFamilyPhonedata.type isEqualToString:@"0"])
        {
            
            cell.BreatheoutView.image = [UIImage imageNamed:@"icon_missed"];
        }
        else if([self.latelyFamilyPhonedata.type isEqualToString:@"2"])
        {
            
           cell.BreatheoutView.image = [UIImage imageNamed:@"icon_Incoming"];
        }
        
        cell.BreatheoutLabel.text = [self getMMSSFromSS:calltimeStr];
        

        
        return cell;
    }
    else
    {
        
        NSString *CellIdentifier = @"FamilyCallcell";
        
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
//        cell.textLabel.text = @"最长通话";
        
        [cell.contentView addSubview:self.FamilyView];
        
            if (self.topContacts.count > 0) {

                self.panel.hidden=  NO;
                self.nopanel.hidden = YES;
            }
            else
            {
                self.panel.hidden=  YES;
                self.nopanel.hidden = NO;
            }
        
//        self.FamilyNumLabel.text = @"sdfsdfds";
        
        return cell;

    }
//    cell.textLabel.text = @"亲情电话";
    
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (indexPath.row == 0) {
//
//        if (self.latelyFamilyPhonedata == nil) {
//            return 54/668.0*KDeviceHeight;
//        }else
//        {
//           return 174/668.0*KDeviceHeight;
//        }
//
//    }
//    else
//    {
//          return 100;
//    }
//

//     return 174/667.0*KDeviceHeight;
    
    return 174.0;
  
}


-(UIView*)FamilyView{

    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 174/668.0*KDeviceHeight)];
    
    
    
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 54)];
    
    heardView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    
    [container addSubview:heardView];
    
    QFamilytopContactData *contactdata = [[QFamilytopContactData alloc] init];
    
    if (self.topContacts.count > 0) {
        contactdata = [self.topContacts objectAtIndex:0];
        
        container.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        container.backgroundColor = DefaultBackgroundColor;
    }
    
    UILabel *heardLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 24, 100, 20)];
    heardLabel.font = [UIFont systemFontOfSize:14.0];
    heardLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    heardLabel.textAlignment = NSTextAlignmentLeft;
    heardLabel.text = @"联系人";
    
    
    [heardView addSubview:heardLabel];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 86, 26, 57, 18)];
    
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    
    [moreBtn setTitleColor:[UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [moreBtn addTarget:self action:@selector(moreContactBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [heardView addSubview:moreBtn];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moreBtn.frame), 28, 14, 14)];
    
    arrowImageView.image = [UIImage imageNamed:@"icon_more04"];
    
    [heardView addSubview:arrowImageView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(familyheardViewClicked)];
    [heardView addGestureRecognizer:singleTap];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth, 120)];
    
    panel.backgroundColor = [UIColor whiteColor];
    
    [container addSubview:panel];
    
    UITapGestureRecognizer *panelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panelViewClicked)];
    [panel addGestureRecognizer:panelTap];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
//    iconImageView.image = [UIImage imageNamed:@"Oval Copy"];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)contactdata.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [iconImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    
    
    [panel addSubview:iconImageView];
    

    
    
//    UILabel *FamilyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 8/375.0 *kDeviceWidth, 38/668.0*KDeviceHeight, 100, 22)];
    
//        CGSize tilteSize = [bulltindata.bulletinTitle sizeWithMaxSize:CGSizeMake(tilteW, MAXFLOAT) fontSize:18];
    
     UILabel *FamilyNameLabel = [[UILabel alloc] init];
    
    
    FamilyNameLabel.font = [UIFont systemFontOfSize:16];
    FamilyNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    FamilyNameLabel.textAlignment = NSTextAlignmentLeft;
    FamilyNameLabel.text = contactdata.nickName;
    
//    CGSize tilteSize = [contactdata.nickName sizeWithMaxSize:CGSizeMake(tilteW, MAXFLOAT) fontSize:16];
     CGSize familyNameLabelsize = [contactdata.nickName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,nil]];
    FamilyNameLabel.frame =(CGRect){{CGRectGetMaxX(iconImageView.frame) + 8/375.0 *kDeviceWidth,40/668.0*KDeviceHeight},familyNameLabelsize};
    
    [panel addSubview:FamilyNameLabel];
    
    UIImageView *normalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(FamilyNameLabel.frame) + 8,38/668.0*KDeviceHeight, 24, 15)];

    normalImageView.image = [UIImage imageNamed:@"contact_normal"];

    [panel addSubview:normalImageView];

    
    UILabel *FamilyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 8/375.0 *kDeviceWidth, CGRectGetMaxY(FamilyNameLabel.frame) + 16 , 100, 17)];
    
    FamilyNumLabel.font = [UIFont systemFontOfSize:12];
    FamilyNumLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    FamilyNumLabel.textAlignment = NSTextAlignmentLeft;
    
    FamilyNumLabel.text = contactdata.phoneNumber;
    
    [panel addSubview:FamilyNumLabel];

    
    self.panel = panel;
    

    self.nopanel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth, 120)];
    
    self.nopanel.backgroundColor = [UIColor whiteColor];
    
    [container addSubview:self.nopanel];
    
    
   UIImageView *noiconView = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
    
    noiconView.image = [UIImage imageNamed:@"contact_n"];
    
    [self.nopanel addSubview:noiconView];
    
    UILabel *noFamilhCallLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noiconView.frame) + 8/375.0 *kDeviceWidth,  49/668.0*KDeviceHeight, 100, 22)];
    
    noFamilhCallLabel.font = [UIFont systemFontOfSize:16];
    noFamilhCallLabel.text = @"无常用联系人";
    noFamilhCallLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    noFamilhCallLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.nopanel addSubview:noFamilhCallLabel];
    
    
    return container;
}

- (void)familyheardViewClicked
{
    NSLog(@"联系人");
    
    QContactViewController *QContactVC = [[QContactViewController alloc] init];
    
    
    [self.navigationController pushViewController:QContactVC animated:YES];
}

- (void)moreContactBtnClicked
{
    NSLog(@"联系人");
    
    QContactViewController *QContactVC = [[QContactViewController alloc] init];
    
    [self.navigationController pushViewController:QContactVC animated:YES];
}

- (void)moreCallBtnCilcked
{
    
    QRecentCallViewController *QRecentCallVC = [[QRecentCallViewController alloc] init];
    
    [self.navigationController pushViewController:QRecentCallVC animated:YES];
    NSLog(@"更多通话");
    
}

#pragma mark - QFamilyCallCellDelegate

-(void)qfamilycall:(QFamilyCallCell *)heardViewClicked
{
    
    QRecentCallViewController *QRecentCallVC = [[QRecentCallViewController alloc] init];
    
    [self.navigationController pushViewController:QRecentCallVC animated:YES];
    NSLog(@"更多通话");
}

- (void)qfamilycallcellView:(QFamilyCallCell *)cellViewClicked
{
    
    QRecentCallDetailViewController *QRecentCallDetailVC = [[QRecentCallDetailViewController alloc] init];
    
//    self.latelyFamilyPhonedata.
    
    QRecentCallDetailVC.contactsId =  self.latelyFamilyPhonedata.contactsId;
    QRecentCallDetailVC.FamilyContact = self.latelyFamilyPhonedata;
    
    [self.navigationController pushViewController:QRecentCallDetailVC animated:YES];
    
    NSLog(@"通话详情");
}

- (void)panelViewClicked
{
    QEditContactViewController *QEditContactVC = [[QEditContactViewController alloc] init];
    
    if (self.topContacts.count > 0) {
        
        QEditContactVC.FamilyContact = [self.topContacts objectAtIndex:0];
    }
    
    
    [self.navigationController pushViewController:QEditContactVC animated:YES];
}

- (void)paneloneViewClicked
{
    
    QEditContactViewController *QEditContactVC = [[QEditContactViewController alloc] init];
    
    if (self.topContacts.count > 0) {
        
        QEditContactVC.FamilyContact = [self.topContacts objectAtIndex:0];
    }
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
     [self GetfamilyPhoneInfo];
    
    
//    //去除导航栏下方的横线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    
}
@end
