//
//  CoursePayResultViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/7.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CoursePayResultViewController.h"
#import "ExperienceViewController.h"
#import "XEOrderViewController.h"

@interface CoursePayResultViewController ()

@property (nonatomic, strong) UIView *successView;

@end

@implementation CoursePayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
    
}



- (void)LoadChlidView
{
    
        
        self.title = @"支付成功";
        
        [self loadSuccessView];

    
}


- (void)loadSuccessView
{
    self.successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    
    [self.view addSubview:self.successView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 117)/2.0, 42, 117, 117)];
    iconImageView.image = [UIImage imageNamed:@"icon_Paymentcompletion"];
    
    [self.successView addSubview:iconImageView];
    
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, CGRectGetMaxY(iconImageView.frame) + 15, 100, 25)];
    
    payLabel.text = @"支付成功";
    payLabel.textColor = NavBackgroundColor;
    payLabel.font = [UIFont systemFontOfSize:18];
    payLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.successView addSubview:payLabel];
    
//    UILabel *AlbumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2.0, CGRectGetMaxY(payLabel.frame) + 13, 100, 20)];
//
//    AlbumNameLabel.text = @"专辑名称";
//    AlbumNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//    AlbumNameLabel.font = [UIFont systemFontOfSize:14];
//    AlbumNameLabel.textAlignment = NSTextAlignmentCenter;
//
//
//    [self.successView addSubview:AlbumNameLabel];
//
//    UILabel *pirceLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 79)/2.0, CGRectGetMaxY(AlbumNameLabel.frame), 19, 26)];
//
//    pirceLabel.text = @"¥";
//    pirceLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//    pirceLabel.font = [UIFont systemFontOfSize:19];
//    pirceLabel.textAlignment = NSTextAlignmentCenter;
//
//
//    [self.successView addSubview:pirceLabel];
//
//    UILabel *pircetextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pirceLabel.frame), CGRectGetMaxY(AlbumNameLabel.frame), 60, 40)];
//
//    pircetextLabel.text = @"1.5";
//    pircetextLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//    pircetextLabel.font = [UIFont boldSystemFontOfSize:36];
//    pircetextLabel.textAlignment = NSTextAlignmentLeft;
//
//
//    [self.successView addSubview:pircetextLabel];
//
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 317, kDeviceWidth - 24, 1.0)];
//    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
//
//    [self.successView addSubview:lineView];
//
//    UILabel *pircetypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 120, CGRectGetMaxY(lineView.frame) + 20, 108, 17)];
//
//    pircetypeLabel.text = @"支付方式: 微信支付";
//    pircetypeLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
//    pircetypeLabel.font = [UIFont boldSystemFontOfSize:12];
//    pircetypeLabel.textAlignment = NSTextAlignmentRight;
//
//
//    [self.successView addSubview:pircetypeLabel];
    
    UIButton *BackBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, KDeviceHeight - 90 - 64 - 56 - 50, kDeviceWidth - 32, 56)];
    
    [BackBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    
    [BackBtn setTitleColor:NavBackgroundColor forState:UIControlStateNormal];
    
    BackBtn.layer.cornerRadius= 6.0f;
    
    BackBtn.layer.borderWidth = 1.2;
    BackBtn.layer.borderColor = NavBackgroundColor.CGColor;
    BackBtn.clipsToBounds = YES;//去除边界
    
    [BackBtn addTarget:self action:@selector(BackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.successView addSubview:BackBtn];
    
    
    UIButton *ExperienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, KDeviceHeight - 90 - 64, kDeviceWidth - 32, 56)];
    
    [ExperienceBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    
    [ExperienceBtn setTitleColor:NavBackgroundColor forState:UIControlStateNormal];
    
    ExperienceBtn.layer.cornerRadius= 6.0f;
    
    ExperienceBtn.layer.borderWidth = 1.2;
    ExperienceBtn.layer.borderColor = NavBackgroundColor.CGColor;
    ExperienceBtn.clipsToBounds = YES;//去除边界
    
    [ExperienceBtn addTarget:self action:@selector(ExperienceBtnClicked)  forControlEvents:UIControlEventTouchUpInside];
    
    [self.successView addSubview:ExperienceBtn];
    
    //    orderBtn.titleLabel.font = [UIFont systemFontOfSize:(CGFloat)]
    
}

- (void)BackBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)ExperienceBtnClicked
{
    
//    ExperienceViewController *ExperienceControlVC = [[ExperienceViewController alloc] init];
//
//    [self.navigationController pushViewController:ExperienceControlVC animated:YES];
    
    XEOrderViewController *XEOrderVC = [[XEOrderViewController alloc] init];
    
    XEOrderVC.pageIndex = 0;
    [self.navigationController pushViewController:XEOrderVC animated:YES];
    
    
    
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
