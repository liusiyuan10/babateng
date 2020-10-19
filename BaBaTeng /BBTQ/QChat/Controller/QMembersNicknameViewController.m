//
//  QMembersNicknameViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QMembersNicknameViewController.h"
#import "QEquipmentRequestTool.h"

#import "QDevice.h"

#import "BBTQAlertView.h"
#import "HomeViewController.h"
#import "BBTMainTool.h"

#import "TMCache.h"
#import "NewHomeViewController.h"

@interface QMembersNicknameViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIImageView  *bgBlurredView;
@property (nonatomic, strong) UITextField  *nicknameField;
@end

@implementation QMembersNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改群名片";
    
    //[self.view addSubview:self.bgBlurredView];
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(17, 17, kDeviceWidth - 34, 55)];
    self.nicknameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nicknameField.backgroundColor = [UIColor whiteColor];
    self.nicknameField.placeholder = @"输入群名片";
    self.nicknameField.text =self.nickname;
    self.nicknameField.font = [UIFont systemFontOfSize:15.0f];
    self.nicknameField.delegate =self;
    [self.view addSubview:self.nicknameField];
    
    [self setNavigationItem];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.nicknameField) {
        
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 30) {
            
            
            
            return NO;//限制长度
        }
        return YES;
        
    }
    return YES;
}


-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//      [[AppDelegate appDelegate]suspendButtonHidden:NO];
//
//}

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
        //[self showToastWithString:@"请输入群名片"];
        
        BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"群名片不能为空!" andWithTag:1 andWithButtonTitle:@"确定"];
        
        
        [QalertView showInView:self.view];
        
        //点击按钮回调方法
        QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
            if (titleBtnTag == 1) {

            }
            
        };
        

        
        return;
    }
    
    
    BOOL ok= [self isIncludeSpecialCharact:self.nicknameField.text];
    if (ok==YES) {
        NSLog(@"包含有特殊字符");
        
        BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"群名片不能包含特殊字符!" andWithTag:1 andWithButtonTitle:@"确定"];
        
        
        [QalertView showInView:self.view];
        
        //点击按钮回调方法
        QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
            if (titleBtnTag == 1) {
                
            }
            
        };
        
        return;
    }
    
    if ([self.nicknameField.text isEqualToString:self.nickname]) {
        
          [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
     [self updateDeviceName];
    
    

    
}

//NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
//
//[QEquipmentRequestTool GetdeviceCompanyInfoDic: [[TMCache sharedCache] objectForKey:@"deviceId"] Parameter:parameter success:^(QDevice *respone) {

-(void)updateDeviceName
{
    
    [self startLoading];
    [QEquipmentRequestTool updateMembersId:self.familyMemberId FamilyId:self.familyId DeviceName:self.nicknameField.text upload:^(QDevice *respone) {

        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            [[TMCache sharedCache]setObject:self.nicknameField.text forKey:@"GroupCard"];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else if( [respone.statusCode isEqualToString:@"101"] )
        {
            NSLog(@"未登录或登录已过期");
            
            BBTQAlertView *QalertView =  [[BBTQAlertView alloc] initWithOneBBTTitle:@"温馨提示" andWithMassage:@"未登录或登录已过期, 请重新登录!" andWithTag:1 andWithButtonTitle:@"确定"];
            
            
            [QalertView showInView:self.view];
            
            //点击按钮回调方法
            QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    [[NewHomeViewController getInstance] disconnectWithmKTopic];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"userId"];
                    [[TMCache sharedCache]removeObjectForKey:@"token"];
                    //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"password"];
                    [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
                    [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"createTime"];
                    [[TMCache sharedCache]removeObjectForKey:@"nickName"];
                    [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
                    [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
                     [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
                    
                    [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
                    [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
                    [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
                    
                    [BBTMainTool setLoginRootViewController:CZKeyWindow];
                    
                    //  NSLog(@"sb");
                }
                
            };
            
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
