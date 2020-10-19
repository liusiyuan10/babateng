//
//  CurriculumViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CurriculumViewController.h"
#import "TapSliderScrollView.h"
#import "CurriculumNoViewController.h"
#import "CurriculumHaveViewController.h"
#import "CurriculumCancelViewController.h"

#import "EnglishRequestTool.h"
#import "TotalCourse.h"
#import "TotalCourseData.h"

@interface CurriculumViewController ()<SliderLineViewDelegate>

@property (nonatomic, copy) NSString *canceledCount;
@property (nonatomic, copy) NSString *classedCount;
@property (nonatomic, copy) NSString *noClassedCount;

@property (nonatomic, assign) NSUInteger cancelCountNum;

@property (nonatomic,strong)NSMutableArray *LbuttonViewArr;

@property (nonatomic,strong) UIButton *rightbutton;

@end

@implementation CurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"课程表";
    
//    [self LoadChlidView];
    self.LbuttonViewArr = [NSMutableArray array];
    
    self.cancelCountNum = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CurriculumBtnNum:) name:@"CurriculumBtnNum" object:nil];
    
    [self getToalStudentCourse];
    
}

- (void)CurriculumBtnNum:(NSNotification *)noti
{
    
    NSLog(@"sddsdsddddddddddddddddddddd");
    
    NSString *Numstr = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"NoClassNum"]];
    
//    NSUInteger cancelCount = [self.canceledCount integerValue] + 1;
    self.cancelCountNum++;

    NSString *cancelNumstr = [NSString stringWithFormat:@"%ld",[self.canceledCount integerValue] + self.cancelCountNum];
    
    if (self.LbuttonViewArr.count > 0) {
        
        UIButton *btn = [self.LbuttonViewArr objectAtIndex:0];
        
        [btn setTitle:[NSString stringWithFormat:@"未上课(%@)",Numstr] forState:UIControlStateNormal];
        
        UIButton *btn1 = [self.LbuttonViewArr objectAtIndex:2];
        
        [btn1 setTitle:[NSString stringWithFormat:@"已取消(%@)",cancelNumstr] forState:UIControlStateNormal];
        
        
        
    }
    

    
}


- (void)getToalStudentCourse
{
    [self startLoading];
    [EnglishRequestTool getToalStudentCourseParameter:nil success:^(TotalCourse *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.canceledCount = respone.data.canceledCount;
            self.classedCount = respone.data.classedCount;
            self.noClassedCount = respone.data.noClassedCount;
            
            [self LoadChlidView];
            
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
    CurriculumNoViewController *CurriculumnoControlVC = [[CurriculumNoViewController alloc] init];
    CurriculumHaveViewController *CurriculumhaveControlVC = [[CurriculumHaveViewController alloc] init];
    CurriculumCancelViewController *CurriculumcancelControlVC = [[CurriculumCancelViewController alloc] init];
    
    TapSliderScrollView *viewControlVC = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    viewControlVC.delegate = self;
    //设置滑动条的颜色
    viewControlVC.sliderViewColor = MNavBackgroundColor;
    viewControlVC.titileColror = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    viewControlVC.selectedColor = MNavBackgroundColor;//x
    
    
    
    [viewControlVC createView:@[[NSString stringWithFormat:@"未上课(%@)",self.noClassedCount],[NSString stringWithFormat:@"已上课(%@)",self.classedCount],[NSString stringWithFormat:@"已取消(%@)",self.canceledCount]] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] andRootVc:self];
    
    
//    [viewControlVC createView:@[@"未上课(3)",@"已上课(2)",@"已取消(1)"] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] andRootVc:self];
    
    self.LbuttonViewArr = viewControlVC.LbuttonViewArr;
    
    [self.view addSubview:viewControlVC];
    
    //自动滑动到第二页
    [viewControlVC sliderToViewIndex:0];
    
    [self setNavigationItem];
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.rightbutton = rightbutton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)rightbuttonClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"llllllllll======%d",btn.selected);
    
    
    if (btn.selected) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    { [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    NSString *selectStr = [NSString stringWithFormat:@"%d",btn.selected];
    
    NSDictionary *jsonDict = @{@"selectStr":selectStr };
   [[NSNotificationCenter defaultCenter] postNotificationName:@"CurriculumNoBtnClicked" object:self userInfo:jsonDict];
}
    


#pragma mark sliderDelegate
-(void)sliderViewAndReloadData:(NSInteger)index
{
    
    NSLog(@"刷新数据啦%ld",(long)index);
    if (index == 0) {
        
        self.rightbutton.hidden = NO;
    }
    else
    {
        self.rightbutton.hidden = YES;
    }
    
    if (index == 2) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurriculumCancelRefresh" object:self userInfo:nil];
        
    }

}

- (void)backForePage
{
//    NSLog(@"sdfsdfsdcccccc");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
