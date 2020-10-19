//
//  QCategoryScrollListViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BCategoryScrollListViewController.h"
#import "QMineRequestTool.h"

#import "QAlbumResponse.h"
#import "QAlbumListResponse.h"
#import "QAlbumListCell.h"
#import <AVFoundation/AVFoundation.h>
#import "QCategoryView.h"
#import "QDemandResultRespone.h"

#import "QCategoryRequestTool.h"

#import "QSourceTag.h"
#import "QSourceTagData.h"
//#import "QSourceTagList.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "QPlayListView.h"

#import "QHomeRequestTool.h"
#import "QSongDataList.h"
#import "QAddSong.h"

#import "HomeViewController.h"

#import "QPlayingTrack.h"
#import "QPlayingTrackData.h"
#import "QSongDetails.h"
#import "QPlayingTrackList.h"
#import "NewHomeViewController.h"

#import "QAlbumDataTrackList.h"

#import "BAlbumCell.h"
#import "BPlayTestViewController.h"



@interface BCategoryScrollListViewController ()<UITableViewDataSource,UITableViewDelegate,QAlbumListCellDelegate,QPlayListViewDelegate>

@property(assign, nonatomic)NSInteger viewIndex;//当前播放音乐索引

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   QSourceTagData *qSourceTagData;

@property (nonatomic, strong) NSString *pageStr;

@end

@implementation BCategoryScrollListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
    
    self.Qcateoryarr = [[NSMutableArray alloc] init];
    self.playSaveArray = [[NSMutableArray alloc] init];
    self.pageNum = 1;

    NSLog(@"self.categoryid===%@",self.categoryid);
    
    [self getSourceTag];
    
    [self LoadChlidView];
    

    
    
    
}


- (void)getSourceTag
{
    //    NSString *name = [[TMCache sharedCache] objectForKey:@"QdeviceTypeId"];
    NSDictionary *parameter = @{@"pageNum" :@1,@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    NSLog(@"sdfsdfsdSocllListView%@",[[TMCache sharedCache] objectForKey:@"deviceId"]);
    
    [self startLoading];
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            self.Qcateoryarr = response.data.list;
            
            self.playSaveArray =response.data.list;
            
            self.pageStr = response.data.pages;

            
            if (self.Qcateoryarr.count>0) {
                
                for (int i = 0; i<self.Qcateoryarr.count; i++)
                {
                    QAlbumDataTrackList *listRespone = self.Qcateoryarr[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self.tableView reloadData];
                
      
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }
        else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }
        else{
            
            
            [self showToastWithString:response.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
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

- (void)dealloc
{
    
    NSLog(@"释放内存");
//    if(self.tableView )
//    { [self.tableView removeFromSuperview]; self.tableView = nil;
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存警告");
    // Dispose of any resources that can be recreated.
}





- (void)LoadChlidView
{
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - 33 - kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
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
    
    self.pageNum =1;
    [self pullRefresh];
    
    [self.view addSubview:self.tableView];
    
    
    
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
    
    NSLog(@"[self.qSourceTagData.pages intValue]======%d",[self.qSourceTagData.pages intValue]);
    
    if (self.pageNum >  [self.pageStr integerValue]) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [self showToastWithString:@"没有更多数据了"];
        return;
    }
    
    NSDictionary *parameter = @{@"pageNum" :[NSString stringWithFormat:@"%ld", (long)self.pageNum],@"pageSize" :@20,@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [QCategoryRequestTool getDeviceSourceTagsName:self.categoryid Parameter:parameter success:^(QSourceTag *response) {
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            

            
            
            NSMutableArray *QcateoryReArray = (NSMutableArray*)response.data.list;
            
//            [self.Qcateoryarr addObjectsFromArray:response.data.list];
            
            if (QcateoryReArray.count>0) {
                
                for (int i = 0; i< QcateoryReArray.count; i++)
                {
                    QAlbumDataTrackList *listRespone = QcateoryReArray[i];
                    listRespone.IsDeviceplay = YES;
                }
                
                [self.Qcateoryarr addObjectsFromArray:QcateoryReArray];
                
                [self.tableView reloadData];
   
                
            }else{
                
                [self showToastWithString:@"暂无内容"];
            }
            
        }else if([response.statusCode isEqualToString:@"3705"])
        {
            
            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
            
            
        }else{
            
            
            [self showToastWithString:response.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
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
    
    return self.Qcateoryarr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //    self.totalNum = [self.headViewArray count];
    //    return [self.headViewArray count];
    return 1;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   static NSString *CellIdentifier = @"balbumlistcell";
    
    BAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[BAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    
    
    QAlbumDataTrackList *listRespone = self.Qcateoryarr[indexPath.row];
    
    if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
        
        [cell.rightMiddleImage setEnabled:NO];
    }
    else
    {
        [cell.rightMiddleImage  setEnabled:YES];
    }
    
    cell.nameLabel.text = listRespone.trackName;
    cell.timeLabel.text = [self getMMSSFromSS:listRespone.duration];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
    NSString *encodedStr = [NSString stringWithFormat:@"%@?imageView2/0/w/320",encodedString];
//
//    NSLog(@"encodedStr=====%@",encodedStr);

//        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed|SDWebImageLowPriority];
//    [cell.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedStr]];

//    [cell.leftImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString]];
    
    
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
    
    [cell.rightMiddleImage addTarget:self action:@selector(rightMiddleImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}


- (void)leftImageClicked:(UIButton *)btn
{
 

    
    appDelegate.playSaveDataArray = self.Qcateoryarr;
    
    QAlbumDataTrackList *listRespone = self.Qcateoryarr[btn.tag];
    
    
    [[TMCache sharedCache]setObject:listRespone .trackIcon forKey:@"currentTrackIcon"];
    
    NSDictionary *jsonDict = @{@"playStatus" : @"playing"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnimationPlay" object:self userInfo:jsonDict];
    
    [[BPlayTestViewController sharedInstance] testPlay:btn.tag];
    

    
    
}




- (void)collectBtnClick:(UIButton *)btn
{
    NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
    if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
        [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
        return;
    }
    
    btn.selected = !btn.selected;
    
    QAlbumDataTrackList *listRespone = [self.Qcateoryarr objectAtIndex:btn.tag];
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"trackId" : listRespone.trackId, @"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    if (btn.selected) {
        
        [self startLoading];
        [QHomeRequestTool AddSingleFavoriteParameter:parameter success:^(QAddSong *response) {
            
            [self stopLoading];
            
            if ([response.statusCode isEqualToString:@"0"]) {
                
//
                [self showToastWithString:@"收藏成功"];
                //[btn setImage:[UIImage imageNamed:@"icon_shouchang02_sel"] forState:UIControlStateNormal];
            
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

            //以前收藏成功重新拿数据进行刷新收藏状态  现在通过不请求数据来刷新收藏状态
                listRespone.isCollected=@"0";
                [self.tableView reloadData];
       
            }
//            else if([response.statusCode isEqualToString:@"6501"])
//            {
//
//                listRespone.isCollected = @"0";
//
//                [self loadModel];
//
//                [self KeepDemandNor];
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

- (void)rightMiddleImageClick:(UIButton *)btn
{
        NSString *deviceIdstr = [[TMCache sharedCache] objectForKey:@"deviceId"];
        if ([deviceIdstr isEqualToString:@"0"]|| deviceIdstr.length == 0) {
            [self showToastWithString:@"您还没有绑定设备，请先绑定设备"];
            return;
        }
    
        [[AppDelegate appDelegate]suspendButtonHidden:YES];

        QPlayListView *tfSheetView = [[QPlayListView alloc]init];
        tfSheetView.delegate = self;
        [tfSheetView showInView:self.view];
    
        self.viewIndex = btn.tag;
}

#pragma mark -- QPlayListViewDelegate
-(void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model
{
    [self addPlayListsectionIndex:self.viewIndex selectModel:model];
    
    
    
}

- (void)addPlayListsectionIndex:(NSInteger)sectionIndex selectModel:(QSongDataList *)model
{
    
    QAlbumDataTrackList *listRespone = self.Qcateoryarr[sectionIndex];
    
    NSDictionary *parameter = @{@"songListId" : model.deviceSongListId , @"trackId" : listRespone.trackId};
    
    [self startLoading];
    
    [QHomeRequestTool AddSingledeviceSongListParameter:parameter success:^(QAddSong *response) {
        
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            

//            
//            [self getSourceTag];
//
            [self showToastWithString:@"添加成功"];
            
    
            //以前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
            
            listRespone.isAddToSongList=@"1";
            

            
            
            [self.tableView reloadData];
            
            
        }
//        else if([response.statusCode isEqualToString:@"3705"])
//        {
//            
//            [[NewHomeViewController getInstance] KickedOutDeviceStaues];
//            
//            
//        }
        else{
            
            
            [self showToastWithString:response.message];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        [self stopLoading];
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];

    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    NSLog(@"即将消失");
//    
//        if(self.tableView )
//        { [self.tableView removeFromSuperview];
//            
//            self.tableView = nil;
//    
//        }
//   
 
    

}




@end
