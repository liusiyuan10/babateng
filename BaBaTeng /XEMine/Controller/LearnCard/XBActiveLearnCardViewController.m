//
//  XBActiveLearnCardViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBActiveLearnCardViewController.h"
#import "MineRequestTool.h"

#import "PanetKnInetlCommon.h"

@interface XBActiveLearnCardViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *cardField;
@property(nonatomic, strong) UITextField *passwordField;
@property(nonatomic, strong) UIButton *submitBtn;


@end

@implementation XBActiveLearnCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"激活卡";
    
    [self LoadChlidView];
}

- (void)LoadChlidView
{
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,60)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.view addSubview:back1View];
    
    self.cardField = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 14)];
    
    self.cardField.backgroundColor=[UIColor clearColor];
    self.cardField.textAlignment=NSTextAlignmentRight;
    self.cardField.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.cardField.placeholder = @"请输入卡号";
    self.cardField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.cardField.font = [UIFont systemFontOfSize:14.0f];
    self.cardField.returnKeyType=UIReturnKeyNext;
    self.cardField.delegate = self;
    self.cardField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.cardField addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    [back1View addSubview:self.cardField];
    
    UILabel *cardlabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 24, 80, 16)];
    
    cardlabel.text = @"卡号";
    cardlabel.textAlignment = NSTextAlignmentLeft;
    cardlabel.textColor= [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];//[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    cardlabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back1View addSubview:cardlabel];
    
    UIView *back2View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(back1View.frame) + 16, kDeviceWidth - 32,60)];
    back2View.backgroundColor = [UIColor whiteColor];
    
    back2View.layer.cornerRadius= 15.0f;
    
    back2View.layer.borderWidth = 1.0;
    back2View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back2View.clipsToBounds = YES;//去除边界
    back2View.layer.masksToBounds = YES;
    
    [self.view addSubview:back2View];
    
    
    
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 180, 24, 140, 14)];
    
    self.passwordField.backgroundColor=[UIColor clearColor];
    self.passwordField.textAlignment=NSTextAlignmentRight;
    self.passwordField.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.passwordField.font = [UIFont systemFontOfSize:14.0f];
    self.passwordField.returnKeyType=UIReturnKeyNext;
    self.passwordField.delegate = self;
//    self.passwordField.secureTextEntry = YES;
    self.cardField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.passwordField addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];

    
    [back2View addSubview:self.passwordField];
    
    
    UILabel *passwordlabel = [[UILabel alloc] initWithFrame:CGRectMake(13,  23, 120, 16)];
    
    passwordlabel.text = @"密码";
    passwordlabel.textAlignment = NSTextAlignmentLeft;
    passwordlabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0]; //[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    passwordlabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back2View addSubview:passwordlabel];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 36 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.submitBtn.backgroundColor = MNavBackgroundColor;
    self.submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.submitBtn addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.submitBtn.layer.cornerRadius= 22.0f;
    
    self.submitBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.submitBtn];

}

- (void)textFiledEditChanged:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:textField.text];
        if (![text isEqualToString:textField.text]) {
            textField.text = text;
        }
    }
    
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.cardField){
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 14) {
            return NO;//限制长度
        }
        return YES;
    }
    
    
    return YES;
}



- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.cardField) {
        //self.usernameTextfield放弃第一响应者，而self.passwordTextfield变为第一响应者
        [self.cardField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if(textField == self.passwordField) {
        //self.passwordTextfield放弃第一响应者，并调用登录函数
        [self.passwordField resignFirstResponder];
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
    [self.cardField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    
    
}

- (void)AddSubmit
{
    if (self.cardField.text.length == 0) {
        
        [self showToastWithString:@"卡号不能为空"];
        return;
    }
    
    if (self.passwordField.text.length == 0 ) {
        
        [self showToastWithString:@"密码不能为空"];
        return;
    }
    



    NSDictionary *parameter = @{@"appName" :  BBT_APP_TYPE, @"cardNo" : self.cardField.text, @"cardPwd" : self.passwordField.text};

    NSLog(@"parameter========%@",parameter);
    
    [self startLoading];
    
    [MineRequestTool PoststudyCardactive:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self showToastWithString:@"提交成功"];
            
            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];
            
            
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];

}

- (void)GoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
