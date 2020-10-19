//
//  QDeviceView.m
//  BaBaTeng
//
//  Created by liu on 17/5/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import "QDeviceView.h"
//
//@implementation QDeviceView
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


#import "QDeviceView.h"
#import "Header.h"
#import "AppDelegate.h"



@interface QDeviceView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_contentView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property(strong,nonatomic)  NSMutableArray *trackArticles; //推荐列表

@end

@implementation QDeviceView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
//        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, kDeviceWidth - 120, 25)];
    
    titleLabel.text = @"灯光亮度";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 60, 15, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.hidden = YES;
    [headView addSubview:cancelBtn];
    
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame) - 35,kDeviceWidth , 259 - 20.0) style:UITableViewStyleGrouped];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //[self.setTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//    
//    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
//        
//    {
//        
//        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//        
//    }
    

    
    if ([self.QDeviceType isEqualToString:@"light"]) {
         titleLabel.text = @"灯光亮度";
//        self.titleArray  = [NSMutableArray arrayWithObjects:@"最亮",@"较亮",@"较暗",@"不亮",nil];
         self.titleArray  = [NSMutableArray arrayWithObjects:@"不亮",@"较暗",@"较亮",@"最亮",nil];
        
    }else
    {
        titleLabel.text = @"定时关机";
        self.titleArray  = [NSMutableArray arrayWithObjects:@"不启用",@"10分钟",@"20分钟",@"30分钟",@"60分钟",nil];
    }
    

      //适配iphone x
    if (_contentView == nil)
    {
       _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight - 259.0-kDevice_Is_iPhoneX, kDeviceWidth,259.0+kDevice_Is_iPhoneX )];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES; //没这句话它圆不起来
        _contentView.layer.cornerRadius = 11; //设置图片圆角的尺度
        
        [self addSubview:_contentView];
        [_contentView addSubview:self.tableView];
        [_contentView addSubview:headView];
    }
    
    self.trackArticles = [[NSMutableArray alloc] init];
    

    
    
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
    [window addSubview:_contentView];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, KDeviceHeight - 259.0, kDeviceWidth, 259.0)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
//    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"QDevicecellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor whiteColor];
        
        //通过RGB来定义自己的颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
        
    }
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
//    if(indexPath.row == 1)
//    {
//        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
//        
//
//    }
    
   


    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    
    
//    NSLog(@"灯光%@",[self.titleArray objectAtIndex:indexPath.row]);
    NSString *name = [self.titleArray objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(QDeviceViewBtnClicked:selectName:selectIndex:)]) {
        
        
        //        [self.delegate Q3PlayListViewAddBtnClicked:self sectionIndex:listresponse.id ListTitle:listresponse.name];
        NSLog(@"indexPath.row======%ld",(long)indexPath.row);
        
        [self.delegate QDeviceViewBtnClicked:self selectName:name selectIndex:indexPath.row];
        
    }
    
    [self disMissView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0/667 * KDeviceHeight;
}



@end
