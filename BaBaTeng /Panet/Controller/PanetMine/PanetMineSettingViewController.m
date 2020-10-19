//
//  PanetMineSettingViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineSettingViewController.h"
#import "PanetMineAddressViewController.h"
#import "PanetMineSetingCell.h"

#import "PanetRequestTool.h"
#import "PanetMineModel.h"
#import "PanetMineDataModel.h"

#import "UIColor+SNFoundation.h"
#import "BBTQAlertView.h"
#import "HelpAndFeedBackEquipmentViewController.h"

#import "BBTMessageCenterViewController.h"
#import "BBTBigAboutViewController.h"
#import "BBTMainTool.h"

@interface PanetMineSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    BBTQAlertView *_QalertView;
    BOOL clearCache;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *addressstr;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataImageArray;


@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIImageView *newsImageView;


@end

@implementation PanetMineSettingViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"收取音效",@"使用帮助",@"消息中心",@"意见反馈",@"清除缓存",@"关于", nil];
    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_charge",@"icon_sybz",@"iconb_xxzx",@"icon_yjfk",@"icon_dianbolishi",@"icon_guanyu1", nil];
    
    [self LoadChlidView];
    

}

- (void)LoadChlidView
{

    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight -150-kDevice_Is_iPhoneX)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10.5)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
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
    
    [self.view addSubview:self.tableView];
    
    
    
    UIButton *logOutButton = [[UIButton alloc] initWithFrame:CGRectMake(68 , CGRectGetMaxY(self.tableView.frame)+ 10, kDeviceWidth - 68 *2, 44)];
//    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_nor"] forState:UIControlStateNormal];
//    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_pre"] forState:UIControlStateHighlighted];
    
    logOutButton.backgroundColor = MNavBackgroundColor;
    logOutButton.contentMode = UIViewContentModeScaleAspectFill;
    
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [ logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    logOutButton.layer.cornerRadius= 22.0f;
    
    logOutButton.clipsToBounds = YES;//去除边界
    
    [logOutButton addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    
}

- (void)getUserScoreCenter
{
    [self startLoading];
    [PanetRequestTool getUserScoreCentersuccess:^(PanetMineModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.addressstr = respone.data.address;
            
            [self.tableView reloadData];
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
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
    
    if (indexPath.row == 0) {
        
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth - 38 - 49, 39 - 10.5, 49, 32)];
        switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
        
        
        [switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        NSString *soundstr = [[TMCache sharedCache]  objectForKey:@"PanetMineSound"];

        if ([soundstr isEqualToString:@"0"]) {

            switchview.on = NO;
        }
        else
        {
            switchview.on = YES;
        }
        
        cell.accessoryView = switchview;
        
        
        
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
    
    if (indexPath.row==1){
        
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
            
            __block PanetMineSettingViewController *self_c = self;
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

-(void)logOutAction{
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alert show];
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要退出登录吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block PanetMineSettingViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
            
            [[TMCache sharedCache]removeObjectForKey:@"userId"];
            [[TMCache sharedCache]removeObjectForKey:@"token"];
            
            [[TMCache sharedCache]removeObjectForKey:@"password"];
            
            
            [[TMCache sharedCache]removeObjectForKey:@"createTime"];
            [[TMCache sharedCache]removeObjectForKey:@"nickName"];
            
            [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
            
            
            [BBTMainTool setLoginRootViewController:CZKeyWindow];
        }
        if (titleBtnTag == 0) {
            
            NSLog(@"sg");
            
        }
    };
    
    
}




//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 2;
//
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 87;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *cellIndentifierOne = @"PanetMineSetingcell";
//
//    PanetMineSetingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
//
//    if (!cell) {
//
//        cell = [[PanetMineSetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
//        //        cell.backgroundColor = [UIColor clearColor];
//
//    }
//    if (indexPath.row == 0) {
//
//        cell.switchview.hidden = NO;
//        [cell.switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//
//        NSString *soundstr = [[TMCache sharedCache]  objectForKey:@"PanetMineSound"];
//
//        if ([soundstr isEqualToString:@"0"]) {
//
//            cell.switchview.on = NO;
//        }
//        else
//        {
//            cell.switchview.on = YES;
//        }
//
//        cell.NameLabel.text = @"收取音效";
//
//
//
//    }else
//    {
//
//        cell.subLabel.hidden = NO;
//        cell.NameLabel.text = @"我的地址";
//
//
//    }
//
//
//    if ([self.addressstr isEqualToString:@"1"]) {
//        cell.subLabel.text = @"已设置";
//        cell.subLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
//
//    }
//
//
//    return cell;
//
//}


-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        
        NSLog(@"开关%@",@"是");
        
        [[TMCache sharedCache] setObject:@"1" forKey:@"PanetMineSound"];
        
    }else {
        NSLog(@"开关%@",@"否");
        [[TMCache sharedCache] setObject:@"0" forKey:@"PanetMineSound"];
    }
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////
////
////    switch (indexPath.row) {
////        case 0:
////        {
////            PanetMineAssetViewController *PanetMineAssetVC = [[PanetMineAssetViewController alloc] init];
////
////
////            [self.navigationController pushViewController:PanetMineAssetVC animated:YES];
////        }
////            break;
////
////        case 3:
////        {
////            PanetMineSettingViewController *PanetMineSettingVC = [[PanetMineSettingViewController alloc] init];
////
////
////            [self.navigationController pushViewController:PanetMineSettingVC animated:YES];
////        }
////            break;
////
////        default:
////            break;
////    }
//
//    if (indexPath.row == 1) {
//        PanetMineAddressViewController *PanetMineAddressSettingVC = [[PanetMineAddressViewController alloc] init];
//
//
//        [self.navigationController pushViewController:PanetMineAddressSettingVC animated:YES];
//    }
//}


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


//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
////    [self getUserScoreCenter];
//
//
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    
    
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
