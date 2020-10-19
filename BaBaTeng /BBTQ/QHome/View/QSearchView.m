//
//  QSearchView.m
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//
//  Q3PlayListView.m
//  XZ_WeChat
//
//  Created by liu on 17/3/23.
//  Copyright © 2017年 gxz. All rights reserved.
//

//#import "Q3PlayListView.h"
//
//@implementation Q3PlayListView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end


#import "QSearchView.h"
#import "Header.h"
#import "QMineRequestTool.h"

#import "QTrackList.h"
#import "QTrackListResponse.h"

#import "AppDelegate.h"


@interface QSearchView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_contentView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property(strong,nonatomic)  NSMutableArray *trackArticles; //推荐列表

@end

@implementation QSearchView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.17];
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    

    //
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KDeviceHeight / 2.0 - 43, kDeviceWidth, 43)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [headView addSubview:cancelBtn];
    
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight / 2.0 - 50)style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.titleArray  = [NSMutableArray arrayWithObjects:@"习惯",@"英语",@"国学",@"生活小百科",@"儿歌",@"故事",@"唐诗",nil];
    
    if (_contentView == nil)
    {
        //        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight / 2.0 - 200, kDeviceWidth, KDeviceHeight / 2.0)];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight / 2.0, kDeviceWidth, KDeviceHeight / 2.0)];
        
        _contentView.backgroundColor = BBT_BACKGROUN_COLOR;
        
        _contentView.layer.masksToBounds = YES; //没这句话它圆不起来
        _contentView.layer.cornerRadius = 11; //设置图片圆角的尺度
        
        [self addSubview:_contentView];
        [_contentView addSubview:self.tableView];
        [_contentView addSubview:cancelBtn];
    }
    
    self.trackArticles = [[NSMutableArray alloc] init];
    
//    [self GetTrackList];
    
    
}

- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
//    if (!view)
//    {
//        return;
//    }
//    
//    [view addSubview:self];
//    [view addSubview:_contentView];
//    
//    [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.alpha = 1.0;
//        
//        [_contentView setFrame:CGRectMake(0, KDeviceHeight / 2.0, kDeviceWidth, KDeviceHeight / 2.0)];
//        
//    } completion:nil];
    
    UIWindow *window = [UIApplication sharedApplication].windows[1];
    [window addSubview:self];
    
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, KDeviceHeight / 2.0 , kDeviceWidth, KDeviceHeight / 2.0)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.trackArticles.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"playcellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        //        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
        
     
    }
    
    if (indexPath.row>0) {
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [[UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0] CGColor];
        lineLayer.frame = CGRectMake(10,0, kDeviceWidth - 20, 0.5);
        [cell.contentView.layer addSublayer:lineLayer];
    }
    
    QTrackListResponse *listresponse = [self.trackArticles objectAtIndex:indexPath.row];
    
    cell.textLabel.text = listresponse.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 43.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //通知代理
    //    if ([self.delegate respondsToSelector:@selector(playerToolBar:btnClickWithType:)]) {
    //        [self.delegate playerToolBar:self btnClickWithType:btnType];
    //    }
    QTrackListResponse *listresponse = [self.trackArticles objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(QSearchViewAddBtnClicked:selectModel:)]) {
        
        
        //        [self.delegate Q3PlayListViewAddBtnClicked:self sectionIndex:listresponse.id ListTitle:listresponse.name];
        
        [self.delegate QSearchViewAddBtnClicked:self selectModel:listresponse];
        
    }
    
    [self disMissView];
    
}
//- (void)GetTrackList
//{
//    [QMineRequestTool GetTrackListName:@"Customer0223_23" success:^(id response) {
//        
//        
//        self.trackArticles = [QTrackListResponse mj_objectArrayWithKeyValuesArray:response];
//        
//        if (self.trackArticles.count>0) {
//            
//            
//            [self.tableView reloadData];
//            
//        }else{
//            
//            NSLog(@"数据为空");
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}
@end
