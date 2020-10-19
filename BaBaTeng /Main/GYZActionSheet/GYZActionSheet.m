//
//  GYZActionSheet.m
//  GYZCustomActionSheet
//  ActionSheet视图
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZActionSheet.h"
#import "GYZSheetView.h"
#import "GYZCommon.h"
#import "QAlbumDataTrackList.h"
#import "HomeViewController.h"
#import "TMCache.h"
#import "UIButton+time.h" //防止频繁点击给服务器带来的压力
#import "NewHomeViewController.h"
#import "BBTCustomViewRequestTool.h"
#import "QAddSong.h"

//#import "SingleHeader.h"
#define kPushTime 0.3
#define kDismissTime 0.3
#define kCellH 45
#define kMW (kScreenWidth-2*kMargin)
#define kCornerRadius 5
#define kMargin 6
#define kSheetViewMaxH (kScreenHeight * 0.7)


@interface GYZActionSheet()<GYZSheetViewDelegate>

@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) GYZSheetView *sheetView;
@property (strong, nonatomic) UILabel *titleView;


@property (strong, nonatomic) UIButton *footButton;
@property (strong, nonatomic) UIView *marginView;
@property (assign, nonatomic) CGFloat contentVH;
@property (assign, nonatomic) CGFloat contentViewY;
@property (assign, nonatomic) CGFloat footViewY;

@property (strong, nonatomic) NSIndexPath *selectIndex;
@property (strong, nonatomic) SelectIndexBlock selectBlock;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) GYZSheetStyle sheetStyle;
@property (assign, nonatomic) PlayStyle playStyle;

@property (assign, nonatomic) SortStyle sortStyle;

@property (assign, nonatomic) NSUInteger playMode;

@property (assign, nonatomic) NSUInteger playMode1;

@end

@implementation GYZActionSheet

- (id)initSheetStyle:(GYZSheetStyle)sheetStyle
           playStyle:(PlayStyle)playStyle SortStyle:(SortStyle)sortStyle
          itemTitles:(NSMutableArray *)itemTitles
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        self.sheetStyle = sheetStyle;
        self.playStyle = playStyle;
        self.sortStyle = sortStyle;
        self.dataSource = itemTitles;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景按钮
        self.bgButton = [[UIButton alloc] init];
        [self addSubview:self.bgButton];
        self.bgButton.backgroundColor = [UIColor blackColor];
        self.bgButton.alpha = 0.35;
        //title和sheetView的容器View
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor colorWithRed:244/255.0 green:225/255.0 blue:206/255.0 alpha:1.0];
        
        [self addSubview:self.contentView];
        
        
        //取消按钮View
        self.footButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.footButton.backgroundColor = [UIColor whiteColor];
        [self.footButton setTitle:@"关闭" forState:UIControlStateNormal];
        [self.footButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.footButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        self.footButton.titleLabel.font = [UIFont systemFontOfSize:18];
        if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self.footButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        }else if ([[UIScreen mainScreen] bounds].size.height > 667) {
            self.footButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        }
        [self addSubview:self.footButton];
        
        //选择TableView
        self.sheetView = [[GYZSheetView alloc]initWithFrame:CGRectZero];
        self.sheetView.cellHeight = kCellH;
        self.sheetView.delegate = self;
        self.sheetView.dataSource = self.dataSource;
        [self.contentView addSubview:self.sheetView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GYZActionSheetMode:) name:@"GYZActionSheetMode" object:nil];
        
        //        GYZActionSheetMode
        
        //选择样式
        if (sheetStyle == GYZSheetStyleDefault) {
            
            [self upDefaultStyeWithItems:itemTitles title:@""];
            
            [self pushDefaultStyeSheetView];
        }
        else if (sheetStyle == GYZSheetStyleWeiChat) {
            
            [self upWeiChatStyeWithItems:itemTitles title:@""];
            
            [self pushWeiChatStyeSheetView];
        }
        else if (sheetStyle == GYZSheetStyleTable) {
            
            [self upTableStyeWithItems:itemTitles title:@""];
            
            [self pushTableStyeSheetView];
            
        }
    }
    return self;
}

- (void)GYZActionSheetMode:(NSNotification *)noti
{
    NSString *strtest1 = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"mode"]];
    
    if ([strtest1 isEqualToString:@"repeat one"]) {
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_dq"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"单曲" forState:UIControlStateNormal];
        [[TMCache sharedCache]setObject:@"repeat one"forKey:@"PlayMode"];
        self.playMode1 = 0;//默认排序
    }else if ([strtest1 isEqualToString:@"repeat all"]){
        
        self.playMode1 = 1;//循坏
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_lb"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"循环" forState:UIControlStateNormal];
        [[TMCache sharedCache]setObject:@"repeat all"forKey:@"PlayMode"];
    }
}

///初始化默认样式
- (void)upDefaultStyeWithItems:(NSArray *)itemTitles title:(NSString *)title
{
    //半透明背景按钮
    [self.bgButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    BOOL isTitle = YES;
    self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, kMW, kCellH)];
    
    self.titleView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.070588 green:0.6196 blue:0.96471 alpha:1];
    self.titleView.textColor = [UIColor darkGrayColor];
    self.titleView.font = [UIFont systemFontOfSize:18];
    self.titleView.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.titleView];
    
    
    
    
    self.playModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playModeBtn.frame = CGRectMake(8, 0, 80, kCellH);
    //    [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_sj"] forState:UIControlStateNormal];
    //    [ self.playModeBtn setTitle:@"随机" forState:UIControlStateNormal];
    [ self.playModeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([[[TMCache sharedCache]objectForKey:@"PlayMode"]isEqualToString:@"repeat one"]) {
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_dq"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"单曲" forState:UIControlStateNormal];
        self.playMode1 = 0;//默认排序
    }else{
        self.playMode1 = 1;//循坏
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_lb"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"循环" forState:UIControlStateNormal];
    }
    
    
    
    self.playModeBtn.backgroundColor = [UIColor clearColor];
    [ self.playModeBtn addTarget:self action:@selector(playModeClick) forControlEvents:UIControlEventTouchUpInside];
    self.playModeBtn.mm_acceptEventInterval = 2.0f;//设置上面点击时间间隔
    [self.contentView addSubview: self.playModeBtn];
    
    
    self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sortBtn.frame = CGRectMake(kScreenWidth-108-10, 0, 120, kCellH);
    [self.sortBtn setImage:[UIImage imageNamed:@"bf_jx"] forState:UIControlStateNormal];
    [self.sortBtn setTitle:@"排序" forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sortBtn.backgroundColor = [UIColor clearColor];
    [self.sortBtn addTarget:self action:@selector(sortBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.sortBtn.hidden = YES;
    if ([[[TMCache sharedCache]objectForKey:@"orderBy"]isEqualToString:@"1"]) {
        
        [self.sortBtn setImage:[UIImage imageNamed:@"bf_sx"] forState:UIControlStateNormal];
        self.playMode1 = 1;//默认排序
    }else{
        self.playMode1 = 0;//默认排序
        [self.sortBtn setImage:[UIImage imageNamed:@"bf_jx"] forState:UIControlStateNormal];
    }
    
    
    [self.contentView addSubview: self.sortBtn];
    
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    self.contentVH = kCellH * (cellCount + isTitle);
    if (self.contentVH > kSheetViewMaxH) {
        self.contentVH = kSheetViewMaxH;
        self.sheetView.tableView.scrollEnabled = YES;
    } else {
        self.sheetView.tableView.scrollEnabled = NO;
    }
    
    self.footViewY = kScreenHeight - kCellH - kMargin;
    self.footButton.frame = CGRectMake(kMargin, kScreenHeight + self.contentVH + kMargin, kMW, kCellH);
    self.contentViewY = kScreenHeight - CGRectGetHeight(self.footButton.frame) - self.contentVH - kMargin * 2-kDevice_Is_iPhoneX;  //适配iphone x
    self.contentView.frame = CGRectMake(kMargin, kScreenHeight, kMW, self.contentVH);
    
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
    if (isTitle) {
        sheetY = CGRectGetHeight(self.titleView.frame);
        sheetH = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.titleView.frame);
    }
    self.sheetView.frame = CGRectMake(0, sheetY+3, kMW, sheetH+3);
    //设置圆角
    ViewRadius(self.contentView, kCornerRadius);
    ViewRadius(self.footButton, kCornerRadius);
    [self.footButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)playModeClick{
    
    
    
    self.playMode ++;
    
    if (self.playMode==2) {
        
        self.playMode=0;
    }
    
    NSLog(@"模式=======%lu",(unsigned long)self.playMode);
    
    if (self.playMode == SinglePlayStyle) {
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_dq"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"单曲" forState:UIControlStateNormal];
        
        NSLog(@"模式=======%@",@"单曲");
        
//        NSDictionary *dic =   @{@"cmd":@"setMode",@"value":@"repeat one"};
//
//
//        [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
        
        [self PutDevicesControlMQTT:@"6" ValueStr:@"repeat one"];
        
        
        [[TMCache sharedCache]setObject:@"repeat one"forKey:@"PlayMode"];
        
        
    }    else if (self.playMode == CyclePlayStyle) {
        
        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_lb"] forState:UIControlStateNormal];
        [ self.playModeBtn setTitle:@"循环" forState:UIControlStateNormal];
        NSLog(@"模式=======%@",@"循环");
        
//        NSDictionary *dic =   @{@"cmd":@"setMode",@"value":@"repeat all"};
//        [[NewHomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
//
        
         [self PutDevicesControlMQTT:@"6" ValueStr:@"repeat all"];
        
        [[TMCache sharedCache]setObject:@"repeat all"forKey:@"PlayMode"];
    }
    
    
    
    //    //选择样式
    //    if (self.playMode == OrderPlayStyle) {
    //
    //        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_lb"] forState:UIControlStateNormal];
    //        [ self.playModeBtn setTitle:@"顺序" forState:UIControlStateNormal];
    //
    //
    //
    //
    //    }
    //    else if (self.playMode == RandomPlayStyle) {
    //
    //        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_sj"] forState:UIControlStateNormal];
    //        [ self.playModeBtn setTitle:@"随机" forState:UIControlStateNormal];
    //
    //
    //
    //
    //    }
    //    else if (self.playMode == SinglePlayStyle) {
    //
    //        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_dq"] forState:UIControlStateNormal];
    //        [ self.playModeBtn setTitle:@"单曲" forState:UIControlStateNormal];
    //
    //        NSDictionary *dic =   @{@"cmd":@"setMode",@"value":@"repeat one"};
    //
    //
    //        [[HomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    //
    //    }    else if (self.playMode == CyclePlayStyle) {
    //
    //        [ self.playModeBtn setImage:[UIImage imageNamed:@"bf_xuhuan"] forState:UIControlStateNormal];
    //        [ self.playModeBtn setTitle:@"循环" forState:UIControlStateNormal];
    //
    //        NSDictionary *dic =   @{@"cmd":@"setMode",@"value":@"repeat all"};
    //        [[HomeViewController getInstance] SendMessagemKTopic:[[TMCache sharedCache] objectForKey:@"mKTopic"] Message:dic];
    //
    //
    //    }
    
    
    
    
}
-(void)sortBtnClick{
    
    self.playMode1 ++;
    
    if (self.playMode1==2) {
        
        self.playMode1=0;
    }
    
    
    
    //选择样式
    if (self.playMode1 == OrderStyle) {
        
        [self.sortBtn setImage:[UIImage imageNamed:@"bf_jx"] forState:UIControlStateNormal];
        [self.sheetView getCurrentPlayingTracksId:@"0"];
        
        [[TMCache sharedCache]setObject:@"0" forKey:@"orderBy"];
        
        
        
    }
    else if (self.playMode1 == InvertedStyle) {
        
        [[TMCache sharedCache]setObject:@"1" forKey:@"orderBy"];
        [self.sheetView getCurrentPlayingTracksId:@"1"];
        [self.sortBtn setImage:[UIImage imageNamed:@"bf_sx"] forState:UIControlStateNormal];
        
        
    }
    
    
    
    
    
}

///初始化微信样式
- (void)upWeiChatStyeWithItems:(NSArray *)itemTitles title:(NSString *)title
{
    [self.bgButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.footButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.footButton.titleLabel.font = [UIFont systemFontOfSize:18];
    if (kScreenHeight == 667) {
        self.footButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }else if (kScreenHeight > 667) {
        self.footButton.titleLabel.font = [UIFont systemFontOfSize:21];
    }
    
    //中间空隙
    self.marginView = [[UIView alloc] init];
    self.marginView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.marginView.alpha = 0.0;
    [self addSubview:self.marginView];
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellH)];
        self.titleView.text = title;
        
        self.titleView.backgroundColor = [UIColor whiteColor];
        self.titleView.textColor = [UIColor darkGrayColor];
        self.titleView.font = [UIFont systemFontOfSize:18];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        isTitle = YES;
        [self.contentView addSubview:self.titleView];
    }
    
    
    
    
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    self.contentVH = kCellH * (cellCount + isTitle);
    if (self.contentVH > kSheetViewMaxH) {
        self.contentVH = kSheetViewMaxH;
        self.sheetView.tableView.scrollEnabled = YES;
    } else {
        self.sheetView.tableView.scrollEnabled = NO;
    }
    
    self.footViewY = kScreenHeight - kCellH;
    self.footButton.frame = CGRectMake(0, self.footViewY + self.contentVH, kScreenWidth, kCellH);
    
    self.contentViewY = kScreenHeight - CGRectGetHeight(self.footButton.frame) - self.contentVH - kMargin-kDevice_Is_iPhoneX;  //适配iphone x
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
    if (isTitle) {
        sheetY = CGRectGetHeight(self.titleView.frame);
        sheetH = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.titleView.frame);
    }
    self.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
    self.marginView.frame = CGRectMake(0, kScreenHeight + sheetH, kScreenWidth, kMargin);
    
    [self.footButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
}

///初始化TableView样式
- (void)upTableStyeWithItems:(NSArray *)itemTitles title:(NSString *)title
{
    if (self.footButton) {
        [self.footButton removeFromSuperview];
    }
    [self.bgButton addTarget:self action:@selector(dismissTableStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellH)];
        self.titleView.text = title;
        self.titleView.textAlignment = NSTextAlignmentLeft;
        self.titleView.backgroundColor = [UIColor whiteColor];
        self.titleView.textColor = [UIColor darkGrayColor];
        self.titleView.font = [UIFont systemFontOfSize:18];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        isTitle = YES;
        [self.contentView addSubview:self.titleView];
    }
    self.sheetView.cellTextColor = [UIColor blackColor];
    self.sheetView.cellTextStyle = NSTextStyleLeft;
    self.sheetView.tableView.scrollEnabled = YES;
    self.sheetView.showTableDivLine = YES;
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    self.contentVH = kCellH * (cellCount + isTitle);
    if (self.contentVH > kSheetViewMaxH) {
        self.contentVH = kSheetViewMaxH;
    }
    //适配iphone x
    self.contentViewY = kScreenHeight - self.contentVH-kDevice_Is_iPhoneX;
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
    if (isTitle) {
        sheetY = CGRectGetHeight(self.titleView.frame);
        sheetH = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.titleView.frame);
    }
    self.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
}
//显示默认样式
- (void)pushDefaultStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentViewY, kMW, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(kMargin, weakSelf.footViewY-kDevice_Is_iPhoneX, kMW, kCellH);  //适配iphone x
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示像微信的样式
- (void)pushWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(0, weakSelf.footViewY-kDevice_Is_iPhoneX, kScreenWidth, kCellH);  //适配iphone x
        weakSelf.marginView.frame = CGRectMake(0, weakSelf.footViewY - kMargin, kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.35;
        weakSelf.marginView.alpha = 1.0;
    }];
}

//显示TableView的样式
- (void)pushTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示
- (void)show
{
    if (_sheetStyle == GYZSheetStyleDefault) {
        [self pushDefaultStyeSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleWeiChat) {
        [self pushWeiChatStyeSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleTable) {
        [self pushTableStyeSheetView];
    }
}


//消失默认样式
- (void)dismissDefaulfSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, kScreenHeight, kMW, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(kMargin, kScreenHeight + weakSelf.contentVH-kDevice_Is_iPhoneX, kMW, kCellH);  //适配iphone x
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footButton removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失微信样式
- (void)dismissWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(0, weakSelf.footViewY + weakSelf.contentVH-kDevice_Is_iPhoneX, kScreenWidth, kCellH);  //适配iphone x
        weakSelf.marginView.frame = CGRectMake(0, kScreenHeight + CGRectGetHeight(weakSelf.contentView.frame) + CGRectGetHeight(weakSelf.titleView.frame), kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.0;
        weakSelf.marginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footButton removeFromSuperview];
        [weakSelf.marginView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失TableView样式
- (void)dismissTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    _titleView.font = titleTextFont;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if (titleTextColor) {
        _titleView.textColor = titleTextColor;
    }
}

- (void)setItemTextFont:(UIFont *)itemTextFont
{
    if (itemTextFont) {
        _sheetView.cellTextFont = itemTextFont;
    }
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    if (itemTextColor) {
        _sheetView.cellTextColor = itemTextColor;
    }
}

- (void)setCancleTextFont:(UIFont *)cancleTextFont
{
    if (cancleTextFont) {
        [_footButton.titleLabel setFont:cancleTextFont];
    }
}

- (void)setCancleTextColor:(UIColor *)cancleTextColor
{
    if (cancleTextColor) {
        [_footButton setTitleColor:cancleTextColor forState:UIControlStateNormal];
    }
}

- (void)setCancleTitle:(NSString *)cancleTitle
{
    if (cancleTitle) {
        [_footButton setTitle:cancleTitle forState:UIControlStateNormal];
    }
}

- (void)setIsUnifyCancleAction:(BOOL)isUnifyCancleAction
{
    if (isUnifyCancleAction) {
        [self.footButton addTarget:self action:@selector(footButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didFinishSelectIndex:(SelectIndexBlock)block
{
    _selectBlock = block;
}

//把取消按钮的点击加入TableView的事件中统一处理
- (void)footButtonAction:(id)sender
{
    NSInteger indexsCount = (NSInteger)self.dataSource.count;
    if (indexsCount) {
        //[self sheetViewDidSelectIndex:indexsCount selectTitle:_footButton.titleLabel.text];
    }
}

//点击了TableView的哪行

- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:( QAlbumDataTrackList*)title selectPlayType:(QplayType *)qPlayType selectQCustomData:(QCustomData*)qCustomData
{
    if (_selectBlock) {
        _selectBlock(Index,title,qPlayType,qCustomData);
    }
    
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:qPlayType:qCustomData:)]) {
        [self.delegate sheetViewDidSelectIndex:Index selectTitle:title selectPlayType:qPlayType selectQCustomData:qCustomData];
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:sender:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title sender:self];
    }
    
    
    //    if (_sheetStyle == GYZSheetStyleDefault) {
    //
    //
    //        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
    //    }
    //    else if (_sheetStyle == GYZSheetStyleWeiChat) {
    //        [self dismissWeiChatStyeSheetView];
    //    }
    //    else if (_sheetStyle == GYZSheetStyleTable) {
    //        [self dismissTableStyeSheetView];
    //    }
    
    
}

- (void)PutDevicesControlMQTT:(NSString *)type ValueStr:(NSString *)valuestr
{
    NSDictionary *bodydic = @{@"type" : type, @"value": valuestr};
    
    [BBTCustomViewRequestTool PutDevicesControlMQTTParameter:nil BodyDic:bodydic success:^(QAddSong *respone) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)delayMethod{
    
    [self dismissDefaulfSheetView];
    
}

@end

