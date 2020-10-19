//
//  EquipmentIDVerifyViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentIDVerifyViewController.h"
#import "BBTEquipmentRequestTool.h"
#import "BBTEquipmentRespone.h"
#import "UIImageView+AFNetworking.h"
@interface EquipmentIDVerifyViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView  *promptPicture;

@property (nonatomic, strong) UITextField   *verifyField;

@property (nonatomic, strong) UIButton     *verifyBtn;

@property (strong, nonatomic) UILabel  *promptLabelOne;

@property (strong, nonatomic) UILabel  *promptLabelTwo;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation EquipmentIDVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.deviceTypeName;
    
    CGFloat pageImageY;
    //适配ipad；
    if ([IphoneType IFChangeCoordinates]) {
        
        pageImageY = 60;
        
    }else{
        
        pageImageY = 100;
    }
    
    self.promptPicture = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-pageImageY)/2, 50, pageImageY,pageImageY)];
    self.promptPicture.contentMode = UIViewContentModeScaleToFill;
    //self.promptPicture.image = [UIImage imageNamed:@"SB_xiaoba_nor"];
    

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.iconUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [ self.promptPicture setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"SB_01"]];
    
    self.promptPicture.backgroundColor = [UIColor clearColor];
    self.promptPicture.userInteractionEnabled = YES;
    [self.view addSubview: self.promptPicture];
    
    
    [self.view addSubview:self.promptLabelOne];
    
    self.verifyField = [[UITextField alloc] initWithFrame:CGRectMake( 20, CGRectGetMaxY(self.promptLabelOne.frame)+8, kDeviceWidth -  20*2, 48)];
    
    [self setViewWithTextField:self.verifyField imageName:@"验证码_icon.png" placeholder:@"输入4位验证码" font: [UIFont systemFontOfSize:14]];
    self.verifyField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:self.verifyField];
    
    //    CGFloat buyW = 100;
    //    CGFloat buyH = 48;
    //    CGFloat buyX = CGRectGetMaxX(self.verifyField.frame) + 20;
    //    CGFloat buyY = CGRectGetMaxY(self.promptPicture.frame) + 20;
    //
    //    self.verifyBtn =[[UIButton alloc] initWithFrame:CGRectMake(buyX, buyY, buyW, buyH)];
    //
    //    [self.verifyBtn addTarget:self action:@selector(getVerifyNumber) forControlEvents:UIControlEventTouchUpInside];
    //
    //    self.verifyBtn .layer.borderWidth = 1.0f;
    //    self.verifyBtn .layer.cornerRadius = 8;
    //    self.verifyBtn .layer.borderColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f].CGColor;
    //    [self.verifyBtn  setTitle:@"获取验证码" forState:UIControlStateNormal];
    //    [self.verifyBtn  setTitleColor:[UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f] forState:UIControlStateNormal];
    //    self.verifyBtn .titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //    self.verifyBtn .clipsToBounds = YES;
    //
    //    self.verifyBtn.hidden = YES;
    //    [self.view addSubview:self.verifyBtn];
    
    //适配iphone x
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-160-kDevice_Is_iPhoneX, kDeviceWidth - 40, 48)];
//    [self.nextButton setImage:[UIImage imageNamed:@"btn_bdsb_nor"] forState:UIControlStateNormal];
//    [self.nextButton setImage:[UIImage imageNamed:@"btn_bdsb_pre"] forState:UIControlStateHighlighted];
    
    self.nextButton.layer.cornerRadius= 10.0f;
    
    self.nextButton.clipsToBounds = YES;//去除边界
    self.nextButton.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [self.nextButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [self.nextButton setTitle:@"绑定设备" forState:UIControlStateNormal];
    
    [self.nextButton setTitle:@"绑定设备" forState:UIControlStateHighlighted];
    
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.promptLabelTwo];
    
    [self setNavigationItem];
    
    // Do any additional setup after loading the view.
}

//根据背景颜色创建图片
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    //    [rightbutton setImage:[UIImage imageNamed:@"nav_tianjiashebei"] forState:UIControlStateNormal];
    //    [rightbutton setImage:[UIImage imageNamed:@"nav_tianjiashebei_pre"] forState:UIControlStateSelected];
    [rightbutton setTitle:@"取消" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}


-(void)cancel{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (UILabel *)promptLabelOne{
    if (!_promptLabelOne) {
        
        UILabel *bgViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptPicture.frame) + 20, kDeviceWidth, 30)];
        
        bgViewLabel.contentMode = UIViewContentModeScaleAspectFill;
        bgViewLabel.text = @"请输入设备播报的验证码";
        bgViewLabel.textAlignment = NSTextAlignmentCenter;
        bgViewLabel.textColor = [UIColor lightGrayColor];
        bgViewLabel.font = [UIFont systemFontOfSize:14];
        _promptLabelOne = bgViewLabel;
    }
    return _promptLabelOne;
}

- (UILabel *)promptLabelTwo{
    if (!_promptLabelTwo) {
        //背景图片
        UILabel *bgViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nextButton.frame) + 10, kDeviceWidth, 30)];
        bgViewLabel.contentMode = UIViewContentModeScaleAspectFill;
        bgViewLabel.text = @"如果设备已绑定,可跳过此界面";
        bgViewLabel.textAlignment = NSTextAlignmentCenter;
        bgViewLabel.textColor = [UIColor lightGrayColor];
        bgViewLabel.font = [UIFont systemFontOfSize:14];
        _promptLabelTwo = bgViewLabel;
    }
    return _promptLabelTwo;
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
    
    //    [textField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];    //创建左侧视图
    //    UIImage *im = [UIImage imageNamed:imageName];
    //    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    //    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor clearColor];
    //    iv.center = lv.center;
    //    [lv addSubview:iv];
    //
    //    //设置 textField 的左侧视图
    //    //设置左侧视图的显示模式
    //    textField.leftViewMode = UITextFieldViewModeAlways;
    //    textField.leftView = lv;
    
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
        if (proposedNewLength > 6) {
            return NO;//限制长度
        }
        return YES;
        
    }
    
    
    return YES;
}



///**
// * 获取验证码
// */
//-(void)getVerifyNumber{
//
//    [self.verifyField resignFirstResponder];
//
//    NSString *number=self.verifyField.text;
//
//    [self startTime];
//
//}
//
//-(void)startTime{
//
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                [self.verifyBtn setTitleColor:[UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f] forState:UIControlStateNormal];
//                self.verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//            });
//        }else{
//
//            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//
//                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%@重新发送",strTime] forState:UIControlStateNormal];
//                self.verifyBtn.userInteractionEnabled = NO;
//
//
//
//            });
//            timeout--;
//
//        }
//    });
//    dispatch_resume(_timer);
//
//}

-(void)nextAction{
    
    [self.verifyField resignFirstResponder];
    
    
    
    if ([self.verifyField.text isEqualToString:@""])
    {
        
        [self showToastWithString:@"请输入验证码"];
        
        return;
    }
    
    
    
    [self startLoading];
    
    [BBTEquipmentRequestTool getSumitbinddevice:self.verifyField.text  DeviceTypeId:self.deviceTypeId success:^(BBTEquipmentRespone *respone) {
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            [[TMCache sharedCache] setObject:@"success" forKey:@"BingdingStr"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        //
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
      [self.verifyField resignFirstResponder];
}

//#pragma mark -点击空白处收键盘
//-(void)retrieveKeyboard{
//    
//    [self.verifyField resignFirstResponder];
//    
//    
//    [self.view endEditing:YES];
//    
//    NSTimeInterval animationDuration = 0.30f;
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:animationDuration];
//    
//    CGRect rect = CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.view.frame = rect;
//    
//    [UIView commitAnimations];
//}
//#pragma mark -textField 防止键盘挡住输入框
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//
//{
//    
//    NSLog(@"textFieldDidBeginEditing");
//    
//    CGRect frame = textField.frame;
//    
//    CGFloat heights = self.view.frame.size.height;
//    
//    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度）
//    
//    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
//    
//    int offset = frame.origin.y + 42- ( heights - 216.0-35.0);//键盘高度216
//    
//    NSTimeInterval animationDuration = 0.30f;
//    
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    
//    [UIView setAnimationDuration:animationDuration];
//    
//    float width = self.view.frame.size.width;
//    
//    float height = self.view.frame.size.height;
//    
//    if(offset > 0)
//        
//    {
//        
//        CGRect rect = CGRectMake(0.0f, -offset,width,height);
//        
//        self.view.frame = rect;
//        
//    }
//    
//    [UIView commitAnimations];
//    
//}



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
