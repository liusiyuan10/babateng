//
//  FYFiveViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "NewFYtopbannerViewCell.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
#import "NewBulletinData.h"

#define topheight 150/568.0*[[UIScreen mainScreen] bounds].size.height
@interface NewFYtopbannerViewCell()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    
    NSInteger _page;
    NSInteger _page1;
    
    BOOL led;
}

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation NewFYtopbannerViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array
{
    
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
//    if(self)
    if(self && array.count >0)
    {
        int z = (int)[array count] + 2;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, topheight)];
        
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * z, topheight);
        
        _scrollView.pagingEnabled = YES;//当值是 YES 会自动滚动到 subview 的边界，默认是NO
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width , 0);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width , 0);
        
        _scrollView.showsHorizontalScrollIndicator = NO;//滚动条是否可见 水平
        _scrollView.showsVerticalScrollIndicator=NO;//滚动条是否可见 垂直
        
        for (int i = 0; i < [array count]; i++)
        {
            UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i+1), 0, [UIScreen mainScreen].bounds.size.width, topheight)];
            
            NewBulletinData *bulletindata = array[i];

            NSString *subStr =bulletindata.contentIcon; //imagestr[@"picture_url"];
//            NSString *subStr =array[i]; //imagestr[@"picture_url"];
            
            backView.image = [UIImage imageNamed:subStr];
            
            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)subStr, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
            [backView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
            
            backView.tag = 5000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            [backView addGestureRecognizer:tap];
            
            backView.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
            [_scrollView addSubview:backView];
        }
        //开头
        UIImageView *backView0 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0, 0, [UIScreen mainScreen].bounds.size.width, topheight)];
        
        NewBulletinData *bulletindata = [array lastObject];

        NSString *subStr0 = bulletindata.contentIcon;
        
//        NSString *subStr0 = [array lastObject];
        
        backView0.image = [UIImage imageNamed:subStr0];
        NSString *encodedStringstr0 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)subStr0, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [backView0 sd_setImageWithURL:[NSURL URLWithString:encodedStringstr0] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        
        backView0.tag = 5000 + [array count] -1;
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
        [backView0 addGestureRecognizer:tap0];
        backView0.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
        
        [_scrollView addSubview:backView0];
        //末尾
        UIImageView *backView9 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (z-1), 0, [UIScreen mainScreen].bounds.size.width, topheight)];
        
        NewBulletinData *bulletindata1 = array[0];
        NSString *subStr9 = bulletindata1.contentIcon;//imagestr9[@"picture_url"];
//        NSString *subStr9 = array[0];//imagestr9[@"picture_url"];
        
        backView9.image = [UIImage imageNamed:subStr9];
        NSString *encodedStringstr9 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)subStr9, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [backView9 sd_setImageWithURL:[NSURL URLWithString:encodedStringstr9] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        
        backView9.tag = 5000;
        UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
        [backView9 addGestureRecognizer:tap9];
        backView9.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
        
        [_scrollView addSubview:backView9];
        
        [self addSubview:_scrollView];
        
        
        int myWidth;
        
        if (kDeviceWidth<=320 ) {
            
            myWidth = 20;
            
        }else if (kDeviceWidth<=375&&kDeviceWidth>320){
            
            myWidth = 25;
        }else if (kDeviceWidth<=414&&kDeviceWidth>375){
            
            myWidth = 30;
        }
        
        
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width- array.count*myWidth-10, 130/568.0*[[UIScreen mainScreen] bounds].size.height,  array.count*20, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = [_scrollView.subviews count] -2;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:254.0/255 green:143.0/255 blue:45.0/255 alpha:1.0f]];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:186.0/255 green:210.0/255 blue:219.0/255 alpha:1.0f]];
        _pageControl.backgroundColor = [UIColor clearColor];
        if (array.count > 1)
        {
            [self addSubview:_pageControl];
            [self addTimer];
        }else
        {
            led = YES;
        }
        
        _page = 1;
        _page1 = [array count]+1;
        
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate  scrollView事件

-(void)scrollViewDidScroll:(UIScrollView *)scrollView//手指拖动后调用
{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    
    _pageControl.currentPage = page-1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView//拖动结束后调用
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    
    if (page == 0)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*([scrollView.subviews count] -2), 0);
    }
    if (page == [scrollView.subviews count] -1)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*1, 0);
    }
    
}

-(void)Clicktap:(UITapGestureRecognizer *)sender//点击释放触发
{
    int tag = (int)sender.view.tag-5000;
    [self.delegate NewdidSelectedTopbannerViewCellIndex:tag];
}


/**
 *  scrollView 开始拖拽的时候调用
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (led)
    {
        
    }else
    {
        [self closeTimer];
        
    }
}

/**
 *  scrollView 结束拖拽的时候调用
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (led)
    {
        
    }else
    {
        [self addTimer];
    }
}

#pragma mark - timer方法
/**
 *  添加定时器
 */
-(void)addTimer
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)nextImage
{
    _page = _page+1;
    
    [_scrollView setContentOffset:CGPointMake(_page*_scrollView.frame.size.width, 0) animated:YES];
    
    if (_page == _page1)
    {
        _page=0;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*_page, 0);
    }
}

/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [self.timer invalidate];
}


@end
