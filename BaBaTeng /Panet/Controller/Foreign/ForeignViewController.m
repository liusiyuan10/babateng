//
//  ForeignViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/28.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "ForeignViewController.h"
#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "TMForeigenQuiltViewCell.h"
#import "ForeignShopDetailViewController.h"
#import "PanetRequestTool.h"
#import "CoursePackage.h"
#import "CoursePackageData.h"
#import "UIImageView+AFNetworking.h"
#import "ForeignPayRecordViewController.h"


@interface ForeignViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong)     TMQuiltView *collectionView;

@property (nonatomic, strong)  NSMutableArray *packageArr;

@end

@implementation ForeignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"外教一对一";
    
    self.packageArr = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];
    
    [self.collectionView reloadData];
    
    [self getCoursePackage];
}


- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64)];
    NSLog(@"KDeviceHeight=====%f",KDeviceHeight);
    
    bgImageView.image = [UIImage imageNamed:@"Foreign_bg"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    self.bgImageView = bgImageView;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 35, kDeviceWidth - 60, 149)];
//    headImageView.backgroundColor = [UIColor purpleColor];
     headImageView.image = [UIImage imageNamed:@"Foreign_fonts"];
    
    [headView addSubview:headImageView];
    
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.collectionView.contentInset=UIEdgeInsetsMake(210+ 10, 0, 0, 0);
    [self.collectionView addSubview:headView];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    CGRect profileRect=headView.frame;
    CGRect newFrame=CGRectMake(0, -profileRect.size.height-5, kDeviceWidth, profileRect.size.height);
    headView.frame=newFrame;
    
    
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.collectionView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.collectionView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
//    [self setNavigationItem];
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 18)];
    
    [rightbutton setTitle:@"付款记录" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(Payrecord) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)Payrecord
{
    

        ForeignPayRecordViewController *PayRecordControlVC = [[ForeignPayRecordViewController alloc] init];
        
        [self.navigationController pushViewController:PayRecordControlVC animated:YES];
    

}

- (void)getCoursePackage
{
    
    [self startLoading];
    
    [PanetRequestTool getCoursePackageParameter:nil PackageType:@"2" success:^(CoursePackage * _Nonnull respone) {
        
        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {

            self.packageArr = respone.data;

            [self.collectionView reloadData];

        }else{

            [self showToastWithString:respone.message];
        }

        
    } failure:^(NSError * _Nonnull error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];

    

    
    
}


//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
  return  self.packageArr.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    TMForeigenQuiltViewCell *cell = (TMForeigenQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMForeigenQuiltViewCell alloc] initWithReuseIdentifier:@"TMForeigenCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    cell.picHeight=164;
//    cell.photoView.image = [UIImage imageNamed:@"empty_state"];
    
//    QMPanelList *listRespone = self.albumListarr[indexPath.row];
//
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
//
//
    
    CoursePackageData *packagedata = [self.packageArr objectAtIndex:indexPath.row];
    

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)packagedata.packageImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"empty_state"]];
    
    cell.titleLabel.text = packagedata.packageName;
    
    cell.buyLabel.text = packagedata.totalPrice;
    
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 2;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KDeviceHeight/667.0*(246+21);
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    CoursePackageData *packagedata = [self.packageArr objectAtIndex:indexPath.row];
    
    ForeignShopDetailViewController *ForeignShopDetailVC = [[ForeignShopDetailViewController alloc] init];
    
    ForeignShopDetailVC.packageId = packagedata.packageId;
    
    [self.navigationController pushViewController:ForeignShopDetailVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
