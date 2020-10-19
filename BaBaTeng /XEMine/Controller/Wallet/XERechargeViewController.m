//
//  XERechargeViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/9.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XERechargeViewController.h"

#import "PlaceholderTextView.h"
#import "MyDateTimeView.h"
#import "UILabel+LXAdd.h"

#import "XERechargeRecordViewController.h"

#import "MineRequestTool.h"
#import "WalletAdressModel.h"

#import "PanetKnInetlCommon.h"
#import "XEMemberRuleViewController.h"
#import "XERechargeField.h"
#import "ExchangeRateModel.h"


#define XERecharge_MAX_LIMIT_NUMS     100

@interface XERechargeViewController ()<UITextFieldDelegate,UITextViewDelegate>


@property(nonatomic, strong) UITextField *rechargenumField;

@property(nonatomic, copy) NSString *timeStr;

@property(nonatomic, strong) UILabel *RechargeRateLabel;
@property(nonatomic, strong) UILabel *payLabel;


@property(nonatomic, copy) NSString *RechargeRateStr;
//@property (nonatomic, strong) PlaceholderTextView *platformwallettextView;

@end

@implementation XERechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
    
//    [self GetWalletAdress];
    
    [self GetWalletRate];

}

- (void)LoadChlidView
{
 
    UILabel *rechargenumlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 180, 17)];
    
    rechargenumlabel.text = @"充值数量";
    rechargenumlabel.textAlignment = NSTextAlignmentLeft;
    rechargenumlabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    rechargenumlabel.font=[UIFont boldSystemFontOfSize:15.0f];
    
    [self.view addSubview:rechargenumlabel];
    
    self.rechargenumField = [[XERechargeField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(rechargenumlabel.frame) + 16, kDeviceWidth - 32, 48)];
    
    self.rechargenumField.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    self.rechargenumField.textAlignment=NSTextAlignmentLeft;
    self.rechargenumField.textColor=[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];

    self.rechargenumField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.rechargenumField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.rechargenumField.font = [UIFont systemFontOfSize:14.0f];
    self.rechargenumField.layer.cornerRadius = 5;
    
    self.rechargenumField.clipsToBounds = YES;//去除_iocnView
    self.rechargenumField.layer.masksToBounds = YES;
    
    self.rechargenumField.placeholder = @"请输入充值数量";
    
    self.rechargenumField.delegate = self;
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 48)];
    
    //设置 textField 的左侧视图
    //设置左侧视图的显示模式
    self.rechargenumField.leftViewMode = UITextFieldViewModeAlways;
    self.rechargenumField.leftView = lv;
    
    [self.view addSubview:self.rechargenumField];
    
    self.RechargeRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(self.rechargenumField.frame) + 24, kDeviceWidth - 32, 12)];
    
    self.RechargeRateLabel.text = @"兑换汇率:1知识豆=1积分";
    self.RechargeRateLabel.textAlignment = NSTextAlignmentLeft;
    self.RechargeRateLabel.textColor=[UIColor colorWithRed:176/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
    
    self.RechargeRateLabel.font=[UIFont systemFontOfSize:12.0f];
    self.RechargeRateLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.RechargeRateLabel];
    
    UILabel *paytextlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.RechargeRateLabel.frame) + 12, 70, 12)];
    
    paytextlabel.text = @"需要付款:";
    paytextlabel.textAlignment = NSTextAlignmentLeft;
    paytextlabel.textColor=[UIColor colorWithRed:176/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
    
    paytextlabel.font=[UIFont systemFontOfSize:12.0f];
    
    [self.view addSubview:paytextlabel];
    
    self.payLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paytextlabel.frame),CGRectGetMaxY(self.RechargeRateLabel.frame) + 12, 200, 12)];
    
    self.payLabel.text = @"23334.000知识豆";
    self.payLabel.textAlignment = NSTextAlignmentLeft;
    self.payLabel.textColor=MNavBackgroundColor;
    
    self.payLabel.font=[UIFont systemFontOfSize:12.0f];
    self.payLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.payLabel];
    
    [self createLabele];
    
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,KDeviceHeight - 64 - 48,kDeviceWidth, 48)];
    
    submitBtn.backgroundColor = MNavBackgroundColor;
    submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    
    [self.view addSubview:submitBtn];
    

    
    [self setNavigationItem];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"充值记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)GetWalletRate
{
    [self startLoading];
    
    [MineRequestTool GetpointWalletExchangesuccess:^(ExchangeRateModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
 
            self.RechargeRateLabel.text = [NSString stringWithFormat:@"兑换汇率:%@知识豆=1积分",respone.data.peasRate];
            
            CGFloat rechargnum =  [self.rechargenumField.text floatValue];
            self.payLabel.text =[NSString stringWithFormat:@"%.5f知识豆",rechargnum*[respone.data.peasRate doubleValue]];
            self.RechargeRateStr = respone.data.peasRate;
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"textfield text %@",textField.text);
    
    CGFloat rechargnum =  [textField.text doubleValue];
    
    self.payLabel.text =[NSString stringWithFormat:@"%.5f知识豆",rechargnum*[self.RechargeRateStr doubleValue]];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
     if (textField == self.rechargenumField){
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
        return YES;
    }
    
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{

    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < XERecharge_MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = XERecharge_MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            
        }
        return NO;
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

- (void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:[textView text]];
        if (![text isEqualToString:textView.text]) {
            NSRange textRange = [textView selectedRange];
            textView.text = text;
            [textView setSelectedRange:textRange];
        }
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > XERecharge_MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:XERecharge_MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    

}


//- (BOOL)isPureFloat:(NSString*)string {
//    NSScanner *scan = [NSScanner scannerWithString:string];
//
//    float val;
//
//    return [scan scanFloat:&val] && [scan isAtEnd];
//
//}





- (void)rightbuttonClicked
{
    XERechargeRecordViewController *XERechargeRecord = [[XERechargeRecordViewController alloc] init];
    
    [self.navigationController pushViewController:XERechargeRecord animated:YES];
    
}


-(void)createLabele
{
    
    
    UILabel *lab=[[UILabel alloc] init];
    lab.text=@"充值说明>>";
    lab.backgroundColor=[UIColor clearColor];
    lab.numberOfLines=0;
    
    lab.font=[UIFont systemFontOfSize:12];
    lab.characterSpace=0;//字间距
    lab.lineSpace=5;//行间距
    lab.textColor  = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    //关键字
    lab.keywords=@"充值说明>>";
    lab.keywordsColor= MNavBackgroundColor;
    lab.keywordsFont=[UIFont boldSystemFontOfSize:15];
    //下划线
    //    lab.underlineStr=@"<<用户协议>>";
    //    lab.underlineColor=[UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    //计算label的宽高
    CGRect h =  [lab getLableHeightWithMaxWidth:300];
    lab.frame=CGRectMake( 15, CGRectGetMaxY(self.payLabel.frame) + 24, 200, h.size.height+30);
    lab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lab];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    
    // 2. 将点击事件添加到label上
    [lab addGestureRecognizer:labelTapGestureRecognizer];
    lab.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
}


- (void)labelClick
{
    XEMemberRuleViewController *XEMemberRuleVC = [[XEMemberRuleViewController alloc] init];
    
    XEMemberRuleVC.title = @"充值说明";
    XEMemberRuleVC.ruleType = @"3";
    [self.navigationController pushViewController:XEMemberRuleVC animated:YES];
}

- (void)submitBtnClicked
{
    
    if (self.rechargenumField.text.length == 0) {
        
        [self showToastWithString:@"充值数量不能为空"];
        return;
    }
    
    if ([self.rechargenumField.text floatValue] <= 0) {
        
        [self showToastWithString:@"充值数量不能为0"];
        return;
    }

    if ([self.rechargenumField.text floatValue] > 99999999999) {
        
        [self showToastWithString:@"超出最大限制数量"];
        return;
        
    }
    
//    NSDictionary *parameter = @{@"rechargeSocre" :  self.rechargenumField.text, @"peasRate" : @"10"};
    NSDictionary *parameter = @{@"rechargeSocre" :  self.rechargenumField.text};
    NSLog(@"parameter========%@",parameter);
    
    [self startLoading];
    
    [MineRequestTool PostpointWalletExchangeParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
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
    
//    [MineRequestTool PostWalletRechargeParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
//
//        [self stopLoading];
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//            [self showToastWithString:@"提交充值"];
//
//             [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];
//
//
//
//
//        }else{
//
//
//            [self showToastWithString:respone.message];
//        }
//
//    } failure:^(NSError * _Nonnull error) {
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//    }];
    
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
