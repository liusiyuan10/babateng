//
//  OrdeyByQAlbumListViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "OrdeyByQAlbumListViewController.h"
#import "AlbumTapSliderScrollView.h"
#import "NewQAlbumListViewController.h"
#import "BSearchViewController.h"
#import "PYSearchViewController.h"
#import "QSearchResultViewController.h"


@interface OrdeyByQAlbumListViewController ()<AlbumSliderLineViewDelegate>

@property (nonatomic,strong)NSMutableArray *LbuttonViewArr;

@end

@implementation OrdeyByQAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.Albumtitle;
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    self.LbuttonViewArr = [NSMutableArray array];
    
    [self LoadChlidView];
    // Do any additional setup after loading the view.
}


- (void)LoadChlidView
{
    NewQAlbumListViewController *CurriculumnoControlVC = [[NewQAlbumListViewController alloc] init];
    NewQAlbumListViewController *CurriculumhaveControlVC = [[NewQAlbumListViewController alloc] init];
    NewQAlbumListViewController *CurriculumcancelControlVC = [[NewQAlbumListViewController alloc] init];
    
    AlbumTapSliderScrollView *viewControlVC = [[AlbumTapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    viewControlVC.delegate = self;
    //设置滑动条的颜色
    viewControlVC.sliderViewColor = [UIColor orangeColor];
    viewControlVC.titileColror = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];
    viewControlVC.selectedColor = [UIColor orangeColor];//x
    
    
    
//    [viewControlVC createView:@[@"综合排序",@"播放最多",@"最近更新"] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] andRootVc:self];
    [viewControlVC createView:@[@"综合排序",@"播放最多",@"最近更新"] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] DeviceTypeId:self.deviceTypeId PanelId:self.panelId andRootVc:self];
    
    
    //    [viewControlVC createView:@[@"未上课(3)",@"已上课(2)",@"已取消(1)"] andViewArr:@[CurriculumnoControlVC,CurriculumhaveControlVC,CurriculumcancelControlVC] andRootVc:self];
    
    self.LbuttonViewArr = viewControlVC.LbuttonViewArr;
    
    [self.view addSubview:viewControlVC];
    
    //自动滑动到第二页
    [viewControlVC sliderToViewIndex:0];
    
    [self setNavigationItem];
    
}

-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_nor"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"nav_shoushuoi_pre"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(QSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}

- (void)QSearch
{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"百家姓", @"为什么", @"守株待兔", @"井底之蛙", @"千字文", @"三字经", @"春晓",@"唐诗"];
    // 2. Create a search view controller
    //适配iphone x
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入搜索关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        
        NSString * urlStr = searchText;
        
        //过滤字符串前后的空格
        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //过滤中间空格
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //过滤中间空格
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
        
        if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
            
            BSearchViewController *searchVc = [[BSearchViewController alloc] init];
            searchVc.searchstr = urlStr;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
            
            nav.navigationBar.barTintColor = [UIColor orangeColor];
            [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
              nav.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [searchViewController presentViewController:nav animated:YES completion:nil];
        }else{
            
            //            QSearchViewController *searchVc = [[QSearchViewController alloc] init];
            QSearchResultViewController *searchVc = [[QSearchResultViewController alloc] init];
            searchVc.searchstr = urlStr;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
            
            nav.navigationBar.barTintColor = [UIColor orangeColor];
            [searchVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
              nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [searchViewController presentViewController:nav animated:YES completion:nil];
        }
        
        
        
    }];
    // 3. Set style for popular search and search history
    
    searchViewController.hotSearchStyle = 2;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    nav.navigationBar.barTintColor = [UIColor orangeColor];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent  = NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)AlbumsliderViewAndReloadData:(NSInteger)index { 
    
}



@end
