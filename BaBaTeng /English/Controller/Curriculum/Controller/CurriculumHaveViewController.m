//
//  CurriculumHaveViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CurriculumHaveViewController.h"

#import "CurriculumHaveCell.h"

#import "ExperienceTimeViewController.h"

#import "EnglishRequestTool.h"
#import "StudentCourse.h"
#import "StudentCourseData.h"
#import "StudentCourseList.h"

#import "UIImageView+AFNetworking.h"
#import "ClassroomPerformanceViewController.h"
#import "ClassroomPlaybackViewController.h"

@interface CurriculumHaveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *HaveClassArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;

@property(nonatomic, strong)    UILabel *noLabel;

@end

@implementation CurriculumHaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.HaveClassArr = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
    
    [self LoadChlidView];
    
     [self getStudentCourse];
}

- (void)LoadChlidView
{
    
    
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
    
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, 50, 100, 30)];
    
    noLabel.text = @"暂无内容";
    noLabel.font = [UIFont systemFontOfSize:15.0];
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    
    noLabel.hidden = YES;
    
    self.noLabel = noLabel;
    [self.view addSubview:noLabel];
    
    [self pullRefresh];
    
    
    
    
}

#pragma mark UITableView + 上拉刷新
- (void)pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}


- (void)loadMoreData
{
    NSLog(@"更多数据");
    
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    [self startLoading];
    [EnglishRequestTool GetStudentCourse:@"2" pageNum:PageStr success:^(StudentCourse *respone) {
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            //            self.NoClassArr = respone.data.list;
            //
            //            [self.tableView reloadData];
            
            self.pageStr = respone.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;
            
            
            if (array1 > 0) {
                
                [self.HaveClassArr addObjectsFromArray:array1];
                
                [self.tableView reloadData];
                
            }
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}




- (void)getStudentCourse
{
    [self startLoading];
    [EnglishRequestTool GetStudentCourse:@"2" pageNum:@"1" success:^(StudentCourse *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.HaveClassArr = respone.data.list;
            
            self.pageStr = respone.data.pages;
            
            if (self.HaveClassArr.count > 0) {
                
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.HaveClassArr.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 183 + 16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"urriculumhavecell";
    CurriculumHaveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[CurriculumHaveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
    
//    cell.experienceBtn.tag = indexPath.row;
//    [cell.experienceBtn addTarget:self action:@selector(experienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    StudentCourseList *listdata = [self.HaveClassArr objectAtIndex:indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
    
    cell.nameLabel.text = listdata.teacherName;
    
    //    _dateLabel.text = @"4/25 周三";
    cell.dateLabel.text = [NSString stringWithFormat:@"%@%@",listdata.classingDate,listdata.week];
    cell.timeLabel.text = listdata.classingTime;
    
    cell.classroomperformanceBtn.tag = indexPath.row;
    cell.classroomplaybackBtn.tag = indexPath.row;
    
    [cell.classroomperformanceBtn addTarget:self action:@selector(classroomperformanceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.classroomplaybackBtn addTarget:self action:@selector(classroomplaybackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}

- (void)classroomplaybackBtnClicked:(UIButton *)btn
{
    
    
    StudentCourseList *listdata = [self.HaveClassArr objectAtIndex:btn.tag];
    ClassroomPlaybackViewController  *ClassroomPlaybackVC = [[ClassroomPlaybackViewController  alloc] init];
    
    ClassroomPlaybackVC.serial = listdata.serial;
    
    [self.navigationController pushViewController:ClassroomPlaybackVC animated:YES];
}


- (void)classroomperformanceBtnClicked:(UIButton *)btn
{
    
    StudentCourseList *listdata = [self.HaveClassArr objectAtIndex:btn.tag];
    
    ClassroomPerformanceViewController *ClassroomPerformanceVC = [[ClassroomPerformanceViewController alloc] init];
    ClassroomPerformanceVC.courseId = listdata.taCourseId;
    
    [self.navigationController pushViewController:ClassroomPerformanceVC animated:YES];
}


- (void)experienceBtnClicked:(UIButton *)btn
{
    
    StudentCourseList *listdata = [self.HaveClassArr objectAtIndex:btn.tag];
    
    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
    
    ExperiencetimeControlVC.teacherId = listdata.teacherId;
    
    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
