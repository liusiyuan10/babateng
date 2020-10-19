//
//  QEquipmentNicknameViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QEditCallPhoneNumViewController.h"

//#import "QEquipmentRequestTool.h"
//
//#import "QDevice.h"

//#import "BBTQAlertView.h"
//#import "HomeViewController.h"
//#import "BBTMainTool.h"
//#import "NewHomeViewController.h"

#import "QFamilyCommon.h"

#import "QFamilyCallRequestTool.h"

@interface QEditCallPhoneNumViewController ()
@property (strong, nonatomic) UIImageView  *bgBlurredView;
@property (nonatomic, strong) UITextField   *nicknameField;
@end

@implementation QEditCallPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改手机号码";
    
    //[self.view addSubview:self.bgBlurredView];
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(17, 17, kDeviceWidth - 34, 55)];
    self.nicknameField.keyboardType = UIKeyboardTypeNumberPad;
    self.nicknameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nicknameField.backgroundColor = [UIColor whiteColor];
    self.nicknameField.placeholder = @"输入手机号码";
    self.nicknameField.text =self.phoneNumstr;
    self.nicknameField.font = [UIFont systemFontOfSize:15.0f];
    
    
    
    [self.view addSubview:self.nicknameField];
    
    [self setNavigationItem];

}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
}


#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"nav_queding_nor"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_queding_nor"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.nicknameField resignFirstResponder];
    
}

-(void)completeAction{
    
    
    [self.nicknameField resignFirstResponder];
    
    
    if ([self.nicknameField.text isEqualToString:@""])
    {
        [self showToastWithString:@"请输入手机号码"];
        return;
    }
    
    if (![self isMobileNumber:self.nicknameField.text])
    {
        [self showToastWithString:@"手机号格式错误，请输入正确的手机号"];
        
        return;
    }
    
    
    [self updatePhoneNum];
    
}

//NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
//
//[QEquipmentRequestTool GetdeviceCompanyInfoDic: [[TMCache sharedCache] objectForKey:@"deviceId"] Parameter:parameter success:^(QDevice *respone) {

-(void)updatePhoneNum
{
    
    [self startLoading];

    
    [QFamilyCallRequestTool updateFamilyPhoneNumdeviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] Phonenum:self.nicknameField.text upload:^(QFamilyCommon *respone) {
        
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            [self showToastWithString:@"修改成功"];
        
            [self.navigationController popViewControllerAnimated:YES];
        
            }
    else
    {


        [self showToastWithString:respone.message];
    }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    


}


//简单匹配是否是 手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    if (mobileNum.length<11) {
        
        return NO;
    }
    
    //这个正则没有把176，177，178号段包括进去，应该改为
    //NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    //NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9]|6[0-9]|9[0-9]|2[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
    
}


-(void)delayMethod{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -背景图片
- (UIImageView *)bgBlurredView{
    if (!_bgBlurredView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"BG_tianlu"];
        
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retrieveKeyboard)];
        [bgView addGestureRecognizer:singleTap];
        
        bgView.image = bgImage;
        _bgBlurredView = bgView;
    }
    return _bgBlurredView;
}

#pragma mark -点击空白处收键盘
-(void)retrieveKeyboard{
    
    [self.nicknameField resignFirstResponder];
    
}



@end
