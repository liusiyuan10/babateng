//
//  ParentSayViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/10.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "ParentSayViewController.h"
#import "PlaceholderTextView.h"
#import "EnglishRequestTool.h"
#import "EnglishCommon.h"


#define ParentSay_MAX_LIMIT_NUMS    500

@interface ParentSayViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) PlaceholderTextView *saytextView;
@property(nonatomic, strong) UIButton *submitBtn;

@property(nonatomic, strong) UIView *successView;

@end

@implementation ParentSayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"家长说";

    
    [self LoadChlidView];
    
}

- (void)LoadChlidView
{
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64 - kDevice_IsE_iPhoneX)];
    
    self.bgImageView.image = [UIImage imageNamed:@"studentstyle_bg"];
    
    self.bgImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bgImageView];
    
    self.saytextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(50, 66 + 16,kDeviceWidth - 100, 200)];
    self.saytextView.backgroundColor = [UIColor clearColor];
    self.saytextView.delegate = self;
    self.saytextView.showsVerticalScrollIndicator = YES;
    self.saytextView.font = [UIFont systemFontOfSize:14.f];
    self.saytextView.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];;
    self.saytextView.textAlignment = NSTextAlignmentLeft;
    self.saytextView.editable = YES;
    
    self.saytextView.placeholder = @"您想对外教老师说";
    self.saytextView.placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgImageView addSubview:self.saytextView];
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 74 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.submitBtn.backgroundColor = [UIColor whiteColor];
    self.submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.submitBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [self.submitBtn addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    self.submitBtn.layer.cornerRadius= 22.0f;
    
    self.submitBtn.clipsToBounds = YES;//去除边界
    
    [self.bgImageView addSubview:self.submitBtn];
    
//    self.bgImageView.hidden = YES;

    
    
    self.successView = [[UIImageView alloc] initWithFrame:CGRectMake( (kDeviceWidth - 213)/2.0, 141, 213 , 129+27+30)];
    self.successView.hidden = YES;
    
    [self.view addSubview:self.successView];
    
    UIImageView  *successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 213, 129)];
    
    successImageView.image = [UIImage imageNamed:@"studentstyle_success"];
    

    
    [self.successView addSubview:successImageView];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake((213 - 100)/2.0, CGRectGetMaxY(successImageView.frame) + 27, 100, 23)];
    
    successLabel.text = @"提交成功";
    successLabel.font = [UIFont systemFontOfSize:24.0];
    successLabel.textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:1.0];
    successLabel.textAlignment = NSTextAlignmentCenter;


    [self.successView addSubview:successLabel];
    
    
    
}

- (void)AddSubmit
{
    NSLog(@"--------------%@",self.saytextView.text);
    
    NSString *suggestContentStr = self.saytextView.text;

    //过滤字符串前后的空格
    suggestContentStr = [suggestContentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    //过滤中间空格
    suggestContentStr = [suggestContentStr stringByReplacingOccurrencesOfString:@" " withString:@""];



    if (suggestContentStr.length== 0) {
        
        [self showToastWithString:@"内容不能为空"];
        return;
    }
    
     NSDictionary *params = @{@"suggestContent" :suggestContentStr };
    
    [self startLoading];
    
    [EnglishRequestTool PostuserSuggestParameter:params success:^(EnglishCommon *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {

         
//          self.successView.hidden = NO;
            [self showToastWithString:@"提交成功"];
            
            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:1.0];
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

- (void)GoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        if (offsetRange.location < ParentSay_MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = ParentSay_MAX_LIMIT_NUMS - comcatstr.length;
    
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
    
    if (existTextNum > ParentSay_MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:ParentSay_MAX_LIMIT_NUMS];
        
        [textView setText:s];
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



@end
