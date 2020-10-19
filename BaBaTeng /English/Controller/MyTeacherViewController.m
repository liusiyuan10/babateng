//
//  MyTeacherViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "MyTeacherViewController.h"

#import "ExperienceTimeViewController.h"

#import "TeacherDetailViewController.h"

#import "MyTeacherCell.h"

#import "EnglishRequestTool.h"
#import "MyEgTeacher.h"
#import "MyEgTeacherData.h"

#import "UIImageView+AFNetworking.h"

#import "ExperienceCollectionViewCell.h"
#import "ExpericecgLayout.h"
#import "ParentSayViewController.h"


static NSString *MyTeachercellID = @"MyTeachercell";

@interface MyTeacherViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *myteacherarr;

@property(nonatomic, strong)    UILabel *noLabel;

@property (nonatomic, strong) UIButton *ExperienceBtn;
@property (nonatomic, assign) NSInteger pageIndex;


@end

@implementation MyTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的老师";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myteacherarr = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
    [self getMyTeacher];
    
    self.pageIndex = 0;
    
}

- (void)getMyTeacher
{
    [self startLoading];
    [EnglishRequestTool getTeacherMyselfTeachersParameter:nil success:^(MyEgTeacher *respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.myteacherarr = respone.data;
            if(self.myteacherarr.count > 0)
            {
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


- (void)LoadChlidView
{
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight-kDevice_IsE_iPhoneX)style:UITableViewStylePlain];
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
    
    
//    CGRect collectionViewFrame= CGRectMake(0, 22, kDeviceWidth, KDeviceHeight - 200);
//
//
//    ExpericecgLayout *flowLayout   = [[ExpericecgLayout alloc] init];
//
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
//    collectionView.backgroundColor = [UIColor clearColor];
//    collectionView.showsHorizontalScrollIndicator = NO;
//    collectionView.showsVerticalScrollIndicator = NO;
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
//    _myCollectionView = collectionView;
//    [self.view addSubview:collectionView];
//
//    [self.myCollectionView registerClass:[ExperienceCollectionViewCell class] forCellWithReuseIdentifier:MyTeachercellID];
//
//    self.ExperienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(68 , KDeviceHeight - 64 - 50 - 44 - kDevice_IsE_iPhoneX, kDeviceWidth - 68*2, 44)];
//
//    self.ExperienceBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
//    [self.ExperienceBtn setTitle:@"预约" forState:UIControlStateNormal];
//    [self.ExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    self.ExperienceBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
//
//    [self.ExperienceBtn addTarget:self action:@selector(experienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.ExperienceBtn.layer.cornerRadius = 22; //设置图片圆角的尺度
//    self.ExperienceBtn.layer.masksToBounds = YES; //没这句话它圆不起来
//
//    [self.view addSubview:self.ExperienceBtn];
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, 50, 100, 30)];
    
    noLabel.text = @"暂无内容";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
    [self setNavigationItem];
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"家长说" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(PanrentSay) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)PanrentSay
{
   
    ParentSayViewController *ParentSayControlVC = [[ParentSayViewController alloc] init];
    
  
    [self.navigationController pushViewController:ParentSayControlVC animated:YES];
}


//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//
//    return self.myteacherarr.count;
//}
//
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    ExperienceCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:MyTeachercellID forIndexPath:indexPath];
//    if (!cell ) {
//        NSLog(@"cell为空,创建cell");
//        cell = [[ExperienceCollectionViewCell alloc] init];
//
//    }
//
//
//
//
//     MyEgTeacherData *egteacherdata = [self.myteacherarr objectAtIndex:indexPath.row];
//
//    cell.teacherLabel.text = egteacherdata.name;
//
//    //        _numLabel.text = @"剩余可预约次数:20";
//
//    cell.noLabel.text = egteacherdata.toBeReservedTimes;
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)egteacherdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.iconImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
//
//    //    NSMutableAttributedString *introductionstr =[[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《存工资服务协议》%@",@"用户协议"];
//    NSString *introductionstr = [NSString stringWithFormat:@"%@%@",egteacherdata.introduction,@""];
//
//    //    NSString *introductionstr = teacherdata.introduction;
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[introductionstr stringByAppendingString:@">>更多详情"]];
//    //    [NSMutableAttributedString stringWithFormat:@"%@%@",teacherdata.introduction,@"用户协议"];
//
//    [attrStr addAttribute:NSForegroundColorAttributeName value:MNavBackgroundColor range:NSMakeRange(attrStr.length - 6, 6)];
//
//    cell.descLabel.attributedText = attrStr;
//    cell.descLabel.userInteractionEnabled = YES;
//
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnViewwClicked:)];
//    cell.descLabel.tag = indexPath.row;
//    [cell.descLabel addGestureRecognizer:singleTap];
//
//
//
//    return cell;
//}
//
//
//
////点击item方法
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//}
//
//
//- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
//    //1.根据偏移量判断一下应该显示第几个item
//    CGFloat offSetX = targetContentOffset->x;
//
//    CGFloat itemWidth = kDeviceWidth - 100;
//
//    //item的宽度+行间距 = 页码的宽度
//    NSInteger pageWidth = itemWidth;
//
//    //根据偏移量计算是第几页
//    NSInteger pageNum = (offSetX+pageWidth/2)/pageWidth;
//
//    //2.根据显示的第几个item，从而改变偏移量
//    //    targetContentOffset->x = pageNum*pageWidth;
//
//    NSLog(@"----------------%ld",(long)pageNum);
//    self.pageIndex = pageNum;
//
//    //    self.currentIndex = pageNum;
//
//}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.myteacherarr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 113;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"myteachercell";
    MyTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[MyTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }

    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnViewwClicked:)];
    cell.iocnView.tag = indexPath.row;
    [cell.iocnView addGestureRecognizer:singleTap];
    
    cell.experienceBtn.tag = indexPath.row;
    [cell.experienceBtn addTarget:self action:@selector(experienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    MyEgTeacherData *egteacherdata = [self.myteacherarr objectAtIndex:indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)egteacherdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
    
    cell.nameLabel.text = egteacherdata.name;
    
    cell.numLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",egteacherdata.toBeReservedTimes];
    cell.dateLabel.text = [NSString stringWithFormat:@"最后约课时间: %@",egteacherdata.lastClassTime];
    

    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MyEgTeacherData *egteacherdata = [self.myteacherarr objectAtIndex:indexPath.row];
    
    
    TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];
    
    TeacherDetailControlVC.teacherId = egteacherdata.teacherId;
    
    [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];
}

-(void)iocnViewwClicked:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIView *views = (UIView*) tap.view;
    
    NSUInteger tag = views.tag;
    
    NSLog(@"-----tag-------------%lu",(unsigned long)tag);

    MyEgTeacherData *egteacherdata = [self.myteacherarr objectAtIndex:tag];
    
    
    TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];
    
    TeacherDetailControlVC.teacherId = egteacherdata.teacherId;
    
    [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];
    
    
}


- (void)experienceBtnClicked:(UIButton *)btn
{
    
    MyEgTeacherData *egteacherdata = [self.myteacherarr objectAtIndex:btn.tag];
    
    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
    ExperiencetimeControlVC.teacherId = egteacherdata.teacherId;
    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
