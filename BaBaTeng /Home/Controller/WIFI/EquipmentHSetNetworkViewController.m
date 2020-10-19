//
//  EquipmentSetNetworkViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentHSetNetworkViewController.h"
#import "ConfigEquipmentInternetViewControlleron.h"
#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

#import "EquipmentPressNetWorkViewController.h"

#import "QCheckBox.h"
#import "EquipmentConfigNetWorkViewController.h"
#import "EquipmentSoundConfigNetWorkViewController.h"

#import "EquipmentSoundGNetWorkViewController.h"

#import "EquipmentSetBlueNetWorkViewController.h"

#import "EquipmentSetWifiNetworkViewController.h"

@interface EquipmentHSetNetworkViewController ()<UITextFieldDelegate ,QCheckBoxDelegate,AVAudioPlayerDelegate>
{
    AppDelegate *appDele;
    BOOL hideAP;
}


@property (nonatomic,strong)  AVAudioPlayer  *player;
@property (strong, nonatomic) UIImageView   *promptPicture;
@property (nonatomic, strong) UITextField   *WiFiNameField;
@property (nonatomic, strong) UITextField   *passwordField;
@property (nonatomic, strong) UIView        *container;
@property (nonatomic, strong) UIView        *line;
@property (nonatomic, strong) UIButton      *passwordPrompt;
@property (nonatomic, strong) UIButton      *WiFiNamePrompt;

@property (strong, nonatomic) QCheckBox  *check;

@end

@implementation EquipmentHSetNetworkViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择WiFi";
    CGFloat pageImageY;
    CGFloat nextButtonY;
    //适配ipad；
    if ([IphoneType IFChangeCoordinates]) {
        
        pageImageY = 70;
        nextButtonY =80;
        
    }else{
        
        pageImageY = kDeviceWidth/3;
        nextButtonY =120;
    }
    NSLog(@"路径==%@",NSHomeDirectory());
    self.promptPicture = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-pageImageY)/2, 60 /667.0 *KDeviceHeight , pageImageY,pageImageY )];
    self.promptPicture.contentMode = UIViewContentModeScaleToFill;

    self.promptPicture.image = [UIImage imageNamed:@"icon_WIFIBIG"];
    self.promptPicture.userInteractionEnabled = YES;
    [self.view addSubview: self.promptPicture];
    
    appDele = (id)[[UIApplication sharedApplication] delegate];
    
    [appDele.wscPresenter setVista:self];
    hideAP = NO;
    
    NSString *mAP = [appDele.wscPresenter getCurrentSSID];
    
    self.container = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.promptPicture.frame) + 20, kDeviceWidth -  20*2, 100)];
    self.container.backgroundColor  = [UIColor clearColor];
    self.container.layer.borderWidth = 1.0f;
    self.container.layer.cornerRadius = 8;
    self.container.layer.borderColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f].CGColor;
    [self.view addSubview:self.container];
    
    
    
    self.WiFiNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 1.5, kDeviceWidth -  20*2, 48)];
    
    [self setViewWithTextField:self.WiFiNameField imageName:@"WiFi名称" placeholder:@"WiFi名称" font: [UIFont systemFontOfSize:14]];
    self.WiFiNameField.text =mAP;
    self.WiFiNameField.delegate = self;//设置代理
    [self.container addSubview:self.WiFiNameField];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.WiFiNameField.frame) , kDeviceWidth -  20*2, 1)];
    self.line.backgroundColor  = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
    [self.container addSubview:self.line];
    
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.WiFiNameField.frame) + 1, kDeviceWidth -  20*2, 48)];
    
    [self setViewWithTextField:self.passwordField imageName:@"WiFi密码" placeholder:@"请输入WiFi密码" font: [UIFont systemFontOfSize:14]];
    self.passwordField.secureTextEntry = NO;//密码开始可见
    self.passwordField.delegate = self;//设置代理
    
    NSString *getPassword = [appDele.wscPresenter getPasswordOfSSID:mAP withEncrypted:NO];
    NSLog(@"getPassword ＝＝＝＝＝＝＝＝＝1:%@",getPassword);
    if (getPassword) {
        self.passwordField.text = getPassword;
    }
    
    
   
    [self.container addSubview:self.passwordField];
    
    self.check = [[QCheckBox alloc] initWithDelegate:self];
    [self.check  setTitle:@"记住密码" forState:UIControlStateNormal];
    [self.check .titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.check setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.check.selected = YES;
    self.check.frame = CGRectMake(30, CGRectGetMaxY(self.container.frame), kDeviceWidth-80, 40);
    self.check.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.check];


    //适配iphone x
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, KDeviceHeight- 144/667.0 *KDeviceHeight -nextButtonY-kDevice_Is_iPhoneX, kDeviceWidth - 40, 48)];
//    [nextButton setImage:[UIImage imageNamed:@"bluework"] forState:UIControlStateNormal];
//    [nextButton setImage:[UIImage imageNamed:@"blueworksel"] forState:UIControlStateSelected];
    
    UIImage *normalBack = [self imageFromColor:[UIColor colorWithRed:245/255.0 green:132/255.0 blue:55/255.0 alpha:1.0]];
    UIImage *hihglightBack = [self imageFromColor:[UIColor colorWithRed:242/255.0 green:106/255.0 blue:46/255.0 alpha:1.0]];
    
    [nextButton setBackgroundImage:normalBack forState:UIControlStateNormal];
    [nextButton setBackgroundImage:hihglightBack forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"开始蓝牙配网" forState:UIControlStateNormal];
    
    [nextButton setTitle:@"开始蓝牙配网" forState:UIControlStateHighlighted];
    
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [nextButton addTarget:self action:@selector(blueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    UIButton *soundButton = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 200) /2, CGRectGetMaxY(nextButton.frame) + 45/667.0 *KDeviceHeight , 200, 14)];
    
    [soundButton setTitle:@"切换WIFI配网" forState:UIControlStateNormal];
    [soundButton setTitleColor:[UIColor colorWithRed:87/255.0 green:166/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    soundButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [soundButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:soundButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(soundButton.frame) + 62/667.0 *KDeviceHeight  , kDeviceWidth, 11)];
    
    titleLabel.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:11.0];
    
    titleLabel.text = @"如多次配网失败，请选择WIFI配网";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    if ([self.deviceTypeId isEqualToString:@"010011"]) {
        
        soundButton.hidden = YES;
        titleLabel.hidden = YES;
    }else
    {
        soundButton.hidden = NO;
        titleLabel.hidden = NO;
    }
    
    
        [self PlayMuisc:@"app_wifi_choose"];
    
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



- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    
    
    
    if (checkbox==self.check) {
        
        
        NSLog(@"checkbox==%d",checked);
      

    }
    
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

    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
//    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    NSString *holderText = placeholder;
      NSMutableAttributedString *placeholdertext = [[NSMutableAttributedString alloc] initWithString:holderText];
      [placeholdertext addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:NSMakeRange(0, holderText.length)];
      [placeholdertext addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14]
                    range:NSMakeRange(0, holderText.length)];
      

      textField.attributedPlaceholder = placeholdertext;
    
    
    if(textField==self.passwordField){
        

        UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 6, 20, 35)];//宽度根据需求进行设置，高度必须大于 textField 的高度
        lv.backgroundColor = [UIColor clearColor];
        //iv.center = lv.center;
       // [lv addSubview:iv];
        
        //设置 textField 的左侧视图
        //设置左侧视图的显示模式
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = lv;
        
        
        self.passwordPrompt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"icon_yanjing_nor"] forState:UIControlStateNormal];
        [self.passwordPrompt setImage:[UIImage imageNamed:@"icon_yanjing_sel"] forState:UIControlStateSelected];
        
        self.passwordPrompt.selected = YES;//密码开始可见
        
        UIView  *promptView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 60, 35)];
        [self.passwordPrompt addTarget:self action:@selector(PromptClicked:) forControlEvents:UIControlEventTouchUpInside];
        [promptView addSubview:self.passwordPrompt];
        self.passwordField.rightViewMode = UITextFieldViewModeAlways;
        self.passwordField.rightView = promptView;
        
    }else if (textField==self.WiFiNameField){
        
        UIView  *leftPromptView=[[UIView alloc] initWithFrame:CGRectMake(0, 6, 20, 35)];
        [self.WiFiNamePrompt addTarget:self action:@selector(WiFiNamePrompt:) forControlEvents:UIControlEventTouchUpInside];
        
        //[leftPromptView addSubview:leftViewBtn];
        
        self.WiFiNameField.leftViewMode = UITextFieldViewModeAlways;
        self.WiFiNameField.leftView =leftPromptView;
        
    }
    
    
    
}


- (void)leftViewBtn:(UIButton *)btn
{
    
    NSLog(@"刷新WiFi");
}
- (void)PromptClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.passwordField.secureTextEntry = !btn.selected;
}

- (void)WiFiNamePrompt:(UIButton *)btn
{
    
    NSLog(@"下拉WiFi");
    
}



-(void)nextAction{
    
    
    NSLog(@"下一步");
    
    
//    [self.player stop];//离开界面停止播放声音
//    self.player = nil;

    NSLog(@"self.passwordField.text=====%@",self.passwordField.text);
    if (self.passwordField.text.length == 0) {
        
        [self showToastWithString:@"密码不能为空!"];
        
        return;
    }
    
    
 
    [appDele.wscPresenter setPassword:self.passwordField.text forSSID:[appDele.wscPresenter getCurrentSSID] isHidden:NO];

    EquipmentSetWifiNetworkViewController *configVc = [[EquipmentSetWifiNetworkViewController alloc] init];

    configVc.deviceTypeName = self.deviceTypeName;
    configVc.deviceTypeId = self.deviceTypeId;
    configVc.iconUrl =self.iconUrl;
     configVc.deivceProgramId =self.deivceProgramId;
    configVc.wifiName=self.WiFiNameField.text;
    configVc.wifiPassword=self.passwordField.text;
    
    [self.navigationController pushViewController:configVc animated:YES];
    
    
    
}

- (void)blueButtonClick
{
//
//    [self.player stop];//离开界面停止播放声音
//    self.player = nil;
    
    if (self.passwordField.text.length == 0) {
        
        [self showToastWithString:@"密码不能为空!"];
        
        return;
    }
    

    [appDele.wscPresenter setPassword:self.passwordField.text forSSID:[appDele.wscPresenter getCurrentSSID] isHidden:NO];
    
    EquipmentSetBlueNetWorkViewController *configVc = [[EquipmentSetBlueNetWorkViewController alloc] init];
    
    configVc.deviceTypeName = self.deviceTypeName;
    configVc.deviceTypeId = self.deviceTypeId;
    configVc.iconUrl =self.iconUrl;
     configVc.deivceProgramId =self.deivceProgramId;
    configVc.wifiName=self.WiFiNameField.text;
    configVc.wifiPassword=self.passwordField.text;
    
    [self.navigationController pushViewController:configVc animated:YES];
    
}


- (void)PlayMuisc:(NSString *)name
{
    
    NSString *namestr = [NSString stringWithFormat:@"%@",name];
    //
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:namestr withExtension:@"mp3"];
    
    NSLog(@"musicURL=======%@",musicURL);
    
    [self play:musicURL];
}

-(void)play:(NSURL *)playPath{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:playPath error:&playerError];
    _player.delegate = self;
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    
    
    
    
    [_player prepareToPlay];
    [_player play];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self retrieveKeyboard];
    
}

#pragma mark -点击空白处收键盘
-(void)retrieveKeyboard{
    
    [self.passwordField resignFirstResponder];
    
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.player stop];//离开界面停止播放声音
    self.player = nil;
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
