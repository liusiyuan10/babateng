//
//  BulletinViewController.m
//  BaBaTeng
//
//  Created by liu on 17/7/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "FreeCourseViewController.h"
#import "PlaceholderTextView.h"
#import "EnglishRequestTool.h"
#import "EnglishCommon.h"
#import "CZAgePickerView.h"


//#import "JSNativeMethod.h"
#define MAX_FLIMIT_NUMS     200

@interface FreeCourseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy)NSArray *dataArray;
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)UILabel *selectLabel;

@property(nonatomic, strong)UILabel *ageLabel;
@property (nonatomic, strong) UIButton *ExperienceBtn;


@property (nonatomic, copy) NSString *ageStr;
//<UIWebViewDelegate,JSNativeMethodDelegate>
//{
//    JSContext *jsContext;
//}


//@property(nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) CZAgePickerView *pickerView;

@property (nonatomic, strong) UIImageView *bgImageView;

@end



@implementation FreeCourseViewController

-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(48, 100, self.view.frame.size.width - 48*2, 180)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = YES;
        _textView.font = [UIFont systemFontOfSize:15.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 8.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
        _textView.layer.borderWidth = 1.0;
        _textView.placeholderColor = [UIColor lightGrayColor];//RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"请您描述上课需求";
    }
    
    return _textView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"领取体验课流程";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];

}


- (void)LoadChlidView
{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64-kDevice_IsE_iPhoneX)];
    NSLog(@"KDeviceHeight=====%f",KDeviceHeight);
    
    bgImageView.image = [UIImage imageNamed:@"english_free"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    self.bgImageView = bgImageView;
    
    
//    self.lcopyBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 70)/2.0, KDeviceHeight -44 - 64 - 24 - 5 , 70, 24)];
//
//    self.lcopyBtn.backgroundColor = MNavBackgroundColor;
//    self.lcopyBtn.layer.cornerRadius=12.0f;
//    self.lcopyBtn.layer.masksToBounds = YES; //没这句话它圆不起来
//    [self.lcopyBtn setTitle:@"复制" forState:UIControlStateNormal];
//
//
//    [self.lcopyBtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:self.lcopyBtn];
}
//- (void)LoadChlidView
//{
////    CGFloat backViewW = kDeviceWidth - 48 *2;
//
//    self.pickerView = [[CZAgePickerView alloc]init];
//
//    [self.view addSubview:self.textView];
//
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(48 ,21, kDeviceWidth - 48 *2,49)];
//    backView.backgroundColor = [UIColor whiteColor];
//
//    backView.layer.cornerRadius= 15.0f;
//
//    backView.layer.borderWidth = 1.0;
//    backView.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
//    backView.clipsToBounds = YES;//去除边界
//    backView.layer.masksToBounds = YES;
//
//    [self.view addSubview:backView];
//
//    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18,50, 15)];
//
//    ageLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    ageLabel.backgroundColor = [UIColor clearColor];
//    ageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    ageLabel.text = @"年龄";
//    ageLabel.textAlignment = NSTextAlignmentLeft;
//
//    [backView addSubview:ageLabel];
//
//    self.ageLabel = ageLabel;
//
//    self.selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 48 *2 - 30 - 16 - 80 - 16, 18, 80, 15)];
//
//    self.selectLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    self.selectLabel.backgroundColor = [UIColor clearColor];
//    self.selectLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    self.selectLabel.text = @"4岁";
//    self.selectLabel.textAlignment = NSTextAlignmentRight;
//
//    [backView addSubview:self.selectLabel];
//
//    self.ageStr = @"4";
//
//    _dataArray = @[@"4", @"5", @"6", @"7", @"8", @"9",@"10",@"11",@"12",@"13"];
//
//
////    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth - 80 - 64 - 30, 40, 80, 0) style:UITableViewStylePlain];
////    self.tableView.delegate = self;
////    self.tableView.dataSource = self;
////    self.tableView.backgroundColor = [UIColor clearColor];
////    [self.view addSubview:self.tableView];
//
//    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.button.frame = CGRectMake( kDeviceWidth - 48 *2 - 30 - 16, (49 - 30)/2.0, 30 , 30);
//
//
//    [self.button setImage:[UIImage imageNamed:@"english_down"] forState:UIControlStateNormal];
//    [self.button setImage:[UIImage imageNamed:@"english_up"] forState:UIControlStateSelected];
//    [self.button addTarget:self action:@selector(clickToPush:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:self.button];
//
//
//
//    self.ExperienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 74 -64 ,kDeviceWidth - 68*2, 44)];
//    //    _phoneView.userInteractionEnabled = NO;
//    self.ExperienceBtn.backgroundColor = MNavBackgroundColor;
//    self.ExperienceBtn.contentMode = UIViewContentModeScaleAspectFill;
//
//    [self.ExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.ExperienceBtn setTitle:@"预约" forState:UIControlStateNormal];
//
//    [self.ExperienceBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.ExperienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
//
//    self.ExperienceBtn.layer.cornerRadius= 22.0f;
//
//    self.ExperienceBtn.clipsToBounds = YES;//去除边界
//
//    [self.view addSubview:self.ExperienceBtn];
//
//}
//
//
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    return 30;
////}
////
//- (void)clickToPush:(UIButton *)btn
//{
////    btn.selected = !btn.selected;
////    if (btn.selected == YES) {
////          _tableView.frame = CGRectMake(kDeviceWidth - 80 - 64 - 30, 40, 80, 200);
////
////    }
////    else {
////      _tableView.frame = CGRectMake(kDeviceWidth - 80 - 64 - 30, 40, 80, 0);
////    }
//
//    self.pickerView.dataSource = @[@"4", @"5", @"6", @"7", @"8", @"9",@"10",@"11",@"12",@"13"];
//    self.pickerView.pickerTitle = @"年龄";
//    __weak typeof(self) weakSelf = self;
//    self.pickerView.defaultStr = @"4";
//
//    self.pickerView.valueDidSelect = ^(NSString *value){
//
//        NSLog(@"ddddddd=====%@",value);
//        weakSelf.ageStr =value;
//
//         weakSelf.selectLabel.text = [NSString stringWithFormat:@"%@岁",weakSelf.ageStr];
//    };
//    [self.pickerView show];
//
//}
////
////- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
////{
////    return [_dataArray count];
////}
////
////- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
////{
////    return 1;
////}
////
////- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    _selectLabel.text = [NSString stringWithFormat:@"%@岁" , _dataArray[indexPath.section] ];
////    self.ageStr =  _dataArray[indexPath.section];
////    _tableView.frame = CGRectMake(200, 40, 80, 0);
////    _button.selected = !_button.selected;
////}
////
////- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
////    if (cell == nil) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
////    }
//////    cell.backgroundColor = MNavBackgroundColor;
////    cell.textLabel.font = [UIFont systemFontOfSize:12];
////    cell.textLabel.text = [NSString stringWithFormat:@"%@岁" , _dataArray[indexPath.section] ];
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////    return cell;
////}
//
//
//
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text
//{
//    //
//    //     //过滤表情符号
//    //    if ([self stringContainsEmoji:textView.text]) {
//    //
//    //        return NO;
//    //    }
//
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    //获取高亮部分内容
//    //NSString * selectedtext = [textView textInRange:selectedRange];
//
//    //如果有高亮且当前字数开始位置小于最大限制时允许输入
//    if (selectedRange && pos) {
//        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
//
//        if (offsetRange.location < MAX_FLIMIT_NUMS) {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//
//
//    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
//
//    NSInteger caninputlen = MAX_FLIMIT_NUMS - comcatstr.length;
//
//    if (caninputlen >= 0)
//    {
//        return YES;
//    }
//    else
//    {
//        NSInteger len = text.length + caninputlen;
//        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
//        NSRange rg = {0,MAX(len,0)};
//
//        if (rg.length > 0)
//        {
//            NSString *s = [text substringWithRange:rg];
//
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//            //既然是超出部分截取了，哪一定是最大限制了。
////            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
//
//        }
//        return NO;
//    }
//
//
//
//
//
//}
//
//
//
//- (NSString *)disable_emoji:(NSString *)text{
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
//                                                               options:0
//                                                                 range:NSMakeRange(0, [text length])
//                                                          withTemplate:@""];
//    return modifiedString;
//}
//
//
//
//
///*
// *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
// *只要知道Emoji表情的Unicode编码的范围，
// *就可以判断用户是否输入了Emoji表情。
// */
//- (BOOL)stringContainsEmoji:(NSString *)string
//{
//    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
//    __block BOOL returnValue = NO;
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//
//        const unichar hs = [substring characterAtIndex:0];
//        // surrogate pair
//        if (0xd800 <= hs && hs <= 0xdbff) {
//            if (substring.length > 1) {
//                const unichar ls = [substring characterAtIndex:1];
//                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                if (0x1d000 <= uc && uc <= 0x1f77f) {
//                    returnValue = YES;
//                }
//            }
//        } else if (substring.length > 1) {
//            const unichar ls = [substring characterAtIndex:1];
//            if (ls == 0x20e3) {
//                returnValue = YES;
//            }
//        } else {
//            // non surrogate
//            if (0x2100 <= hs && hs <= 0x27ff) {
//                returnValue = YES;
//            } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                returnValue = YES;
//            } else if (0x2934 <= hs && hs <= 0x2935) {
//                returnValue = YES;
//            } else if (0x3297 <= hs && hs <= 0x3299) {
//                returnValue = YES;
//            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                returnValue = YES;
//            }
//        }
//    }];
//    return returnValue;
//}
//
////作者：Jingege
////链接：http://www.jianshu.com/p/90d68e7e5d53
////來源：简书
////著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
//
//- (void)textViewDidChange:(UITextView *)textView
//{
//
//
//    if (textView.text.length > 0) {
//        // 禁止系统表情的输入
//        NSString *text = [self disable_emoji:[textView text]];
//        if (![text isEqualToString:textView.text]) {
//            NSRange textRange = [textView selectedRange];
//            textView.text = text;
//            [textView setSelectedRange:textRange];
//        }
//    }
//
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//
//    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
//
//    NSString  *nsTextContent = textView.text;
//    NSInteger existTextNum = nsTextContent.length;
//
//    if (existTextNum > MAX_FLIMIT_NUMS)
//    {
//        //截取到最大位置的字符
//        NSString *s = [nsTextContent substringToIndex:MAX_FLIMIT_NUMS];
//
//        [textView setText:s];
//    }
//
//    //不让显示负数 口口日
//    //NSLog(@"MAX(0,MAX_LIMIT_NUMS - existTextNum)=%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum));
////    self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",existTextNum,MAX_LIMIT_NUMS];
//}
//
//
//- (void)ExperienceBtnClicked:(UIButton *)btn
//{
//    if (self.selectLabel.text.length==0) {
//
//        [self showToastWithString:@"年龄不能为空"];
//
//        return;
//    }
//
//
//
//
//    NSString * urlStr = self.textView.text;
//
//    //过滤字符串前后的空格
//    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    //过滤中间空格
//    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//
//
//    if (urlStr.length==10) {
//
//        urlStr = @"";
//    }
//
//    NSLog(@"sssssss===%@",self.ageStr);
//
//
//    NSDictionary *params = @{@"age" :self.ageStr, @"phone": [[TMCache sharedCache] objectForKey:@"phoneNumber"] , @"remark": urlStr, @"source": @"0" };
//
//    [EnglishRequestTool PostFreeReservations:params success:^(EnglishCommon *respone) {
//
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//
//            [self showToastWithString:@"预约成功"];
//
//            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
//
//        }
//        else
//        {
//            [self showToastWithString:respone.message];
//        }
//
//    } failure:^(NSError *error) {
//
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//
//    }];
//
//}
//
//-(void)delayMethod{
//
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//
//
//
////- (void)viewDidLoad {
////    [super viewDidLoad];
////
////    self.title = @"领取体验课流程";
////    self.view.backgroundColor = [UIColor whiteColor];
////
//////    CGRect webViewRect=CGRectMake(0, 0, kDeviceWidth,KDeviceHeight);
//////    self.webView=[[UIWebView alloc]initWithFrame:webViewRect];
//////    self.webView.contentMode = UIViewContentModeScaleToFill;
//////    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//////    self.webView.scalesPageToFit = YES;
//////    [self.webView setUserInteractionEnabled:YES];
//////    self.webView.delegate = self;
//////    [self.view  addSubview:self.webView];
//////
//////
//////
//////    [self loadFile];
////
////
////
////
////}
////
////- (void)LoadChlidView
////{
////    UILabel *ageLabel = [UILabel alloc] init
////}
////
//
//
////#pragma mark - 加载文件
////- (void)loadFile
////{
////    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
////    //    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"labplus/apps/code/index.html" withExtension:nil];
////    //    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
////    //    [self.webView loadRequest:request];
////    NSString *urlStr = self.name;
//////    NSString *urlStr = @"http://192.168.1.19/H5/education/order.html";
////    NSURL *url = [NSURL URLWithString:urlStr];
////
////    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
////    NSURLRequest *request = [NSURLRequest requestWithURL:url];
////
////    // 3. 发送请求给服务器
////    [self.webView loadRequest:request];
////
////}
////
////
////
////#pragma mark --webViewDelegate
////-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
////{
////    //网页加载之前会调用此方法
////
////    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
////    return YES;
////}
////
////-(void)webViewDidStartLoad:(UIWebView *)webView
////{
////    //开始加载网页调用此方法
////
////    [self startLoading];
////}
////
////-(void)webViewDidFinishLoad:(UIWebView *)webView
////{
////    //网页加载完成调用此方法
////    [self stopLoading];
////    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
////    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    //    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
////    //    [jsContext evaluateScript:send];//通过oc方法调用js的alert
////
////    //测试
////
////
////    JSNativeMethod *appMethod = [[JSNativeMethod alloc] init];
////    appMethod.delegate = self;
////    jsContext[@"App"] = appMethod;
////    appMethod.jsContext = jsContext;
////
////
////}
////
////
////
////- (void)JSNativeMethodEnglisBack:(JSNativeMethod *)Method selectName:(NSString *)name
////{
////    NSLog(@"viewcontroller=====%@",name);
////
////    dispatch_async(dispatch_get_main_queue(), ^{
////            [self.navigationController popViewControllerAnimated:YES];
////    });
////
////}
////
////
////
////-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
////{
////    //网页加载失败 调用此方法
////}
////
////
////
////-(void)viewWillAppear:(BOOL)animated{
////    [super viewWillAppear:animated];
////    //禁用侧滑手势方法
////
////
////}
////-(void)viewWillDisappear:(BOOL)animated{
////    [super viewWillDisappear:animated];
////
////
////
////}
//
//


@end
