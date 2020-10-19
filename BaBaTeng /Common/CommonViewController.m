//
//  CommonViewController.m
//  SingleProject
//
//  Created by admin on 16/7/7.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "CommonViewController.h"
#import "MBProgressHUD.h"
@interface CommonViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    UIControl *controller;
    bool isLoading;
    UIActivityIndicatorView *spinner;
}


@end

@implementation CommonViewController
id<UIGestureRecognizerDelegate> _commondelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =DefaultBackgroundColor;
    //[UIColor colorWithRed:0.933 green:0.933 blue:0.918 alpha:1];
    //[UIColor colorWithRed:0.933 green:0.933 blue:0.918 alpha:1];
    //    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
//      self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:BBT_ONE_FONT,
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    //适配iphone x
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
        //        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
    }
    
    //    SNUIBarButtonItem *item = [SNUIBarButtonItem itemWithTitle:nil
    //                                                         Style:SNNavItemStyleBack
    //                                                        target:self
    //                                                        action:@selector(backForePage)];
    //    self.navigationItem.leftBarButtonItem = item;
    
    if (self.navigationController.viewControllers.count > 1) {
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    //        button.backgroundColor = [UIColor whiteColor];
    
    [button addTarget:self action:@selector(backForePage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    }
    
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    if (self.navigationController.viewControllers.count > 1) {
        // 记录系统返回手势的代理
        _commondelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _commondelegate;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {    return self.navigationController.viewControllers.count > 1;
}


- (void)backForePage
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showLoading{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"请稍后...";
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}

-(void)showOnWindow{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"请稍后...";
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}

/**
 * myTask 方法暂时模拟请求数据所需要加载的时间
 */
- (void)myTask {
    
    sleep(3);
    
}

/**
 *一些操作结果的提示
 */

- (void)showOnWindowWithString:(NSString *)content{
    
    // The hud will dispable all input on the window
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = self;
    HUD.labelText =content;
    HUD.color = [UIColor orangeColor];
    HUD.labelColor = [UIColor whiteColor];
    HUD.margin = 10.f;
    HUD.yOffset = 150.f;
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    
}

-(void)showToastWithString:(NSString *)content{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText =content;
    HUD.color = [UIColor blackColor];//[UIColor colorWithRed:196.0/255 green:196.0/255 blue:196.0/255 alpha:1.0f];
    HUD.labelColor = [UIColor whiteColor];
    HUD.margin = 10.f;
    HUD.yOffset = 150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.4f];
//    [HUD hide:YES afterDelay:11.0f];
    
}

/**
 *加载成功后隐藏加载框
 */
-(void)hideLoading{
    
    [HUD removeFromSuperview];
}

-(void)showSuccess{
    
    
    
    
}


-(void)showError{
    
    
}


/**
 *载入数据
 */
-(void)startLoading{
    
    if (isLoading==NO) {
        
        isLoading=YES;
        int translucentViewHeight=60;
        int translucentViewWidth=120;
        
        CGRect loadingBackgroundRect=CGRectMake((self.view.frame.size.width-translucentViewWidth)/2,(self.view.frame.size.height-translucentViewHeight)/2-60, translucentViewWidth,translucentViewHeight );
        
        
        controller=[[UIControl alloc]initWithFrame:loadingBackgroundRect];
        controller.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        
        
        CALayer *layer= controller.layer;
        layer.cornerRadius=3.0f;
        layer.masksToBounds=YES;
        
        int x=(loadingBackgroundRect.size.width-40)/2;
        
        int y=(loadingBackgroundRect.size.height-40)/2;
        
        
        CGRect spinnerRect=CGRectMake(x, y, 40, 40);
//         CGRect spinnerRect=CGRectMake(0, 0, 40, 40);
        
        spinner  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        spinner=[[UIActivityIndicatorView alloc] initWithFrame:spinnerRect];
        spinner.frame = spinnerRect;
      
        
        spinner.color = [UIColor lightGrayColor];
        
        [controller addSubview:spinner];
        
        [self.view addSubview:controller];
//        self.view.userInteractionEnabled = NO;
        
        [spinner startAnimating];
        
        
    }
    
}
/**
 *停止载入数据
 */
-(void) stopLoading{
    
    if (isLoading) {
        
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [controller removeFromSuperview];
        
        spinner=nil;
        controller=nil;
        
    }
    isLoading=NO;
}



@end
