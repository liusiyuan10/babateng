//
//  XEMemberRuleViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMemberRuleViewController.h"
#import "MineRequestTool.h"
#import "RulesModel.h"
#import "RulesDataModel.h"
@interface XEMemberRuleViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *memberRuleLabel;
@property (nonatomic, strong) UIScrollView *BackScrollView;
@end

@implementation XEMemberRuleViewController

- (UIScrollView *)BackScrollView
{
    if (_BackScrollView == nil) {
        
        _BackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, KDeviceHeight )];
        

        _BackScrollView.scrollEnabled = YES;
        _BackScrollView.showsVerticalScrollIndicator =  NO;
        _BackScrollView.showsHorizontalScrollIndicator = YES;
        
        _BackScrollView.pagingEnabled = YES;
        _BackScrollView.delegate = self;
        _BackScrollView.bounces = YES;
        
        
        _BackScrollView.backgroundColor = [UIColor whiteColor];
        _BackScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //                [self.view addSubview:_detailParamtView];
        
        [self.view addSubview:_BackScrollView];
        
    }
    
    return _BackScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"会员规则";
    
    [self LoadChlidView];
    
    [self GetRule];
    // Do any additional setup after loading the view.
}

- (void)LoadChlidView
{
    
  self.memberRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 38, kDeviceWidth - 36, 15)];

    self.memberRuleLabel.font = [UIFont systemFontOfSize:16.0];
    self.memberRuleLabel.backgroundColor = [UIColor clearColor];
    self.memberRuleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    self.memberRuleLabel.text = @"会员升级";
    self.memberRuleLabel.textAlignment = NSTextAlignmentLeft;
    self.memberRuleLabel.numberOfLines = 0;

    [self.BackScrollView addSubview:self.memberRuleLabel];
    
}
- (void)GetRule
{
    [self startLoading];
    
    [MineRequestTool GetWalletRulesRulesType:self.ruleType success:^(RulesModel * _Nonnull response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            NSLog(@"-----%@",response.data.rulesContent);
            
            CGFloat memberRuleH = [self getLabelHeightWithText:response.data.rulesContent width:kDeviceWidth - 32 font:16.0];

            self.memberRuleLabel.frame = CGRectMake(16, 38, kDeviceWidth - 32, memberRuleH);
            
            self.memberRuleLabel.text = response.data.rulesContent;
            
            self.BackScrollView.contentSize = CGSizeMake(0, 38 + memberRuleH + 50);
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font

{
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
//        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
//
//                                                            options:NSStringDrawingUsesLineFragmentOrigin
//
//                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;

    
    
    
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
