//
//  RealNameViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "RealNameViewController.h"

#import "VPImageCropperViewController.h"

#import "CustomSheetView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "QiniuSDK.h"

#import "BBTUserInfo.h"

#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "PanetRequestTool.h"
#import "RealNameDataModel.h"
#import "RealNameModel.h"
#import "PanetKnInetlCommon.h"
#import "UIImageView+AFNetworking.h"


#define ORIGINAL_MAX_WIDTH 640.0f


@interface RealNameViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    float _cursorHeight;                                    //光标距底部的高度
    float _spacingWithKeyboardAndCursor;                    //光标与键盘之间的间隔
}


@property(nonatomic, retain)UIScrollView *backScrollView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, strong) UITextField *nametext;
@property(nonatomic, strong) UITextField *zhifubaotext;

@property (nonatomic, strong)  BBTUserInfo *resultTokenInfo;


@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *auditbackView;

@property (nonatomic,strong) UIView *successbackView;

@property (nonatomic, strong) UIImageView *auditbgImageView;




@property(nonatomic, strong) UILabel *auditnameLabel;

@property(nonatomic, strong) UILabel *auditzhifubaoLabel;


@property(nonatomic, strong) UILabel *failreasonLabel;

@property(nonatomic, strong) UIButton *submitBtn;

@property(nonatomic, strong) UIButton *nosubmitBtn;

@property(nonatomic, strong) RealNameDataModel *realnamedata;

@end

@implementation RealNameViewController

- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        _backScrollView = [[UIScrollView alloc] init];
        
        
        _backScrollView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        _backScrollView.contentSize = CGSizeMake(0,KDeviceHeight+ 60);
        //
        _backScrollView.scrollEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator =  NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
      
        _backScrollView.pagingEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.bounces = NO;

        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_backScrollView];
        
    }
    return _backScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"实名认证";
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    self.backView.backgroundColor = DefaultBackgroundColor;

    
    [self.view addSubview:self.backView];
   
    self.auditbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    self.auditbackView.backgroundColor = DefaultBackgroundColor;

    [self.view addSubview:self.auditbackView];
    
    self.successbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    self.successbackView.backgroundColor = DefaultBackgroundColor;
    
    [self.view addSubview:self.successbackView];
    

    
    [self Getauthentication];
    
}

- (void)Getauthentication
{
    [self startLoading];
    
    [PanetRequestTool Getauthenticationsuccess:^(RealNameModel * _Nonnull respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"10350"]) {
            
            [self LoadbackChlidView];
//            [self LoadauditbackChlidView];
            
//            [self LoadsuccessbackChlidView];

        }
        else if([respone.statusCode isEqualToString:@"0"])
        {

            self.realnamedata = respone.data;
            
            if ([self.realnamedata.verifyStatus isEqualToString:@"0"]) {
                
                  [self LoadauditbackChlidView];

            }
            else if([self.realnamedata.verifyStatus isEqualToString:@"1"])
            {
                [self LoadsuccessbackChlidView];
            }
            else if([self.realnamedata.verifyStatus isEqualToString:@"-1"])
            {
                [self LoadbackChlidView];
            }

            
          
        
        }
        else
        {
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)LoadbackChlidView
{
    self.backView.hidden = NO;
    self.auditbackView.hidden = YES;
    self.successbackView.hidden = YES;

    
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,60)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.backView addSubview:back1View];
    
    self.nametext = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 14)];
    
    self.nametext.backgroundColor=[UIColor clearColor];
    self.nametext.textAlignment=NSTextAlignmentRight;
    self.nametext.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.nametext.placeholder = @"填写真实姓名";
    self.nametext.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.nametext.font = [UIFont systemFontOfSize:14.0f];
    self.nametext.returnKeyType=UIReturnKeyNext;
    self.nametext.delegate = self;
    [self.nametext addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.nametext.text = self.realnamedata.realName;
    
    [back1View addSubview:self.nametext];
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 24, 80, 16)];
    
    namelabel.text = @"真实姓名";
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    namelabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back1View addSubview:namelabel];
    
    UIView *back2View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(back1View.frame) + 16, kDeviceWidth - 32,60)];
    back2View.backgroundColor = [UIColor whiteColor];
    
    back2View.layer.cornerRadius= 15.0f;
    
    back2View.layer.borderWidth = 1.0;
    back2View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back2View.clipsToBounds = YES;//去除边界
    back2View.layer.masksToBounds = YES;
    
    [self.backView addSubview:back2View];
    
 
    
    
    
    self.zhifubaotext = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 180, 24, 140, 14)];
    
    self.zhifubaotext.backgroundColor=[UIColor clearColor];
    self.zhifubaotext.textAlignment=NSTextAlignmentRight;
    self.zhifubaotext.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.zhifubaotext.placeholder = @"填写支付宝收款账号";
    self.zhifubaotext.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.zhifubaotext.font = [UIFont systemFontOfSize:14.0f];
    self.zhifubaotext.returnKeyType=UIReturnKeyNext;
    self.zhifubaotext.delegate = self;
    [self.zhifubaotext addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.zhifubaotext.text = self.realnamedata.alipayAccount;
    
    [back2View addSubview:self.zhifubaotext];
    
    
    UILabel *zhifubaolabel = [[UILabel alloc] initWithFrame:CGRectMake(38,  23, 120, 16)];
    
    zhifubaolabel.text = @"支付宝收款账号";
    zhifubaolabel.textAlignment = NSTextAlignmentLeft;
    zhifubaolabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    zhifubaolabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back2View addSubview:zhifubaolabel];
    
    self.failreasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(back2View.frame) + 8, 150, 30)];

    self.failreasonLabel.backgroundColor=[UIColor clearColor];
    self.failreasonLabel.textAlignment=NSTextAlignmentLeft;
    self.failreasonLabel.textColor=[UIColor colorWithRed:255/255.0 green:73/255.0 blue:1/255.0 alpha:1.0];
    self.failreasonLabel.text =[NSString stringWithFormat:@"未通过原因：%@",self.realnamedata.remark];
    self.failreasonLabel.hidden = YES;

    self.failreasonLabel.font = [UIFont systemFontOfSize:12.0f];
    self.failreasonLabel.numberOfLines = 0;

    [self.backView addSubview:self.failreasonLabel];
    
   if([self.realnamedata.verifyStatus isEqualToString:@"-1"])
    {
        self.failreasonLabel.hidden = NO;

    }
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(back2View.frame) + 37, kDeviceWidth, 120)];
    
    bgImageView.image = [UIImage imageNamed:@"RealName_ruler"];
    
    [self.backView addSubview:bgImageView];
    
    [bgImageView.layer setCornerRadius:10];
    
    bgImageView.clipsToBounds=YES;
    
    self.bgImageView = bgImageView;
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 36 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.submitBtn.backgroundColor = MNavBackgroundColor;
    self.submitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    
    [self.submitBtn addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.submitBtn.layer.cornerRadius= 22.0f;
    
    self.submitBtn.clipsToBounds = YES;//去除边界
    
    [self.backView addSubview:self.submitBtn];

    
}

//#pragma mark - NavigationItem
//-(void)setNavigationItem{
//
//    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
//
//    [rightbutton setTitle:@"提交认证" forState:UIControlStateNormal];
//    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightbutton addTarget:self action:@selector(AddSubmit) forControlEvents:UIControlEventTouchUpInside];
//    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
//
//}


- (void)LoadauditbackChlidView
{
    self.backView.hidden = YES;
    self.auditbackView.hidden = NO;
    self.successbackView.hidden = YES;

    

    
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,60)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.auditbackView addSubview:back1View];
    
    self.auditnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 14)];
    
    self.auditnameLabel.backgroundColor=[UIColor clearColor];
    self.auditnameLabel.textAlignment=NSTextAlignmentRight;
    self.auditnameLabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.auditnameLabel.text =self.realnamedata.realName;
    
    self.auditnameLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [back1View addSubview:self.auditnameLabel];
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 24, 80, 16)];
    
    namelabel.text = @"真实姓名";
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    namelabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back1View addSubview:namelabel];
    
    UIView *back2View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(back1View.frame) + 16, kDeviceWidth - 32,60)];
    back2View.backgroundColor = [UIColor whiteColor];
    
    back2View.layer.cornerRadius= 15.0f;
    
    back2View.layer.borderWidth = 1.0;
    back2View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back2View.clipsToBounds = YES;//去除边界
    back2View.layer.masksToBounds = YES;
    
    [self.auditbackView addSubview:back2View];
    
    self.auditzhifubaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 180, 24, 140, 14)];
    
    self.auditzhifubaoLabel.backgroundColor=[UIColor clearColor];
    self.auditzhifubaoLabel.textAlignment=NSTextAlignmentRight;
    self.auditzhifubaoLabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.auditzhifubaoLabel.text = self.realnamedata.alipayAccount;
    self.auditzhifubaoLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [back2View addSubview:self.auditzhifubaoLabel];
    
    
    UILabel *zhifubaolabel = [[UILabel alloc] initWithFrame:CGRectMake(38,  23, 120, 16)];
    
    zhifubaolabel.text = @"支付宝收款账号";
    zhifubaolabel.textAlignment = NSTextAlignmentLeft;
    zhifubaolabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    zhifubaolabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back2View addSubview:zhifubaolabel];
    
    
    UIImageView *auditbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(back2View.frame) + 27, kDeviceWidth , 120)];
    
    
    [self.auditbackView addSubview:auditbgImageView];
    
    [auditbgImageView.layer setCornerRadius:10];
    
    auditbgImageView.image = [UIImage imageNamed:@"RealName_ruler"];
    
    auditbgImageView.clipsToBounds=YES;
    
    self.auditbgImageView = auditbgImageView;
    
    self.nosubmitBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 36 - 64 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];
    
    self.nosubmitBtn.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.nosubmitBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.nosubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nosubmitBtn setTitle:@"审核中" forState:UIControlStateNormal];
    
    self.nosubmitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.nosubmitBtn.layer.cornerRadius= 22.0f;
    
    self.nosubmitBtn.clipsToBounds = YES;//去除边界
    
    [self.auditbackView addSubview:self.nosubmitBtn];

    
//    if ([self.realnamedata.verifyStatus isEqualToString:@"0"]) {
//
//       self.auditbgImageView.image = [UIImage imageNamed:@"RealName_Review"];
//        self.failreasonLabel.hidden = YES;
//        self.ToeditBtn.hidden = YES;
//    }
//    else if([self.realnamedata.verifyStatus isEqualToString:@"1"])
//    {
//        self.auditbgImageView.image = [UIImage imageNamed:@"RealName_success"];
//        self.failreasonLabel.hidden = YES;
//        self.ToeditBtn.hidden = YES;
//    }
//    else if([self.realnamedata.verifyStatus isEqualToString:@"-1"])
//    {
//
//        self.auditbgImageView.image = [UIImage imageNamed:@"RealName_fail"];
//        self.failreasonLabel.hidden = NO;
//        self.ToeditBtn.hidden = NO;
//        self.auditbgImageView.userInteractionEnabled = YES;
//    }
    

    
    
    
    
}

- (void)LoadsuccessbackChlidView
{
    self.backView.hidden = YES;
    self.auditbackView.hidden = YES;
    self.successbackView.hidden = NO;
    
    UIImageView *auditbgImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (kDeviceWidth - 160)/2.0, 16, 160, 160)];
    
    [auditbgImageView.layer setCornerRadius:10];
    
    auditbgImageView.image = [UIImage imageNamed:@"RealName_success"];
    
    auditbgImageView.clipsToBounds=YES;
    
    
    
    [self.successbackView addSubview:auditbgImageView];
    


    
    UIView *back1View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(auditbgImageView.frame) + 16, kDeviceWidth - 32,60)];
    back1View.backgroundColor = [UIColor whiteColor];
    
    back1View.layer.cornerRadius= 15.0f;
    
    back1View.layer.borderWidth = 1.0;
    back1View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back1View.clipsToBounds = YES;//去除边界
    back1View.layer.masksToBounds = YES;
    
    [self.successbackView addSubview:back1View];
    
    self.auditnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 160, 25, 120, 14)];
    
    self.auditnameLabel.backgroundColor=[UIColor clearColor];
    self.auditnameLabel.textAlignment=NSTextAlignmentRight;
    self.auditnameLabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.auditnameLabel.text =self.realnamedata.realName;
    
    self.auditnameLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [back1View addSubview:self.auditnameLabel];
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 24, 80, 16)];
    
    namelabel.text = @"真实姓名";
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    namelabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back1View addSubview:namelabel];
    
    UIView *back2View = [[UIView alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(back1View.frame) + 16, kDeviceWidth - 32,60)];
    back2View.backgroundColor = [UIColor whiteColor];
    
    back2View.layer.cornerRadius= 15.0f;
    
    back2View.layer.borderWidth = 1.0;
    back2View.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    back2View.clipsToBounds = YES;//去除边界
    back2View.layer.masksToBounds = YES;
    
    [self.successbackView addSubview:back2View];
    
    self.auditzhifubaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 180, 24, 140, 14)];
    
    self.auditzhifubaoLabel.backgroundColor=[UIColor clearColor];
    self.auditzhifubaoLabel.textAlignment=NSTextAlignmentRight;
    self.auditzhifubaoLabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.auditzhifubaoLabel.text = self.realnamedata.alipayAccount;
    self.auditzhifubaoLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [back2View addSubview:self.auditzhifubaoLabel];
    
    
    UILabel *zhifubaolabel = [[UILabel alloc] initWithFrame:CGRectMake(38,  23, 120, 16)];
    
    zhifubaolabel.text = @"支付宝收款账号";
    zhifubaolabel.textAlignment = NSTextAlignmentLeft;
    zhifubaolabel.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    zhifubaolabel.font=[UIFont systemFontOfSize:16.0f];
    
    [back2View addSubview:zhifubaolabel];
    
    

    
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if(textField == self.nametext)
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
    
    
    
}



- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


- (void)AddSubmit
{
    
//    alipayAccount    支付宝账号    string    @mock=test
//    backImage    证件背面图    string    @mock=http://file.ai.babateng.cn//image%2Ficon%2Fcab66095-1059-4e16-9499-8f76d1d16016
//    cardNumber    证件号码    string    @mock=431026199902113836
//    faceImage    证件正面图    string    @mock=http://file.ai.babateng.cn//image%2Ficon%2F5dd566d2-2a75-494b-a1ad-1f1ba9702b3f
//    nickName    用户昵称    string    @mock=你大爷
//    phoneNumber    手机号码    string    @mock=15112295282
//    realName    真实姓名    string    @mock=周星星
//    token    用 户token    string
//    userId    用户编号    string
//    weixinAccount    微信账号    string
    

    
    if (self.zhifubaotext.text.length == 0) {
        
        [self showToastWithString:@"支付宝账号不能为空"];
        return;
    }
    

    if (self.nametext.text.length == 0) {
        
        [self showToastWithString:@"真实姓名不能为空"];
        return;
    }


    
    
//    NSDictionary *parameter = @{@"alipayAccount" : self.zhifubaotext.text, @"backImage": self.IDBackIcon, @"cardNumber": self.IDCardtext.text,@"faceImage": self.IDFrontIcon,@"nickName":[[TMCache sharedCache] objectForKey:@"nickName"],@"phoneNumber":[[TMCache sharedCache] objectForKey:@"phoneNumber"],@"realName":self.nametext.text,@"weixinAccount":self.weixintext.text };
    
    NSDictionary *parameter = @{@"alipayAccount" : self.zhifubaotext.text, @"nickName":[[TMCache sharedCache] objectForKey:@"nickName"],@"phoneNumber":[[TMCache sharedCache] objectForKey:@"phoneNumber"],@"realName":self.nametext.text };

    
    
    [self startLoading];
    
    [PanetRequestTool PostsaveauthenticationParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
        
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nametext) {
        //self.usernameTextfield放弃第一响应者，而self.passwordTextfield变为第一响应者
        [self.nametext resignFirstResponder];
        [self.zhifubaotext becomeFirstResponder];
    }
    else if(textField == self.zhifubaotext) {
        //self.passwordTextfield放弃第一响应者，并调用登录函数
        [self.zhifubaotext resignFirstResponder];
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];


    [self.nametext resignFirstResponder];
    [self.zhifubaotext resignFirstResponder];

  
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
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
