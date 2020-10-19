//
//  GYZSheetView.m
//  GYZCustomActionSheet
//
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZSheetView.h"
#import "GYZSheetCell.h"
#import "GYZCommon.h"
#import "Header.h"
#import "QHomeRequestTool.h"
#import "TMCache.h"
#import "QPlayingTrack.h"
#import "QplayType.h"
#import "BBTCustomViewRequestTool.h"
#import "QCustom.h"
#import "QCustomData.h"
#import "QPlayingTrackList.h"
#define GYZSHEETCELL @"GYZSheetCell"

@interface GYZSheetView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSString   *strTrackid;
@property (nonatomic, strong) QplayType  *qPlayType;
@property (nonatomic, strong) QCustomData *qCustomData;

@end

@implementation GYZSheetView

// 代码创建输入框视图
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        self.selfPlaying = NO;
        
        self.divLine = [[UIView alloc]init];
        self.divLine.backgroundColor = kGrayLineColor;
        [self addSubview:self.divLine];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:[GYZSheetCell class] forCellReuseIdentifier:GYZSHEETCELL];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GYZSheetPlay:) name:@"GYZSheetPlay" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GYZSheet:) name:@"GYZSheet" object:nil];
        
        [self GetPlayingTrackId];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoRefreshing) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)autoRefreshing
{
    self.strTrackid = nil;
    //    self.strTrackid1 = nil;
    
    for (int i = 0; i < self.dataSource.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.dataSource objectAtIndex:i];
        
        
        
        listrespone.IsDeviceplay = NO;
        
        listrespone.isPlaying = NO;
        
        
    }
     [self.tableView reloadData];
     NSLog(@" [self.tableView reloadData]==============3");
    // [self GetPlayingTrackId];//获取当前播放歌曲
    
    [self performSelector:@selector(GetPlayingTrackId) withObject:nil afterDelay:1.0];
    
    
    
}

- (void)GetPlayingTrackId
{
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    
    [QHomeRequestTool GetplayingTrackId:parameter success:^(QPlayingTrack *respone) {
        
        
        
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            QPlayingTrackData *trackdata = respone.data;
            if (trackdata.tracks.count > 0) {
             QPlayingTrackList *listdata = trackdata.tracks[0];
             self.strTrackid =  [listdata.trackId stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
            }
           
          
    
         
            [[TMCache sharedCache]setObject:trackdata.mode forKey:@"PlayMode"];
            
            [self getCurrentPlayingTracksId:@"0"];//获取播放播放列表
        }
        else
        {
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

-(void)getCurrentPlayingTracksId:(NSString*)orderBy{

    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"],@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"],@"orderBy" :orderBy};
    
    [BBTCustomViewRequestTool getCurrentPlayingTracksParameter:parameter success:^(QCustom *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            if (_dataSource.count>0) {
                _dataSource = [[NSMutableArray alloc]init];
            }
            
           _dataSource = respone.data.tracks;
            
             self.qPlayType = respone.data.playType;
             self.qCustomData= respone.data;
          //  [self GetPlayingTrackId];

            
            if (_dataSource.count>0) {
                
                for (int i=0; i<_dataSource.count; i++) {
                    
                    
                    QAlbumDataTrackList *respone = _dataSource[i];
                    NSLog(@"self.strTrackid======%@",self.strTrackid);
                    if ([respone.trackId isEqualToString:self.strTrackid]) {
                        
                        if (self.selfPlaying==YES) {
                            NSLog(@"fdsafdsa00000000");
                            respone.IsDeviceplay = YES;
                            respone.isPlaying = YES;
                            
                        }else{
                             NSLog(@"fdsafdsa11111111");
                            respone.IsDeviceplay = YES;
                            respone.isPlaying = NO;
                        
                        }
                        
                       
                    }else{
                         NSLog(@"fdsafdsa222222");
                        respone.IsDeviceplay = NO;
                        respone.isPlaying = NO;
                    
                    }
                }
            }
            
        }
        
        [self.tableView reloadData];
        NSLog(@" [self.tableView reloadData]==============2");
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)GYZSheetPlay:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"playStatus"]];
    

    for (int i = 0; i < self.dataSource.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.dataSource objectAtIndex:i];
        
        
        if ([listrespone.trackId isEqualToString:self.strTrackid]) {
            
            listrespone.IsDeviceplay = YES;
            
            if ([strtest1 isEqualToString:@"playing"]) {
                
                listrespone.isPlaying = YES;
                
                
            }else
            {
                listrespone.isPlaying = NO;
            }
            
            
        }else{
        
           listrespone.IsDeviceplay = NO;
        }
        
    }
    
    
    
     [self.tableView reloadData];
    
    NSLog(@" [self.tableView reloadData]==============0");
}



- (void)GYZSheet:(NSNotification *)noti
{
    
    NSString *strtest = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"trackId"]];
    
    NSString *strtest1 = [strtest stringByReplacingOccurrencesOfString:@"-" withString:@""];
    

    
    NSLog(@"8888888=============================================================================%@",strtest1);
    

    
    self.strTrackid = strtest1;

    
    NSString * exist =  @"NO";
    
    for (int i = 0; i < self.dataSource.count; i++) {
        
        QAlbumDataTrackList *listrespone = [self.dataSource objectAtIndex:i];
        
        NSLog(@"respone-trackId11111===%@",listrespone.trackId);
        
        if ([listrespone.trackId isEqualToString:strtest1]) {
            
            listrespone.isPlaying = NO;
            listrespone.IsDeviceplay = YES;
            exist = @"YES";
            
            
        }else
        {
            listrespone.IsDeviceplay = NO;
            listrespone.isPlaying = NO;
            
    
        }
        
    }
    
    
    
    
    if ([exist isEqualToString:@"YES"]) {
        
        
        [self.tableView reloadData];
         NSLog(@" [self.tableView reloadData]==============1");
        
    }else{
        
        [self GetPlayingTrackId];//获取当前播放歌曲
        //[self getCurrentPlayingTracksId:@"0"];
        NSLog(@"再次获取当前播放歌曲");
        
    }

    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
 
    
    self.divLine.frame = CGRectMake(0, 0, self.frame.size.width, kLineHeight);
    self.tableView.frame = CGRectMake(0, MaxY(self.divLine), WIDTH(self), HEIGHT(self));
    
    if (_dataSource.count>0) {
        
        for (int i=0; i<_dataSource.count; i++) {
            
            
            QAlbumDataTrackList *respone = _dataSource[i];
            
            if (respone.isPlaying == YES) {
                
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                
                
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
                break;
            }
        }
    }
    
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYZSheetCell *cell= [tableView dequeueReusableCellWithIdentifier:GYZSHEETCELL forIndexPath:indexPath];
    
    
    
    if (_cellTextColor) {
        cell.myLabel.textColor = _cellTextColor;
    }
    
    self.resultRespone = _dataSource[indexPath.row];
    
    if (!IsStrEmpty(self.resultRespone.trackName)) {
        
        cell.myLabel.text =self.resultRespone.trackName;
        
    }else{
        
        cell.myLabel.text =@"无数据";
    }
    
    
    if (_cellTextFont) {
        cell.myLabel.font = _cellTextFont;
    }
    
    cell.myLabel.textAlignment = NSTextAlignmentLeft;
    
    
    if (_showTableDivLine) {
        cell.tableDivLine.hidden = NO;
    }
    
    
    NSLog(@"=========================================%@=====================================%d",self.resultRespone.trackName,self.resultRespone.isPlaying);
    
    
    if (self.resultRespone.isPlaying) {
        
        self.strTrackid =   self.resultRespone.trackId;
        
        self.selfPlaying = YES;
    }
    
    if( self.resultRespone.isPlaying==YES){
        cell.myLabel.textColor =NavBackgroundColor;
        cell.myImageView.hidden = NO;
        cell.myLabel.frame = CGRectMake(35, 0, kScreenWidth-20-40, 44.5);
        cell.myImageView.frame = CGRectMake(10, 13,19, 14);
        [self startAnimation:cell.myImageView];
        
    }else{
        
        if (self.resultRespone.IsDeviceplay==YES) {
            
            cell.myLabel.textColor = NavBackgroundColor;
            
        }else{
            
            cell.myLabel.textColor = [UIColor blackColor];
        }
        
        [cell.myImageView stopAnimating];
        cell.myLabel.frame = CGRectMake(15, 0, kScreenWidth-20-25, 44.5);
        cell.myImageView.hidden = YES;
    }
    
    return cell;
}
-(void)startAnimation:(UIImageView*)cellImageView{
    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"nlk_1"],[UIImage imageNamed:@"nlk_2"],[UIImage imageNamed:@"nlk_3"],[UIImage imageNamed:@"nlk_4"],[UIImage imageNamed:@"nlk_5"], nil];
    
    //imageView的动画图片是数组images
    cellImageView .animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    cellImageView.animationDuration = 3;
    //动画的重复次数，想让它无限循环就赋成0
    cellImageView .animationRepeatCount = 0;
    //开始动画
    [cellImageView startAnimating];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    //GYZSheetCell *cell = (GYZSheetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellTitle = cell.myLabel.text;
    
    //self.productRespone =_dataSource[indexPath.row];
    
    for (int i=0; i<_dataSource.count; i++) {
        
          QAlbumDataTrackList *listrespone = _dataSource[i];
        
       listrespone.isPlaying =NO;
        
        listrespone.IsDeviceplay=NO;
    }
    
     QAlbumDataTrackList *listrespone1 = _dataSource[indexPath.row];
    listrespone1.IsDeviceplay =YES;
   // listrespone1.isPlaying =NO;
    
    self.strTrackid = listrespone1.trackId ;
    
    [self.tableView  reloadData];
    
    
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:selectPlayType:selectQCustomData:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle: _dataSource[indexPath.row] selectPlayType:self.qPlayType selectQCustomData:self.qCustomData];
    }
}
@end
