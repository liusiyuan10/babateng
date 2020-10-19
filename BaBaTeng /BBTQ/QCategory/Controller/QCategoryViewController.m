//
//  QCategoryViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/12.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCategoryViewController.h"
#import "QCategoryCell.h"
#import "QCategoryCollectionViewCell.h"
#import "QCategoryListViewController.h"
#import "CustomRootViewController.h"

#import "QMineRequestTool.h"
#import "QDeviceInfoRespone.h"

#import "QSourceType.h"
#import "QSourceTypeData.h"
#import "QSourceTypeDataTag.h"

#import "UIImageView+AFNetworking.h"
#import "HomeViewController.h"
#import "QAlbumCategoryListViewController.h"

@interface QCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)      NSString *sign;

@property (nonatomic, assign) BOOL isCanSideBack;


@end

@implementation QCategoryViewController

-(void)loadView
{
    [super loadView];
//    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分类";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppCategoryPlay:) name:@"AppCategoryPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryRefresh:) name:@"CategoryRefresh" object:nil];
    
    [self setNavigationItem];
    [self LoadChlidView];
    [self getQCategory];
    
    //    self.view.backgroundColor = [UIColor colorWithRed:246 /255.0 green:246 /255.0 blue:246 /255.0 alpha:1];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)CategoryRefresh:(NSNotification *)noti
{
     [self getQCategory];
    
}


- (void)AppCategoryPlay:(NSNotification *)noti
{
    NSLog(@"self.sign===%@",self.sign);
    [appDelegate AnimationOutsidePlay:self.sign];
    
}

- (void)getQCategory
{
    
    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    NSLog(@"qcateory123333%@",name);
    
    [self startLoading];
    
   [QMineRequestTool getDeviceSourceTypesName:name success:^(QSourceType *response) {
       
       [self stopLoading];
       
       if ([response.statusCode isEqualToString:@"0"]) {
           
           self.categoryArray = response.data;
           
//           [self LoadChlidView];
           
           [self.tableView reloadData];
           
           
           
       }
//       else if([response.statusCode isEqualToString:@"3705"])
//       {
//           
//           [[HomeViewController getInstance] KickedOutDeviceStaues];
//           
//           
//       }
       else{
           
           [self showToastWithString:response.message];
       }
       
       
       
   } failure:^(NSError *error) {
       
       [self stopLoading];
       
       [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
       
   }];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    //    [button setTitle:@"返回" forState:UIControlStateNormal];
    //    [button setTitle:@"返回" forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

-(void)backFore{

        [[CustomRootViewController getInstance]comeback];

}

- (void)LoadChlidView
{
       
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -33, kDeviceWidth, KDeviceHeight -50 - 50 -kDevice_Is_iPhoneX) style:UITableViewStyleGrouped];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
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
    //    [self.tableView addSubview:bgView];
    
    [self.view addSubview:self.tableView];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
//    
//    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
//    [button addTarget:self action:@selector(backFore) forControlEvents:UIControlEventTouchUpInside];
//    
//    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    
//    [self.view addSubview:button];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    QCategoryCell *cell = (QCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[QCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:246 /255.0 green:246 /255.0 blue:246 /255.0 alpha:1];
        
    }
    
    cell.iconView.userInteractionEnabled = YES;
    
    QSourceTypeData *typeData = [self.categoryArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = typeData.deviceSourceTypeName;
    
//    cell.leftImageView.image = [UIImage imageNamed:@"changjing"];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)typeData.deviceSourceTypeIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    NSLog(@"typeData.deviceSourceTypeIcon=====%@",typeData.deviceSourceTypeIcon);
    
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"changjing"]];
    
    UITapGestureRecognizer *iconViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClicked:)];
    cell.iconView.tag = indexPath.row;
    [cell.iconView addGestureRecognizer:iconViewTap];
    
    return cell;
}

- (void)iconViewClicked:(UITapGestureRecognizer *)recognizer
{
    
    // NSLog(@"recognizer=======%d",recognizer.view.tag);
    QSourceTypeData *typeData = [self.categoryArray objectAtIndex:recognizer.view.tag];
    
    
    NSMutableArray *arrayList = [[NSMutableArray alloc] init];
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (int i = 0; i<typeData.sourceTags.count; i++) {
        
        QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:i];
        [tagList addObject:datatag.tagId];
    }
    
    for (int i = 0; i<typeData.sourceTags.count; i++) {
        
        QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:i];
        [arrayList addObject:datatag.tagName];
    }
    
    QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:0];
    if ([typeData.flag isEqualToString:@"2"]) {
        
        QAlbumCategoryListViewController *categoryList = [[QAlbumCategoryListViewController alloc]init];
        categoryList.hidesBottomBarWhenPushed = YES;
        categoryList.arrayList = arrayList;
        categoryList.index = 0;
        
        categoryList.categoryid = datatag.tagId;
        
        categoryList.tagList = tagList;
        
        NSLog(@"datatag.tagId=====%@",datatag.tagId);
        categoryList.controllerTitle = @"专辑列表";
        [self.navigationController pushViewController:categoryList animated:YES];
    }
    else if([typeData.flag isEqualToString:@"1"])
    {
        QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:0];
        
        QCategoryListViewController *categoryList = [[QCategoryListViewController alloc]init];
        categoryList.hidesBottomBarWhenPushed = YES;
        categoryList.arrayList = arrayList;
        categoryList.index = 0;
        
        categoryList.categoryid = datatag.tagId;
        categoryList.tagList =tagList;
        NSLog(@"datatag.tagId==888888888=====%@",datatag.tagId);
        categoryList.controllerTitle = @"分类列表";
        [self.navigationController pushViewController:categoryList animated:YES];
    }
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(QCategoryCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    NSInteger index = cell.collectionView.indexPath.row;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        QSourceTypeData *typeData = self.categoryArray[0];
//        NSLog(@"sdfsdfdsf===%u",((typeData.sourceTags.count - 1)/2 +1));
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
    }
    else if (indexPath.row == 1)
    {
        QSourceTypeData *typeData = self.categoryArray[1];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
    }
    else if(indexPath.row == 2)
    {
        QSourceTypeData *typeData = self.categoryArray[2];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 3)
    {
        QSourceTypeData *typeData = self.categoryArray[3];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 4)
    {
        QSourceTypeData *typeData = self.categoryArray[4];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 5)
    {
        QSourceTypeData *typeData = self.categoryArray[5];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 6)
    {
        QSourceTypeData *typeData = self.categoryArray[6];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 7)
    {
        QSourceTypeData *typeData = self.categoryArray[7];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 8)
    {
        QSourceTypeData *typeData = self.categoryArray[8];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 9)
    {
        QSourceTypeData *typeData = self.categoryArray[9];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 10)
    {
        QSourceTypeData *typeData = self.categoryArray[10];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 11)
    {
        QSourceTypeData *typeData = self.categoryArray[11];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 12)
    {
        QSourceTypeData *typeData = self.categoryArray[12];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 13)
    {
        QSourceTypeData *typeData = self.categoryArray[13];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 14)
    {
        QSourceTypeData *typeData = self.categoryArray[14];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 15)
    {
        QSourceTypeData *typeData = self.categoryArray[15];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 16)
    {
        QSourceTypeData *typeData = self.categoryArray[16];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 17)
    {
        QSourceTypeData *typeData = self.categoryArray[17];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 18)
    {
        QSourceTypeData *typeData = self.categoryArray[18];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 19)
    {
        QSourceTypeData *typeData = self.categoryArray[19];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 20)
    {
        QSourceTypeData *typeData = self.categoryArray[20];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 21)
    {
        QSourceTypeData *typeData = self.categoryArray[21];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 22)
    {
        QSourceTypeData *typeData = self.categoryArray[22];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 23)
    {
        QSourceTypeData *typeData = self.categoryArray[23];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 24)
    {
        QSourceTypeData *typeData = self.categoryArray[24];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 25)
    {
        QSourceTypeData *typeData = self.categoryArray[25];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 26)
    {
        QSourceTypeData *typeData = self.categoryArray[26];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if
        (indexPath.row == 27)
    {
        QSourceTypeData *typeData = self.categoryArray[27];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 28)
    {
        QSourceTypeData *typeData = self.categoryArray[28];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 29)
    {
        QSourceTypeData *typeData = self.categoryArray[29];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    else if(indexPath.row == 30)
    {
        QSourceTypeData *typeData = self.categoryArray[30];
        return 51 * ((typeData.sourceTags.count - 1)/2 +1)  + 10;
        
    }
    
    else
        return 51 + 10;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    
    QSourceTypeData *typeData = self.categoryArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    
    //    if ( == 0) {
    //        return 1;
    //    }else
    
    return typeData.sourceTags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    QCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    
//    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    QSourceTypeData *typeData = self.categoryArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    
//    NSLog(@"typeData%@",typeData.sourceTags);
    
    
    QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.nameLabel.text =  datatag.tagName;
//    cell.backgroundColor = collectionViewArray[indexPath.item];
    
    
    
    return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"sb nidianwole ");
//    
//    NSArray *arrayList = [NSMutableArray arrayWithObjects:@"哄睡",@"洗澡",@"哄睡", @"哄睡", @"哄睡", @"哄睡",@"哄睡",@"洗澡",nil];
    
    NSLog(@"indgdgsss%ld",(long)indexPath.item);
    
   
   QSourceTypeData *typeData = self.categoryArray[[(AFIndexedCollectionView *)collectionView indexPath].row];

    
    
    NSMutableArray *arrayList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<typeData.sourceTags.count; i++) {
        
        QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:i];
        [arrayList addObject:datatag.tagName];
    }
    
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<typeData.sourceTags.count; i++) {
        
        QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:i];
        [tagList addObject:datatag.tagId];
    }
    
    QSourceTypeDataTag *datatag = [typeData.sourceTags objectAtIndex:indexPath.row];
    if ([typeData.flag isEqualToString:@"2"]) {
        
        QAlbumCategoryListViewController *categoryList = [[QAlbumCategoryListViewController alloc]init];
        categoryList.hidesBottomBarWhenPushed = YES;
        categoryList.arrayList = arrayList;
        categoryList.index = indexPath.row;
        
        categoryList.categoryid = datatag.tagId;
        
        categoryList.tagList = tagList;
        
        NSLog(@"datatag.tagId=====%@",datatag.tagId);
        categoryList.controllerTitle = @"专辑列表";
        [self.navigationController pushViewController:categoryList animated:YES];
    }
    else if([typeData.flag isEqualToString:@"1"])
    {
        QCategoryListViewController *categoryList = [[QCategoryListViewController alloc]init];
        categoryList.hidesBottomBarWhenPushed = YES;
        categoryList.arrayList = arrayList;
        categoryList.index = indexPath.row;
        
        categoryList.categoryid = datatag.tagId;
        
        categoryList.tagList = tagList;
        
        NSLog(@"datatag.tagId=====%@",datatag.tagId);
        categoryList.controllerTitle = @"分类列表";
        [self.navigationController pushViewController:categoryList animated:YES];
    }
    

}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
    NSInteger index = collectionView.indexPath.row;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.sign = @"QCategoryViewController";
    
//    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
//    [self getQCategory];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self forbiddenSideBack];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self resetSideBack];
    
}



/**
 
 * 禁用边缘返回
 
 */

-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    
    //关闭ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        
    }
    
}

/*
 
 恢复边缘返回
 
 */

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    
    //开启ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
}

@end

