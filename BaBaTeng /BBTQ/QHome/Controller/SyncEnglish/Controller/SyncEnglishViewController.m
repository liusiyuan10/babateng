//
//  SyncEnglishViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/10/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "SyncEnglishViewController.h"
#import "Header.h"
#import "SyncEnglishCell.h"
#import "MySyncEnglishCell.h"
#import "BBTQAlertView.h"

#import "SyncEnglishRequest.h"

#import "SyncEnglishModel.h"
#import "SyncEnglishModelData.h"

#import "MyEnglishModel.h"
#import "MyEnglishDataModel.h"
#import "EnglishCommon.h"


#import "UIImageView+AFNetworking.h"

@interface SyncEnglishViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BBTQAlertView *_QalertView;
}


@property(nonatomic, strong) UIView *heardView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *EnglishType;

@property (nonatomic, strong) UIButton *noBookImageView;

@property(nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *SyncEnglishArray;

@property (nonatomic, strong) NSMutableArray *MyEnglishArray;

@end

@implementation SyncEnglishViewController

-(UIButton *)noBookImageView
{
    if (_noBookImageView == nil) {
        _noBookImageView = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 239)/2.0, (KDeviceHeight - 341)/2.0 - 60, 239, 341)];
//        _noBookImageView.image = [UIImage imageNamed:@"Syncemptystate"];
        [_noBookImageView setImage: [UIImage imageNamed:@"Syncemptystate"] forState:UIControlStateNormal];
        [_noBookImageView addTarget:self action:@selector(noBookImageViewClicked) forControlEvents:UIControlEventTouchUpInside];
        _noBookImageView.hidden = YES;
        
        [self.view addSubview:_noBookImageView];
    }
    
    return _noBookImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"英语学习";
    self.EnglishType = @"1";// 1为我的课本，2为全部课本
    self.SyncEnglishArray = [NSMutableArray array];
    self.MyEnglishArray = [NSMutableArray array];
    
    [self LoadChlidView];
    
    [self getMyEnglishlist];
    [self GetEnglishList];
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


-(void)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"我的课本",@"全部课本",nil];
    
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
    
    self.segmentedControl = segmentedControl;
}

- (void)noBookImageViewClicked
{
    self.segmentedControl.selectedSegmentIndex = 1; 
    [self indexDidChangeForSegmentedControl:self.segmentedControl];
}


- (void)getMyEnglishlist
{
    [self startLoading];
    [SyncEnglishRequest getMyEnglishListParameter:nil success:^(MyEnglishModel *response) {
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.MyEnglishArray = response.data;
            
            if (self.MyEnglishArray.count == 0) {
                self.noBookImageView.hidden = NO;
                self.tableView.hidden = YES;
            }
            else
            {
                self.EnglishType = @"1";
                self.tableView.hidden = NO;
                self.noBookImageView.hidden = YES;
                [self.tableView reloadData];
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
- (void)GetEnglishList
{
    [self startLoading];
    [SyncEnglishRequest getEnglishListParameter:nil success:^(SyncEnglishModel *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
           self.SyncEnglishArray = response.data;
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



-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        NSLog(@"我的课本");

        [self getMyEnglishlist];
        
//        if (self.MyEnglishArray.count == 0) {
//
//            self.noBookImageView.hidden = NO;
//            self.tableView.hidden = YES;
//        }
//        else
//        {
//            self.EnglishType = @"1";
//            self.tableView.hidden = NO;
//            self.noBookImageView.hidden = YES;
//
//
//            [self.tableView reloadData];
//        }
        
    }else if( sender.selectedSegmentIndex == 1 )
    {
        NSLog(@"所有课本");
         self.tableView.hidden = NO;
        self.noBookImageView.hidden = YES;
        self.EnglishType = @"2";
        
        [self.tableView reloadData];
    }
}


#pragma mark - 数据源方法
// 如果没有实现，默认为1，分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

// 每个分组中的数据总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if ([self.EnglishType isEqualToString:@"1"]) {
        
        return self.MyEnglishArray.count;
    }else if([self.EnglishType isEqualToString:@"2"])
    {
        return self.SyncEnglishArray.count;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.EnglishType isEqualToString:@"1"]) {
        
        return 65.0;
    }else if([self.EnglishType isEqualToString:@"2"])
    {
        return 132.0;
    }
    
    return 0.0;
    
}

// 告诉表格控件，每一行cell单元表格的细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *CellIdentifier = @"SyncEnglishcell";
    
//    SyncEnglishCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[SyncEnglishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle
//        = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
//
//    }
//
//    cell.labTip.text = @"人教版小学三年级英语下";

    
    if ([self.EnglishType isEqualToString:@"1"]) {
        
        NSString *CellIdentifier = @"mySyncEnglishcell";
        MySyncEnglishCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MySyncEnglishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
    
        }
    
        MyEnglishDataModel *datamodel = [self.MyEnglishArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = datamodel.trackName;
       
        cell.timeLabel.text = [self getMMSSFromSS:datamodel.duration];
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)datamodel.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SyncEnglishimage_my"]];
        
        return cell;
    }else if([self.EnglishType isEqualToString:@"2"])
    {
        NSString *CellIdentifier = @"SyncEnglishcell";
        SyncEnglishCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SyncEnglishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle
            = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
    
        }
        
        SyncEnglishModelData *listdata = [self.SyncEnglishArray objectAtIndex:indexPath.row];
    
        cell.labTip.text =listdata.trackListName;
        
  
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SyncEnglishimage"]];
//        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SyncEnglishimage"]];
        
        
        if ([listdata.studying isEqualToString:@"1"]) {
            [cell.beginLearnBtn setTitle:@"正在学习" forState:UIControlStateNormal];
            cell.beginLearnBtn.backgroundColor = [UIColor lightGrayColor];
            cell.beginLearnBtn.enabled = NO;
        }
        
        else
        {
            [cell.beginLearnBtn setTitle:@"开始学习" forState:UIControlStateNormal];
            
            cell.beginLearnBtn.backgroundColor = [UIColor orangeColor];
            cell.beginLearnBtn.enabled = YES;
        }
        
        cell.beginLearnBtn.tag = indexPath.row;
        [cell.beginLearnBtn addTarget:self action:@selector(beginLearnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return cell;
    }
    
    return nil;
    
}

- (void)beginLearnBtnClicked:(UIButton *)btn
{
    
    SyncEnglishModelData *listdata = [self.SyncEnglishArray objectAtIndex:btn.tag];
    
    NSDictionary *parameter = @{@"trackListId" : listdata.trackListId};
    
    _QalertView = [[BBTQAlertView alloc] initWithSYNCBBTTitle:@"温馨提示" andWithMassage:@"您确定要选择《人教版小学三年级英语》开始学习吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];

    __block SyncEnglishViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            [self_c startLoading];
            [SyncEnglishRequest AddmyEnglishListParameter:parameter success:^(EnglishCommon *response) {
                [self_c stopLoading];
                if ([response.statusCode isEqualToString:@"0"]) {
  
                    [self_c showToastWithString:@"设置成功，请按设备英语键开始学习吧"];
                    
                    [self_c GetEnglishList];
                    
                }
                else{
                    
                    [self_c showToastWithString:response.message];
                }
                
            } failure:^(NSError *error) {
                
                [self_c stopLoading];
                [self_c showToastWithString:@"网络连接失败，请检查您的网络设置!"];
                
            }];


            NSLog(@"sf");

            
        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");

        }
    };
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    //    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
