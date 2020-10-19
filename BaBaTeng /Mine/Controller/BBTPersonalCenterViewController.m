//
//  BBTPersonalCenterViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTPersonalCenterViewController.h"

#import "BBTMessageCenterViewController.h"

#import "AddEquipmentViewController.h"

#import "BBTMessageCenterViewController.h"

#import "BBTPersonalDataViewController.h"

#import "BBTBigAboutViewController.h"

#import "BBTBigFeedBackViewController.h"

#import "UIColor+SNFoundation.h"
//#import "BBTBigHelpAndFeedbackViewController.h"

//#import "P1DateViewController.h"
#import "BBTQAlertView.h"

#import "SDImageCache.h"

#import "UIImageView+AFNetworking.h"

#import "HelpAndFeedBackEquipmentViewController.h"

/** BXImageH */
#define imageH [UIScreen mainScreen].bounds.size.width*0.6
/** 滚动到多少高度开始出现 */
static CGFloat const startH = 0;
@interface BBTPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{

    BBTQAlertView *_QalertView;
     BOOL clearCache;
}

/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 头部图片 */
@property (nonatomic, strong) UIImageView *headerImage;
/** 标题 */
@property (nonatomic, copy) NSString *titleName;
/** 导航条View */
@property (nonatomic, weak) UIView *navBarView;


@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, strong) UILabel *personalNameLabel;
@property (nonatomic, strong) UILabel *personalSubNameLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataImageArray;

@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIImageView *newsImageView;

@property (nonatomic, assign) BOOL isCanSideBack;

@end

@implementation BBTPersonalCenterViewController


static BBTPersonalCenterViewController *personalCenterViewController;

+(BBTPersonalCenterViewController *)getInstance{
    
    return personalCenterViewController;
}

- (UILabel *)cacheLabel
{
    if (_cacheLabel == nil) {
        _cacheLabel  = [[UILabel alloc] init];
    }
    return _cacheLabel;
}

- (UIImageView *)newsImageView
{
    if (_newsImageView == nil) {
        
        _newsImageView  = [[UIImageView alloc] init];
    }
    return _newsImageView;
}


#pragma mark -control
- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}


#pragma mark - initView
-(void)initView{
    
    self.navigationItem.title = @"个人中心";
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    tableView.contentInset = UIEdgeInsetsMake(imageH, 0, 49, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor =  [UIColor clearColor];//CellBackgroundColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(0, -imageH, [UIScreen mainScreen].bounds.size.width, imageH);
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    [tableView insertSubview:headerImage atIndex:0];
    self.headerImage = headerImage;
    self.headerImage.image = [UIImage imageNamed:@"bg_grzx01"];
    self.headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalCenterAction)];
    [self.headerImage addGestureRecognizer:singleTap];
    
    
    self.iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(20,self.headerImage.frame.size.height-imageH/2-20, 80, 80)];
    self.iconImageview.layer.cornerRadius = self.iconImageview.frame.size.width / 2;
    self.iconImageview.layer.masksToBounds = YES;
//    [self.iconImageview setImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    [self.iconImageview setImageWithURL:[NSURL URLWithString: [[TMCache sharedCache] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    [headerImage addSubview:self.iconImageview];
    
    
    
    
    
    self.arrow     = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-30, headerImage.frame.size.height-imageH/2+10,20,20)];
    self.arrow.contentMode      = UIViewContentModeScaleAspectFit;
    [self.arrow setImage:[UIImage imageNamed:@"圆角矩形1"]];
    [headerImage addSubview:self.arrow];
    //
    self.personalNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+30, self.headerImage.frame.size.height-imageH/2-15,kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-80,40)];
    [self.personalNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
    self.personalNameLabel.font =  [UIFont systemFontOfSize:15.0f];
    self.personalNameLabel.numberOfLines = 0;
    self.personalNameLabel.textColor = [UIColor whiteColor];
    self.personalNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [headerImage addSubview:self.personalNameLabel];
    
    self.personalSubNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+30, headerImage.frame.size.height-imageH/2+30, kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-80,20)];
    
    NSString *deviceName = [NSString stringWithFormat:@"%@台设备",[[TMCache sharedCache] objectForKey:@"bindDeviceNumber"]];
    [self.personalSubNameLabel  setText:deviceName];
    self.personalSubNameLabel .font = BBT_THREE_FONT;
    self.personalSubNameLabel .textColor = [UIColor whiteColor];
    self.personalSubNameLabel.textAlignment = NSTextAlignmentLeft;
    [headerImage addSubview:self.personalSubNameLabel ];
    //
    
    
    
    
    
    
}




#pragma mark -message center
-(void)message{
    
    
    [self.navigationController pushViewController:[BBTMessageCenterViewController new] animated:YES];
}

-(void)personalCenterAction{
    
    
    NSLog(@"personalCenterAction");
    [self.navigationController pushViewController:[BBTPersonalDataViewController new] animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView.backgroundColor = [UIColor redColor];//CellBackgroundColor;
        //cell.contentView.backgroundColor = CellBackgroundColor;
        //需要画一条横线
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,59.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
        topImageView.backgroundColor = [UIColor colorWithRGBHex:0xe0dfd3];//[UIImage imageNamed:@"line.png"];
        
        [cell.contentView addSubview:topImageView];
        
        UIImageView *selecetedCellBG = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,60)];
        selecetedCellBG.backgroundColor =SelecetedCellBG;
        selecetedCellBG.clipsToBounds = YES;
        selecetedCellBG.contentMode = UIViewContentModeScaleAspectFill;
        cell.selectedBackgroundView=selecetedCellBG ;
    }
    
    
    if (indexPath.row==2) {
        
        self.newsImageView.frame = CGRectMake(kDeviceWidth-25-25, 25,10,10 );
        self.newsImageView.backgroundColor = [UIColor clearColor];
        self.newsImageView.layer.cornerRadius = 5;
        self.newsImageView.clipsToBounds = YES;
        self.newsImageView.backgroundColor = [UIColor colorWithRGBHex:0xe35454];
        [cell.contentView addSubview:self.newsImageView];
        
        if ([[[TMCache sharedCache] objectForKey:@"systemMessage1"]isEqualToString:@"NO"]&&[[[TMCache sharedCache] objectForKey:@"devicMessage1"]isEqualToString:@"NO"]&&[[[TMCache sharedCache] objectForKey:@"familyMessage1"]isEqualToString:@"NO"]) {
            
            
            self.newsImageView.hidden = YES;
            //为了不干扰下一次新消息的显示 使用一后晴空
            [[TMCache sharedCache]removeObjectForKey:@"systemMessage1"];
            [[TMCache sharedCache]removeObjectForKey:@"devicMessage1"];
            [[TMCache sharedCache]removeObjectForKey:@"familyMessage1"];
            
        }else if ([[[TMCache sharedCache] objectForKey:@"systemMessage1"]isEqualToString:@"YES"]||[[[TMCache sharedCache] objectForKey:@"devicMessage1"]isEqualToString:@"YES"]||[[[TMCache sharedCache] objectForKey:@"familyMessage1"]isEqualToString:@"YES"]){
            
            
            self.newsImageView.hidden = NO;
            //为了不干扰下一次新消息的显示 使用一后晴空
            [[TMCache sharedCache]removeObjectForKey:@"systemMessage1"];
            [[TMCache sharedCache]removeObjectForKey:@"devicMessage1"];
            [[TMCache sharedCache]removeObjectForKey:@"familyMessage1"];
            
        }
        else{
            
            
            if ([[[TMCache sharedCache] objectForKey:@"HomeViewNewMessage"]isEqualToString:@"YES"]) {
                
                self.newsImageView.hidden = NO;
                
                
            }else{
                
                
                self.newsImageView.hidden = YES;
            }
        }
        
        
        
    }
    
    if (indexPath.row==4) {
        
        
        
        if (!clearCache) {
            
            
            self.cacheLabel.frame=  CGRectMake(kDeviceWidth-140, 10, 100,40 );
            self.cacheLabel.backgroundColor = [UIColor clearColor];
            self.cacheLabel.textColor = MainFontColorTWO;
            self.cacheLabel.font = BBT_THREE_FONT;
            self.cacheLabel.textAlignment = NSTextAlignmentRight;
            self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB" ,[self getCachSize]];
            
            [cell.contentView addSubview: self.cacheLabel];
            
            
        }else{
            
            self.cacheLabel.frame=  CGRectMake(kDeviceWidth-140, 10, 100,40 );
            self.cacheLabel.backgroundColor = [UIColor whiteColor];
            self.cacheLabel.textColor = MainFontColorTWO;
            self.cacheLabel.font = BBT_THREE_FONT;
            self.cacheLabel.textAlignment = NSTextAlignmentRight;
            self.cacheLabel.text = @"0 MB";
            [cell.contentView addSubview: self.cacheLabel];
            
            
        }
        
        
    }
    
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dataImageArray[indexPath.row]]];
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //[self.navigationController pushViewController:[[CustomRootViewController alloc]init] animated:YES];
    // [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //self.navigationController.navigationBar.hidden = YES;
    
    if (indexPath.row==0) {
        
        //[self.navigationController pushViewController:[BBTBigHelpAndFeedbackViewController new] animated:YES];
        // [self.navigationController pushViewController:[P1DateViewController new] animated:YES];
        
        AddEquipmentViewController  * addViewControlle = [[AddEquipmentViewController alloc]init];
        addViewControlle.title = @"添加设备";
        
        [self.navigationController pushViewController:addViewControlle animated:YES];
        
    }else if (indexPath.row==1){
        
        //  [self.navigationController pushViewController:[BBTBigAboutViewController new] animated:YES];
        
        HelpAndFeedBackEquipmentViewController *helpVc = [[HelpAndFeedBackEquipmentViewController alloc] init];
        helpVc.JumpType = @"helpVc";
        helpVc.title = @"使用帮助";
        [self.navigationController pushViewController:helpVc animated:YES];
        
    }else if (indexPath.row==2){
        
        //  [self.navigationController pushViewController:[BBTBigAboutViewController new] animated:YES];
        
        [self.navigationController pushViewController:[[BBTMessageCenterViewController alloc]init] animated:YES];
        
    }else if (indexPath.row==3){
        
        //  [self.navigationController pushViewController:[BBTBigAboutViewController new] animated:YES];
        
      
        
        
        HelpAndFeedBackEquipmentViewController *helpVc = [[HelpAndFeedBackEquipmentViewController alloc] init];
        helpVc.JumpType = @"feedBack";
        helpVc.title = @"意见反馈";
 
        [self.navigationController pushViewController:helpVc animated:YES];
        
    }else if (indexPath.row==4){
        
        if (clearCache) {
        
            [self showToastWithString:@"无缓存可清除"];
            
        }else{
        
            _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"清除缓存" andWithMassage:[NSString stringWithFormat:@"总共清除%.2fMB" ,[self getCachSize]] andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
            [_QalertView showInView:self.view];
            
            __block BBTPersonalCenterViewController *self_c = self;
            //点击按钮回调方法
            _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                if (titleBtnTag == 1) {
                    
                    clearCache =YES;
                    [self_c handleClearView];
                    [self_c.tableView reloadData];
                    
                }
                if (titleBtnTag == 0) {
                    
                    NSLog(@"FASDF");
                }
            };
            
        }
        
        
    }else{
        
        [self.navigationController pushViewController:[[BBTBigAboutViewController alloc]init] animated:YES];
        
        
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > -imageH + startH) {
        CGFloat alpha = MIN(1, 1 - ((-imageH + startH + 64 - offsetY) / 64));
        
        self.navBarView.backgroundColor = BXAlphaColor(243, 126, 8, alpha);
        
    } else {
        
        self.navBarView.backgroundColor = BXAlphaColor(243, 126, 8, 0);
    }
    
    // ------------------------------华丽的分割线------------------------------------
    // 设置头部放大
    // 向下拽了多少距离
    CGFloat down = - imageH - scrollView.contentOffset.y;
    if (down < 0) return;
    
    CGRect frame = self.headerImage.frame;
    frame.origin.y = - imageH - down;
    frame.size.height = imageH + down;
    self.headerImage.frame = frame;
    
    // self.messageLabel.frame =CGRectMake(0, self.headerImage.frame.size.height-imageH/2+10,kDeviceWidth, imageH/2);
    
    self.arrow.frame = CGRectMake(kDeviceWidth-30, self.headerImage.frame.size.height-imageH/2+10,20,20);
    self.iconImageview.frame =CGRectMake(20, self.headerImage.frame.size.height-imageH/2-20, 80, 80);
    self.personalNameLabel.frame =CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+30, self.headerImage.frame.size.height-imageH/2-10,kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-60,30);
    
    self.personalSubNameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageview.frame)+30, self.headerImage.frame.size.height-imageH/2+30,  kDeviceWidth-CGRectGetMaxX(self.iconImageview.frame)+10-60,20);
}



#pragma mark - Systems
- (void)viewDidLoad {
    
    [super viewDidLoad];
    personalCenterViewController = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];//初始化
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.dataArray = [NSMutableArray arrayWithObjects:@"添加设备",@"使用帮助",@"消息中心",@"意见反馈",@"清除缓存",@"关于", nil];
    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_tjsb",@"icon_sybz",@"iconb_xxzx",@"icon_yjfk",@"icon_dianbolishi",@"icon_guanyu1", nil];
    
    
}
- (void)updateImage:(UIImage *)image{

   [self.iconImageview setImage:image];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    
    //去掉分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.tableView reloadData];
    
     [self.personalNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
    
    NSString *deviceName = [NSString stringWithFormat:@"%@台设备",[[TMCache sharedCache] objectForKey:@"bindDeviceNumber"]];
    [self.personalSubNameLabel  setText:deviceName];
    
  
}

//-(void)viewDidDisappear:(BOOL)animated{
//    
//    [super viewDidDisappear:YES];
////     [[AppDelegate appDelegate]suspendButtonHidden:YES];
//    
//}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self forbiddenSideBack];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [self resetSideBack];

}



/**
 
 * 禁用边缘返回
 
 */

-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    
    //关闭ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        
    }
    
}

/*
 
 恢复边缘返回
 
 */

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    
    //开启ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
}




//获取app缓存大小
- (CGFloat)getCachSize {
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义缓存大小
    //用枚举器遍历 一个文件夹的内容
    //1.获取 文件夹枚举器
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count = 0;
    //2.遍历
    for (NSString *fileName in enumerator) {
        NSString *path = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;//自定义所有缓存大小
    }
    // 得到是字节  转化为M
    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    
    return totalSize;
}

//清理app缓存

- (void)handleClearView {
    //删除两部分
    //1.删除 sd 图片缓存
    //先清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    //2.删除自己缓存
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
}

@end
