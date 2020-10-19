//
//  BBTAboutViewController.m
//  BaBaTeng
//
//  Created by liu on 16/10/28.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTBigAboutViewController.h"
#import "Header.h"
#import "RDVTabBarController.h"
#import "AboutCell.h"
#import "CKAlertViewController.h"
#import "BBTAgreementViewController.h"
#import "BBTQAlertView.h"
#import "BulletinViewController.h"
#import "HelpViewController.h"
#import <StoreKit/StoreKit.h>
#import "AFNetworking.h"

@interface BBTBigAboutViewController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>{
 
      BBTQAlertView *_QalertView;

}

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UIView       *containerViewOne;
@property (strong, nonatomic) UIView       *containerViewTwo;
@property (strong, nonatomic) UIImageView  *bgBlurredView;
@property (nonatomic, strong) NSString     *appStoreVison;
@end

@implementation BBTBigAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"关于";
    
    [self.view addSubview:self.containerViewOne];
    [self.containerViewOne addSubview:self.bgBlurredView];
    [self.view addSubview:self.containerViewTwo];
    [self LoadChlidView];
    
}


#pragma mark -背景图片
- (UIImageView *)bgBlurredView{
    if (!_bgBlurredView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-80)/2,25, 80, 80)];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"about"];
        
        bgView.userInteractionEnabled = YES;
       
        bgView.image = bgImage;
        _bgBlurredView = bgView;
    }
    return _bgBlurredView;
}

- (UIView *)containerViewOne{
    if (!_containerViewOne) {
        //背景图片
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 130)];
        bgView.backgroundColor = [UIColor whiteColor];
        _containerViewOne = bgView;
    }
    return _containerViewOne;
}

- (UIView *)containerViewTwo{
    if (!_containerViewTwo) {
        //背景图片
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_containerViewOne.frame)+20, kDeviceWidth, 250)];
        bgView.backgroundColor = [UIColor whiteColor];
        _containerViewTwo = bgView;
    }
    return _containerViewTwo;
}

- (void)LoadChlidView
{

    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 60)];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.text = [NSString stringWithFormat:@"V%@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    textLabel.textColor = [UIColor grayColor]; //[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerViewTwo addSubview:textLabel];
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textLabel.frame), kDeviceWidth-40,_containerViewTwo.frame.size.height-100) style:UITableViewStylePlain];

    self.tableView.backgroundColor=[UIColor whiteColor];

    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.containerViewTwo addSubview:self.tableView];
    
    //适配iphone x
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0,KDeviceHeight-110-kDevice_Is_iPhoneX, kDeviceWidth, 30)];
    text.backgroundColor = [UIColor clearColor];
//    text.text = @"©2017深圳市鑫益嘉科技股份有限公司";
    text.textColor = MainFontColorTWO; //[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    text.font  = BBT_THREE_FONT;
    text.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:text];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"changepasswordCell";
    
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[AboutCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row==0) {
            
            UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width-40, 0.5)];
            topLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
            
            [cell.contentView addSubview:topLine];
            
        }
        
        
        UILabel *endLine = [[UILabel alloc] initWithFrame:CGRectMake(0,49.5,[UIScreen mainScreen].bounds.size.width-40, 0.5)];
        endLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        
        [cell.contentView addSubview:endLine];
        

         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
   
    
    if (indexPath.row==0) {
        
        cell.labTip.text = @"版本更新";

    }
    
    if (indexPath.row==1) {
        
        
        cell.labTip.text = @"用户协议";
        
    }else if(indexPath.row==2){
    
        cell.labTip.text = @"联系我们";
    
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==0) {
        
        [self showToastWithString:@"版本检测中..."];
        [self startLoading];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager POST:@"https://itunes.apple.com/lookup?id=1152456714" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
             [self stopLoading];
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *array = result[@"results"];
            
            NSDictionary *dict = [array lastObject];
            self.appStoreVison = dict[@"version"];
            NSLog(@"当前版本为：%@", dict[@"version"]);
            
            
            if (![self.appStoreVison isEqualToString:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]) {
                  [self showToastWithString:@"发现新版本,正在跳转界面"];
                // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%B7%B4%E5%B7%B4%E8%85%BE/id1152456714?mt=8"]];
                
                SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
                //设置代理请求为当前控制器本身
                storeProductViewContorller.delegate = self;
                //加载一个新的视图展示
                [storeProductViewContorller loadProductWithParameters:
                 //appId唯一的
                 @{SKStoreProductParameterITunesItemIdentifier : @"1152456714"} completionBlock:^(BOOL result, NSError *error) {
                     //block回调
                     if(error){
                         
                         NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
                     }else{
                         //模态弹出appstore
                         [self presentViewController:storeProductViewContorller animated:YES completion:^{
                             
                         }
                          
                          ];
                     }
                 }];
                
            }else{
                
                
                [self showToastWithString:@"已经是最新版本"];
            }

            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
             [self stopLoading];
             [self showToastWithString:@"版本检测失败"];
            
        }];

    
    }else if(indexPath.row==1){
      
//        BBTAgreementViewController *agreementVC = [[BBTAgreementViewController alloc] init];
//        [self.navigationController pushViewController:agreementVC animated:YES];
        
        
        HelpViewController *helpVc = [[HelpViewController alloc] init];
        helpVc.name = @"用户协议";
        // NSString *urlStr = [NSString stringWithFormat:@"%@UserAgreement.html",BBT_HTML];
        NSString *urlStr = [NSString stringWithFormat:@"%@UserAgreement.html",BBT_HTML];
        NSLog(@"用户协议urlStr====%@",urlStr);
        
        helpVc.URL = [NSURL URLWithString:urlStr];
        
        [self.navigationController pushViewController:helpVc animated:YES];
    
    }else if(indexPath.row==2){
        
     
        HelpViewController *helpVc = [[HelpViewController alloc] init];
        helpVc.name = @"联系我们";
        // NSString *urlStr = [NSString stringWithFormat:@"%@UserAgreement.html",BBT_HTML];
        NSString *urlStr = [NSString stringWithFormat:@"%@ContactUs.html",BBT_HTML];
        NSLog(@"联系我们urlStr====%@",urlStr);
        
        helpVc.URL = [NSURL URLWithString:urlStr];
        
        [self.navigationController pushViewController:helpVc animated:YES];
    }
    
}
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.translucent = YES;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
     self.navigationController.navigationBar.translucent = NO;
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
 
    self.navigationController.navigationBar.translucent = YES;
    
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
