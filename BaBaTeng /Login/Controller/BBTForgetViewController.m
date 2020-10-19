//
//  BBTForgetViewController.m
//  BaBaTeng
//
//  Created by liu on 16/10/19.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTForgetViewController.h"
#import "DKTextField.h"
#import "Header.h"
//#import "FUIButton.h"
//#import "NSAttributedString+Attributes.h"


#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "YBPopupMenu.h"
#import "NSString+Hash.h"
#import "PasswordEncrypt.h"


@interface BBTForgetViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UITextField   *usernameField;
@property (nonatomic, strong) DKTextField   *passwordField;
@property (nonatomic, strong) DKTextField   *repeatpasswordField;
@property (nonatomic, strong) UIButton      *passwordPrompt;
@property (nonatomic, strong) UIButton      *repeatpasswordPrompt;
@property (nonatomic, strong) UITextField   *verifyField;
@property (nonatomic, strong) UIButton      *verifyBtn;
@property (nonatomic, strong) UIButton      *registerBtn;
@property (strong, nonatomic) UIImageView   *bgBlurredView;
@property (nonatomic, assign)  CGFloat padding;
@property (nonatomic, assign)  BOOL verifyError;

@property (nonatomic, strong) YBPopupMenu *popupMenu;

@property (nonatomic, assign)  BOOL showprompt;

@end

@implementation BBTForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1.0];
    
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //
    //    self.navigationItem.backBarButtonItem = backItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgetChange)name:UITextFieldTextDidChangeNotification object:nil];
    
    
    if(320<=kDeviceWidth && kDeviceWidth<375){
        
        self.padding = 20;
        
    }else if (375<=kDeviceWidth && kDeviceWidth<414){
        
        self.padding = 40;
        
    }else if (414<=kDeviceWidth){
        
        self.padding = 60;
        
    }else{
        
        self.padding = 20;
        
    }
    
    
    [self LoadChlidView];
    
}





- (void)LoadChlidView
{
    
    [self.view addSubview:self.bgBlurredView];
    
    CGFloat UsernameY;
    CGFloat RegisterBtnY;
    //适配ipad；
    if ([IphoneType IFChangeCoordinates]) {
        
        UsernameY = 100;
        RegisterBtnY =40;
        
    }else{
        
        UsernameY = 120;
        RegisterBtnY =80;
    }
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(self.padding, UsernameY, kDeviceWidth -  self.padding*2, 55)];
    
    [self setViewWithTextField:self.usernameField imageName:@"icon_sj" placeholder:@"输入手机号" font: [UIFont boldSystemFontOfSize:14]];
    self.usernameField.text =  self.username;
    self.usernameField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.usernameField];
    
    self.verifyField = [[UITextField alloc] initWithFrame:CGRectMake(self.padding, CGRectGetMaxY(self.usernameField.frame) + 16,  kDeviceWidth - self.padding*2-20-100, 55)];
    
    [self setViewWithTextField:self.verifyField imageName:@"验证码_icon.png" placeholder:@"输入验证码" font: [UIFont boldSystemFontOfSize:14]];
    self.verifyField.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [self.view addSubview:self.verifyField];
    
    CGFloat buyW = 100;
    CGFloat buyH = 55;
    CGFloat buyX = CGRectGetMaxX(self.verifyField.frame) + 20;
    CGFloat buyY = CGRectGetMaxY(self.usernameField.frame) + 16;
    
    self.verifyBtn =[[UIButton alloc] initWithFrame:CGRectMake(buyX, buyY, buyW, buyH)];
    [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_hqyzm_nor"] forState:UIControlStateNormal];
    [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_hqyzm_pre"] forState:UIControlStateHighlighted];
    [self.verifyBtn setTitleColor:[UIColor colorWithRed:162.0/255 green:72.0/255 blue:58.0/255 alpha:1.0f]  forState:UIControlStateNormal];
    self.verifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.verifyBtn addTarget:self action:@selector(getVerifyNumber) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:self.verifyBtn];
    
    self.passwordField = [[DKTextField alloc] initWithFrame:CGRectMake(self.padding, CGRectGetMaxY(self.verifyBtn.frame) + 16, kDeviceWidth - self.padding*2, 55)];
    
    [self setViewWithTextField:self.passwordField imageName:@"icon_mms" placeholder:@"输入新密码" font: [UIFont boldSystemFontOfSize:14]];
    self.passwordField.secureTextEntry = YES;
    
    [self.view addSubview:self.passwordField];
    
    
    self.repeatpasswordField = [[DKTextField alloc] initWithFrame:CGRectMake(self.padding, CGRectGetMaxY(self.passwordField.frame) + 16, kDeviceWidth - self.padding*2, 55)];
    [self setViewWithTextField:self.repeatpasswordField imageName:@"icon_mms" placeholder:@"重复输入新密码" font: [UIFont boldSystemFontOfSize:14]];
    self.repeatpasswordField.secureTextEntry = YES;
    
    [self.view addSubview:self.repeatpasswordField];
    
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.padding,  CGRectGetMaxY(self.repeatpasswordField.frame)+RegisterBtnY,  kDeviceWidth-self.padding*2, 51)];
    
    // [self.registerBtn setTitleColor:[UIColor colorWithRed:162.0/255 green:72.0/255 blue:58.0/255 alpha:1.0f]  forState:UIControlStateNormal];
    //    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [self.registerBtn setImage:[UIImage imageNamed:@"btn_wancheng_nor"] forState:UIControlStateNormal];
    //    [self.registerBtn setImage:[UIImage imageNamed:@"btn_wancheng_pre"] forState:UIControlStateSelected];
    
    
    [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
    
    self.registerBtn.userInteractionEnabled = NO;
    
    [self.registerBtn setTitle:@"完成" forState:UIControlStateNormal];
    [ self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    
    [self.registerBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.registerBtn];
    
    self.showprompt = YES;
    
    
}

- (void)forgetChange
{
    //    NSLog(@"========%lu",self.passwordField.text.length);
    //    if (self.passwordField.text.length==14) {
    //
    //           [self shwoprompt:self.passwordField toastWithString:@"密码长度为6-14位字符" menuWidth:self.passwordField.bounds.size.width*2/3];
    //    }
    
    if (self.usernameField.text.length != 0&& self.passwordField.text.length != 0&&self.verifyField.text.length != 0&& self.repeatpasswordField.text.length != 0) {
        
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registerBtn.userInteractionEnabled = YES;
        
        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateNormal];
        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    }
    else
    {
        
        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_dis"] forState:UIControlStateNormal];
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registerBtn.userInteractionEnabled = NO;
    }
}


-(void)completeAction{
    
    
    //      [[TMCache sharedCache] setObject:self.usernameField.text forKey:@"phoneNumber"];
    //    if (_delegate) {
    //
    //        [_delegate didAutomaticLogin:self.usernameField.text Password:self.passwordField.text];
    //    }
    //
    //     [self.navigationController popViewControllerAnimated:YES];
    //    return;
    NSLog(@"完成");
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.repeatpasswordField resignFirstResponder];
    
    if ([self.usernameField.text isEqualToString:@""])
    {
        [self showToastWithString:@"请输入手机号"];
        return;
    }
    
    else if (![self isMobileNumber:self.usernameField.text]) {
        
        [self showToastWithString:@"手机号格式错误，请输入正确的手机号"];
        return;
    }
    
    else if (self.verifyField.text.length == 0)
    {
        
        [self showToastWithString:@"请输入验证码"];
        
        return;
    }
    
    else if ([self.passwordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请输入新密码"];
        return;
    }
    
    
    else if (self.passwordField.text.length <6||self.passwordField.text.length >14)
    {
        
        [self showToastWithString:@"密码长度为6-14位字符"];
        
        return;
    }
    
    else if ([self.repeatpasswordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请重复输入新密码"];
        return;
    }
    
    
    else if (self.repeatpasswordField.text.length <6||self.repeatpasswordField.text.length >14)
    {
        
        [self showToastWithString:@"密码长度为6-14位字符"];
        
        return;
    }
    
    
    else if (![self.repeatpasswordField.text isEqualToString:self.passwordField.text])
    {
        
        [self showToastWithString:@"两次密码不一致"];
        
        return;
    }
    
    
    
    [self postforgetpwd:self.usernameField.text Password:self.passwordField.text Code:self.verifyField.text];
    
}


- (void)sendSmsCodeMobile:(NSString *)phoneNumber
{
    
    [BBTLoginRequestTool verifyPhoneforgetPassword:phoneNumber upload:^(BBTUserInfoRespone *registerRespone) {
        
        
        [self stopLoading];
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            [self showToastWithString:@"验证码已发送，请注意查收"];
            self.verifyError =NO;
        }else{
            
            [self showToastWithString:registerRespone.message];
            self.verifyError =YES;
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}



- (void)postforgetpwd:(NSString *)userName Password:(NSString *)password Code:(NSString *)code
{
    
    PasswordEncrypt *encypy = [[PasswordEncrypt alloc] init];
    
    [self startLoading];
    
    [BBTLoginRequestTool forgetpwd:userName unewpwd:[encypy Encode:[password md5String]] Code:code upload:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            
            [self showToastWithString:@"密码找回成功,将自动为您登录!"];
            
            [[TMCache sharedCache] setObject:self.usernameField.text forKey:@"phoneNumber"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            //[BBTMainTool setUpRootViewController:CZKeyWindow];
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
}


-(void)delayMethod{
    
    
    if (_delegate) {
        
        [_delegate didAutomaticLogin:self.usernameField.text Password:self.passwordField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


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
    
//    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    NSString *holderText = placeholder;
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:NSMakeRange(0, holderText.length)];
      [placeholdertext addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15]
                    range:NSMakeRange(0, holderText.length)];
      

      textField.attributedPlaceholder = placeholdertext;
    
    
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
    
    if(textField==self.repeatpasswordField){
        
        self.passwordPrompt = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 80, 25)];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"眼_sel"] forState:UIControlStateNormal];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"眼_nor"] forState:UIControlStateSelected];
        
        UIView  *promptView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 80, 35)];
        [self.passwordPrompt addTarget:self action:@selector(repeatPromptClicked:) forControlEvents:UIControlEventTouchUpInside];
        [promptView addSubview:self.passwordPrompt];
        self.repeatpasswordField.rightViewMode = UITextFieldViewModeAlways;
        self.repeatpasswordField.rightView = promptView;
        
    }
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.showprompt) {
        NSString *toastWithString;
        
        CGFloat itemWidth ;
        if (textField==self.usernameField) {
            
            if ([self.usernameField.text isEqualToString:@""])
            {
                toastWithString=@"请输入手机号";
                itemWidth = textField.bounds.size.width/2;
                
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            else if (![self isMobileNumber:self.usernameField.text]) {
                
                itemWidth = textField.bounds.size.width;
                toastWithString=@"手机号格式错误，请输入正确的手机号";
                
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            
            
        }else if (textField==self.passwordField){
            
            
            if ([self.passwordField.text isEqualToString:@""])
            {
                
                itemWidth = textField.bounds.size.width/2;
                toastWithString = @"输入新密码";
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            else if (self.passwordField.text.length <6||self.passwordField.text.length >14)
            {
                itemWidth = textField.bounds.size.width*2/3;
                toastWithString=@"密码长度为6-14位字符";
                
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            
            
        }else if (textField==self.repeatpasswordField){
            
            
            
            
            if ([self.repeatpasswordField.text isEqualToString:@""])
            {
                
                itemWidth = textField.bounds.size.width/2;
                toastWithString = @"请重复输入新密码";
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            else if (self.repeatpasswordField.text.length <6||self.repeatpasswordField.text.length >14)
            {
                itemWidth = textField.bounds.size.width*2/3;
                toastWithString=@"密码长度为6-14位字符";
                
                [self showprompt:textField toastWithString:toastWithString menuWidth:itemWidth];
            }
            
            
        }
    }
    
}

-(void)showprompt:(UITextField *)textField toastWithString:(NSString*)toastWithString menuWidth:(CGFloat)itemWidth  {
    
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
        
    }else if (textField == self.repeatpasswordField){
        
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
        
    }else if (textField == self.verifyField){
        
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
        if (proposedNewLength > 6) {
            
            
            
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



/**
 * 获取验证码
 */
-(void)getVerifyNumber{
    
    
    
    
    if ([self.usernameField.text isEqualToString:@""])
    {
        
        [self showprompt:self.usernameField toastWithString:@"请输入手机号" menuWidth:self.usernameField.bounds.size.width/2];
        
        return;
    }
    else if (![self isMobileNumber:self.usernameField.text]) {
        
        
        [self showprompt:self.usernameField toastWithString:@"手机号格式错误，请输入正确的手机号" menuWidth:self.usernameField.bounds.size.width];
        
        return;
    }
    
    
    [self.verifyField resignFirstResponder];
    
    [self.usernameField resignFirstResponder];
    
    
    
    [self startTime];
    
    
    
    
    [self sendSmsCodeMobile:self.usernameField.text];
    
}

-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        
        
        if (self.verifyError) {
            
            
            timeout=0;
        }
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.verifyError =NO;
                
                //设置界面的按钮显示 根据自己需求设置
                [self.verifyBtn setTitle:@" " forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
                
                [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_hqyzm_nor"] forState:UIControlStateNormal];
                [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_hqyzm_pre"] forState:UIControlStateHighlighted];
            });
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                
                [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_yzm01_nor"] forState:UIControlStateNormal];
                [self.verifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_yzm01_pre"] forState:UIControlStateHighlighted];
                
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%@s重新发送",strTime] forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = NO;
                
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

- (void)PromptClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.passwordField.secureTextEntry = !btn.selected;
}

- (void)repeatPromptClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.repeatpasswordField.secureTextEntry = !btn.selected;
    
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
    [self.repeatpasswordField  resignFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.showprompt = NO;
}

@end