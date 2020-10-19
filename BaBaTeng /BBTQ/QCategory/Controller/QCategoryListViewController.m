


//
//  CategoryListViewController.m
//  YijietongBuy
//
//  Created by YangGH on 16/2/3.
//  Copyright © 2016年 YangGH. All rights reserved.
//

#import "QCategoryListViewController.h"
#import "SXTitleLable.h"
#import "QCategoryScrollListViewController.h"
#import "UIColor+Helper.h"
#import "UIColor+SNFoundation.h"
#import "Header.h"
#import "QSourceTagList.h"

#import "BCategoryScrollListViewController.h"

@interface QCategoryListViewController ()<UIScrollViewDelegate>{
    
    
    SXTitleLable                            * _cursorView;                 //游标
}
/** 标题栏 */
@property (strong, nonatomic) UIScrollView *smallScrollView;
@property(nonatomic,strong) NSMutableArray *arrayCategoryList;

@property (strong, nonatomic)  UIScrollView *bigScrollView;
//@property(nonatomic,strong) SXTitleLable *oldTitleLable;
@property (nonatomic,assign) CGFloat beginOffsetX;




@end

@implementation QCategoryListViewController

static QCategoryListViewController *qCategoryListViewController;

+(QCategoryListViewController *)getInstance{
    
    return qCategoryListViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    qCategoryListViewController = self;
    [self setTitle:self.controllerTitle];
    
    [self.view addSubview:self.containerView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor light_White_Color];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self.arrayCategoryList addObjectsFromArray: self.arrayList];
    
    CGFloat smallScrollX;
    CGFloat smallScrollW;
    if ((kDeviceWidth-self.arrayCategoryList.count*70)<=0) {
        smallScrollX=0;
        smallScrollW = kDeviceWidth;
    }else{
        //        smallScrollX  = (kDeviceWidth-self.arrayCategoryList.count*70)/2;
        //        smallScrollW = self.arrayCategoryList.count*70;
        
        smallScrollX=0;
        smallScrollW = kDeviceWidth;
    }
    
    
    self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(smallScrollX,0,smallScrollW, 40)];
    self.smallScrollView.backgroundColor = NavBackgroundColor;// [UIColor orangeColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.bounces = YES;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *vBottomGrayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, 0.5)];
    vBottomGrayLine.backgroundColor = [UIColor colorWithRGBHex:0xdcdcdc];
    
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80)];
    self.bigScrollView.delegate = self;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:vBottomGrayLine];
    [self.view addSubview:self.bigScrollView];
    //NSLog(@"COUT===%lu",self.arrayLists.count);
    
    
    NSString *QdeivceProgramIdStr = [[TMCache sharedCache] objectForKey:@"QdeivceProgramId"];
    
    if ([QdeivceProgramIdStr isEqualToString:@"3"]) {
        [self addBController];
    }
    else
    {
        [self addQController];
    }
    
    
    [self addLable];
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = self.childViewControllers[self.index];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    
    CGFloat offsetX = (self.index) * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    SXTitleLable *lable = self.smallScrollView.subviews[self.index];
    lable.scale = 1.0;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    
    
    if(_cursorView){
        [_cursorView removeFromSuperview];
        _cursorView = nil;
    }
    _cursorView = [[SXTitleLable alloc]initWithFrame:CGRectMake((self.index)*70-15,37, 100,3)];
    _cursorView.backgroundColor =[UIColor whiteColor];//[UIColor orange_Red_Color]; //[UIColor colorWithRed:228.0/225 green:48.0/255 blue:44.0/255 alpha:1];
    
    [self.smallScrollView addSubview:_cursorView];
    
}

#pragma mark - ******************** 添加方法
/** 添加子控制器 */
/** 添加子控制器 */
- (void)addQController
{
    for (int i=0 ; i<self.arrayCategoryList.count;i++){
        QCategoryScrollListViewController *vc1 = [[QCategoryScrollListViewController alloc]init];
        
        
        //CategoryModel *category = self.arrayCategoryList[i];
        //vc1.title = category.meunName;
        vc1.title =[self.arrayList objectAtIndex:i];
        vc1.categoryid = [self.tagList objectAtIndex:i];
        //vc1.urlString = self.arrayLists[i][@"urlString"];
        
        [self addChildViewController:vc1];
    }
}

- (void)addBController
{
    for (int i=0 ; i<self.arrayCategoryList.count;i++){
        BCategoryScrollListViewController *vc1 = [[BCategoryScrollListViewController alloc]init];
        
        
        //CategoryModel *category = self.arrayCategoryList[i];
        //vc1.title = category.meunName;
        vc1.title =[self.arrayList objectAtIndex:i];
        vc1.categoryid = [self.tagList objectAtIndex:i];
        //vc1.urlString = self.arrayLists[i][@"urlString"];
        
        [self addChildViewController:vc1];
    }
}

/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < self.arrayCategoryList.count; i++) {
        
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        SXTitleLable *lbl1 = [[SXTitleLable alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text = vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:20];
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake(70 * self.arrayCategoryList.count, 0);
    
}

/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    SXTitleLable *titlelable = (SXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
}


#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
    SXTitleLable *titleLable = (SXTitleLable *)self.smallScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    // 添加控制器
    QCategoryScrollListViewController *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    newsVc.categoryid = [self.tagList objectAtIndex:index];//self.categoryid;
    
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            
            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    newsVc.view.frame = scrollView.bounds;
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    self.smallScrollView.backgroundColor = NavBackgroundColor;//[UIColor orangeColor];
    if (self.arrayCategoryList.count>5) {
        [self.smallScrollView setContentOffset:offset animated:YES];
    }
    
    CGRect cursorViewRC = CGRectZero;
    cursorViewRC = _cursorView.frame;
    cursorViewRC.origin.x = index*70;
    CGFloat  animatedDuring = 0.5;
    
    [UIView animateWithDuration:animatedDuring animations:^{
        
        _cursorView.frame = cursorViewRC;
        
        
    }completion:^(BOOL finished) {
        
        //_currentCursorX = _cursorView.x;
        
    }];
    
    
    
    if (newsVc.view.superview) return;
    [self.bigScrollView addSubview:newsVc.view];
    
    
    
}

-(void)stopplay:(NSInteger) index{
    
    
    for(int i=0; i<self.childViewControllers.count; i++) {
        
        if (i==index) {
            
            return;
        }
        
        QCategoryScrollListViewController *newsVc1 = self.childViewControllers[i];
        
        if (newsVc1.IsPlaying) {
            
            [newsVc1.playerView  removeObserver];
            newsVc1.IsPlaying = NO;
            for (int i=0; i<newsVc1.Qcateoryarr.count; i++) {
                
                QSourceTagList *listRespone = [newsVc1.Qcateoryarr objectAtIndex:i];
                if (listRespone.isListening==YES) {
                    
                    listRespone.isListening = NO;
                    
                    [newsVc1.tableView reloadData];
                    break;
                }
                
            }
            
            break;
        }
    }
    
    
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
    CGRect cursorViewRC = CGRectZero;
    cursorViewRC = _cursorView.frame;
    cursorViewRC.origin.x = value*70;
    _cursorView.frame = cursorViewRC;
}



-(UIView*)containerView{
    
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth, 40)];
    bgView.backgroundColor=[UIColor whiteColor];
    
    return bgView;
}


- (NSMutableArray *)arrayCategoryList
{
    if (_arrayCategoryList == nil) {
        _arrayCategoryList = [NSMutableArray array];
    }
    return _arrayCategoryList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}



@end

