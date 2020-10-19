//
//  BBTStartPageViewController.m
//  BaBaTeng
//
//  Created by liu on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTStartPageViewController.h"
#import "BBTStartPageCell.h"
#import "BBTLoginViewController.h"
#import "BBTRegisterViewController.h"
#import "MBProgressHUD.h"
@interface BBTStartPageViewController ()<RegisterLoginDelegate>{

     MBProgressHUD *HUD;
}

@property (nonatomic, weak) UIPageControl *control;

@end

@implementation BBTStartPageViewController

static NSString *ID = @"Cell";


- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 清空行距
    layout.minimumLineSpacing = 0;
    
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.collectionView.backgroundColor = [UIColor purpleColor];
    
    // 设置返回按钮 代表下一个控制器的返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    // self.view != self.collectionView
    // 注意: self.collectionView 是self.view的子控件
    
    // 使用UICollectionViewController
    // 1.初始化的时候设置布局参数
    // 2.必须collectionView要注册cell
    // 3.自定义cell
    
    // 注册cell
    [self.collectionView registerClass:[BBTStartPageCell class] forCellWithReuseIdentifier:ID];
    
    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 添加pageController
    [self setUpPageControl];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除 navigationBar 底部的细线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
//    self.navigationController.navigationBar.translucent = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

//     self.navigationController.navigationBar.translucent=NO;



- (void)setUpPageControl
{
    // 添加pageController，只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = 4;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置center
    control.center = CGPointMake(self.view.width * 0.5, self.view.height - 30);
    _control = control;
    
    [self.view addSubview:control];
    
}


#pragma mark <UICollectionViewDataSource>
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
    
    NSLog(@"%d",page);
}

// 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // dequeueReusableCellWithReuseIdentifier
    // 1.首先从缓冲池里取出cell
    // 2.看下当前是否有注册cell,如果注册了cell，就会帮你创建cell
    // 3.没有注册，报错
    
    
    BBTStartPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //    NSLog(@"%@",cell);
    
    //    cell.backgroundColor = [UIColor greenColor];
    
    // 给cell传值
    
    // 拼接图片名称
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    NSString *imageName = [NSString stringWithFormat:@"new_featureNew_%ld",indexPath.row + 1];
    
    if (screenH > 480) {//5,6,6p
        
        imageName = [NSString stringWithFormat:@"new_featureNew_%ld",indexPath.row + 1];
    }
    
    cell.image = [UIImage imageNamed:imageName];
    
//    cell.backgroundColor = [UIColor greenColor];
    
    [cell setIndexPath:indexPath count:4];
    
    [cell.loginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [cell.registerButton addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}


- (void)Login
{

// NSLog(@"dfdfdfdfdfdfdfdf");
//    
//    BBTLoginViewController *oneVC = [[BBTLoginViewController alloc] init];
//    
//    //    oneVC.view.backgroundColor = [UIColor greenColor];
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];
//    
//    CZKeyWindow.rootViewController = nav;
    
    BBTLoginViewController *LoginVC = [[BBTLoginViewController alloc] init];
    [self.navigationController pushViewController:LoginVC animated:YES];
    
    
}

- (void)Register
{
    BBTRegisterViewController *RegisterVC = [[BBTRegisterViewController alloc] init];

    RegisterVC.delegate = self;
    
    [self.navigationController pushViewController:RegisterVC animated:YES];
    
}


-(void)didRegisterLogin:(NSString *)userName Password:(NSString *)password{
    
    [self showStartPageToastWithString:@"自动跳转登录界面,请稍后..."];
    
   // NSLog(@"自动登录中,请稍后...");
    
    [self performSelector:@selector(delayMethod:) withObject:[NSArray arrayWithObjects:userName,password, nil] afterDelay:1.5f];
    
}
-(void)delayMethod:(NSArray*)data{
    
//   [self postLoginUserName:self.usernameField.text Password:self.passwordField.text];

    if (data.count==2) {
        BBTLoginViewController *LoginVC = [[BBTLoginViewController alloc] init];
        LoginVC.pageType = @"Automaticlogin";
        LoginVC.username = data[0];
        LoginVC.password = data[1];
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    

    
}

-(void) showStartPageToastWithString:(NSString *)content{
    
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
    
    
}


@end
