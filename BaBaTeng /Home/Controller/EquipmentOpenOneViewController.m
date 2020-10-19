//
//  EquipmentOpenOneViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentOpenOneViewController.h"
#import "EquipmentOpenTwoViewController.h"
#import "QCheckBox.h"
#import "EquipmentSetNetworkViewController.h"
#import "EquipmentConfigNetWorkViewController.h"
#import "EquipmentPressNetWorkViewController.h"
@interface EquipmentOpenOneViewController ()<QCheckBoxDelegate>

@property (strong, nonatomic) UIImageView  *promptPicture;
@property (strong, nonatomic) UILabel  *promptLabel;
@property (strong, nonatomic) QCheckBox  *check;
@property (strong, nonatomic) UILabel  *checkBoxLabel;
@end

@implementation EquipmentOpenOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.deviceTypeName;//@"开机";
    
    self.promptPicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, (KDeviceHeight-64)/2)];
    self.promptPicture.contentMode = UIViewContentModeScaleAspectFill;
    self.promptPicture.backgroundColor =  [UIColor colorWithRed:251.0/255 green:223.0/255 blue:191.0/255 alpha:1.0f];
   // self.promptPicture.image = [UIImage imageNamed:@"BL_denglu"];
    self.promptPicture.userInteractionEnabled = YES;
    [self.view addSubview: self.promptPicture];
    
     self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptPicture.frame)+20, kDeviceWidth, 40)];
     self.promptLabel.textAlignment = NSTextAlignmentCenter;
     self.promptLabel.font = [UIFont systemFontOfSize:14];
     self.promptLabel.textColor = [UIColor grayColor];
     self.promptLabel.backgroundColor = [UIColor clearColor];
     self.promptLabel.text = @"顺时针旋转设备尾巴开机";
     self.promptLabel.numberOfLines=0;
     [self.view addSubview: self.promptLabel];
    
    


    self.check = [[QCheckBox alloc] initWithDelegate:self];
    [self.check  setTitle:@"确认设备已开机" forState:UIControlStateNormal];
    [self.check .titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.check setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.check.frame = CGRectMake(80, CGRectGetMaxY(self.promptLabel.frame)+10, kDeviceWidth-160, 40);
    self.check.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.check];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-120, kDeviceWidth - 40, 48)];
//    [nextButton setImage:[UIImage imageNamed:@"btn_xyb_nor"] forState:UIControlStateNormal];
//    [nextButton setImage:[UIImage imageNamed:@"btn_xyb_pre"] forState:UIControlStateHighlighted];
    
    nextButton.layer.cornerRadius= 10.0f;
    
    nextButton.clipsToBounds = YES;//去除边界
    nextButton.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [nextButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [nextButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    // Do any additional setup after loading the view.
}

//根据背景颜色创建图片
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    
    
    
    if (checkbox==self.check) {
        
        
         NSLog(@"checkbox==%d",checked);
     
        
        
    }
    

    
}



-(void)nextAction{


    EquipmentPressNetWorkViewController *configVc = [[EquipmentPressNetWorkViewController alloc] init];
    configVc.deviceTypeName = self.deviceTypeName;
    
    [self.navigationController pushViewController:configVc animated:YES];
    
    
    
    
  //  [self.navigationController pushViewController:[EquipmentOpenTwoViewController new] animated:YES];

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
