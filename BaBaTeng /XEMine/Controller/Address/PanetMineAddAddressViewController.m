//
//  PanetMineAddAddressViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineAddAddressViewController.h"
#import "AddressPickView.h"
#import "PlaceholderTextView.h"
#import "MineRequestTool.h"
#import "PanetKnInetlCommon.h"
#define PanetMineAddAddress_MAX_LIMIT_NUMS     50

@interface PanetMineAddAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic, strong) UITextField *nametext;

@property(nonatomic, strong) UITextField *phonetext;

@property(nonatomic, strong) UILabel *areatextlabel;

//@property(nonatomic, strong) UITextField *phonetext;

@property (nonatomic, strong) UIImageView *informationView;



@property (nonatomic, strong) PlaceholderTextView *addrestextView;

@property (nonatomic, copy) NSString *provinceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *townStr;

@end

@implementation PanetMineAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增地址";
    
    [self LoadChlidView];

//          self.areatextlabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town] ;
    
}

- (void)LoadChlidView
{
    [self LoadinformationView];
    [self setNavigationItem];
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"保存" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(SaveAddress) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}


- (void)LoadinformationView
{
    //    RealNamerectangle
    self.informationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 21, kDeviceWidth, 288)];
    self.informationView.image = [UIImage imageNamed:@"PanetMine_addadress_bg"];
    self.informationView.userInteractionEnabled = YES;
    [self.informationView.layer setCornerRadius:10];
    self.informationView.backgroundColor = [UIColor clearColor];
    self.informationView.clipsToBounds=YES;
    
    [self.view addSubview:self.informationView];
    
    self.nametext = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 16)];
    
    self.nametext.backgroundColor=[UIColor clearColor];
    self.nametext.textAlignment=NSTextAlignmentRight;
    self.nametext.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.nametext.placeholder = @"填写收货人姓名";
    self.nametext.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.nametext.font = [UIFont systemFontOfSize:14.0f];
    self.nametext.returnKeyType=UIReturnKeyNext;
    self.nametext.delegate = self;
    [self.nametext addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.informationView addSubview:self.nametext];
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 24, 80, 17)];
    
    namelabel.text = @"收货人";
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    namelabel.font=[UIFont systemFontOfSize:16.0f];
    
    [self.informationView addSubview:namelabel];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(38, CGRectGetMaxY(namelabel.frame) + 22, kDeviceWidth - 38*2, 1)];
    line1.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:0.3];
    
    [self.informationView addSubview:line1];
    
    self.phonetext = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, CGRectGetMaxY(line1.frame) + 25, 120, 13)];
    
    self.phonetext.backgroundColor=[UIColor clearColor];
    self.phonetext.textAlignment=NSTextAlignmentRight;
    self.phonetext.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.phonetext .placeholder = @"请填写手机号码";
    self.phonetext.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.phonetext.keyboardType = UIKeyboardTypeNumberPad;
    self.phonetext.font = [UIFont systemFontOfSize:14.0f];
    self.phonetext.returnKeyType=UIReturnKeyNext;
    self.phonetext .delegate = self;
    
    [self.informationView addSubview:self.phonetext];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(39, CGRectGetMaxY(line1.frame) + 24, 100, 17)];
    
    phonelabel.text = @"手机号码";
    phonelabel.textAlignment = NSTextAlignmentLeft;
    phonelabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    phonelabel.font=[UIFont systemFontOfSize:16.0f];
    
    
    [self.informationView addSubview:phonelabel];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(38, CGRectGetMaxY(phonelabel.frame) + 22, kDeviceWidth - 38*2, 1)];
    line2.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:0.3];
    
    [self.informationView addSubview:line2];
    
    UILabel *arealabel = [[UILabel alloc] initWithFrame:CGRectMake(39, CGRectGetMaxY(line2.frame) + 24, 100, 17)];
    
    arealabel.text = @"所属地区";
    arealabel.textAlignment = NSTextAlignmentLeft;
    arealabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    arealabel.font=[UIFont systemFontOfSize:16.0f];
    
    
    [self.informationView addSubview:arealabel];
    
    self.areatextlabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 240, CGRectGetMaxY(line2.frame) + 25, 200, 13)];
    
    self.areatextlabel.text = @"请选择所属地区";
    self.areatextlabel.textAlignment = NSTextAlignmentRight;
    self.areatextlabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];;
    self.areatextlabel.backgroundColor = [UIColor clearColor];
    self.areatextlabel.font=[UIFont systemFontOfSize:14.0f];
    
    
    [self.informationView addSubview:self.areatextlabel];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(38, CGRectGetMaxY(arealabel.frame) + 22, kDeviceWidth - 38*2, 1)];
    line3.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:0.3];
    
    [self.informationView addSubview:line3];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areatextlabelClick)];
    
    // 2. 将点击事件添加到label上
    [self.areatextlabel addGestureRecognizer:labelTapGestureRecognizer];
    self.areatextlabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    
    UILabel *addresslabel = [[UILabel alloc] initWithFrame:CGRectMake(39, CGRectGetMaxY(line3.frame) + 24, 100, 17)];
    
    addresslabel.text = @"详细地址";
    addresslabel.textAlignment = NSTextAlignmentLeft;
    addresslabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    addresslabel.font=[UIFont systemFontOfSize:16.0f];
    
    
    [self.informationView addSubview:addresslabel];
    
    self.addrestextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(kDeviceWidth - 240, CGRectGetMaxY(line3.frame) + 25, 200, 40)];
    self.addrestextView.backgroundColor = [UIColor clearColor];
    self.addrestextView.delegate = self;
    self.addrestextView.showsVerticalScrollIndicator = YES;
    self.addrestextView.font = [UIFont systemFontOfSize:14.f];
    self.addrestextView.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];;
    self.addrestextView.textAlignment = NSTextAlignmentRight;
    self.addrestextView.editable = YES;

    self.addrestextView.placeholder = @"                   请填写详细地址";
    self.addrestextView.placeHolderLabel.textAlignment = NSTextAlignmentRight;
    [self.informationView addSubview:self.addrestextView];
    
    
}

- (void)SaveAddress
{
    NSLog(@"dsdfdfdfdf");
    
    //    address    详细地址    string    @mock=梧桐岛
    //    area    地区    string    @mock=宝安区
    //    city    城市    string    @mock=深圳市
    //    isDefault    是否默认    boolean    @mock=true
    //    postCode    邮政编码    string    @mock=518000
    //    province    省份    string    @mock=广东省
    //    receiverName    收件人    string    @mock=test
    //    receiverPhone    手机号码    string    @mock=15112295282

    if (self.nametext.text.length == 0) {
        
        [self showToastWithString:@"收货人姓名不能为空"];
        return;
    }
    
    if (self.phonetext.text.length == 0) {
        
        [self showToastWithString:@"收货人手机号不能为空"];
        return;
    }
    
    if (![self isMobileNumber:self.phonetext.text]) {
        

        [self showToastWithString:@"手机号格式错误，请输入正确的手机号"];
        return;
    }
    
    if (self.areatextlabel.text.length == 0) {
        
        [self showToastWithString:@"请选择省市区"];
        return;
    }
    
    
    if (self.addrestextView.text.length == 0) {
        
        [self showToastWithString:@"详细地址不能为空"];
        return;
    }
    
    if (self.provinceStr.length == 0 &&self.cityStr.length == 0&&self.townStr.length == 0) {
        [self showToastWithString:@"请选择省市区"];
        return;
    }
    
    
    NSDictionary *parameter = @{@"address" : self.addrestextView.text, @"province": self.provinceStr, @"city": self.cityStr,@"area": self.townStr,@"isDefault":@"",@"postCode":@"",@"receiverName":self.nametext.text,@"receiverPhone":self.phonetext.text };
    
    [self startLoading];
    
    [MineRequestTool PostPanetMineaddressnParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
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
//    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9]|6[0-9]|9[0-9]|2[0-9])\\d{8}$";
    
    NSString *MOBILE = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9])|(16[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
      if (textField == self.phonetext){
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
        return YES;
    }
    else if(textField == self.nametext)
    {
        
        
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 8) {
            return NO;//限制长度
        }
    
        
        return YES;
    }
    
//    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
//        return NO;
//    }
    
    
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
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nametext) {
        //self.usernameTextfield放弃第一响应者，而self.passwordTextfield变为第一响应者
        [self.nametext resignFirstResponder];
        [self.phonetext becomeFirstResponder];
    } else if(textField == self.phonetext) {
        //self.passwordTextfield放弃第一响应者，并调用登录函数
        [self.phonetext resignFirstResponder];
        [self.addrestextView becomeFirstResponder];
    }
    
//    else if(textField == self.zhifubaotext) {
//        //self.passwordTextfield放弃第一响应者，并调用登录函数
//        [self.zhifubaotext resignFirstResponder];
//        [self.weixintext becomeFirstResponder];
//    }    else if(textField == self.weixintext) {
//        //self.passwordTextfield放弃第一响应者，并调用登录函数
//        [self.weixintext resignFirstResponder];
//
//    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
//      NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//
//       if (![text isEqualToString:tem]) {
//
//                    return NO;
//
//                }

//    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
//
//    if (![text isEqualToString:tem]) {
//        return NO;
//    }
    
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
        
        if (offsetRange.location < PanetMineAddAddress_MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = PanetMineAddAddress_MAX_LIMIT_NUMS - comcatstr.length;
    
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
    
    if (existTextNum > PanetMineAddAddress_MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:PanetMineAddAddress_MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
    [self.phonetext resignFirstResponder];
    [self.nametext resignFirstResponder];
    [self.addrestextView resignFirstResponder];
  
    
    
}

- (void)areatextlabelClick
{
    
    NSLog(@"ddd");
    AddressPickView *addressPickView = [AddressPickView shareInstance];
    [self.view addSubview:addressPickView];
    
    
    addressPickView.block = ^(NSString *province,NSString *city,NSString *town){
        self.areatextlabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town] ;
        self.provinceStr = province;
        self.cityStr = city;
        self.townStr = town;
    };
    
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
