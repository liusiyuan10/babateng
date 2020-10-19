//
//  TeacherDetailViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/19.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "TeacherDetailViewController.h"

#import "TeacherInfo.h"
#import "TeacherInfoData.h"
#import "EnglishRequestTool.h"
#import "UIImageView+AFNetworking.h"
#import "ExperienceTimeViewController.h"

@interface TeacherDetailViewController ()<UIScrollViewDelegate>

@property(nonatomic,copy) NSString *DetailStr;
@property(nonatomic, retain)UIScrollView *detailParamtView;
@property(nonatomic, retain)UIScrollView *ParamtView;
@property(nonatomic,strong) UIView *DetailView;

@property (nonatomic ,strong) TeacherInfoData *teacherInfodata;

@property(nonatomic,strong) UIView *HeaderView;

@end

@implementation TeacherDetailViewController

- (UIScrollView *)ParamtView
{
    if (_ParamtView == nil) {
        
        _ParamtView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KDeviceHeight - CGRectGetMaxY(self.DetailView.frame) - 64)];
        
        //        _detailParamtView.userInteractionEnabled = YES;
        
//        _ParamtView.backgroundColor = [UIColor redColor];
        _ParamtView.scrollEnabled = YES;
        _ParamtView.showsVerticalScrollIndicator =  NO;
        _ParamtView.showsHorizontalScrollIndicator = YES;
        
        _ParamtView.pagingEnabled = YES;
        _ParamtView.delegate = self;
        _ParamtView.bounces = YES;
        
        
        _ParamtView.backgroundColor = [UIColor whiteColor];
        _ParamtView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //                [self.view addSubview:_detailParamtView];
        
    }
    
    return _ParamtView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.DetailStr = @"adfdsflsdfjlsdkjflskjdflskdjfldskjflkdjlkfjdlksjfldksjflsdjfldskjklfjdslkfjlsdjfldskjflkdsjflsdkjflksdjlkfdjslkdjf";
    
//    [self LoadChlidView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self GetTeacherInfo];
    
    
    
}

- (void)GetTeacherInfo
{
    if (self.teacherId.length == 0) {
        return;
    }
    
    
     NSDictionary *parameter = @{@"teacherId" : self.teacherId};
    [self startLoading];
    
    [EnglishRequestTool getTeacherInfoParameter:parameter success:^(TeacherInfo *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.teacherInfodata = respone.data;
            
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
    self.title = @"老师介绍";

    [self.view addSubview:self.ParamtView];

    self.HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 125)];
    
    self.HeaderView.backgroundColor =[UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 104 - 18, 21, 104, 104)];

    iconView.layer.cornerRadius = 52; //设置图片圆角的尺度
    iconView.layer.borderWidth = 1.0;
    iconView.layer.borderColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0].CGColor;
    iconView.clipsToBounds = YES;//去除边界
    iconView.layer.masksToBounds = YES; //没这句话它圆不起来

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.teacherInfodata.introductionImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [iconView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];

    iconView.userInteractionEnabled = YES;
    
    [self.HeaderView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 52,200, 26)];
    
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    //    numLabel.text = @"剩余可约次数: 20";
    nameLabel.text = self.teacherInfodata.name;;
    
    
//    nameLabel.textAlignment = NSTextAlignmentRight;
    
    [self.HeaderView addSubview:nameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(nameLabel.frame) + 12,200, 13)];

    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor colorWithRed:252/255.0 green:156/255.0 blue:32/255.0 alpha:1.0];
//    numLabel.text = @"剩余可约次数: 20";
    numLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",[self.teacherInfodata.teacherCourseCount objectForKey:@"toBeReservedTimes"]];


//    numLabel.textAlignment = NSTextAlignmentRight;

    [self.HeaderView addSubview:numLabel];
    
    [self.ParamtView addSubview:self.HeaderView ];
    

    

    
    
    UIView *DetailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.HeaderView.frame) + 22, kDeviceWidth, 37)];
    DetailView.backgroundColor = [UIColor whiteColor];
    
    [self.ParamtView addSubview:DetailView];
    
    
    
//    UIImageView *DetailiconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 3, 16)];
//    DetailiconView.backgroundColor = MNavBackgroundColor;
//
//    [DetailView addSubview:DetailiconView];
    
    
    UILabel *Detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 23)];
    Detaillabel.font = [UIFont boldSystemFontOfSize:24.0f];  //UILabel的字体大小
//    Detaillabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    Detaillabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    Detaillabel.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [Detaillabel setBackgroundColor:[UIColor clearColor]];
    Detaillabel.text = @"个人简介";
    [DetailView addSubview:Detaillabel];
    
//    UIImageView *DetaillineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 36, kDeviceWidth, 1)];
//    DetaillineView.backgroundColor = [UIColor colorWithRed:224/225.0 green:223/225.0 blue:211/225.0 alpha:1.0];
//    [DetailView addSubview:DetaillineView];
    
    self.DetailView = DetailView;


    UILabel *titleLabel = [[UILabel alloc] init];
    
    CGFloat titleLabelY =  CGRectGetMaxY(self.DetailView.frame) + 20;
    CGFloat titleLabelX = 15;
    
    titleLabel.numberOfLines = 0;
    
    titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.userInteractionEnabled = YES;

    
    
    if (self.teacherInfodata.introduction !=0 ) {
        //
        CGSize titleLabelSize = [self.teacherInfodata.introduction sizeWithMaxSize:CGSizeMake(kDeviceWidth - titleLabelX *2, MAXFLOAT) fontSize:15.0];
        
        
        //        titleLabel.frame = (CGRect){titleLabelX,titleLabelY,kDeviceWidth - titleLabelX *2, titleLabelSize.height + 50};
        titleLabel.frame = (CGRect){titleLabelX,titleLabelY,kDeviceWidth - titleLabelX *2, titleLabelSize.height};
        titleLabel.text = self.teacherInfodata.introduction;
        

        
        self.ParamtView.contentSize = CGSizeMake(0, titleLabelY + titleLabelSize.height + 50);
        
      
    }
    else{
        
        titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, kDeviceWidth - titleLabelX *2, 30);
        
        titleLabel.text = @"暂无简介内容";
        self.ParamtView.contentSize = CGSizeMake(0,KDeviceHeight - 64 - 40);
    }
    
    
    [self.ParamtView addSubview:titleLabel];
    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 60 - 64 -kDevice_Is_iPhoneX, kDeviceWidth, 60)];
//
//    bottomView.backgroundColor = [UIColor whiteColor];
//
//    [self.view addSubview:bottomView];
//
//    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 200 -20 -91 - 12, 28,200, 20)];
//
//    numLabel.font = [UIFont systemFontOfSize:14];
//    numLabel.backgroundColor = [UIColor clearColor];
//    numLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
////    numLabel.text = @"剩余可约次数: 20";
//    numLabel.text = [NSString stringWithFormat:@"剩余可约次数: %@",[self.teacherInfodata.teacherCourseCount objectForKey:@"toBeReservedTimes"]];
//
//
//    numLabel.textAlignment = NSTextAlignmentRight;
//
//    [bottomView addSubview:numLabel];
//
    UIButton * experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 21 -64 -kDevice_Is_iPhoneX,kDeviceWidth - 68*2, 44)];
    //    _phoneView.userInteractionEnabled = NO;
    experienceBtn.backgroundColor = MNavBackgroundColor;
    experienceBtn.contentMode = UIViewContentModeScaleAspectFill;

    [experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [experienceBtn setTitle:@"预约" forState:UIControlStateNormal];

    [experienceBtn addTarget:self action:@selector(experienceBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    experienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];

    experienceBtn.layer.cornerRadius= 22.0f;

    experienceBtn.clipsToBounds = YES;//去除边界

    [self.view addSubview:experienceBtn];

    
}

- (void)LoadDetailParamtView
{
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kDeviceWidth - 30, KDeviceHeight - 235 - 50)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    CGFloat titleLabelY =  0;
    CGFloat titleLabelX = 15;
    
    titleLabel.numberOfLines = 0;
    
    titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.userInteractionEnabled = YES;

//    _detailParamtView.backgroundColor = [UIColor purpleColor];
    
    
    if (self.teacherInfodata.introduction !=0 ) {
        //
        CGSize titleLabelSize = [self.teacherInfodata.introduction sizeWithMaxSize:CGSizeMake(kDeviceWidth - titleLabelX *2, MAXFLOAT) fontSize:16.0];
        
        
//        titleLabel.frame = (CGRect){titleLabelX,titleLabelY,kDeviceWidth - titleLabelX *2, titleLabelSize.height + 50};
          titleLabel.frame = (CGRect){titleLabelX,titleLabelY,kDeviceWidth - titleLabelX *2, titleLabelSize.height};
        titleLabel.text = self.teacherInfodata.introduction;
        
        
//        titleLabel.backgroundColor = [UIColor redColor];
        
        _detailParamtView.contentSize = CGSizeMake(0,titleLabelSize.height + 50);
        
//        _detailParamtView.contentSize = CGSizeMake(0, 60);
    }
    else{
        
        titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, kDeviceWidth - titleLabelX *2, 30);
        
        titleLabel.text = @"暂无简介内容";
        _detailParamtView.contentSize = CGSizeMake(0,KDeviceHeight/2);
    }
    

    [self.detailParamtView addSubview:titleLabel];
}


- (void)backFore
{
    //    [[CustomRootViewController getInstance]comeback];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)experienceBtnClicked
{
    
    
    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
    ExperiencetimeControlVC.teacherId = self.teacherInfodata.id;
    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
}






- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
