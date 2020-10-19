//
//  OrderViewController.m
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "EnglishViewController.h"
#import "FYtopbannerViewCell.h"

//#import "TCRotatorImageView.h"

#import "EnglishHeadCell.h"

#import "BBTEquipmentRequestTool.h"
#import "Bulletin.h"
#import "BulletinData.h"
#import "BulletinViewController.h"

#import "SwipeView.h"

#import "EnglishTeacherCell.h"
#import "ExperienceViewController.h"

#import "TeacherDetailViewController.h"

#import "CurriculumViewController.h"

#import "ExperienceTimeViewController.h"

#import "TeacherDetailViewController.h"

#import "MyTeacherViewController.h"

#import "BuyCourseViewController.h"

#import "BBTQAlertView.h"

#import "EnglishRequestTool.h"
#import "Student.h"
#import "StudentData.h"
#import "AllEgTeacher.h"
#import "AllEgTeacherData.h"
#import "AllEgTeacherData.h"
#import "EnglishCommon.h"

#import "FreeCourseViewController.h"

#import "UIImageView+AFNetworking.h"

#import "NewPagedFlowView.h"

#import "PGIndexBannerSubiew.h"

#import "ForeignViewController.h"
#import "MybuyClassViewController.h"
#import "StudentStyleViewController.h"

#import "MyButton.h"

#import "StudentStyleMoreViewController.h"

#import "studentVideo.h"
#import "studentVideoData.h"
#import "studentVideoList.h"

#import "YGPlayInfo.h"
#import "HJVideoPlayerController.h"

#define KTitleHeight 52

@interface EnglishViewController()<UITableViewDelegate,UITableViewDataSource,FYtopbannerViewCellDelegate,SwipeViewDelegate, SwipeViewDataSource,UIGestureRecognizerDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    BBTQAlertView *_QalertView;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FYtopbannerViewCell *topCell;

@property(strong,nonatomic)  NSMutableArray *ADImageArray;

@property (nonatomic, strong)      SwipeView *swipeView;

@property(strong,nonatomic)  NSMutableArray *AllEgTeacherArray;

@property (nonatomic, strong) StudentData *studentdata;

@property (nonatomic, strong) UIView *HeardView;

@property(nonatomic,strong)UIImageView *iocnView;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *phoneView;

@property(nonatomic,strong)UIImageView *phoneImagView;

@property (nonatomic, assign) BOOL isCanSideBack;

@property(nonatomic,strong) NewPagedFlowView *pageFlowView;


@property(strong,nonatomic)  NSMutableArray *studentVideoArray;

@property (nonatomic, strong) NSMutableArray *playInfos;

//@property (nonatomic, assign) CGFloat tableviewY;
@property (nonatomic, copy) NSString *tableViewType;

@property (nonatomic, strong) UIView *buttonListContainer;

@property (nonatomic, strong) UIView *experienceView;

@end

@implementation EnglishViewController




- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"英语";
    // Do any additional setup after loading the view.


//    [self AddBannerView];

    self.tableViewType = @"0";
    
    self.ADImageArray = [[NSMutableArray alloc] init];

    self.AllEgTeacherArray = [[NSMutableArray alloc] init];

    self.studentVideoArray = [[NSMutableArray alloc] init];
    
    self.playInfos = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];



//    [self GetBulletinList];

//    [self GetAllEgTeacher];
    
       [self  example01];

  NSLog(@"kDeviceWidthindex=========%ld",(long)kDeviceWidth);
}

#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{

    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

- (void)loadNewData
{
    [self GetBulletinList];
    //
    [self GetAllEgTeacher];
    
    [self GetStudentVideo];
    
}

- (void)GetStudent
{

    [self startLoading];
    
    
    
    [EnglishRequestTool getStudentParameter:nil success:^(Student *respone) {

        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {



            self.studentdata = respone.data;

            if ([self.studentdata.studentFlg isEqualToString:@"0"]) {
                [self showToastWithString:@"你还没有预约过课程"];
            }

            self.numLabel.text = self.studentdata.remainingCourses;
            if (self.self.studentdata.courseValidity.length == 0) {
               self.timeLabel.text = @"---";
            }
            else
            {
                self.timeLabel.text = self.studentdata.courseValidity;

            }

//            [self.tableView reloadData];

        }else{

            [self showToastWithString:respone.message];
        }

    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}

- (void)GetAllEgTeacher
{
    [self startLoading];
    
    [EnglishRequestTool getAllEgTeacherParameter:nil success:^(AllEgTeacher *respone) {

        [self stopLoading];
        
         [self.tableView.mj_header endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {

            self.AllEgTeacherArray = respone.data;

            [self.tableView reloadData];


        }else{

            [self showToastWithString:respone.message];
        }


    } failure:^(NSError *error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

    }];
}

- (void)GetStudentVideo
{
    [self startLoading];
    
    [EnglishRequestTool getStudentVideopageNum:@"1" success:^(studentVideo *respone) {
        
        [self stopLoading];
        
        [self.tableView.mj_header endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.studentVideoArray = respone.data.list;
            
            NSLog(@"-------%lu",(unsigned long)self.studentVideoArray.count);
            
            if (self.studentVideoArray.count > 0 && self.studentVideoArray.count < 5) {
                
                for (int i = 0; i < self.studentVideoArray.count; i++) {
                    
                    studentVideoList *trackList = [self.studentVideoArray objectAtIndex:i];
                    
                    NSLog(@"111111studentName-------%@",trackList.studentName);
                    
                    YGPlayInfo *playinfo = [[YGPlayInfo alloc] init];
                
                    playinfo.url = trackList.videoUrl;
                    playinfo.artist = trackList.studentName;
                    playinfo.title = trackList.studentName;
                    playinfo.placeholder = @"default_bg_land";
                
                
                    [self.playInfos addObject:playinfo];
                }
            }
            else if (self.studentVideoArray.count > 5)
            {
                for (int i = 0; i < 4; i++) {
                    
                    
                    studentVideoList *trackList = [self.studentVideoArray objectAtIndex:i];
                    NSLog(@"1222222studentName-------%@",trackList.studentName);
                    
                    YGPlayInfo *playinfo = [[YGPlayInfo alloc] init];
                    
                    playinfo.url = trackList.videoUrl;
                    playinfo.artist = trackList.studentName;
                    playinfo.title = trackList.studentName;
                    playinfo.placeholder = @"default_bg_land";
                    
                    
                    [self.playInfos addObject:playinfo];
                }
            }
            
            [self.tableView reloadData];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

- (void)GetBulletinList
{

    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};

    [BBTEquipmentRequestTool GetBulletinDeviceTypeId:@"2" Parameter:parameter success:^(Bulletin *response) {

        if ([response.statusCode isEqualToString:@"0"]) {

            self.ADImageArray = response.data;

            NSLog(@"self.ADImageArray%@",self.ADImageArray);

            [self.tableView reloadData];

            [self.pageFlowView reloadData];


        }else{

            [self showToastWithString:response.message];
        }

    } failure:^(NSError *error) {

//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

    }];



}


- (void)LoadChlidView
{
    [self LoadHerdView];


    CGFloat TableY = CGRectGetMaxY(self.HeardView.frame);
    CGFloat TableH = KDeviceHeight - 64-kDevice_IsE_iPhoneX;


//    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+kDevice_IsE_iPhoneX ,kDeviceWidth, TableH) style:UITableViewStyleGrouped];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+kDevice_IsE_iPhoneX ,kDeviceWidth, TableH)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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


}



-(void)LoadHerdView{


    self.HeardView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,64+kDevice_IsE_iPhoneX)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    self.HeardView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 34+kDevice_IsE_iPhoneX,200, 20)];

    nameLabel.font = [UIFont boldSystemFontOfSize:21];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    nameLabel.text = @"巴巴腾在线少儿英语";
    nameLabel.textAlignment = NSTextAlignmentLeft;

    [self.HeardView addSubview:nameLabel];


    self.phoneView = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 29 - 19,29+kDevice_IsE_iPhoneX ,19, 28)];

    self.phoneView.backgroundColor = [UIColor clearColor];


    [self.phoneView setImage:[UIImage imageNamed:@"nav_dh"] forState:UIControlStateNormal];


    [self.HeardView addSubview:self.phoneView];

    [self.phoneView addTarget:self action:@selector(phoneViewClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.HeardView];





}
#pragma mark --轮播图

- (NewPagedFlowView *)pageFlowView
{
    if (_pageFlowView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];//kDeviceWidth * 9 / 16
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = NO;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;
    
//        _pageFlowView.backgroundColor = [UIColor redColor];
        
        //初始化pageControl
//        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 32, kDeviceWidth, 8)];
//        _pageFlowView.pageControl = pageControl;
//        [_pageFlowView addSubview:pageControl];
    
        [_pageFlowView reloadData];
    }
    
    return _pageFlowView;
}


#pragma mark --按钮菜单

-(UIView*)buttonListContainer{
    
    if (_buttonListContainer == nil) {

        _buttonListContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,98)];
        _buttonListContainer.backgroundColor = [UIColor clearColor];
        
        _swipeView =[[SwipeView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 98)];
        _swipeView.alignment = SwipeViewAlignmentEdge;
        _swipeView.pagingEnabled = NO;//是否翻页
        _swipeView.wrapEnabled = NO;//可循环滚动
        _swipeView.scrollEnabled = NO;
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
        _swipeView.itemsPerPage = 3;
        _swipeView.truncateFinalPage = YES;
        _swipeView.backgroundColor = [UIColor whiteColor];
        
        
        [_buttonListContainer addSubview:_swipeView];
        
    }
    
    return _buttonListContainer;
    






}


//-(UIView*)buttonListContainer{
//
//    UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,98)];
//    containView.backgroundColor = [UIColor clearColor];
//
//    _swipeView =[[SwipeView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 98)];
//    _swipeView.alignment = SwipeViewAlignmentEdge;
//    _swipeView.pagingEnabled = NO;//是否翻页
//    _swipeView.wrapEnabled = NO;//可循环滚动
//    _swipeView.scrollEnabled = NO;
//    _swipeView.delegate = self;
//    _swipeView.dataSource = self;
//    _swipeView.itemsPerPage = 3;
//    _swipeView.truncateFinalPage = YES;
//    _swipeView.backgroundColor = [UIColor whiteColor];
//
//
//    [containView addSubview:_swipeView];
//
//    return containView;
//
//
//
//}

#pragma mark --体验课程
-(UIView*)experienceView{
    
    if (_experienceView == nil) {
        
        if (kDevice_IS_PAD) {
            _experienceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,242 + 21)];
            
            _experienceView.backgroundColor = [UIColor whiteColor];
            
            UIButton *experienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth - 32, 242)];
            
            [experienceBtn setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
            
            [experienceBtn addTarget:self action:@selector(experienceViewClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [_experienceView addSubview:experienceBtn];
            
            return _experienceView;
            
        }
        else
        {
            _experienceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,100 + 21)];
            
            _experienceView.backgroundColor = [UIColor whiteColor];
            
            UIButton *experienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth - 32, 100)];
            
            [experienceBtn setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
            
            [experienceBtn addTarget:self action:@selector(experienceViewClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [_experienceView addSubview:experienceBtn];
            
            return _experienceView;
            
        }

        

    }
    
    return _experienceView;

    


}



//-(UIView*)experienceView{
//
//    if (kDevice_IS_PAD) {
//        UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,242 + 21)];
//
//        containView.backgroundColor = [UIColor whiteColor];
//
//        UIButton *experienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth - 32, 242)];
//
//        [experienceBtn setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
//
//        [experienceBtn addTarget:self action:@selector(experienceViewClicked) forControlEvents:UIControlEventTouchUpInside];
//
//        [containView addSubview:experienceBtn];
//
//        return containView;
//
//    }
//    else
//    {
//        UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth,100 + 21)];
//
//        containView.backgroundColor = [UIColor whiteColor];
//
//        UIButton *experienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth - 32, 100)];
//
//        [experienceBtn setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
//
//        [experienceBtn addTarget:self action:@selector(experienceViewClicked) forControlEvents:UIControlEventTouchUpInside];
//
//        [containView addSubview:experienceBtn];
//
//        return containView;
//
//    }
//
//
//
//}




- (void)experienceViewClicked
{

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    [[AppDelegate appDelegate]suspendButtonHidden:YES];

    FreeCourseViewController *bulletinVc = [[FreeCourseViewController alloc] init];



    [self.navigationController pushViewController:bulletinVc animated:YES];





}




#pragma mark --SwipeView 代理函数

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 4;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{


//    NSArray *titleNameArray = [NSArray arrayWithObjects:@"购买课程",@"预约课程",@"课程表",@"我的老师",nil];
//    NSArray *imageArray = [NSArray arrayWithObjects:@"buykc",@"yuyuekc",@"kecheng",@"mineT",nil];
    
    NSArray *titleNameArray = [NSArray arrayWithObjects:@"预约老师",@"课程表",@"我的老师",@"我的课时",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"yuyuekc",@"kecheng",@"mineT",@"myclass",nil];
    
    NSUInteger itemCount = 4;
    
    


    UIView * mview = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width/itemCount, 98)];
    mview.backgroundColor = [UIColor whiteColor];


    int item = self.view.frame.size.width/itemCount;
    CGRect userIconRect= CGRectMake((item-32)/2,16,32, 32);


    UIImageView * selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];

    //selerListImage.contentMode = UIViewContentModeScaleToFill;
    selerListImage.contentMode = UIViewContentModeScaleAspectFit;
    selerListImage.backgroundColor = [UIColor clearColor];
    selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;

    selerListImage.image = [UIImage imageNamed:imageArray[index]];


    [mview addSubview: selerListImage];





    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,63,item-10, 16)];
    //UIColor *fontColor=[UIColor colorWithWhite:0.5f alpha:1.0f];
    label.text = titleNameArray[index];

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:112/255.0 green:109/255.0 blue:107/255.0 alpha:1.0];
    label.font=[UIFont systemFontOfSize:11.0f];
    label.backgroundColor = [UIColor clearColor];
    [mview addSubview:label];





    return mview;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index=========%ld",(long)index);

    if (index == 0) {
        ExperienceViewController *ExperienceControlVC = [[ExperienceViewController alloc] init];

        [self.navigationController pushViewController:ExperienceControlVC animated:YES];
    }
    else if (index == 1)
    {
        CurriculumViewController *CurriculumControlVC = [[CurriculumViewController alloc] init];

        [self.navigationController pushViewController:CurriculumControlVC animated:YES];
    }else if (index == 2)
    {
        MyTeacherViewController *MyTeacherControlVC = [[MyTeacherViewController alloc] init];

        [self.navigationController pushViewController:MyTeacherControlVC animated:YES];
    }
    else if (index == 3){
        
        MybuyClassViewController *MybuyClassControlVC = [[MybuyClassViewController alloc] init];
        
        [self.navigationController pushViewController:MybuyClassControlVC animated:YES];
    }else
    {
        
    }

}


#pragma mark --UITableView 代理函数


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==1) {

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        headerView.backgroundColor = [UIColor whiteColor];

//        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 3, 16)];
//        iconView.backgroundColor = MNavBackgroundColor;
//
//        [headerView addSubview:iconView];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 100, 20)];
        label.font = [UIFont boldSystemFontOfSize:21.0f];  //UILabel的字体大小
        label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        label.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = @"外教团队";

        [headerView addSubview:label];
        
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 50 - 35, 12, 50, 15)];
        sublabel.font = [UIFont boldSystemFontOfSize:15.0f];  //UILabel的字体大小
        sublabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        sublabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        sublabel.textAlignment = NSTextAlignmentRight;  //文本对齐方式
        [sublabel setBackgroundColor:[UIColor clearColor]];
        sublabel.text = @"更多";
        
        [headerView addSubview:sublabel];

        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 12 - 16, 14, 7, 12)];
//        arrowView.backgroundColor = [UIColor redColor];
//
        arrowView.image = [UIImage imageNamed:@"english_front"];
        
        [headerView addSubview:arrowView];
        
        UITapGestureRecognizer *headerViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick)];
        
        // 2. 将点击事件添加到label上
        [headerView addGestureRecognizer:headerViewGestureRecognizer];

        return  headerView;

    }else{


        return nil;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

  if (section==1){

        return 44;

    }else{

        return 0;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 4;
    }else
    {
        return self.AllEgTeacherArray.count;
    }
    
//    return 4;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {

    if (indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"EnglishcellTwo";


            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];

            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.pageFlowView];
           
//            cell.backgroundColor = [UIColor greenColor];

            
            return cell;


        }

        else  if (indexPath.row==1){

            static NSString *cellIndentifierOne = @"EnglishcellFour";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];

            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.buttonListContainer];
            cell.backgroundColor = [UIColor clearColor];
            return cell;

        }

        else  if (indexPath.row==2){

            static NSString *cellIndentifierOne = @"EnglishcellThree";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];

            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.experienceView];
            cell.backgroundColor = [UIColor clearColor];
            return cell;

        }
        else if (indexPath.row==3){
            
            static NSString *cellIndentifierOne = @"Englishcellfour";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                
            }
            for(UIView *view in [cell.contentView subviews])
            {
                [view removeFromSuperview];
            }
            
            [cell.contentView addSubview:self.StudentStyle];
            
            
            return cell;
            
            
        }
        
         else
         {
             static NSString *cellIndentifierOne = @"Englishcellother";
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
             
             if (!cell) {
                 
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                 
             }
             
             cell.textLabel.text = @"测试";
             return cell;
         }
        
    }
    else
    {
        static NSString *cellIndentifierOne = @"EnglishcellSOne";
        EnglishTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[EnglishTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        
        AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = teacherdata.name;
        
        //        _numLabel.text = @"剩余可预约次数:20";
        cell.numLabel.text = [NSString stringWithFormat:@"剩余可预约次数:%@",teacherdata.toBeReservedTimes];
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)teacherdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnViewwClicked:)];
        cell.iocnView.tag = indexPath.row;
        [cell.iocnView addGestureRecognizer:singleTap];
        
        cell.experienceBtn.tag = indexPath.row;
        cell.experienceBtn.hidden = NO;
        
        [cell.experienceBtn addTarget:self action:@selector(experienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    
        return cell;
        
    }





   

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CGFloat panelWidth = (kDeviceWidth- 16 * 3)/2+24 + 30;

 if (indexPath.section==0){
     switch (indexPath.row) {


         case 0:
               return 160 + 10;
             break;

         case 1:
             return 98;
             break;

         case 2:
             
             if (kDevice_IS_PAD) {
                 return 242+21;
             }
             else
             {
                 return 100 + 21;
             }
             break;
         case 3:
           {
//             NSInteger listcount = 1;
//
//             if (listcount >0) {
//
//                 return listcount * panelWidth +16+KTitleHeight;
//
//             }else
//                 return KTitleHeight + 16;
               
               NSInteger listcount = 0;
               
               if (self.studentVideoArray.count >0 &&self.studentVideoArray.count < 5)
               {
                   listcount =  ((self.studentVideoArray.count -1)/2 + 1);
                   
                   
                return   ((kDeviceWidth- 16 *3)/2+80) *listcount + KTitleHeight +16;
                   
               }
               else if(self.studentVideoArray.count > 4)
               {
                   listcount =  2;
                   
                   
                  return  ((kDeviceWidth- 16 *3)/2+80) *listcount + KTitleHeight + 16;
               }
               else
               {
                  return  KTitleHeight + 16;
               }
               
             
         }
             
             
//             if (kDevice_IS_PAD) {
//                 return 339;
//             }
//             else
//             {
//                 return 160;
//             }
             break;

         default:

             return 0;
             break;
     }
     
 }
    else
    {
        return 113;
    }


 

}



#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kDeviceWidth - 24*2, 160);//(kDeviceWidth - 60) * 9 / 16
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:subIndex];
    
    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    bulletinVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:bulletinVc animated:YES];

}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.ADImageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 15;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    
    BulletinData *bulletindata = self.ADImageArray[index];
    
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.bulletinIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
//    bannerView.mainImageView.backgroundColor = [UIColor purpleColor];
    
    return bannerView;
}



//-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index{
//
//    NSLog(@"index===%ld",(long)index);
//
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//
//    [[AppDelegate appDelegate]suspendButtonHidden:YES];
//
//
//    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:index];
//
//    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
//    bulletinVc.URL = [NSURL URLWithString:urlStr];
//
//    [self.navigationController pushViewController:bulletinVc animated:YES];
//
//
//}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


//    if (indexPath.section == 1) {
//
//        AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:indexPath.row];
//
//        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//
//        [[AppDelegate appDelegate]suspendButtonHidden:YES];
//
//        TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];
//
//        TeacherDetailControlVC.teacherId = teacherdata.id;
//
//        [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];
//
//
//    }
    
}

#pragma mark 学生风采

-(UIView*)StudentStyle{

    

    CGFloat panelHeight = KTitleHeight;

    
    NSInteger listcount = 0;
    
    if (self.studentVideoArray.count >0 &&self.studentVideoArray.count < 5)
    {
        listcount =  ((self.studentVideoArray.count -1)/2 + 1);
        
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+80) *listcount + KTitleHeight ;
        
    }
    else if(self.studentVideoArray.count > 4)
    {
        listcount =  2;
        
        
        panelHeight = ((kDeviceWidth- 16 *3)/2+80) *listcount + KTitleHeight ;
    }
    else
    {
        panelHeight = KTitleHeight;
    }
    
    
    
//    if (listcount > 0)
//    {
//        panelHeight = ((kDeviceWidth- 16 *3)/2+24 + 30) *listcount + KTitleHeight ;
//
//    }
//
//    else
//    {
//        panelHeight = KTitleHeight;
//    }
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, panelHeight)];
    
    container.backgroundColor = [UIColor whiteColor];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KTitleHeight)];
    tempView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:tempView];
    
    
    
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,0, kDeviceWidth-100, KTitleHeight)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.lineBreakMode = NSLineBreakByClipping;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    titleName.font = [UIFont boldSystemFontOfSize:21.0f];
    
    titleName.text =  @"学员风采";
    
    [tempView addSubview:titleName];
    
    UIButton *moreView = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 85, 0, 85, KTitleHeight)];
    moreView.backgroundColor = [UIColor clearColor];
    moreView.tag = 1;
    [moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 35, 13)];
    moreLabel.backgroundColor = [UIColor clearColor];
    //    moreLabel.lineBreakMode = NSLineBreakByClipping;
    moreLabel.textAlignment = NSTextAlignmentLeft;
    moreLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    moreLabel.font = [UIFont boldSystemFontOfSize:15.0f];;
    
    moreLabel.text =  @"更多";
    
    [moreView addSubview:moreLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+34, (KTitleHeight - 12)/2.0,7, 12)];
    moreImageView.image = [UIImage imageNamed:@"english_front"];
    
    [moreView addSubview:moreImageView];
    
    CGRect imageViewListContainerRect=CGRectMake(0,CGRectGetMaxY(tempView.frame), self.view.frame.size.width,panelHeight-KTitleHeight);
    
    UIView *imageViewListContainer = [[UIView alloc]initWithFrame:imageViewListContainerRect];
    imageViewListContainer.backgroundColor =[UIColor clearColor];
    [container addSubview:imageViewListContainer];
    
    
    if (self.studentVideoArray.count >4) {
        for(int i=0;i < 4;i++)
        {
            studentVideoList *trackList = [self.studentVideoArray objectAtIndex:i];
            
            
            CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+80)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+80);
            

            MyButton *btn = [[MyButton buttonWithType:UIButtonTypeCustom] initWithImageEnglishStudentStyle:trackList.coverUrl title:trackList.studentName Subtitle:trackList.introduction frame:rect type:@"no"];
            
            [btn addTarget:self action:@selector(StudentStyleClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i;
            [imageViewListContainer addSubview:btn];
            
        }
    }
    else
    {
        for( int i=0; i <self.studentVideoArray.count; i++)
        {
            studentVideoList *trackList = [self.studentVideoArray objectAtIndex:i];
            
            
            CGRect rect = CGRectMake((((kDeviceWidth- 16*3)/2))*(i%2) +(i%2)*16+16,(((kDeviceWidth- 16 * 3)/2+80)*(i/2)+0.5)+(i/2)*0.5, (kDeviceWidth- 16*3)/2,(kDeviceWidth- 16*3)/2+80);
            
            
            MyButton *btn = [[MyButton buttonWithType:UIButtonTypeCustom] initWithImageEnglishStudentStyle:trackList.coverUrl title:trackList.studentName Subtitle:trackList.introduction frame:rect type:@"no"];
            
            [btn addTarget:self action:@selector(StudentStyleClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i;
            [imageViewListContainer addSubview:btn];
            
        }
    }


    return container;
}

- (void)moreBtnClick:(UIButton *)btn
{
    StudentStyleMoreViewController *StudentStyleMoreVC = [[StudentStyleMoreViewController alloc] init];
    
    
    [self.navigationController pushViewController:StudentStyleMoreVC animated:YES];
}

- (void)StudentStyleClick:(UIButton *)btn
{
    
    NSLog(@"sdddd===%@",self.playInfos);
    NSLog(@"StudentStylesdfdsfsdfsdfdsfsdfdf------sdfsdfsdf ----%f",self.tableView.contentOffset.y);
    
//    self.tableviewY = self.tableView.contentOffset.y;
    YGPlayInfo *playInfo = [self.playInfos objectAtIndex:btn.tag];
 
    self.tableViewType = @"1";
    
    NSLog(@"StudentStylesdfdsfsdfsdfdsfsdfdf------playUrl===%@", playInfo.url);
    
    
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
        StudentStyleVC.playUrl =  playInfo.url;
     
        [self.navigationController pushViewController:StudentStyleVC animated:YES];
    }


}



- (void)headerViewClick
{
    ExperienceViewController *ExperienceControlVC = [[ExperienceViewController alloc] init];
    
    [self.navigationController pushViewController:ExperienceControlVC animated:YES];
    
}



-(void)iocnViewwClicked:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;

    UIView *views = (UIView*) tap.view;

    NSUInteger tag = views.tag;

    NSLog(@"-----tag-------------%lu",(unsigned long)tag);

     AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:tag];

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    [[AppDelegate appDelegate]suspendButtonHidden:YES];

    TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];

    TeacherDetailControlVC.teacherId = teacherdata.id;

    [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];


}


- (void)experienceBtnClicked:(UIButton *)btn
{
     NSLog(@"experienceBtnClicked------sdfsdfsdf ----%f",self.tableView.contentOffset.y);
     AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:btn.tag];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    [[AppDelegate appDelegate]suspendButtonHidden:YES];

    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
    ExperiencetimeControlVC.teacherId = teacherdata.id;

    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
}




- (void)phoneViewClicked
{
    NSLog(@"sg");


    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"18145863529"];
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (version >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

//- (void)ForeignViewClicked
//{
//    ForeignViewController *ForeignVC = [[ForeignViewController alloc] init];
//
//
//    [self.navigationController pushViewController:ForeignVC animated:YES];
//    
//
//    
//
//    
//    
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",self.tableView.contentOffset.y);
//    if (self.tableView.contentOffset.y <= 0) {
//        self.tableView.bounces = NO;
//
//        NSLog(@"禁止下拉");
//    }
//    else
//        if (self.tableView.contentOffset.y >= 0){
//            self.tableView.bounces = YES;
//            NSLog(@"允许上拉");
//
//        }
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 44;  //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

     [super viewWillAppear:animated];

     self.navigationController.navigationBar.translucent = NO;

     [self.navigationController setNavigationBarHidden:YES animated:NO];

     [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

     [[AppDelegate appDelegate]suspendButtonHidden:YES];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

//    self.tableView.contentOffset.y = 0;


//    CGPoint temp = self.tableView.contentOffset;
//    temp.y = 1000;
//    self.tableView.contentOffset = temp;

//    NSLog(@"sdfdsfsdfsdfdsfsdfdf------sdfsdfsdf ----%f",self.tableView.contentOffset.y);

//
////
//    [self GetBulletinList];
////
//    [self GetAllEgTeacher];
    
    

//    if (@available(iOS 13.0, *)) {
//        }
//    else
//    {
        if ([self.tableViewType isEqualToString:@"1"]) {
            [self.tableView reloadData];
            self.tableViewType = @"0";

             NSLog(@"sdfdsfsdfsdfdsfsdfdf------ 刷新shuan x");
        }
//    }



}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//
//    [[AppDelegate appDelegate]suspendButtonHidden:YES];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    [self forbiddenSideBack];
    
//    CGPoint temp = self.tableView.contentOffset;
//    temp.y = self.tableviewY;
//    self.tableView.contentOffset = temp;
//
    
//    [self.tableView reloadData];
    
    NSLog(@"11111------sdfsdfsdf=======%f",self.tableView.contentOffset.y);


}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self resetSideBack];
    


    NSLog(@"22222------sdfsdfsdf=======%f",self.tableView.contentOffset.y);
    
}



/**

 * 禁用边缘返回

 */

-(void)forbiddenSideBack{

    self.isCanSideBack = NO;

    //关闭ios右滑返回

    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

        self.navigationController.interactivePopGestureRecognizer.delegate=self;

    }

}

/*

 恢复边缘返回

 */

- (void)resetSideBack {

    self.isCanSideBack=YES;

    //开启ios右滑返回

    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

        self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {

    return self.isCanSideBack;

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
