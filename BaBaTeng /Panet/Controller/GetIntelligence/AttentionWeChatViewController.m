//
//  AttentionWeChatViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/28.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "AttentionWeChatViewController.h"
#import "YN_PassWordView.h"

#import "PanetRequestTool.h"
#import "PanetKnInetlCommon.h"

@interface AttentionWeChatViewController ()
@property(nonatomic,strong)YN_PassWordView *passView;

@property(nonatomic,strong) NSString *codeStr;
@end

@implementation AttentionWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"关注微信公众号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadChlidView];
    
}

- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, kDeviceWidth, 173)];
    
    bgImageView.image = [UIImage imageNamed:@"know_rule"];
    
    [self.view addSubview:bgImageView];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 200)/2.0, CGRectGetMaxY(bgImageView.frame) + 60, 200, 17)];
    codeLabel.text = @"请输入六位验证码";
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont boldSystemFontOfSize:18.0];
    codeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    codeLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:codeLabel];
    
    self.passView = [[YN_PassWordView alloc] init];
    self.passView.frame = CGRectMake(62, CGRectGetMaxY(codeLabel.frame) + 54, kDeviceWidth- 62*2, 35);
    
    self.passView.textBlock = ^(NSString *str) {//返回的内容
        NSLog(@"%@",str);
        self.codeStr = str;
    };
    [self.view addSubview:_passView];
    self.passView.backgroundColor = [UIColor whiteColor];
    self.passView.showType = 5;//五种样式
    self.passView.num = 6;//框框个数
    self.passView.tintColor = [UIColor orangeColor];//主题色
    [self.passView show];
    
    
    UIButton *confrimBtn = [[UIButton alloc] initWithFrame:CGRectMake(68, KDeviceHeight - 95-44 , kDeviceWidth - 68*2, 44)];
    
    confrimBtn.backgroundColor = [UIColor orangeColor];
    confrimBtn.layer.cornerRadius=22.0f;
    confrimBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    [confrimBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [confrimBtn addTarget:self action:@selector(confrimClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confrimBtn];
    
}

- (void)confrimClicked
{
    if (self.codeStr.length == 0) {
        
        [self showToastWithString:@"请输入六位验证码"];
        return;
    }
    
    [PanetRequestTool PostConcernedcheckCode:self.codeStr success:^(PanetKnInetlCommon * _Nonnull respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [self showToastWithString:respone.message];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
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
