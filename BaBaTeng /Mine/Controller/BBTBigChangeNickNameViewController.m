//
//  BBTBigChangeNickNameViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBigChangeNickNameViewController.h"
#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "Header.h"
@interface BBTBigChangeNickNameViewController ()
@property (strong, nonatomic) UIImageView  *bgBlurredView;
@property (nonatomic, strong) UITextField   *nicknameField;
@end

@implementation BBTBigChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    
    //[self.view addSubview:self.bgBlurredView];
    
    
    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, kDeviceWidth - 40, 50)];
    self.nicknameField.layer.borderWidth = 1.0f;
    self.nicknameField.layer.cornerRadius = 8;
    self.nicknameField.clipsToBounds = YES;
    self.nicknameField.layer.borderColor = [UIColor whiteColor].CGColor;
    // self.nicknameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nicknameField.backgroundColor = [UIColor whiteColor];
    self.nicknameField.text =[[TMCache sharedCache] objectForKey:@"nickName"];
//    self.nicknameField.placeholder = @"输入昵称";
//    [self.nicknameField setValue: MainFontColorTWO forKeyPath:@"_placeholderLabel.textColor"];
    
    NSString *holderText =  @"输入昵称";
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:MainFontColorTWO
                    range:NSMakeRange(0, holderText.length)];
    
      

      self.nicknameField.attributedPlaceholder = placeholdertext;
    
    self.nicknameField.font = [UIFont systemFontOfSize:15.0f];
    
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    
    //设置 textField 的左侧视图
    //设置左侧视图的显示模式
    self.nicknameField.leftViewMode = UITextFieldViewModeAlways;
    self.nicknameField.leftView = lv;
    
    [self.view addSubview:self.nicknameField];
    
    [self setNavigationItem];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"nav_queding_nor"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_queding_nor"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.nicknameField resignFirstResponder];
    
}

-(void)completeAction{
    
    
    [self.nicknameField resignFirstResponder];
    
    
    if ([self.nicknameField.text isEqualToString:@""])
    {
        [self showToastWithString:@"亲,请输入昵称"];
        return;
    }
    
    NSString * urlStr = self.nicknameField.text;
    // NSLog(@"urlStr1 = %@",urlStr);
    //过滤字符串前后的空格
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // NSLog(@"urlStr2 = %@",urlStr);
    //过滤中间空格
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    // NSLog(@"urlStr3 = %@",urlStr);

    
    if (_delegate) {
        
        [_delegate didClickedWithNickName:urlStr];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
   // [self updatenickname: [[TMCache sharedCache] objectForKey:@"phone"] unickname:self.nicknameField.text];
    
}




- (void)updatenickname:(NSString *)uphone  unickname :(NSString *)unickname
{
    
    [self startLoading];
    
    
    [BBTLoginRequestTool updatenickname:uphone unickname:unickname upload:^(BBTUserInfoRespone *registerRespone) {
        
        [self stopLoading];
        
        if ([registerRespone.errcode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"昵称修改成功"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
        }else{
            
            [self showToastWithString:registerRespone.errinfo];
        }
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
}

-(void)delayMethod{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -背景图片
- (UIImageView *)bgBlurredView{
    if (!_bgBlurredView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"BG_tianlu"];
        
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retrieveKeyboard)];
        [bgView addGestureRecognizer:singleTap];
        
        bgView.image = bgImage;
        _bgBlurredView = bgView;
    }
    return _bgBlurredView;
}

#pragma mark -点击空白处收键盘
-(void)retrieveKeyboard{
    
    [self.nicknameField resignFirstResponder];
    
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
