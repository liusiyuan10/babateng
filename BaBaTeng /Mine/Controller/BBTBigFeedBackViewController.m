//
//  BBTBigFeedBackViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/29.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBigFeedBackViewController.h"
#import "PlaceholderTextView.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define MAX_LIMIT_NUMS     200
@interface BBTBigFeedBackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * lbNums;

@end

@implementation BBTBigFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, kDeviceWidth-60, 30)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = MainFontColorTWO;//[UIColor lightGrayColor];
    self.titleLabel.text = @"问题和意见";
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view  addSubview:self.titleLabel];
    
    [self.view addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.sendButton];
    
    [self.view addSubview:self.lbNums];
}




-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 180)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = YES;
        _textView.font = [UIFont systemFontOfSize:15.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 8.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = [UIColor lightGrayColor];//RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"请输入10个字以上的问题描述以便我们提供更好的帮助";
    }
    
    return _textView;
}

- (UIButton *)sendButton{
    
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 2.0f;
        _sendButton.frame = CGRectMake(20, CGRectGetMaxY(self.textView.frame)+60, self.view.frame.size.width - 40, 50);
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_nor"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn_cheng_pre"] forState:UIControlStateHighlighted];
        
        [_sendButton setTitle:@"提 交" forState:UIControlStateNormal];
        [ _sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [_sendButton addTarget:self action:@selector(sendFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendButton;
    
}

-(UILabel *)lbNums{
    
    if (!_lbNums) {
        _lbNums = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-140, CGRectGetMaxY(self.textView.frame)-30, 120, 30)];
        _lbNums.backgroundColor = [UIColor clearColor];
        _lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        _lbNums.font = [UIFont systemFontOfSize:15.f];
        _lbNums.textColor = [UIColor lightGrayColor];
        _lbNums.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _lbNums;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //
    //     //过滤表情符号
    //    if ([self stringContainsEmoji:textView.text]) {
    //
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
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
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
            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            
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




/*
 *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
- (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

//作者：Jingege
//链接：http://www.jianshu.com/p/90d68e7e5d53
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

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
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    //NSLog(@"MAX(0,MAX_LIMIT_NUMS - existTextNum)=%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum));
    self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",existTextNum,MAX_LIMIT_NUMS];
}



- (void)sendFeedBack:(UIButton *)btn{
    
    
    btn.enabled = NO;
    
    
    
   // NSLog(@"=======%@",self.textView.text);
    
    if (self.textView.text.length==0) {
        
        [self showToastWithString:@"内容不能为空"];
        
        return;
    }
    
    
    NSString * urlStr = self.textView.text;
    
    //过滤字符串前后的空格
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (urlStr.length<10) {
        
        [self showToastWithString:@"请输入10个字以上的描述"];
        
        return;
    }
    
    [BBTMineRequestTool POSTFeedback:self.deviceTypeId Feedback:self.textView.text upload:^(QMessage *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            [self showToastWithString:@"意见反馈成功"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)delayMethod{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}

@end
