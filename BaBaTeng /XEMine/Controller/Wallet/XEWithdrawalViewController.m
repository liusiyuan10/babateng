//
//  XEWithdrawalViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/6/6.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEWithdrawalViewController.h"
#import "XERechargeField.h"
#import "XEMemberRuleViewController.h"
#import "XERechargeRecordViewController.h"

#import "MineRequestTool.h"

#import "PanetKnInetlCommon.h"
#import "PanetRequestTool.h"
#import "RealNameDataModel.h"
#import "RealNameModel.h"

@interface XEWithdrawalViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UILabel *auditnameLabel;

@property(nonatomic, strong) UILabel *auditzhifubaoLabel;
@property(nonatomic, strong) UILabel *auditphoneLabel;
@property(nonatomic, strong) UITextField *withdrawalField;

@property(nonatomic, strong) UILabel *auditwithdrawalLabel;

@property(nonatomic, strong) UIButton *submitBtn;

@end

@implementation XEWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
    
    [self Getauthentication];
}

- (void)LoadChlidView
{
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 80, 14)];
    
    namelabel.text = @"真实姓名:";
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    
    namelabel.font=[UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:namelabel];
    
    self.auditnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(namelabel.frame), 17, 120, 16)];
    
    self.auditnameLabel.backgroundColor=[UIColor clearColor];
    self.auditnameLabel.textAlignment=NSTextAlignmentLeft;
    self.auditnameLabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.auditnameLabel.text =@"";
    
    self.auditnameLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    [self.view addSubview:self.auditnameLabel];
    
    UILabel *zhifubaolabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(namelabel.frame) +  17, 80, 14)];
    
    zhifubaolabel.text = @"支付宝号:";
    zhifubaolabel.textAlignment = NSTextAlignmentLeft;
    zhifubaolabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    
    zhifubaolabel.font=[UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:zhifubaolabel];
    
    self.auditzhifubaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zhifubaolabel.frame), CGRectGetMaxY(namelabel.frame) +17, 120, 17)];
    
    self.auditzhifubaoLabel.backgroundColor=[UIColor clearColor];
    self.auditzhifubaoLabel.textAlignment=NSTextAlignmentLeft;
    self.auditzhifubaoLabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.auditzhifubaoLabel.text = @"";
    self.auditzhifubaoLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    [self.view addSubview:self.auditzhifubaoLabel];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(zhifubaolabel.frame) +  17, 80, 14)];
    
    phonelabel.text = @"手机号码:";
    phonelabel.textAlignment = NSTextAlignmentLeft;
    phonelabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    
    phonelabel.font=[UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:phonelabel];
    
    self.auditphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phonelabel.frame), CGRectGetMaxY(zhifubaolabel.frame) +17, 120, 15)];
    
    self.auditphoneLabel.backgroundColor=[UIColor clearColor];
    self.auditphoneLabel.textAlignment=NSTextAlignmentLeft;
    self.auditphoneLabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.auditphoneLabel.text = @"";
    self.auditphoneLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    [self.view addSubview:self.auditphoneLabel];
    
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(phonelabel.frame) + 20, kDeviceWidth - 32,60)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.view addSubview:back1View];
    
    UILabel *withdrawallabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 80, 13)];
    
    withdrawallabel.text = @"提现金额";
    withdrawallabel.textAlignment = NSTextAlignmentLeft;
    withdrawallabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    
    withdrawallabel.font=[UIFont systemFontOfSize:14.0f];
    
    [back1View addSubview:withdrawallabel];
    
    self.withdrawalField = [[XERechargeField alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 12)];
    
    self.withdrawalField.backgroundColor=[UIColor clearColor];
    self.withdrawalField.textAlignment=NSTextAlignmentRight;
    self.withdrawalField.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.withdrawalField.placeholder = @"请输入提现金额";
    self.withdrawalField.keyboardType = UIKeyboardTypeNumberPad;
    self.withdrawalField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.withdrawalField.font = [UIFont systemFontOfSize:12.0f];

    self.withdrawalField.delegate = self;
    [self.withdrawalField addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
  
    
    [back1View addSubview:self.withdrawalField];
    
    self.auditwithdrawalLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(back1View.frame) +8, kDeviceWidth - 16, 11)];
    
    self.auditwithdrawalLabel.backgroundColor=[UIColor clearColor];
    self.auditwithdrawalLabel.textAlignment=NSTextAlignmentLeft;
    self.auditwithdrawalLabel.textColor=[UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    self.auditwithdrawalLabel.text = [NSString stringWithFormat:@"提现只能是整数，最低提现100元，当前可提现余额：¥%@",self.enableProfitstr];
    self.auditwithdrawalLabel.font = [UIFont systemFontOfSize:10.0f];
    
    
    [self.view addSubview:self.auditwithdrawalLabel];
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 71 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.submitBtn.backgroundColor = MNavBackgroundColor;
    self.submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    
    [self.submitBtn addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.submitBtn.layer.cornerRadius= 22.0f;
    
    self.submitBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.submitBtn];
    

    UILabel *tixianlabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 80)/2.0 , CGRectGetMaxY(self.submitBtn.frame) + 21, 80, 14)];
    
    tixianlabel.text = @"提现说明";
    tixianlabel.textAlignment = NSTextAlignmentCenter;
    tixianlabel.textColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    
    tixianlabel.font=[UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:tixianlabel];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    
    // 2. 将点击事件添加到label上
    [tixianlabel addGestureRecognizer:labelTapGestureRecognizer];
    tixianlabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [self setNavigationItem];
    
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"提现记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)rightbuttonClicked
{
    XERechargeRecordViewController *XERechargeRecord = [[XERechargeRecordViewController alloc] init];
    
    [self.navigationController pushViewController:XERechargeRecord animated:YES];
    
}


- (void)Getauthentication
{
    [self startLoading];
    
    [PanetRequestTool Getauthenticationsuccess:^(RealNameModel * _Nonnull respone) {
        [self stopLoading];
        
       if([respone.statusCode isEqualToString:@"0"])
        {
            
//            self.realnamedata = respone.data;
            self.auditnameLabel.text = respone.data.realName;
            self.auditzhifubaoLabel.text = respone.data.alipayAccount;
            self.auditphoneLabel.text = [[TMCache sharedCache] objectForKey:@"phoneNumber"];
        
            
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)AddSubmit
{
    
    if (self.withdrawalField.text.length == 0) {
        
        [self showToastWithString:@"提现金额不能为空"];
        return;
    }
    
    if ([self.withdrawalField.text floatValue] < 100) {
        
        [self showToastWithString:@"提现金额最低提现100元"];
        return;
    }
    
     NSLog(@"========%.2f   ========%.2f",[self.withdrawalField.text floatValue],[self.enableProfitstr floatValue]);
    
    if ([self.withdrawalField.text floatValue] > [self.enableProfitstr floatValue]) {
        
        [self showToastWithString:@"超出最大可提现金额"];
        return;
    }
    
    if ([self.withdrawalField.text floatValue] > 99999999999) {
        
        [self showToastWithString:@"超出最大限制数量"];
        return;
        
    }
    
    
    NSDictionary *parameter = @{@"withdrawMoney" :  self.withdrawalField.text, @"alipayNo" : self.auditzhifubaoLabel.text};
    NSLog(@"parameter========%@",parameter);
    
    
    [self startLoading];
    
    [MineRequestTool PostwithDrawMoneyapply:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
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

- (void)labelClick
{
    XEMemberRuleViewController *XEMemberRuleVC = [[XEMemberRuleViewController alloc] init];

    XEMemberRuleVC.title = @"提现说明";
    XEMemberRuleVC.ruleType = @"3";
    [self.navigationController pushViewController:XEMemberRuleVC animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.withdrawalField){
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
        return YES;
    }
    
    
    return YES;
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



- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


- (void)GoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
