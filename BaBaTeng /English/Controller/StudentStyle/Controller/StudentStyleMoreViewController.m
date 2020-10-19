//
//  StudentStyleMoreViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/9.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "StudentStyleMoreViewController.h"
#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "StudentStyleMoreQuiltViewCell.h"


#import "UIImageView+AFNetworking.h"
#import "StudentStyleViewController.h"

#import "EnglishRequestTool.h"

#import "studentVideo.h"
#import "studentVideoData.h"
#import "studentVideoList.h"

#import "YGPlayInfo.h"
#import "HJVideoPlayerController.h"

@interface StudentStyleMoreViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>

@property (nonatomic, strong)     TMQuiltView *collectionView;
@property(strong,nonatomic)       NSMutableArray *StudentStyleMorearr; //推荐列表

@property (nonatomic, assign)       NSInteger PageNum;
@property (nonatomic, strong)       NSString *pageStr;

@property (nonatomic, strong) NSMutableArray *playInfos;

@end

@implementation StudentStyleMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学员风采";
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    self.PageNum = 1;
    
    self.StudentStyleMorearr = [[NSMutableArray alloc] init];
    
    self.playInfos = [[NSMutableArray alloc] init];
    
    
    [self LoadChlidView];
    
    [self.collectionView reloadData];
    
    [self GetStudentVideo];
    
}

#pragma mark UITableView + 上拉刷新 默认
- (void)pullRefresh
{
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}




- (void)LoadChlidView
{
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //    self.collectionView.bounces = NO;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    
    [self pullRefresh];
    
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
}

- (void)GetStudentVideo
{
    [self startLoading];
    
    [EnglishRequestTool getStudentVideopageNum:@"1" success:^(studentVideo *respone) {
        
        [self stopLoading];
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.StudentStyleMorearr = respone.data.list;
            
//            NSLog(@"-------%lu",(unsigned long)self.StudentStyleMorearr.count);
 
                for (int i = 0; i < self.StudentStyleMorearr.count; i++) {
                    
                    studentVideoList *trackList = [self.StudentStyleMorearr objectAtIndex:i];
                    
                    NSLog(@"111111studentName-------%@",trackList.studentName);
                    
                    YGPlayInfo *playinfo = [[YGPlayInfo alloc] init];
                    
                    playinfo.url = trackList.videoUrl;
                    playinfo.artist = trackList.studentName;
                    playinfo.title = trackList.studentName;
                    playinfo.placeholder = @"default_bg_land";
                    
                    
                    [self.playInfos addObject:playinfo];
                }

            
            [self.collectionView reloadData];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

- (void)loadMoreData
{
    NSLog(@"更多数据");
    
    self.PageNum++;
    
    if (self.PageNum>[self.pageStr integerValue]) {
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    
    [self startLoading];
    
    [EnglishRequestTool getStudentVideopageNum:PageStr success:^(studentVideo *respone) {
        
        [self stopLoading];
        
            [self.collectionView.mj_footer endRefreshing];
    
            if ([respone.statusCode isEqualToString:@"0"]) {
    
    
                self.pageStr = respone.data.pages;
    
                NSMutableArray *array1 = [[NSMutableArray alloc]init];
                array1 = respone.data.list;
    
            
    
                if (array1 > 0) {
                    
                    NSMutableArray *array2 = [[NSMutableArray alloc]init];
                    
                    for (int i = 0; i < array1.count; i++) {
        
                        studentVideoList *trackList = [array1 objectAtIndex:i];
        
                        NSLog(@"111111studentName-------%@",trackList.studentName);
        
                        YGPlayInfo *playinfo = [[YGPlayInfo alloc] init];
        
                        playinfo.url = trackList.videoUrl;
                        playinfo.artist = trackList.studentName;
                        playinfo.title = trackList.studentName;
                        playinfo.placeholder = @"default_bg_land";
        
        
                        [array2 addObject:playinfo];
                    }
                    
                    
                    [self.StudentStyleMorearr addObjectsFromArray:array1];
                    
                    [self.playInfos addObjectsFromArray:array2];
                    
    
                    [self.collectionView reloadData];
    
                }
    
    
    
            }else{
    
    
                [self showToastWithString:respone.message];
            }
    
    
        
    } failure:^(NSError *error) {
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    

    
}



//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return self.StudentStyleMorearr.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentStyleMoreQuiltViewCell *cell = (StudentStyleMoreQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[StudentStyleMoreQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    //    cell.picHeight=80;
    
//    QMPanelList *listRespone = self.albumListarr[indexPath.row];
    studentVideoList *trackList = [self.StudentStyleMorearr objectAtIndex:indexPath.row];

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)trackList.coverUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_recommend"]];
//    cell.photoView.image = [UIImage imageNamed:@"image_recommend"];

    cell.titleLabel.text = trackList.studentName;
    cell.titlesubLabel.text = trackList.introduction;
    
    
//    cell.titleLabel.text = @"测试";
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 2;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat picHeight = (kDeviceWidth - 16 *3)/2.0;
    
    return picHeight + 80;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    
    NSLog(@"精品推荐");
    
    YGPlayInfo *playInfo = [self.playInfos objectAtIndex:indexPath.row];
    
    
    if (@available(iOS 13.0, *)) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

        [[AppDelegate appDelegate]suspendButtonHidden:YES];
        
        HJVideoPlayerController * videoC = [[HJVideoPlayerController alloc] init];
        [videoC.configModel setOnlyFullScreen:YES];
        [videoC setUrl:playInfo.url ];
        videoC.videoTitle = playInfo.title;
        
        [self.navigationController pushViewController:videoC animated:YES];

       }else {
        StudentStyleViewController *StudentStyleVC = [[StudentStyleViewController alloc] init];
        StudentStyleVC.playInfos = self.playInfos;
        StudentStyleVC.playIndex = indexPath.row;
        
        [self.navigationController pushViewController:StudentStyleVC animated:YES];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent  = NO;
    
}

@end
