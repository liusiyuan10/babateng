//
//  EquipmentManuallyEnterViewController.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2018/1/3.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentManuallyEnterViewController.h"
#import "EquipmentScanBindingViewController.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTDevice.h"

@interface EquipmentManuallyEnterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView  *promptPicture;

@property (nonatomic, strong) UITextField   *verifyField;

@property (nonatomic, strong) UIButton     *verifyBtn;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation EquipmentManuallyEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入设备码绑定";
   
    CGFloat pageImageY;
    //适配ipad；
    if ([IphoneType IFChangeCoordinates]) {
        
        pageImageY = 60;
        
    }else{
        
        pageImageY = 120;
    }
    
    self.promptPicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80/568.0 *KDeviceHeight, kDeviceWidth-40,pageImageY)];
    self.promptPicture.contentMode = UIViewContentModeScaleToFill;
    //self.promptPicture.image = [UIImage imageNamed:@"SB_xiaoba_nor"];
    
    
   self.promptPicture.image = [UIImage imageNamed:@"Codebinding"];
    
    self.promptPicture.backgroundColor = [UIColor clearColor];
    self.promptPicture.userInteractionEnabled = YES;
    [self.view addSubview: self.promptPicture];
    
    
 
    self.verifyField = [[UITextField alloc] initWithFrame:CGRectMake( 20, CGRectGetMaxY(self.promptPicture.frame)+20, kDeviceWidth -  20*2, 48)];
    
    [self setViewWithTextField:self.verifyField imageName:@"验证码_icon.png" placeholder:@"请输入16位数字的设备码" font: [UIFont systemFontOfSize:14]];
    self.verifyField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:self.verifyField];
    
    //适配iphone x
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-180-kDevice_Is_iPhoneX, kDeviceWidth - 40, 74)];
  
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn_key"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn_key_pre"] forState:UIControlStateHighlighted];
    [self.nextButton setTitle:@"确定绑定" forState:UIControlStateNormal];
    [ self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.userInteractionEnabled = YES;
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextButton];
    

    // Do any additional setup after loading the view.
}



#pragma mark -textField 初始化封装
-(void)setViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName placeholder:(NSString*)placeholder font:(UIFont*)font{
    
    textField.delegate = self;
    textField.font = font;
//    textField.placeholder =placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 8;
    textField.layer.borderColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f].CGColor;
    textField.clipsToBounds = YES;
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor lightGrayColor];//[UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
//    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSString *holderText = placeholder;
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:NSMakeRange(0, holderText.length)];


      textField.attributedPlaceholder = placeholdertext;
    
 
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField == self.verifyField) {
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
        if (proposedNewLength > 16) {
            return NO;//限制长度
        }
        return YES;
        
    }
    
    
    return YES;
}


-(void)nextAction{
    
    [self.verifyField resignFirstResponder];

    if ([self.verifyField.text isEqualToString:@""])
    {

        [self showToastWithString:@"请输入设备码"];

        return;
    }
    
//    [((UIViewController*)self.navigationController.viewControllers[0]) dismissViewControllerAnimated:YES completion:^{
//        [[EquipmentScanBindingViewController getInstance]manuallyEnter:self.verifyField.text];
//    }];
    
    [self bangding:self.verifyField.text];

    
}



//判断是不是请求连接
- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
}


-(void)bangding:(NSString*)code{
    
    
    
    NSString *urlStr;
    
    if (code.length<=16) {
        
        urlStr = [NSString stringWithFormat:@"%@%@/devices/%@/onbind",BBT_HTTP_URL,PROJECT_NAME_APP,code];
        
    }else{
        
        
        //        NSLog(@"=============%@",[self getCompleteWebsite:code]);
        
        //判断是一个连接
        if ([self getCompleteWebsite:code]!=nil) {
            // 如果是连接,再判断是不是巴巴腾的
            if ([code hasPrefix:BBT_HTTP_URL] || [code containsString:BBT_CODE_URL]) {
                
                NSLog(@"存在巴巴腾的域名");
                urlStr = code;
                
            } else {
                
                NSLog(@"不存在巴巴腾的域名");
                [self showToastWithString:@"二维码是不正确的绑定码"];
                return;
                
            }
        }else{
            
            [self showToastWithString:@"二维码是不正确的绑定码"];
            return;
        }
        
        urlStr = code;//[NSString stringWithFormat:@"%@%@",BBT_HTTP_URL,urlORCode];
        
    }
    
    NSLog(@"请求链接%@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    [self startLoading];
    
    [BBTEquipmentRequestTool getScanbindcode:encodedString Parameter:parameter success:^(BBTDevice *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
            
        }else{
            if (IsStrEmpty(respone.message)) {
                
                [self showToastWithString:@"设备不存在"];
                
            }else{
                
                [self showToastWithString:respone.message];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.verifyField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
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
