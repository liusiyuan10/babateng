//
//  BBTBigChangePasswordViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBigChangePasswordViewController.h"
#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTMainTool.h"
#import "NSString+Hash.h"
#import "PasswordEncrypt.h"

@interface BBTBigChangePasswordViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *oldPasswordField;

@property (nonatomic, strong) UITextField   *newsPasswordField;
@property (nonatomic, strong) UITextField   *newsAagePasswordField;
@property (nonatomic, strong) UIButton      *completeBtn;

//@property (nonatomic, strong) UIButton      *forgetBtn;

@property (nonatomic, strong) UIButton      *passwordPrompt;

@property (strong, nonatomic) UIImageView  *bgBlurredView;

@property (nonatomic, assign)  CGFloat padding;

@end

@implementation BBTBigChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    //    self.navigationController.navigationBar.translucent = YES;
    //    [self.view addSubview:self.bgBlurredView];
    
    
    if(320<=kDeviceWidth && kDeviceWidth<375){
        
        self.padding = 20;
        
    }else if (375<=kDeviceWidth && kDeviceWidth<414){
        
        self.padding = 30;
        
    }else if (414<=kDeviceWidth){
        
        self.padding = 40;
        
    }else{
        
        self.padding = 20;
        
    }
    
    
    
    self.oldPasswordField = [[UITextField alloc] initWithFrame:CGRectMake( self.padding,40, kDeviceWidth -  self.padding*2, 50)];
    
    [self setViewWithTextField:self.oldPasswordField placeholder:@"输入旧密码" font: [UIFont systemFontOfSize:15]];
    self.oldPasswordField.secureTextEntry = YES;
    [self.view addSubview:self.oldPasswordField];
    
    
    self.newsPasswordField = [[UITextField alloc] initWithFrame:CGRectMake( self.padding, CGRectGetMaxY(self.oldPasswordField.frame) + 30, kDeviceWidth -  self.padding*2, 50)];
    [self setViewWithTextField:self.newsPasswordField  placeholder:@"设置6-20位新密码" font: [UIFont systemFontOfSize:15]];
    self.newsPasswordField.secureTextEntry = YES;
    [self.view addSubview:self.newsPasswordField];
    
    
    self.newsAagePasswordField = [[UITextField alloc] initWithFrame:CGRectMake( self.padding, CGRectGetMaxY(self.newsPasswordField.frame) + 15, kDeviceWidth -  self.padding*2, 50)];
    [self setViewWithTextField:self.newsAagePasswordField  placeholder:@"重新输入新密码" font: [UIFont systemFontOfSize:15]];
    self.newsAagePasswordField.secureTextEntry = YES;
    [self.view addSubview:self.newsAagePasswordField];
    
    
    //    //登录 注册 忘记密码  等相关按钮
    //
    //    self.forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-70-self.padding, CGRectGetMaxY(self.newsAagePasswordField.frame)  +20, 70, 25)];
    //    [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    //    self.forgetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    [self.forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    //    [self.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.forgetBtn];
    
    self.completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.padding, CGRectGetMaxY(self.newsAagePasswordField.frame) + 70, kDeviceWidth-self.padding*2, 50)];
    
    //    [self.completeBtn setImage:[UIImage imageNamed:@"btn_wangcheng_nor"] forState:UIControlStateNormal];
    //    [self.completeBtn setImage:[UIImage imageNamed:@"btn_wangcheng_pre"] forState:UIControlStateSelected];
    
    
    [self.completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
    [self.completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
    [self.completeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.completeBtn.titleLabel.font = BBT_TWO_FONT;
    
    [self.completeBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.completeBtn];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.oldPasswordField resignFirstResponder];
    [self.newsPasswordField resignFirstResponder];
    
}

-(void)completeClick{
    
    
    NSLog(@"完成");
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.oldPasswordField resignFirstResponder];
    [self.newsPasswordField resignFirstResponder];
    
    
    if ([self.oldPasswordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请输入旧密码"];
        
        return;
    }
    else if (self.oldPasswordField.text.length <6||self.oldPasswordField.text.length >14)
    {
        
        [self showToastWithString:@"密码长度为6-14位字符"];
        
        return;
    }
    
    else if ([self.newsPasswordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请输入新密码"];
        
        return;
    }
    else if (self.newsPasswordField.text.length <6||self.newsPasswordField.text.length >14)
    {
        
        [self showToastWithString:@"密码长度为6-14位字符"];
        
        return;
    }
    
    
    
    else if ([self.newsAagePasswordField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请再次输入新密码"];
        
        return;
    }
    else if (![self.newsPasswordField.text isEqualToString:self.newsAagePasswordField.text])
    {
        
        [self showToastWithString:@"新密码两次输入不一致"];
        
        return;
    }
    
    
    [self updatepwd:[[TMCache sharedCache] objectForKey:@"userId"] uoldpwd:self.oldPasswordField.text unewpwd:self.newsPasswordField.text];
    
    
    
}
- (void)updatepwd:(NSString *)userId uoldpwd:(NSString *)uoldpwd  unewpwd:(NSString *)unewpwd{
    
    PasswordEncrypt *encypy = [[PasswordEncrypt alloc] init];
    
    [self startLoading];
    
    [BBTLoginRequestTool updatepwd:userId uoldpwd:[encypy Encode:[uoldpwd md5String]] unewpwd:[encypy Encode:[unewpwd md5String]] upload:^(BBTUserInfoRespone *registerRespone) {
        
        [self stopLoading];
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            [self showToastWithString:@"密码修改成功,请重新登录"];
            
            [[TMCache sharedCache]removeObjectForKey:@"userId"];
            [[TMCache sharedCache]removeObjectForKey:@"token"];
            //[[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
            [[TMCache sharedCache]removeObjectForKey:@"password"];
            [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
            [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
            [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
            [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
            [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
            [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
            [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
}

-(void)delayMethod{
    
    [BBTMainTool setLoginRootViewController:CZKeyWindow];
    
}

-(void)forgetBtnClick{
    
    NSLog(@"忘记密码");
    
    
}
#pragma mark -textField 初始化封装
-(void)setViewWithTextField:(UITextField *)textField placeholder:(NSString*)placeholder font:(UIFont*)font{
    
    textField.delegate = self;
    textField.font = font;
//    textField.placeholder =placeholder;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    // textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.5f;
    textField.layer.cornerRadius = 8;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor lightGrayColor];
//    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    NSString *holderText = placeholder;
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:NSMakeRange(0, holderText.length)];
      [placeholdertext addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15]
                    range:NSMakeRange(0, holderText.length)];
      

      textField.attributedPlaceholder = placeholdertext;
    
    
    
    UIView  *promptleftView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 20, 35)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = promptleftView;
    
    //    if(textField==self.oldPasswordField){
    
    self.passwordPrompt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    [self.passwordPrompt setImage:[UIImage imageNamed:@"icon_yan1_sel"] forState:UIControlStateNormal];
    [self.passwordPrompt setImage:[UIImage imageNamed:@"icon_yan1_nor"] forState:UIControlStateSelected];
    
    UIView  *promptView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 80, 35)];
    
    [self.passwordPrompt addTarget:self action:@selector(PromptClicked:) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:self.passwordPrompt];
    
    
    
    if(textField==self.oldPasswordField){
        
        
        self.passwordPrompt.tag=1001;
        self.oldPasswordField.rightViewMode = UITextFieldViewModeAlways;
        self.oldPasswordField.rightView = promptView;
        
    }else if(textField==self.newsPasswordField){
        
        
        self.passwordPrompt.tag=1002;
        self.newsPasswordField.rightViewMode = UITextFieldViewModeAlways;
        self.newsPasswordField.rightView = promptView;
        
    }else{
        
        self.passwordPrompt.tag=1003;
        self.newsAagePasswordField.rightViewMode = UITextFieldViewModeAlways;
        self.newsAagePasswordField.rightView = promptView;
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
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
}

- (void)PromptClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.tag==1001) {
        
        self.oldPasswordField.secureTextEntry = !btn.selected;
        
    }
    else   if (btn.tag==1002) {
        
        self.newsPasswordField.secureTextEntry = !btn.selected;
        
    }else {
        
        self.newsAagePasswordField.secureTextEntry = !btn.selected;
        
    }
    
    
    
}


//- (void)PromptClicked:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//
//    if (btn.tag==1001) {
//
//        self.oldPasswordField.secureTextEntry = !btn.selected;
//
//    }else{
//
//        self.newsPasswordField.secureTextEntry = !btn.selected;
//    }
//
//
//
//}

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
    
    [self.oldPasswordField resignFirstResponder];
    [self.newsPasswordField resignFirstResponder];
    
    
    [self.view endEditing:YES];
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
#pragma mark -textField 防止键盘挡住输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    NSLog(@"textFieldDidBeginEditing");
    
    CGRect frame = textField.frame;
    
    CGFloat heights = self.view.frame.size.height;
    
    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度）
    
    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
    
    int offset = frame.origin.y + 42- ( heights - 216.0-35.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    if(offset > 0)
        
    {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        self.view.frame = rect;
        
    }
    
    [UIView commitAnimations];
    
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
