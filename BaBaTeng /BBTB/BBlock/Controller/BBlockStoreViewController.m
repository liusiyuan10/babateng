//
//  BBlockStoreViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BBlockStoreViewController.h"

#import "BBlockRequestTool.h"
#import "BStoreModel.h"
#import "BStoreDataModel.h"
#import "BStoreListDataModel.h"

#import "UIImageView+AFNetworking.h"

#import "BBTQAlertView.h"

#import "BBlockCommon.h"


@interface BBlockStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BBTQAlertView *_QalertView;
}

@property (nonatomic, strong) NSMutableArray *headViewArray;
@property (nonatomic, assign) NSInteger PageNum;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *ProgrammArray;

@property (nonatomic, strong)    NSString *pageStr;


@end

@implementation BBlockStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BBT_BACKGROUN_COLOR;
    
   
    self.ProgrammArray = [[NSMutableArray alloc] init];
    
    self.PageNum = 1;
   
    [self LoadChlidView];
    
    [self GetProgramming];
    
//    self.title =
    
    
}

- (void)GetProgramming
{

    
    NSDictionary *parameter = @{@"pageNum" :@1,@"pageSize" :@20};
    
    [self startLoading];
    
    [BBlockRequestTool GetProgrammingParameter:parameter success:^(BStoreModel *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ProgrammArray = response.data.list;
            self.pageStr = response.data.pages;
//
            if (self.ProgrammArray.count>0) {
                
                [self loadModel];
                
                [self.tableView reloadData];
            }
    
        }
        else{

            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];

    }];
    
//    [QHomeRequestTool GetFavoriteParameter:parameter success:^(QFavorite *response) {
}

- (void)LoadChlidView
{


    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight - kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //[self.setTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:self.tableView];
    
//     [self GetProgramming];
    
    [self pullRefresh];
    
    
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
    
    
    NSString *PageStr = [NSString stringWithFormat:@"%ld",(long)self.PageNum];
    
    NSDictionary *parameter = @{@"pageNum" : PageStr,@"pageSize" :@20};
    
    [self startLoading];
    
    [BBlockRequestTool GetProgrammingParameter:parameter success:^(BStoreModel *response) {
        [self stopLoading];
        [self.tableView.mj_footer endRefreshing];
        if ([response.statusCode isEqualToString:@"0"]) {
            
//            self.ProgrammArray = response.data.list;
            
            NSMutableArray *ProgrammReArray = (NSMutableArray*)response.data.list;


            if (ProgrammReArray.count>0) {

                [self.ProgrammArray addObjectsFromArray:ProgrammReArray];


                [self loadModel];

                [self.tableView reloadData];
            }
           

            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self stopLoading];
        
    }];
    
//    [QMineRequestTool getpagetrackListsId:self.trackListId PageNum:PageStr PageSize:@"10" Parameter:parameter success:^(QAlbum *respone) {
//        [self stopLoading];
//        [self.tableView.mj_footer endRefreshing];
//        if ([respone.statusCode isEqualToString:@"0"]) {
//            
//            NSMutableArray *AlbumReArray = (NSMutableArray*)respone.data.list;
//            
//            
//            if (AlbumReArray.count>0) {
//                
//                for (int i = 0; i<AlbumReArray.count; i++)
//                {
//                    QAlbumDataTrackList *listRespone = AlbumReArray[i];
//                    listRespone.IsDeviceplay = YES;
//                }
//                
//                
//                [self.AlbumArray addObjectsFromArray:AlbumReArray];
//                
//                
//                [self loadModel];
//                
//                [self KeepDemandNor];
//                
//                [self.tableView reloadData];
//                
//                [self GetPlayingTrackId];
//                
//                
//                
//            }else{
//                
//                //[self showToastWithString:@"暂无内容"];
//            }
//            
//        }
//        //        else if([respone.statusCode isEqualToString:@"3705"])
//        //        {
//        //
//        //            [[HomeViewController getInstance] KickedOutDeviceStaues];
//        //
//        //
//        //        }
//        else{
//            [self.tableView.mj_footer endRefreshing];
//            [self stopLoading];
//            [self showToastWithString:respone.message];
//        }
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
//        
//    }];
    
}


- (void)loadModel{
    _currentRow = -1;
    self.headViewArray = [[NSMutableArray alloc] init];
    
    for(int i = 0;i< self.ProgrammArray.count ;i++)
    {
        
        BStoreListDataModel *listdata = [self.ProgrammArray objectAtIndex:i];
        
        BStoreHeadView *qheadview = [[BStoreHeadView alloc] init];
        qheadview.delegate = self;
        qheadview.section = i;

        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listdata.userIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

        [qheadview.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
     
       qheadview.nameLabel.text = listdata.shareName;
       qheadview.authorLabel.text = [NSString stringWithFormat:@"作者:%@",listdata.userName];
       qheadview.timeLabel.text = listdata.shareTime;
        
        if ([listdata.downLoad isEqualToString:@"1"]) {

            [qheadview.addBtn setEnabled:NO];
        }
        else
        {
            [qheadview.addBtn setEnabled:YES];
        }
        

        [self.headViewArray addObject:qheadview];
        
//        QAlbumDataTrackList *listRespone = self.AlbumArray[i];
    
        
//        QHeadView *qheadview = [[QHeadView alloc] init];
//        qheadview.delegate = self;
//        qheadview.section = i;
//
//        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//
//        [qheadview.leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
//
//        NSLog(@"listRespone.isAddToSongList === %@",listRespone.isAddToSongList);
//
//        if ([listRespone.isAddToSongList isEqualToString:@"1"]) {
//
//            [qheadview.addBtn setEnabled:NO];
//        }
//        else
//        {
//            [qheadview.addBtn setEnabled:YES];
//        }
//
//        //        icon_tjdemand_sel
//        qheadview.nameLabel.text = listRespone.trackName;
//        qheadview.timeLabel.text = [self getMMSSFromSS:listRespone.duration];
//
//        [self.headViewArray addObject:qheadview];
    }
    
}


#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   BStoreHeadView  *headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?65:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 71;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BStoreHeadView* headView = [self.headViewArray objectAtIndex:section];
    
    
    return headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BStoreHeadView *headView = [self.headViewArray objectAtIndex:section];
    return headView.open?1:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    

    return [self.headViewArray count];
    //    return 1;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"albumlistcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
//    QAlbumDataTrackList *listRespone = [self.AlbumArray objectAtIndex:indexPath.section];
    
    BStoreListDataModel *listdata = [self.ProgrammArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"简介:%@", listdata.remark];
    
    return cell;
}


-(void)selectedWith:(BStoreHeadView *)view{
    _currentRow = -1;
 
    if (view.open) {
        for(int i = 0;i<[self.headViewArray count];i++)
        {
            BStoreHeadView *head = [self.headViewArray objectAtIndex:i];
            head.open = NO;
            //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
    
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        BStoreHeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
     

            
        }else {
           
            
            head.open = NO;
        }
        
    }
    
    [self.tableView reloadData];
    
    //    NSLog(@"dianji%ld",(long)self.musicIndex);
}

#pragma mark-----BStoreHeadViewDelegate

- (void)BStoreHeadViewAddBtnClicked:(BStoreHeadView *)view
{
//    view.section
    
    NSLog(@"view.section112222=============%ld",(long)view.section);
    
    BStoreListDataModel *listdata = [self.ProgrammArray objectAtIndex:view.section];
    
    //    [parameter objectForKey:@"stCourseId"]
    
    NSDictionary *parameter = @{@"shareId" : listdata.shareId};
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要下载该程序吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block BBlockStoreViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
            NSLog(@"sf");
//
            [self_c startLoading];
            
            
            [BBlockRequestTool PutProgrammingDownloadParameter:parameter success:^(BBlockCommon *respone) {
                
                [self_c stopLoading];
                
                if ([respone.statusCode isEqualToString:@"0"]) {
                    
                    
                    
                    [self_c showToastWithString:@"添加成功"];
                    
                    //  [self GetRTrackLists];
                    
                    //以前添加成功重新拿数据进行刷新添加状态  现在通过不请求数据来刷新添加状态
                    
                    listdata.downLoad=@"1";
                    
                    [self_c loadModel];
   
                    [self_c.tableView reloadData];
                    
                }else{
                    
                    
                    [self_c showToastWithString:respone.message];
                    
                    
                }

                
            } failure:^(NSError *error) {
                
                [self_c showToastWithString:@"网络连接失败，请检查您的网络设置"];
                [self_c stopLoading];
                
            }];
            

            
            
        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");
            
        }
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
