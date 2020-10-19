//
//  CurriculumNoViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CurriculumNoViewController.h"
#import "CurriculumViewController.h"

#import "CurriculumNoCell.h"

#import "BBTEAlertView.h"

#import "EnglishRequestTool.h"
#import "StudentCourse.h"
#import "StudentCourseData.h"
#import "StudentCourseList.h"

#import "EnglishCommon.h"
#import "ExperienceTimeViewController.h"
#import "UIImageView+AFNetworking.h"

#import "TKEduClassRoom.h"

#import "EnglishTimeModel.h"

@interface CurriculumNoViewController ()<UITableViewDelegate,UITableViewDataSource,TKEduRoomDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *NoClassArr;

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;
@property (nonatomic, strong)       NSString *pagetotal;

@property (nonatomic, assign)     NSUInteger noCountNum;

@property(nonatomic, strong)    UILabel *noLabel;

@property (strong, nonatomic) NSString *defaultServer;//默认服务

@property (nonatomic, strong)       NSString *selectStr;

@end

@implementation CurriculumNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.NoClassArr = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
    self.noCountNum = 0;
    
    [self LoadChlidView];
    
    [self getStudentCourse];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CurriculumNoBtnClicked:) name:@"CurriculumNoBtnClicked" object:nil];
    
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

- (void)CurriculumNoBtnClicked:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"selectStr"]];
    
    NSLog(@"sssssssssss=====%@",strtest1);
    self.selectStr = strtest1;
    
    [self.tableView reloadData];
    
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
    [EnglishRequestTool GetStudentCourse:@"1" pageNum:PageStr success:^(StudentCourse *respone) {
        
        [self stopLoading];
        
         [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
//            self.NoClassArr = respone.data.list;
//
//            [self.tableView reloadData];
            
            self.pageStr = respone.data.pages;
            self.pagetotal = respone.data.total;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;
            
            
            if (array1 > 0) {
                
                [self.NoClassArr addObjectsFromArray:array1];
                
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
    [EnglishRequestTool GetStudentCourse:@"1" pageNum:@"1" success:^(StudentCourse *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.NoClassArr = respone.data.list;
            
            self.pagetotal = respone.data.total;
            
            self.pageStr = respone.data.pages;
            
            if(self.NoClassArr.count > 0)
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.NoClassArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 183 + 16;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"urriculumNocell";
    CurriculumNoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[CurriculumNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    

    cell.cancelBtn.tag = indexPath.row;
//
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.beginClassBtn.tag = indexPath.row;
    
    [cell.beginClassBtn addTarget:self action:@selector(beginClassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    StudentCourseList *listdata = [self.NoClassArr objectAtIndex:indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
    
    cell.nameLabel.text = listdata.teacherName;
    
//    _dateLabel.text = @"4/25 周三";
    cell.dateLabel.text = [NSString stringWithFormat:@"%@%@",listdata.classingDate,listdata.week];
    cell.timeLabel.text = listdata.classingTime;
    
    if ([self.selectStr isEqualToString:@"1"]) {
        cell.cancelBtn.hidden = NO;
        cell.beginClassBtn.hidden = YES;
    }
    else
    {        cell.cancelBtn.hidden = YES;
        cell.beginClassBtn.hidden = NO;
    }
    

    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (void)beginClassBtnClicked:(UIButton *)btn
{
    

    
    StudentCourseList *listdata = [self.NoClassArr objectAtIndex:btn.tag];


    NSDictionary *parameter = @{@"studentCourseId" : listdata.stCourseId, @"type":@"0"};

    [EnglishRequestTool getCourseCheckTimeParameter:parameter success:^(EnglishTimeModel *respone) {


        if ([respone.statusCode isEqualToString:@"0"]) {

            if ([respone.data isEqualToString:@"1"]) {
                 [self joinRoomClassNum:listdata.serial NickName:listdata.studentName];
            }
            else
            {
                [self showToastWithString:@"请在开课前10分内进入教室"];
            }

        }else{

            [self showToastWithString:respone.message];
        }



    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];

}

- (void)cancelBtnClicked:(UIButton *)btn
{

    StudentCourseList *listdata = [self.NoClassArr objectAtIndex:btn.tag];



   NSDictionary *parameter = @{@"stCourseId" : listdata.stCourseId};
    NSLog(@"sdfdfdfdfdfd=%@",listdata.stCourseId);

   BBTEAlertView *QalertView = [[BBTEAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要取消预约吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [QalertView showInView:self.view];

    __block CurriculumNoViewController *self_c = self;

    //点击按钮回调方法
    QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {

            NSLog(@"sdddddddd");

            [self startLoading];
            [EnglishRequestTool PutCancelStudentCourseParameter:parameter success:^(EnglishCommon *respone) {
                [self stopLoading];

                if ([respone.statusCode isEqualToString:@"0"]) {
                    
                    [self_c showToastWithString:@"取消预约成功"];

                    [self_c.NoClassArr removeObject:listdata];

                    [self_c.tableView reloadData];
                    self.noCountNum++;
                    NSInteger noclassnum = [self.pagetotal integerValue];
                    NSString *NoClassNumStr = [NSString stringWithFormat:@"%lu",noclassnum - self.noCountNum];
                    NSDictionary *jsonDict = @{@"NoClassNum":NoClassNumStr };


                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurriculumBtnNum" object:self_c userInfo:jsonDict];



                }else{

                    [self showToastWithString:respone.message];
                }



            } failure:^(NSError *error) {

                [self stopLoading];
                [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

            }];



        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");

        }
    };
}


- (void)joinRoomClassNum:(NSString *)classnum NickName:(NSString *)nickname {

    if (classnum.length == 0 ) {
        
        [self showToastWithString:@"教室号不能为空"];
        return;
    }

    if (nickname.length == 0) {
        [self showToastWithString:@"昵称不能为空"];
        return;

    }

  

   
    [[NSUserDefaults standardUserDefaults] setObject:classnum forKey:@"meetingID"];
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickName"];


    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"userrole"];

    NSString *storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (storedServer != nil) {
        self.defaultServer = storedServer;
    } else {
        if ([TKUtil isDomain:sHost] == YES) {
            NSArray *array = [sHost componentsSeparatedByString:@"."];
            self.defaultServer = [NSString stringWithFormat:@"%@", array[0]];
        } else {
            self.defaultServer = @"global";
        }
    }

    NSDictionary *tDict = @{
                            @"serial"   :classnum,
                            @"host"    :sHost,
                            @"port"    :sPort,
                            @"nickname":nickname,
                            @"userrole":@(2),
                            @"server":self.defaultServer,
                            @"clientType":@(3)
                            };

    [[TKEduClassRoom shareInstance] joinRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:NO];
//    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:NO];


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
