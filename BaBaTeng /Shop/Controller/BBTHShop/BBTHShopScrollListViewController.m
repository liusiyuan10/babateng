//
//  BBTShopScrollListViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/8/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "BBTHShopScrollListViewController.h"
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

@interface BBTHShopScrollListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)  NSMutableArray *ADImageArray;

@property (nonatomic, strong)  NSMutableArray *packageArr;

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSString *pageStr;


@end

@implementation BBTHShopScrollListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商城";
    
    self.pageNum = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.ADImageArray = [[NSMutableArray alloc] init];
    
    self.packageArr = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
   [self  example01];
    
    
    
    
    
    
}

- (void)LoadChlidView
{
    
    
    CGFloat TableH = KDeviceHeight - kDevice_Is_iPhoneX - 26;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,kDeviceWidth, TableH)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
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



- (void)getCoursePackage
{
    
    [self startLoading];
    
    [HomeRequestTool getGoodsGoodsListCategoryId:self.categoryid pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(XEGoodModel * _Nonnull respone) {
        
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
    
    [HomeRequestTool getGoodsGoodsListCategoryId:self.categoryid pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] success:^(XEGoodModel * _Nonnull respone) {
        
        
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
    
//    cell.NameLabel.text = goodlist.goodsName;
    
    if ([goodlist.goodsOrigin isEqualToString:@"1"]) {
        
        NSTextAttachment *foreAttachment = [[NSTextAttachment alloc]init];
        foreAttachment.image = [UIImage imageNamed:@"XEShop_JD"];
        foreAttachment.bounds = CGRectMake(0, 0, 29, 16);
        
        NSMutableAttributedString *orginalAttributString = [[NSMutableAttributedString alloc]initWithString:@""];
        NSAttributedString *firsString = [NSAttributedString attributedStringWithAttachment:foreAttachment];
        [orginalAttributString appendAttributedString:firsString];
        
        NSString *goodStr = [NSString stringWithFormat:@" %@",goodlist.goodsName];
        NSMutableAttributedString *newAttributString = [[NSMutableAttributedString alloc]initWithString:goodStr];
        
        [orginalAttributString appendAttributedString:newAttributString];
        
        cell.NameLabel.attributedText = orginalAttributString;
    }
    else
    {
        cell.NameLabel.text = goodlist.goodsName;
    }
    
    
    cell.DescriptionLabel.text = [NSString stringWithFormat:@"已兑购%@件",goodlist.sellVolume];
    
    if (goodlist.rewardKeyWords.length > 0) {
        
        NSArray *array = [goodlist.rewardKeyWords componentsSeparatedByString:@","]; //字符串按照【分隔成数组
        if (array.count == 1) {
            cell.knowledgeLabel.hidden = NO ;
            cell.intelligenceLabel.hidden  = YES;
            
            
            
            cell.knowledgeLabel.text = [array objectAtIndex:0];
            
            
            
        }
        else if (array.count == 2)
        {
            cell.knowledgeLabel.hidden = NO ;
            cell.intelligenceLabel.hidden  = NO;
            
            
            
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
    
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[self removeFloatAllZeroByString:sellPricedStr]];
    
    
    if (goodlist.marketingKeyWords.length >0) {
        cell.SpecialLabel.hidden  = NO;
        
        
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






- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    

    
    
//    [self  example01];
    
    
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
