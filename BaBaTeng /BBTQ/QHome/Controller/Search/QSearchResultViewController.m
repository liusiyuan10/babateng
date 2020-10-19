//
//  QSearchResultViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QSearchResultViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "QSearchViewController.h"
#import "QSearchAlbumListViewController.h"
#import "SearchTapSliderScrollView.h"
#import "QMineRequestTool.h"
#import "QSearchCount.h"
#import "QSearchCountData.h"


@interface QSearchResultViewController ()<UISearchBarDelegate,SearchSliderLineViewDelegate>

@property(nonatomic , strong)UISearchBar * searchBar;
@property(nonatomic , strong)UIView * headView;

@property (nonatomic,strong)NSMutableArray *LbuttonViewArr;

@property (nonatomic,assign) CGFloat myheight;

@property (nonatomic, copy) NSString *albumCount;
@property (nonatomic, copy) NSString *songCount;

@end

@implementation QSearchResultViewController

//适配iphone x
- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc]init];
        //适配iphone x
        CGFloat myheight;
        if (iPhoneX) {
            myheight =24;
        }else{
            
            myheight =0;
            
        }
        _headView.frame = CGRectMake(0, 0, kDeviceWidth, 20+myheight);
        _headView.backgroundColor = [UIColor clearColor];
    }
    return _headView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        //适配iphone x
        CGFloat myheight;
        if (iPhoneX) {
            myheight =12;
        }else{
            
            myheight =0;
            
        }
        
//        _searchBar.frame = CGRectMake(12, 21+myheight, kDeviceWidth - 12 - 50, 28);
//        //        _searchBar.tintColor=[UIColor blueColor];
//        //        [_searchBar setBackgroundImage:[UIImage imageNamed:@"ic_searchBar_bgImage"]];
//                        _searchBar.backgroundColor = [UIColor redColor];
////        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
//        //        [_searchBar sizeToFit];
//        [_searchBar setPlaceholder:@"请输入关键字"];
//        _searchBar.text = self.searchstr;
//
//        [_searchBar setDelegate:self];
//        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
//        [_searchBar setTranslucent:YES];//设置是否透明
//        [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
//
//
//
//        _searchBar.tintColor = [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
        
        _searchBar.frame = CGRectMake(12, 21+myheight, kDeviceWidth - 12 - 50, 28);
        _searchBar.barStyle=UIBarStyleDefault;
        _searchBar.searchBarStyle=UISearchBarStyleDefault;
//        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        
//        _searchBar.layer.borderWidth = 1;
//        _searchBar.layer.borderColor = [[UIColor orangeColor] CGColor];
        
        UIImageView *barImageView = [[[_searchBar.subviews firstObject] subviews] firstObject];
        
        barImageView.layer.borderColor = [UIColor orangeColor].CGColor;
        barImageView.layer.borderWidth = 1;



  
        _searchBar.placeholder=@"请输入关键字";
         _searchBar.text = self.searchstr;
        

       // _searchBar.showsSearchResultsButton=YES;
        

        _searchBar.tintColor= [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
        _searchBar.barTintColor=[UIColor orangeColor];
        
//        _searchBar.backgroundColor = [UIColor redColor];
        
         UITextField *searchField=[_searchBar valueForKey:@"searchField"];
         searchField.backgroundColor = [UIColor whiteColor];
  
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
        
//        _searchBar.translucent=YES;
//        //输入框和输入文字的调整
//        //白色的那个输入框的偏移
        _searchBar.searchFieldBackgroundPositionAdjustment=UIOffsetMake(0, 0);
        //输入的文字的位置偏移
        _searchBar.searchTextPositionAdjustment=UIOffsetMake(0, 0);


        //设置代理
        _searchBar.delegate=self;

        
    }
    return _searchBar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    
    //适配iphone x
    CGFloat myheight;
    if (iPhoneX) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    
    self.myheight = myheight;
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64+myheight)];
    
    navView.backgroundColor = [UIColor orangeColor];
    
 
    [self.view addSubview:navView];
    
    [navView addSubview:self.headView];
    
    [navView addSubview:self.searchBar];
    
//    for (UIView *view in self.searchBar.subviews) {
//
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
////             [view.subviews objectAtIndex:0].layer.contents = nil;
//            break;
//        }
//    }//去掉搜索周围的灰色
    
//    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            view.layer.contents = nil;
//            break;
//        }
//    }//去掉黑线
    
//    for (UIView *view in self.searchBar.subviews) {
//
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }//去掉搜索周围的灰色
    

    
    
    [self.searchBar becomeFirstResponder];
    
    //适配iphone x
    CGFloat myheight1;
    if (iPhoneX) {
        myheight1 =16;
    }else{
        
        myheight1 =0;
        
    }
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBar.frame), 21+ 5 +myheight1, 32, 20)];
    
    
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelBtn setTitleEdgeInsets:(]
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:cancelBtn];
    
    self.LbuttonViewArr = [NSMutableArray array];
    
//    [self LoadChlidView];
    [self getToalAblumCourse];
    

}

- (void)getToalAblumCourse
{
    
    NSDictionary *parameter = @{@"deviceTypeId" : [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"keyword":self.searchstr};
    
    [self startLoading];
    
    [QMineRequestTool GetSearchCountListParameter:parameter success:^(QSearchCount *respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {

            self.albumCount = respone.data.trackListCount;
            self.songCount = respone.data.trackCount;
           

            [self LoadChlidView];

        }else{

            [self showToastWithString:respone.message];
        }
    } failure:^(NSError *error) {
        
                [self stopLoading];
                [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];

    
}


- (void)LoadChlidView
{
    QSearchAlbumListViewController *CurriculumnoControlVC = [[QSearchAlbumListViewController alloc] init];
    QSearchViewController *CurriculumhaveControlVC = [[QSearchViewController alloc] init];

    CurriculumhaveControlVC.block = ^{
        [self.searchBar resignFirstResponder];
    };
    CurriculumnoControlVC.block = ^{
        [self.searchBar resignFirstResponder];
    };
    
    SearchTapSliderScrollView *viewControlVC = [[SearchTapSliderScrollView alloc]initWithFrame:CGRectMake(0, 64 + self.myheight, kDeviceWidth, KDeviceHeight)];
    viewControlVC.delegate = self;
    //设置滑动条的颜色
    viewControlVC.sliderViewColor = [UIColor orangeColor];
    viewControlVC.titileColror = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];
    viewControlVC.selectedColor = [UIColor orangeColor];//x
    
    
  
    [viewControlVC createView:@[[NSString stringWithFormat:@"专辑 (%@)",self.albumCount],[NSString stringWithFormat:@"声音 (%@)",self.songCount]] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC] SearchStr:self.searchstr  andRootVc:self];
    
    
    //    [viewControlVC createView:@[@"未上课(3)",@"已上课(2)",@"已取消(1)"] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] andRootVc:self];
    
    self.LbuttonViewArr = viewControlVC.LbuttonViewArr;
    
    [self.view addSubview:viewControlVC];
    
    //自动滑动到第二页
    [viewControlVC sliderToViewIndex:0];
    
}


- (void)cancelBtnClicked
{
    [self.searchBar resignFirstResponder];
    

    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}


/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark----UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getSToalAblumCourse
{
    
    NSDictionary *parameter = @{@"deviceTypeId" : [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"keyword":self.searchstr};
    
    [self startLoading];
    
    [QMineRequestTool GetSearchCountListParameter:parameter success:^(QSearchCount *respone) {
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.albumCount = respone.data.trackListCount;
            self.songCount = respone.data.trackCount;
            
            if (self.LbuttonViewArr.count > 0) {
                
                UIButton *btn = [self.LbuttonViewArr objectAtIndex:0];
                
                [btn setTitle:[NSString stringWithFormat:@"专辑 (%@)",self.albumCount] forState:UIControlStateNormal];
                
                UIButton *btn1 = [self.LbuttonViewArr objectAtIndex:1];
                
                [btn1 setTitle:[NSString stringWithFormat:@"声音(%@)",self.songCount] forState:UIControlStateNormal];
                
                
                
            }
            
        }else{
            
            [self showToastWithString:respone.message];
        }
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    
    NSString * urlStr = searchBar.text;
    
    //过滤字符串前后的空格
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    self.searchstr = urlStr;
    
    [self getSToalAblumCourse];
    
    NSDictionary *jsonDict = @{@"SearchStr" : self.searchstr };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QSearchResult" object:self userInfo:jsonDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QSearchAlbumResult" object:self userInfo:jsonDict];
    NSLog(@"sdfdgdsb");
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    

    // self.navigationController.navigationBar.translucent = NO;
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
