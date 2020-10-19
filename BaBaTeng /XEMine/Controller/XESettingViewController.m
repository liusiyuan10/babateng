//
//  PanetMineSettingViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XESettingViewController.h"
#import "PanetMineAddressViewController.h"
#import "XESetingCell.h"
#import "BBTMainTool.h"
#import "BBTQAlertView.h"


@interface XESettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BBTQAlertView *_QalertView;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *addressstr;

@end

@implementation XESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    [self LoadChlidView];
    

    
}

- (void)LoadChlidView
{

    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 64 - 50 - 45)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10.5)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.tableView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
    [self.view addSubview:self.tableView];
    
//    UIButton *logOutButton = [[UIButton alloc] initWithFrame:CGRectMake(10,  KDeviceHeight - 64 - 50 - 45 - kDevice_Is_iPhoneX, kDeviceWidth - 20, 50)];
//    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_nor"] forState:UIControlStateNormal];
//    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_pre"] forState:UIControlStateHighlighted];
//    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    [ logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    logOutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [logOutButton addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:logOutButton];
    
    
    
}

-(void)logOutAction{
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alert show];
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要退出登录吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block XESettingViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {

            
            
            [[TMCache sharedCache]removeObjectForKey:@"userId"];
            [[TMCache sharedCache]removeObjectForKey:@"token"];
    
            [[TMCache sharedCache]removeObjectForKey:@"password"];


            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
            [[TMCache sharedCache]removeObjectForKey:@"nickName"];

            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];

            
            [BBTMainTool setLoginRootViewController:CZKeyWindow];
        }
        if (titleBtnTag == 0) {
            
            NSLog(@"sg");
            
        }
    };
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 87;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"PanetMineSetingcell";
    
    XESetingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[XESetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }

        cell.subLabel.hidden = YES;
        cell.NameLabel.text = @"我的地址";
        
        

    

    
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//

    PanetMineAddressViewController *PanetMineAddressSettingVC = [[PanetMineAddressViewController alloc] init];
    
    PanetMineAddressSettingVC.addressType = @"1";
    
    //    PanetMineAddressSettingVC.block = ^(NSString *addressStr, NSString *phonenumStr, NSString *nameStr) {
    //         NSLog(@"sdfsdfsdllls===%@    %@   %@",addressStr,phonenumStr,nameStr);
    //    };
    //
    [self.navigationController pushViewController:PanetMineAddressSettingVC animated:YES];

 
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
