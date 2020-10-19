//
//  BBTLoginViewController.m
//  BaBaTeng
//
//  Created by liu on 16/10/11.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTLoginViewController.h"
#import "Header.h"
#import "DKTextField.h"
#import "BBTRegisterViewController.h"
#import "BBTForgetViewController.h"
#import "BBTMainTool.h"
#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTResultRespone.h"
#import "YBPopupMenu.h"
#import "NSString+Hash.h"
#import "PasswordEncrypt.h"



@interface BBTLoginViewController ()<UITextFieldDelegate,YBPopupMenuDelegate,AutomaticLoginDelegate,RegisterLoginDelegate>

@property (nonatomic, strong) UITextField   *usernameField;
@property (nonatomic, strong) DKTextField   *passwordField;
@property (nonatomic, strong) UIButton      *registerBtn;
@property (nonatomic, strong) UIButton      *forgetBtn;
@property (nonatomic, strong) UIButton      *loginBtn;
@property (nonatomic, strong) UIButton      *passwordPrompt;

@property (strong, nonatomic) UIImageView  *bgBlurredView;

@property (nonatomic, assign)  CGFloat padding;

@property (nonatomic, strong) YBPopupMenu *popupMenu;
//@property (nonatomic, strong) UIView * navView;
@end

@implementation BBTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1.0];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)name:UITextFieldTextDidChangeNotification object:nil];
    
//    NSLog(@"kDeviceWidth======%f",kDeviceWidth);
    if(320<=kDeviceWidth && kDeviceWidth<375){
        
        self.padding = 40;
        
    }else if (375<=kDeviceWidth && kDeviceWidth<414){
        
        self.padding = 50;
        
    }else if (414<=kDeviceWidth){
        
        self.padding = 60;
        
    }else{
        
        self.padding = 30;
        
    }
    
    [self LoadChlidView];
}
#pragma mark -加载UI
- (void)LoadChlidView
{
    
    [self.view addSubview:self.bgBlurredView];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    //self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    
    
    // [self.view addSubview:self.navView];
    
    //适配ipad；
    
    CGFloat UsernameY;
    
    if ([IphoneType IFChangeCoordinates]) {
        
        UsernameY = 100;
        
    }else{
        
        UsernameY = 100+76;
    }

    
    //手机号  用户名称 输入框
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake((kDeviceWidth-275)/2,UsernameY,275, 55)];
    
    [self setViewWithTextField:self.usernameField imageName:@"icon_sj" placeholder:@"输入手机号" font: [UIFont boldSystemFontOfSize:14]];
    self.usernameField.keyboardType = UIKeyboardTypeNumberPad;
    
    //    [[TMCache sharedCache] setObject:userName forKey:@"phoneNumber"];
    
    
    if ([[TMCache sharedCache] objectForKey:@"phoneNumber"] != 0)
    {
        NSLog(@"phoneNumber====%@",[[TMCache sharedCache] objectForKey:@"phoneNumber"]);
        
        self.usernameField.text = [[TMCache sharedCache] objectForKey:@"phoneNumber"];
    }
    
    [self.view addSubview:self.usernameField];
    
    //密码 输入框
    self.passwordField = [[DKTextField alloc] initWithFrame:CGRectMake((kDeviceWidth-275)/2, CGRectGetMaxY(self.usernameField.frame) + 17, 275, 55)];
    [self setViewWithTextField:self.passwordField imageName:@"icon_mms" placeholder:@"输入密码" font: [UIFont boldSystemFontOfSize:14]];
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    //登录 注册 忘记密码  等相关按钮
    self.forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth-275)/2, CGRectGetMaxY(self.passwordField.frame)  +17, 70, 25)];
    [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetBtn];
    
    
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-70- (kDeviceWidth-275)/2, CGRectGetMaxY(self.passwordField.frame)+20 , 70, 25)];
    [self.registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    self.registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-275)/2, CGRectGetMaxY(self.forgetBtn.frame) + 100, kDeviceWidth-(kDeviceWidth-275)/2*2, 51)];
    
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
    
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [ self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.userInteractionEnabled = NO;
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    if ([self.pageType isEqualToString:@"Automaticlogin"]) {
        
        self.usernameField.text = self.username;
        self.passwordField.text = self.password;
        
        [self showToastWithString:@"自动登录中,请稍后..."];
        
        [self performSelector:@selector(delayMethodAutomatic) withObject:nil afterDelay:1.5f];
    }
    
}


-(void)delayMethodAutomatic{
    
    [self postLoginUserName:self.usernameField.text Password:self.passwordField.text];
}





- (void)loginBtnClick:(UIButton *)btn
{
    
    //[BBTMainTool setUpRootViewController:CZKeyWindow];
    
   
    
    
    [self.usernameField resignFirstResponder];
    
    [self.passwordField resignFirstResponder];
    
    if ([self.usernameField.text isEqualToString:@""])
    {
        [self showToastWithString:@"请输入手机号"];
        return;
    }
    else if (![self isMobileNumber:self.usernameField.text])
    {
        [self showToastWithString:@"手机号格式错误，请输入正确的手机号"];
        
        return;
    }
    else if ([self.passwordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请输入密码"];
        
        return;
    }
    else if (self.passwordField.text.length <6||self.passwordField.text.length >14)
    {
        
        [self showToastWithString:@"密码长度为6-14位字符"];
        
        
        return;
    }
    
    self.loginBtn.userInteractionEnabled = NO;
//    btn.enabled = NO;
    NSLog(@"登陆开始");
    [self postLoginUserName:self.usernameField.text Password:self.passwordField.text];

    
    
}


- (void)postLoginUserName:(NSString *)userName Password:(NSString *)password
{
//    NSString *str1 = [str md5String];
//    
//    NSLog(@"sdlkfjsldjfls=%@",str1);
//    
    PasswordEncrypt *encypy = [[PasswordEncrypt alloc] init];
//
//    NSLog(@"1234343546565=%@",[encypy Encode:str1]);
    
    if (IsStrEmpty(userName)) {
        
         [self showToastWithString:@"请输入手机号"];
        
        return;
    }
    
    if (IsStrEmpty([encypy Encode:[password md5String]])) {
        
        [self showToastWithString:@"请输入密码"];
        
        return;
    }
//    e10adc3949ba59abbe56e057f20f883e
    [self startLoading];
    NSLog(@"-----------%@",[password md5String]);
    
    [BBTLoginRequestTool postLoginUserName:userName Password:[encypy Encode:[password md5String]] newLoginsuccess:^(BBTUserInfoRespone *respone) {
        
        [self stopLoading];
        
        self.loginBtn.userInteractionEnabled = YES;
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            //            [self showToastWithString:@"登录成功"];
            
            NSLog(@"登陆中中中国呢");
            
            [[TMCache sharedCache] setObject:respone.data.userId forKey:@"userId"];
            [[TMCache sharedCache] setObject:respone.data.token forKey:@"token"];
            [[TMCache sharedCache] setObject:userName forKey:@"phoneNumber"];
            [[TMCache sharedCache]setObject:password forKey:@"password"];
            
            [[TMCache sharedCache]setObject:respone.data.userAddress forKey:@"userAddress"];
            [[TMCache sharedCache]setObject:respone.data.accountStatus forKey:@"accountStatus"];
            [[TMCache sharedCache]setObject:respone.data.bindDeviceNumber forKey:@"bindDeviceNumber"];
            [[TMCache sharedCache]setObject:respone.data.createTime forKey:@"createTime"];
            [[TMCache sharedCache]setObject:respone.data.nickName forKey:@"nickName"];
            [[TMCache sharedCache]setObject:respone.data.onlineStatus forKey:@"onlineStatus"];
            [[TMCache sharedCache]setObject:respone.data.userIcon forKey:@"userIcon"];
            
//            self.loginBtn.userInteractionEnabled = YES;
            
            //[self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            [BBTMainTool setUpRootViewController:CZKeyWindow];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        self.loginBtn.userInteractionEnabled = YES;
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
}

//-(void)delayMethod{
//
//    [BBTMainTool setUpRootViewController:CZKeyWindow];
//
//}

#pragma mark -textField 初始化封装
-(void)setViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName placeholder:(NSString*)placeholder font:(UIFont*)font{
    
    textField.delegate = self;
    textField.font = font;
    textField.clearButtonMode = UITextFieldViewModeAlways;
//    textField.placeholder =placeholder;
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.5f;
    textField.layer.cornerRadius = 8;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor whiteColor];
    

    NSString *holderText = placeholder;
    NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholdertext addAttribute:NSForegroundColorAttributeName
                  value:[UIColor whiteColor]
                  range:NSMakeRange(0, holderText.length)];
    [placeholdertext addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:15]
                  range:NSMakeRange(0, holderText.length)];
    

    textField.attributedPlaceholder = placeholdertext;
    
//
//    [textField setValue:[UIColor whiteColor] forKey:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:15] forKey:@"_placeholderLabel.font"];
    



    //创建左侧视图
    UIImage *im = [UIImage imageNamed:imageName];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    lv.backgroundColor = [UIColor clearColor];
    iv.center = lv.center;
    [lv addSubview:iv];
    
    //设置 textField 的左侧视图
    //设置左侧视图的显示模式
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = lv;
    
    if(textField==self.passwordField){
        
        self.passwordPrompt = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 80, 25)];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"眼_sel"] forState:UIControlStateNormal];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"眼_nor"] forState:UIControlStateSelected];
        
        UIView  *promptView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 80, 35)];
        [self.passwordPrompt addTarget:self action:@selector(PromptClicked:) forControlEvents:UIControlEventTouchUpInside];
        [promptView addSubview:self.passwordPrompt];
        self.passwordField.rightViewMode = UITextFieldViewModeAlways;
        self.passwordField.rightView = promptView;
        
    }
    
}

#pragma mark -背景图片
- (UIImageView *)bgBlurredView{
    if (!_bgBlurredView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"bg_zcdl"];
        
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
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
    
    if ([[TMCache sharedCache] objectForKey:@"phoneNumber"] != 0)
    {
        NSLog(@"phoneNumber1====%@",[[TMCache sharedCache] objectForKey:@"phoneNumber"]);
        
        self.usernameField.text = [[TMCache sharedCache] objectForKey:@"phoneNumber"];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
    //self.navigationController.navigationBar.translucent = NO;
    
    [self.usernameField resignFirstResponder];
    
    [self.passwordField resignFirstResponder];
    
}

- (void)registerBtnClick
{
    BBTRegisterViewController *registerVC = [[BBTRegisterViewController alloc] init];
    
    registerVC.delegate = self;
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetBtnClick
{
    BBTForgetViewController *forgetVC = [[BBTForgetViewController alloc] init];
    forgetVC.username = self.usernameField.text;
    forgetVC.delegate = self;
    [self.navigationController pushViewController:forgetVC animated:YES];
}
#pragma mark -AutomaticLoginDelegate
-(void)didAutomaticLogin:(NSString *)userName Password:(NSString *)password{
    
    
    [self showToastWithString:@"自动登录中,请稍后..."];
    
    self.usernameField.text =userName;
    self.passwordField.text =password;

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
}

-(void)didRegisterLogin:(NSString *)userName Password:(NSString *)password{
    
    [self showToastWithString:@"自动登录中,请稍后..."];
    
    self.usernameField.text =userName;
    self.passwordField.text =password;

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
    
}
-(void)delayMethod{
    
    [self postLoginUserName:self.usernameField.text Password:self.passwordField.text];
}
- (void)PromptClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    
    self.passwordField.secureTextEntry = !btn.selected;
    
    
}

- (void)textChange
{
    //    NSLog(@"========%lu",self.passwordField.text.length);
    //    if (self.passwordField.text.length==14) {
    //
    //           [self shwoprompt:self.passwordField toastWithString:@"密码长度为6-14位字符" menuWidth:self.passwordField.bounds.size.width*2/3];
    //    }
    
    if (self.usernameField.text.length != 0&& self.passwordField.text.length != 0) {
        
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
        
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    }
    else
    {
        
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField == self.passwordField) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 14) {
            
            
            
            return NO;//限制长度
        }
        return YES;
        
    }else if (textField == self.usernameField){
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
        return YES;
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *toastWithString;
    
    CGFloat itemWidth;
    
    if (textField==self.usernameField) {
        
        if ([self.usernameField.text isEqualToString:@""])
        {
            toastWithString=@"请输入手机号";
            itemWidth = textField.bounds.size.width/2;
            
            [self shwoprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
        }
        else if (![self isMobileNumber:self.usernameField.text]) {
            
            itemWidth = textField.bounds.size.width;
            toastWithString=@"手机号格式错误，请输入正确的手机号";
            
            [self shwoprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
        }
        
        
    }else if (textField==self.passwordField){
        
        
        
        
        if ([self.passwordField.text isEqualToString:@""])
        {
            
            itemWidth = textField.bounds.size.width/2;
            toastWithString = @"请输入密码";
            [self shwoprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
        }
        else if (self.passwordField.text.length <6||self.passwordField.text.length >14)
        {
            itemWidth = textField.bounds.size.width*2/3;
            toastWithString=@"密码长度为6-14位字符";
            
            [self shwoprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
        }
        
        
    }
}

-(void)shwoprompt:(UITextField *)textField toastWithString:(NSString*)toastWithString menuWidth:(CGFloat)itemWidth  {
    
    _popupMenu = [YBPopupMenu showRelyOnView:textField titles:@[toastWithString] icons:nil menuWidth:itemWidth otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.maxVisibleCount = 1;
        popupMenu.itemHeight = 30;
        popupMenu.borderWidth = 1;
        popupMenu.fontSize = 12;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.borderColor = [UIColor brownColor];
        popupMenu.textColor = [UIColor brownColor];
        
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (self.usernameField.text.length != 0 && self.passwordField.text.length != 0) {
        
        NSLog(@"sdfddd");
    }
    
    return YES;
}

@end
