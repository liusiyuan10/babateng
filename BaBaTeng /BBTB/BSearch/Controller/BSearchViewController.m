//
//  BSearchViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/26.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BSearchViewController.h"

#import "QMineRequestTool.h"

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"
//#import "QAlbumListCell.h"
#import "QSearchCell.h"
#import <AVFoundation/AVFoundation.h>
#import "QPlayListView.h"

#import "QDemandResultRespone.h"

#import "QAlbumDetailView.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "QAlbum.h"
#import "QAlbumData.h"
#import "QAlbumDataTrack.h"
#import "QAlbumDataTrackList.h"

#import "QHomeRequestTool.h"

#import "QSongDataList.h"

#import "QAddSong.h"



#import "HomeViewController.h"

#import "QSongDevicePlayData.h"
#import "QSongDetailsPlayData.h"

#import "QPlayingTrack.h"
#import "QPlayingTrackData.h"

#import "AFNetworking.h"

#import "QHistory.h"

#import "QCustomViewController.h"

#import "QSearchAlbumViewController.h"

#import "UIButton+WebCache.h"

#import "QPlayingTrackList.h"

#import "NewHomeViewController.h"

#import "BPlayTestViewController.h"

#import "BSearchCell.h"
#import "BSearchAlbumViewController.h"

@interface BSearchViewController ()<UITableViewDelegate,UITableViewDataSource,QSearchCellCellDelegate,UIGestureRecognizerDelegate,QAlbumDetailViewDelegate,QPlayListViewDelegate,UISearchBarDelegate>



@property(assign, nonatomic)NSInteger viewIndex;//当前播放音乐索引


@property (nonatomic, strong) NSMutableArray *AlbumArray;
@property (nonatomic, strong) NSMutableArray *playSaveArray;

@property (nonatomic, assign) NSInteger PageNum;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign)    BOOL IsAllAddSong;

@property (nonatomic, strong) UISwipeGestureRecognizer  *swipeRight;

@property (nonatomic, strong) QHistoryData *QAlbumdata;
@property (nonatomic, strong) QSongDetailsPlayData *qSongDetailsPlayData;



@property(nonatomic , strong)  UISearchBar * searchBar;
@property(nonatomic , strong)  UIView * headView;

@property (nonatomic, strong)   NSString *pageStr;

@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong)   CABasicAnimation* rotationAnimation;

@end

@implementation BSearchViewController

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
//        //                _searchBar.backgroundColor = [UIColor redColor];
//        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
//        //        [_searchBar sizeToFit];
//        [_searchBar setPlaceholder:@"请输入关键字"];
//        _searchBar.text = self.searchstr;
//
//        [_searchBar setDelegate:self];
//        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
//        [_searchBar setTranslucent:YES];//设置是否透明
//        [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
//        //        [_searchBar setShowsCancelButton:YES];
//        //        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
//        //        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//
//
//        _searchBar.tintColor = [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
        
             _searchBar.frame = CGRectMake(12, 21+myheight, kDeviceWidth - 12 - 50, 28);
            _searchBar.barStyle=UIBarStyleDefault;
            _searchBar.searchBarStyle=UISearchBarStyleDefault;

            
            UIImageView *barImageView = [[[_searchBar.subviews firstObject] subviews] firstObject];
            
            barImageView.layer.borderColor = [UIColor orangeColor].CGColor;
            barImageView.layer.borderWidth = 1;



      
            _searchBar.placeholder=@"请输入关键字";
             _searchBar.text = self.searchstr;
            


            

            _searchBar.tintColor= [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
            _searchBar.barTintColor=[UIColor orangeColor];
            

            
             UITextField *searchField=[_searchBar valueForKey:@"searchField"];
             searchField.backgroundColor = [UIColor whiteColor];
      
            [_searchBar setKeyboardType:UIKeyboardTypeDefault];
            

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
    
    //self.title = @"专辑详情";
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    //适配iphone x
    CGFloat myheight;
    if (iPhoneX) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64+myheight)];
    
    navView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:navView];
    
    [navView addSubview:self.headView];
    
//    for (UIView *view in self.searchBar.subviews) {
//        
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }//去掉搜索周围的灰色
    
    
    [navView addSubview:self.searchBar];
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
    
    
    self.AlbumArray = [NSMutableArray array];
    self.playSaveArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnimationPlay:) name:@"AnimationPlay" object:nil];
    

    
    self.PageNum = 1;
    
    [self GetTrackLists];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UITableView + 上拉刷新 默认
- (void)pullRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom =0;
}

- (void)loadMoreData
{
    
    self.PageNum++;
    
    if( self.PageNum > [self.pageStr integerValue])
    {
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"没有更多数据"];
        
        return;
    }
    
    NSString *PageNumStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :PageNumStr,@"pageSize" :@20,@"keyword":self.searchstr};
    
    
    [self startLoading];
    
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        [self stopLoading];
        [self.tableView.mj_footer endRefreshing];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            NSMutableArray *AlbumReArray = (NSMutableArray*)respone.data.list;
            
            if (AlbumReArray.count>0) {
                
                for (int i = 0; i<AlbumReArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = AlbumReArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self.AlbumArray addObjectsFromArray:AlbumReArray];

                
            }else{
                
                [self showToastWithString:@"暂无内容"];
         
            }
            [self.tableView reloadData];
       
            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[HomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];
    }];
    
    
    
}


- (void)cancelBtnClicked
{
    [self.searchBar resignFirstResponder];
    
    //    QHomeViewController *homeVc = [[QHomeViewController alloc] init];
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    [self.navigationController popToViewController:homeVc animated:YES];
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)LoadChlidView
{
    
    //NSLog(@"=============%f",CGRectGetMaxY(self.navigationController.navigationBar.frame));
    
    //适配iphone x
    CGFloat myheight;
    if (iPhoneX) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64+myheight,kDeviceWidth , KDeviceHeight-kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
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
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //适配iphone x
    
    self.button .frame = CGRectMake(kDeviceWidth / 2 - 30, KDeviceHeight- 55-kDevice_Is_iPhoneX , 50, 50);
    self.button .imageView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    if (encodedString.length == 0) {
        
        [self.button setImage:[UIImage imageNamed:@"bar_bfq_nor"] forState:UIControlStateNormal];
    }
    else
    {
        [self.button sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
        
    }
    
//    [self.button sd_setImageWithURL:[NSURL URLWithString:  [[TMCache sharedCache]objectForKey:@"currentTrackIcon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];

    
    self.button.clipsToBounds=YES;
    
    self.button.layer.cornerRadius=25;
    
    [self.button  addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.button .adjustsImageWhenHighlighted = false;
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 ];
    
    self.rotationAnimation.duration = 0.5;
    
    self.rotationAnimation.cumulative = YES;
    
    self.rotationAnimation.repeatCount = ULLONG_MAX;
    
    
    
    if ([[[TMCache sharedCache]objectForKey:@"buttonAnimation"] isEqualToString:@"addAnimation"]){
        
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    [self.view addSubview:self.button];
    
    [self pullRefresh];
    
    
    
}


//本地播放
- (void)buttonClicked
{
    
    if (appDelegate.playSaveDataArray.count == 0) {
        [self showToastWithString:@"您还没有播放歌单"];
        
        return;
    }
    
//    QCustomViewController * qCustom = [[QCustomViewController alloc] init];
    BPlayTestViewController *bplayC = [BPlayTestViewController sharedInstance];
    
    UINavigationController *qCustomrNav = [[UINavigationController alloc]
                                           initWithRootViewController:bplayC];
    
    [qCustomrNav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    qCustomrNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:qCustomrNav animated:YES completion:nil];
    
}


- (void)AnimationPlay:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[[TMCache sharedCache]objectForKey:@"currentTrackIcon"], (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    NSLog(@"encodedString===%@",encodedString);
    
    [self.button sd_setImageWithURL:[NSURL URLWithString: encodedString ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bar_bfq_nor"]];
    
    if ([strtest1 isEqualToString:@"playing"]){
        
        [[TMCache sharedCache]setObject:@"addAnimation" forKey:@"buttonAnimation"];
        [self.button.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        
    }else{
        [[TMCache sharedCache]setObject:@"removeAnimation" forKey:@"buttonAnimation"];
        [self.button .layer removeAnimationForKey:@"rotationAnimation"];
    }
    
    
    
}

- (void)GetTrackLists
{
    
    //     NSString *deviceId = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"] ,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"pageNum" :@1,@"pageSize" :@20,@"keyword":self.searchstr};
    
    
    [self startLoading];
    
    [QMineRequestTool GetSearchListParameter:parameter success:^(QHistory *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.QAlbumdata = respone.data;
            self.pageStr = respone.data.pages;
            
            [self LoadChlidView];
            
            if (self.AlbumArray.count>0) {
                
                self.AlbumArray  = [[NSMutableArray alloc]init];
            }
            
            self.AlbumArray = (NSMutableArray*)self.QAlbumdata.list;
            
            if (self.AlbumArray.count>0) {
                
                for (int i = 0; i<self.AlbumArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.AlbumArray[i];
                    listRespone.IsDeviceplay = YES;
                }
       
                
                
            }else{
                
                NSLog(@"self.AlbumArray==%lu",(unsigned long)self.AlbumArray.count);
                
                [self showToastWithString:@"暂无内容"];
            
            }
            [self.tableView reloadData];

            
        }else if([respone.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];
    }];
    
    
    
}



-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    
    NSString * urlStr = searchBar.text;
    
    //过滤字符串前后的空格
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    self.searchstr = urlStr;
    
    [self GetTrackLists];
    
    // [self.AlbumArray removeAllObjects];
    
    //    [self GetSearchBrowse:searchBar.text Page:@"1" Count:@"20"];
    
    NSLog(@"sdfdgdsb");
}


#pragma mark - TableViewdelegate&&TableViewdataSource


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 65;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    QHeadView *headView = [self.headViewArray objectAtIndex:section];
    //    return headView.open?1:0;
    
    return self.AlbumArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //    self.totalNum = [self.headViewArray count];
    //    return [self.headViewArray count];
    return 1;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"BSearchCellcell";
    
    BSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[BSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[indexPath.row];
    
    if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
        
        [cell.rightDownImage setEnabled:NO];
    }
    else
    {
        [cell.rightDownImage  setEnabled:YES];
    }
    
    cell.nameLabel.text = listRespone.trackName;
    cell.timeLabel.text = [self getMMSSFromSS:listRespone.duration];
    [cell.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:listRespone.trackIcon]];
    
    
    cell.leftImage.tag = indexPath.row;
    
    [cell.leftImage addTarget:self action:@selector(leftImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([listRespone.isCollected isEqualToString:@"1"]) {
        
        cell.rightUpImage.selected = YES;
        
    }
    else
    {
        cell.rightUpImage.selected = NO;
        
    }
    
    cell.rightUpImage.tag = indexPath.row;
    cell.rightMiddleImage.tag = indexPath.row;
    
    [cell.rightUpImage addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.rightDownImage addTarget:self action:@selector(rightDownImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.rightMiddleImage.tag = indexPath.row;
    [cell.rightMiddleImage addTarget:self action:@selector(rightMiddleImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)leftImageClicked:(UIButton *)btn
{
    //编辑情况下不能进行点播操作
    
    appDelegate.playSaveDataArray = self.AlbumArray;
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[btn.tag];
    
    
    [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
    
    NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
    
    [[BPlayTestViewController sharedInstance] testPlay:btn.tag];

    
    
}


- (void)rightMiddleImageClick:(UIButton *)btn {
    
    
    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:btn.tag];
    
    BSearchAlbumViewController *AlbumVc = [[BSearchAlbumViewController alloc] init];
    AlbumVc.trackListId =listRespone.trackListId;
    [self.navigationController pushViewController:AlbumVc animated:YES];
    
}

- (void)rightDownImageClick:(UIButton *)btn
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    tfSheetView.albumPlaystr = @"albumPlaystr";
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = YES;
    
    self.viewIndex =btn.tag;
    
    
}


- (void)collectBtnClick:(UIButton *)btn
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    
    
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    btn.selected = !btn.selected;
    
    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:btn.tag];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : listRespone.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    if (btn.selected) {
        
        [self startLoading];
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"收藏成功"];
                //[self GetRTrackLists];
                //以前收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
                
                listRespone.isCollected=@"1";
                
                [self.tableView reloadData];
                

                
            }
//            else if([response.statusCode isEqualToString:@"6500"])
//            {
//                
//                listRespone.isCollected = @"1";
//                
//                
//                [self showToastWithString:response.message];
//                
//            }else if([response.statusCode isEqualToString:@"3705"])
//            {
//                
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//                
//                
//            }
            else{
                
                
                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
        }];
        
        
    }
    else
    {
        [self startLoading];
        [QHomeRequestTool CancelFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            if ([response.statusCode isEqualToString:@"0"]) {
                
                [self showToastWithString:@"取消收藏成功"];
                //               [self GetRTrackLists];
    
                //以前收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
                listRespone.isCollected=@"0";
                [self.tableView reloadData];
                
            }
//            else if([response.statusCode isEqualToString:@"6501"])
//            {
//                
//                listRespone.isCollected = @"0";
//                
//                
//                [self showToastWithString:response.message];
//                
//            }else if([response.statusCode isEqualToString:@"3705"])
//            {
//                
//                [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//                
//                
//            }
            else{
                
                
                [self showToastWithString:response.message];
                
                
            }
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            
        }];
        
    }
}












- (void)backForePage
{
    [self.navigationController popViewControllerAnimated:YES];

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

#pragma mark -- QAlbumDetailViewDelegate
- (void)QDeviceVolumeViewAddBtnClicked:(QAlbumDetailView *)view
{
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    QPlayListView *tfSheetView = [[QPlayListView alloc]init];
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    
    self.IsAllAddSong = YES;
    
    
}

- (void)QDeviceVolumeViewAddFavoriteBtnClicked:(QAlbumDetailView *)view
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能收藏"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[0];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackListId" : listRespone.trackListId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    
    [QHomeRequestTool AddAllFavoriteParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            
            [self showToastWithString:@"全部收藏成功"];
            
            // [self GetRTrackLists];
            //以前全部收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
            for (int i=0;i<self.AlbumArray.count; i++) {
                
                QAlbumDataTrackList *listRespone =self.AlbumArray[i];
                
                listRespone.isCollected=@"1";
            }
            

            
            [self.tableView reloadData];
            
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark -- QPlayListViewDelegate
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model
{
    
    
    if (self.IsAllAddSong) {
        
        [self addAllPlayListsectionIndex:0 selectModel:model];
        
    }
    else
    {
        [self addPlayListsectionIndex:self.viewIndex selectModel:model];
    }
    
    
    
}


- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能添加"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[sectionIndex];
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : listRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"添加成功"];
            
            //  [self GetRTrackLists];
            
            //以前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
            
            listRespone.isAddToSongList=@"1";

            
            [self.tableView reloadData];
            
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        [self stopLoading];
        
    }];
    
}

- (void)addAllPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    if (self.AlbumArray.count == 0) {
        
        [self showToastWithString:@"没有数据不能添加"];
        
        return;
    }
    
    QAlbumDataTrackList *listRespone = self.AlbumArray[sectionIndex];
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackListId" : listRespone.trackListId};
    
    [self startLoading];
    
    [QHomeRequestTool AddAlldeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            
            [self showToastWithString:@"全部添加成功"];
            
            // [self GetRTrackLists];
            
            //前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
            
            for (int i=0;i<self.AlbumArray.count; i++) {
                
                QAlbumDataTrackList *listRespone =self.AlbumArray[i];
                
                listRespone.isAddToSongList=@"1";
            }
            
            
            
            
            [self.tableView reloadData];
            
            
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
    }];
    
    
}

@end
