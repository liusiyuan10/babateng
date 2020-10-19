//
//  EquipmentInputViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentInputViewController.h"
#import "EquipmentIDVerifyViewController.h"
@interface EquipmentInputViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *usernameField;

@end

@implementation EquipmentInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手动输入";
    
    // Do any additional setup after loading the view.
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake( 20,130, kDeviceWidth -  40, 48)];
    [self setViewWithTextField:self.usernameField imageName:@"串号:" placeholder:@"请输入设备串号(IMEI号)" font: [UIFont systemFontOfSize:13]];

    self.usernameField.delegate = self;//设置代理
    [self.view addSubview:self.usernameField];
   
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight-64-160, kDeviceWidth - 40, 48)];
//    [nextButton setImage:[UIImage imageNamed:@"btn_xyb_nor"] forState:UIControlStateNormal];
//    [nextButton setImage:[UIImage imageNamed:@"btn_xyb_pre"] forState:UIControlStateHighlighted];
    
    nextButton.layer.cornerRadius= 10.0f;
    
    nextButton.clipsToBounds = YES;//去除边界
    nextButton.layer.masksToBounds = YES;
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [nextButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [nextButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self retrieveKeyboard];
    
    return YES;
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
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
//    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    NSString *holderText = placeholder;
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:NSMakeRange(0, holderText.length)];
      [placeholdertext addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, holderText.length)];
      

      textField.attributedPlaceholder = placeholdertext;
    
    
    //创建左侧视图
    //UIImage *im = [UIImage imageNamed:imageName];
    UILabel *iv = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    iv.text =imageName;
    iv.textAlignment = NSTextAlignmentCenter;
    iv.textColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
    iv.font = font;
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    lv.backgroundColor = [UIColor clearColor];
    //iv.center = lv.center;
    [lv addSubview:iv];
    
    //设置 textField 的左侧视图
    //设置左侧视图的显示模式
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = lv;
    
    
}



-(void)nextAction{
    
    [self.navigationController pushViewController:[EquipmentIDVerifyViewController new] animated:YES];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self retrieveKeyboard];
}

#pragma mark -点击空白处收键盘
-(void)retrieveKeyboard{
    
    [self.usernameField resignFirstResponder];
    
    
    [self.view endEditing:YES];
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
    
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
