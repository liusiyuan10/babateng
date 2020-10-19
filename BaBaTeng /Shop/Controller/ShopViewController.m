//
//  HomeViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "ShopViewController.h"
#import "NewPagedFlowView.h"

#import "UIImageView+AFNetworking.h"

#import "HomeRequestTool.h"
#import "Bulletin.h"
#import "BulletinData.h"

#import "UIImageView+WebCache.h"

#import "CoursePackage.h"
#import "CoursePackageData.h"
#import "HomeCell.h"
#import "XEMallViewController.h"

#import "XEGoodModel.h"
#import "XEGoodDataModel.h"
#import "XEGoodListModel.h"

#import "BulletinViewController.h"
  #import "XEMallNewViewController.h"

@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) NewPagedFlowView *pageFlowView;
@property(strong,nonatomic)  NSMutableArray *ADImageArray;

@property (nonatomic, strong)  NSMutableArray *packageArr;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;


@end

@implementation ShopViewController

#pragma mark --轮播图

- (NewPagedFlowView *)pageFlowView
{
    if (_pageFlowView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth * 9 / 16)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = NO;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;
        
        //初始化pageControl
        //        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 32, kDeviceWidth, 8)];
        //        _pageFlowView.pageControl = pageControl;
        //        [_pageFlowView addSubview:pageControl];
        
        [_pageFlowView reloadData];
    }
    
    return _pageFlowView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商城";
    
    self.pageNum = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.ADImageArray = [[NSMutableArray alloc] init];
    
    self.packageArr = [[NSMutableArray alloc] init];

    [self LoadChlidView];
    
//    [self GetBulletinList];
//    [self getCoursePackage];
    
    
//    self.view.backgroundColor = [UIColor redColor];
    
 

    
    

}

- (void)LoadChlidView
{
    
    
    CGFloat TableH = KDeviceHeight - kDevice_IsE_iPhoneX;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,kDeviceWidth, TableH)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth * 9 / 16)];
    
    [self.tableView.tableHeaderView addSubview:self.pageFlowView];
    
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
    
    [self pullRefresh];
    
}


- (void)GetBulletinList
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    [HomeRequestTool GetBulletinDeviceTypeId:@"2" Parameter:parameter success:^(Bulletin *response) {
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ADImageArray = response.data;
            
            NSLog(@"self.ADImageArray%@",self.ADImageArray);
            
            [self.tableView reloadData];
            
            [self.pageFlowView reloadData];
            
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
        //        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
    
}

- (void)getCoursePackage
{

    [self startLoading];
    
    [HomeRequestTool getGoodsGoodsListpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(XEGoodModel * _Nonnull respone) {
        
            [self stopLoading];
            [self.tableView.mj_header endRefreshing];
    
            if ([respone.statusCode isEqualToString:@"0"]) {
    
                self.packageArr = respone.data.list;
                self.pageStr = respone.data.pages;
    
                [self.tableView reloadData];
    
            }else{
    
                [self showToastWithString:respone.message];
            }
    
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

}

#pragma mark UITableView + 下拉刷新 默认
- (void)example01
{
      self.pageNum = 1;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
 
    [self GetBulletinList];//获取广告列表
    
    [self getCoursePackage];//获取商品
    
}


#pragma mark UITableView + 上拉刷新
- (void) pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}


#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    self.pageNum++;
    
    if (self.pageNum>[self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    //
    
    
    [self startLoading];
    
    [HomeRequestTool getGoodsGoodsListpageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(XEGoodModel * _Nonnull respone) {
        
        
        [self stopLoading];
        
        [self.tableView.mj_footer endRefreshing];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.pageStr = respone.data.pages;
            
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            array1 = respone.data.list;
            
            if (array1.count>0) {
                
                
                
                
                [self.packageArr addObjectsFromArray:array1];
                [self.tableView reloadData];
                
            }
            
            
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
}





#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.packageArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndentifierOne = @"HomeCellcell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    
//    CoursePackageData *packagedata = [self.packageArr objectAtIndex:indexPath.row];
    XEGoodListModel *goodlist  =  [self.packageArr objectAtIndex:indexPath.row];
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)goodlist.goodsFaceImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"order_image_empty"]];
    
    cell.NameLabel.text = goodlist.goodsName;
    
   
    cell.DescriptionLabel.text = [NSString stringWithFormat:@"已兑购%@件",goodlist.sellVolume];
   
    if (goodlist.rewardKeyWords.length > 0) {
        
         NSArray *array = [goodlist.rewardKeyWords componentsSeparatedByString:@","]; //字符串按照【分隔成数组
        if (array.count == 1) {
            cell.knowledgeLabel.hidden = NO ;
            cell.intelligenceLabel.hidden  = YES;
            
            NSString *knowledgeStr = [NSString stringWithFormat:@"%@ ",[array objectAtIndex:0]];
            
            CGFloat knowledgeW = [self getWidthWithText:knowledgeStr height:16.0 font:10.0];
            
//             _knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_NameLabel.frame) + 8, 80, 16)];
            
            cell.knowledgeLabel.frame =CGRectMake( 16 + 125 + 16, 60 + 8, knowledgeW, 16);
            
            cell.knowledgeLabel.text = [array objectAtIndex:0];
            
            
            
        }
        else if (array.count == 2)
        {
            cell.knowledgeLabel.hidden = NO ;
            cell.intelligenceLabel.hidden  = NO;
            
            
            NSString *knowledgeStr = [NSString stringWithFormat:@" %@ ",[array objectAtIndex:0]];
            
            CGFloat knowledgeW = [self getWidthWithText:knowledgeStr height:16.0 font:10.0];
            
            //             _knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_NameLabel.frame) + 8, 80, 16)];
            
            cell.knowledgeLabel.frame =CGRectMake( 16 + 125 + 16, 60 + 8, knowledgeW, 16);
            
            NSString *intelligenceStr = [NSString stringWithFormat:@" %@ ",[array objectAtIndex:1]];
            
            CGFloat intelligenceW = [self getWidthWithText:intelligenceStr height:16.0 font:10.0];
            
            //             _knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_NameLabel.frame) + 8, 80, 16)];
            

            
            cell.knowledgeLabel.frame =CGRectMake( 16 + 125 + 16, 60 + 8, knowledgeW, 16);
            cell.intelligenceLabel.frame =CGRectMake( CGRectGetMaxX(cell.knowledgeLabel.frame) + 6, 60 + 8, intelligenceW, 16);
            
            cell.knowledgeLabel.text = [array objectAtIndex:0];
            cell.intelligenceLabel.text = [array objectAtIndex:1];
        }
        else
        {
            cell.knowledgeLabel.hidden =YES ;
            cell.intelligenceLabel.hidden  = YES;
         
        }
        
    }
    else
    {
        cell.knowledgeLabel.hidden = YES;
        cell.intelligenceLabel.hidden  = YES;
    }
    
     NSString *sellPricedStr = [NSString stringWithFormat:@"%.2f",goodlist.sellPrice];
    
    NSString *priceLabelStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"¥%.2f",goodlist.sellPrice]];
    
//    NSString *priceLabelStr = [NSString stringWithFormat:@"%@      ", sellPricedStr];
    

    CGFloat priceLabelW = [self getWidthWithText:priceLabelStr height:18.0 font:15.0];
    
     cell.priceLabel.frame = CGRectMake(125 + 16 + 16,68 + 19, priceLabelW, 15);
    
    
//     cell.priceLabel.text =[NSString stringWithFormat:@"¥%.2f",goodlist.sellPrice];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[self removeFloatAllZeroByString:sellPricedStr]];
    
    
    if (goodlist.marketingKeyWords.length >0) {
        cell.SpecialLabel.hidden  = NO;
        
        
        NSString *SpecialStr = [NSString stringWithFormat:@" %@ ",goodlist.marketingKeyWords];
        
        CGFloat SpeciallW = [self getWidthWithText:SpecialStr height:16.0 font:10.0];
        
        cell.SpecialLabel.frame = CGRectMake(CGRectGetMaxX(cell.priceLabel.frame), 68 + 19,SpeciallW , 16 );
        
        cell.SpecialLabel.text = goodlist.marketingKeyWords;
        
    }
    else
    {
        cell.SpecialLabel.hidden  = YES;
    }
   
    

    
    return cell;
    
}

- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
    
}


- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    //    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, height)];
    
    return rect.size.width;
    //    return size.width;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    return 125 + 12;


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    XEGoodListModel *goodlist  = [self.packageArr objectAtIndex:indexPath.row];
    
//    XEMallViewController *XEMalllVC = [[XEMallViewController alloc] init];
//
//    XEMalllVC.packageId = goodlist.goodsId;
//
//    [self.navigationController pushViewController:XEMalllVC animated:YES];
    
    

    XEMallNewViewController *XEMalllVC = [[XEMallNewViewController alloc] init];

    XEMalllVC.packageId = goodlist.goodsId;

    [self.navigationController pushViewController:XEMalllVC animated:YES];

}




#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kDeviceWidth - 60, (kDeviceWidth - 60) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:subIndex];
    
    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@mallAdvert.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    bulletinVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:bulletinVc animated:YES];
    
    //    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.ADImageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 15;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    
    BulletinData *bulletindata = self.ADImageArray[index];
    
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.bulletinIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
    //    bannerView.mainImageView.backgroundColor = [UIColor purpleColor];
    
    return bannerView;
}

-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index{
    
    NSLog(@"index===%ld",(long)index);
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    

    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:index];
    
    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@mallAdvert.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    
    NSLog(@"dddddddd======%@",urlStr);
    
    bulletinVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:bulletinVc animated:YES];
    
    
}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if ([self.VCType isEqualToString:@"Panet"])
    {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
    else
    {
       [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
    

    
    [self  example01];


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    

    

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
