//
//  ExperienceTimeViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/18.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "ExperienceTimeViewController.h"

#import "FDSlideBar.h"
#import "MulChooseCollectView.h"

#import "TeaReservation.h"
#import "TeaReservationData.h"
#import "TeaReservationRes.h"
#import "TeaReservationTime.h"

#import "EnglishRequestTool.h"
#import "UIImageView+AFNetworking.h"

#import "EnglishCommon.h"

#import "CurriculumViewController.h"

@interface ExperienceTimeViewController ()<UIScrollViewDelegate>
{
    MulChooseCollectView * MyCollectView;
    NSMutableArray * dataArr;
    NSMutableArray * choosedArr;
}

@property (strong, nonatomic) FDSlideBar *slideBar;

@property (nonatomic, strong) NSMutableArray *choseArr1;
@property (nonatomic, strong) NSMutableArray *choseArr2;
@property (nonatomic, strong) NSMutableArray *choseArr3;
@property (nonatomic, strong) NSMutableArray *choseArr4;
@property (nonatomic, strong) NSMutableArray *choseArr5;
@property (nonatomic, strong) NSMutableArray *choseArr6;
@property (nonatomic, strong) NSString *chosestr;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray *sideritems;


@property (nonatomic, strong) UIButton *ExperienceBtn;

@property (nonatomic, strong) TeaReservationData *teareservationdata;


@property (nonatomic, copy) NSString *strTest;
@end

@implementation ExperienceTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预约课程";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.chosestr = @"0";
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:0];

    choosedArr = [[NSMutableArray alloc]initWithCapacity:0];

    self.choseArr1 = [[NSMutableArray alloc]initWithCapacity:0];

    self.choseArr2 = [[NSMutableArray alloc]initWithCapacity:0];

    self.choseArr3 = [[NSMutableArray alloc]initWithCapacity:0];
    self.choseArr4 = [[NSMutableArray alloc]initWithCapacity:0];
    self.choseArr5 = [[NSMutableArray alloc]initWithCapacity:0];
    self.choseArr6 = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.sideritems = [[NSMutableArray alloc] init];
    
//    [self LoadChlidView];
    
    [self getTeareservation];
    
   
    
    
}

- (void)getTeareservation
{
    if(self.teacherId.length == 0)
    {
        return;
    }
     NSDictionary *parameter = @{@"teacherId" : self.teacherId};
    
    [self startLoading];
    [EnglishRequestTool getTeacherReservationsParameter:parameter success:^(TeaReservation *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.teareservationdata = respone.data;
            
           
            
            if (self.teareservationdata.reservations.count >0) {
               TeaReservationRes *reservationres = [self.teareservationdata.reservations objectAtIndex:0];
                
                dataArr = reservationres.timeSlots;
                
                for (int i = 0; i < self.teareservationdata.reservations.count; i++) {
                    TeaReservationRes *reservationress = [self.teareservationdata.reservations objectAtIndex:i];
                    
//                    NSString *weerstr = [NSString stringWithFormat:@"%@\n%@",reservationress.dateMd,reservationress.week];
                    NSString *weerstr = [NSString stringWithFormat:@"%@ %@",reservationress.dateMd,reservationress.week];
                    [self.sideritems addObject:weerstr];
                    
                    
                }
                
            }
            
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

    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 125)];
    self.headView.backgroundColor =[UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 104 - 18, 21, 104, 104)];
    
    iconView.layer.cornerRadius = 52; //设置图片圆角的尺度
    iconView.layer.borderWidth = 1.0;
    iconView.layer.borderColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0].CGColor;
    iconView.clipsToBounds = YES;//去除边界
    iconView.layer.masksToBounds = YES; //没这句话它圆不起来
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.teareservationdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
    
    iconView.userInteractionEnabled = YES;
    
    [self.headView  addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 52,200, 18)];
    
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    nameLabel.text = self.teareservationdata.name;
    
    
    //    nameLabel.textAlignment = NSTextAlignmentRight;
    
    [self.headView  addSubview:nameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(nameLabel.frame) + 12,200, 13)];
    
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor colorWithRed:252/255.0 green:156/255.0 blue:32/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    numLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",self.teareservationdata.toBeReservedTimes];
    
    
    //    numLabel.textAlignment = NSTextAlignmentRight;
    
    [self.headView  addSubview:numLabel];
    
    [self.view addSubview:self.headView];
    
    
    
    [self setupSlideBar];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.slideBar.frame), kDeviceWidth,KDeviceHeight - CGRectGetMaxY(self.slideBar.frame) - 44 - 21 -64 -kDevice_Is_iPhoneX)];
    
    [self.view addSubview:self.backView];
    
    MyCollectView = [MulChooseCollectView ShareCollectviewWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height - 64 - kDevice_IsE_iPhoneX) HeaderTitle:@"全选"];
    MyCollectView.dataArr = dataArr;
    MyCollectView.choosedArr = choosedArr;
    
    MyCollectView.backgroundColor = [UIColor clearColor];
    
    __block ExperienceTimeViewController *self_c = self;
    
    MyCollectView.block = ^(NSString *chooseContent,NSMutableArray *chooseArr){
        NSLog(@"%@ %@",chooseContent,chooseArr);
        
        choosedArr = chooseArr;
        
        
        NSInteger experienNum = chooseArr.count;
        
        [self_c.ExperienceBtn setTitle:[NSString stringWithFormat:@"预约(%ld)",(long)experienNum] forState:UIControlStateNormal];
    };
    
    
    [self.backView addSubview:MyCollectView];
    

    
//    self.ExperienceBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 302)/2.0, KDeviceHeight - 66 - 43 - 44 - kDevice_IsE_iPhoneX, 302, 66)];
//    [self.ExperienceBtn setBackgroundImage:[UIImage imageNamed:@"Ebtn_Confirm"] forState:UIControlStateNormal];
//
//    [self.ExperienceBtn setTitle:@"立即预约" forState:UIControlStateNormal];
//    [self.ExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    [self.ExperienceBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.ExperienceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
//
//    [self.view addSubview:self.ExperienceBtn];
    
    self.ExperienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 21 -64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    //    _phoneView.userInteractionEnabled = NO;
    self.ExperienceBtn.backgroundColor = MNavBackgroundColor;
    self.ExperienceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.ExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ExperienceBtn setTitle:@"预约" forState:UIControlStateNormal];
    
    [self.ExperienceBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ExperienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
    self.ExperienceBtn.layer.cornerRadius= 22.0f;
    
    self.ExperienceBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.ExperienceBtn];
    

    
}






// Set up a slideBar and add it into view
- (void)setupSlideBar {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.headView.frame) + 21,200, 23)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    titleLabel.text = @"请选择上课时间";
    
    [self.view  addSubview:titleLabel];
    
    FDSlideBar *sliderBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 28, kDeviceWidth, 50)];
//    sliderBar.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0];
    sliderBar.backgroundColor = [UIColor whiteColor];
    // Init the titles of all the item
//    self.strTest = [NSString stringWithFormat:@"%@\n%@",@"04-11",@"周三"];
//    sliderBar.itemsTitle = @[self.strTest, @"04-12\n 周四", @"04-13\n 周五", @"04-14\n 周六", @"04-15\n 周日", @"04-16\n 周一", @"04-17\n 周二", @"04-18\n 周三", @"04-19\n 周四"];
    if (self.sideritems.count > 0) {
        
        sliderBar.hidden = NO;
    }else
    {
        sliderBar.hidden = YES;
    }
    
    sliderBar.itemsTitle = self.sideritems;
    
    // Set some style to the slideBar
    sliderBar.itemColor = [UIColor blackColor];
    sliderBar.itemSelectedColor = MNavBackgroundColor;
    sliderBar.sliderColor = MNavBackgroundColor;
    
    // Add the callback with the action that any item be selected
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
         TeaReservationRes *reservationres = [self.teareservationdata.reservations objectAtIndex:idx];
        
        MyCollectView.dataArr = reservationres.timeSlots;
        MyCollectView.choosedArr = choosedArr;

        [MyCollectView ReloadData];

    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
}


- (void)ExperienceBtnClicked:(UIButton *)btn
{
    
    if (choosedArr.count == 0) {
        [self showToastWithString:@"没有选择预约课程"];

        return;
    }

    NSMutableArray *courseIdsarr = [[NSMutableArray alloc] init];

    for (int i = 0; i <choosedArr.count; i++) {
        TeaReservationTime *reservationchosetime = [choosedArr objectAtIndex:i];

        [courseIdsarr addObject:reservationchosetime.courseId];

    }

    NSLog(@"courseIdsarr=====%@",courseIdsarr);
    
     btn.userInteractionEnabled = NO;

    [self startLoading];
    [EnglishRequestTool PostStudentsParameter:nil bodyArr:courseIdsarr success:^(EnglishCommon *response) {
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {

            [self showToastWithString:@"预约成功"];

             [self performSelector:@selector(ToCurriculumVC) withObject:nil afterDelay:1.4];


        }else{

            btn.userInteractionEnabled = YES;
            [choosedArr removeAllObjects];
            [courseIdsarr removeAllObjects];
            [self.ExperienceBtn setTitle:@"预约" forState:UIControlStateNormal];
            [MyCollectView ReloadData];
            [self showToastWithString:response.message];
        }

    } failure:^(NSError *error) {
        
        btn.userInteractionEnabled = YES;
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];

    
}

- (void)ToCurriculumVC
{
    CurriculumViewController *CurriculumControlVC = [[CurriculumViewController alloc] init];
    
    [self.navigationController pushViewController:CurriculumControlVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSIndexPath *indexPath = [MyCollectView indexPathForRowAtPoint:scrollView.contentOffset];
//
//    // Select the relating item when scroll the tableView by paging.
//    [self.slideBar selectSlideBarItemAtIndex:indexPath.row];
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
