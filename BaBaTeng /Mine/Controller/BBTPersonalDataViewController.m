//
//  BBTPersonalDataViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTPersonalDataViewController.h"
#import "PersonalDataCell.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Header.h"
#import "BBTBigChangePasswordViewController.h"
#import "BBTBigChangeNickNameViewController.h"
#import "CityListViewController.h"
#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"
#import "BBTResultRespone.h"
#import "BBTMainTool.h"
#import "CustomSheetView.h"
#import "BBTQAlertView.h"
#import "QiniuSDK.h"
#import "BBTLoginRequestTool.h"
#import "BBTUserInfo.h"
#import "BBTMineRequestTool.h"
#import "UIImageView+AFNetworking.h"
#import "BBTPersonalCenterViewController.h"

#import "HomeViewController.h"
#import "NewHomeViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface BBTPersonalDataViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,CityListViewDelegate,NickNameViewDelegate, UIAlertViewDelegate,CustomSheetViewDelegate>{

    BBTQAlertView *_QalertView;
 
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArrayOne;

@property (nonatomic, strong) NSMutableArray *dataArrayTwo;

@property (nonatomic, strong) UIImage *touxiangImage;


@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong)  BBTResultRespone *resultRespone;
@property (nonatomic, strong)  BBTUserInfo *resultTokenInfo;
@property (nonatomic, strong)  BBTUserInfo *userInfo;

@end

@implementation BBTPersonalDataViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    //适配iphone x
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight-150-kDevice_Is_iPhoneX) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.dataArrayOne = [NSMutableArray arrayWithObjects:@"头像",@"账号",@"昵称",@"地区",nil];
    
    self.dataArrayTwo = [NSMutableArray arrayWithObjects:@"修改密码", nil];
    
    
    
    UIButton *logOutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_nor"] forState:UIControlStateNormal];
    [logOutButton setBackgroundImage:[UIImage imageNamed:@"btn_hong_pre"] forState:UIControlStateHighlighted];
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [ logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [logOutButton addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    
    self.resultRespone=[[BBTResultRespone alloc]init];
    self.userInfo = [[BBTUserInfo alloc]init];
   // [self GETPersonalData];
    
    [self POSTTokenHead];
    
    // Do any additional setup after loading the view.
}


#pragma mark -- 获取个人资料
-(void)GETPersonalData{

   [BBTMineRequestTool GETPersonalData:^(BBTUserInfoRespone *registerRespone) {
       
   } failure:^(NSError *error) {
       
   }];
}

#pragma mark -- 修改个人头像和昵称
-(void)PUTResetPersonalData{

    
    [self startLoading];
    
     [BBTMineRequestTool PUTResetPersonalData:self.userInfo upload:^(BBTUserInfoRespone *registerRespone) {
         
         [self stopLoading];
         
         if ([registerRespone.statusCode isEqualToString:@"0"]) {
             
             [[TMCache sharedCache]setObject:registerRespone.data.accountStatus forKey:@"accountStatus"];
             [[TMCache sharedCache]setObject:registerRespone.data.bindDeviceNumber forKey:@"bindDeviceNumber"];
             [[TMCache sharedCache]setObject:registerRespone.data.createTime forKey:@"createTime"];
             [[TMCache sharedCache]setObject:registerRespone.data.nickName forKey:@"nickName"];
             [[TMCache sharedCache]setObject:registerRespone.data.onlineStatus forKey:@"onlineStatus"];
             [[TMCache sharedCache]setObject:registerRespone.data.userIcon forKey:@"userIcon"];
            
             
             
             [self.tableView reloadData];
             
         }else{
             
             [self showToastWithString:registerRespone.message];
         }
         
     } failure:^(NSError *error) {
         
         [self stopLoading];
         [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
     }];

}
#pragma mark -- 修改地址
-(void)editCityName:(NSString*)cityName{
    [self startLoading];
    
    [BBTMineRequestTool PUTResetPersonalAddressData:cityName upload:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            //self.resultTokenInfo =registerRespone.data;
            [[TMCache sharedCache]setObject:cityName forKey:@"userAddress"];
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
}

//+ (void)PUTResetPersonalData:

-(void)POSTTokenHead{
    
    [BBTLoginRequestTool POSTTokenHeadNowTimeTimestamp:[self getNowTimeTimestamp] upload:^(BBTUserInfoRespone *registerRespone) {
        
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {

             self.resultTokenInfo =registerRespone.data;


         }else{
         
         
         }

        
    } failure:^(NSError *error) {
        
    }];
}



//获取当前时间戳

-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



- (void)UpLoadPic:(UIImage *)UpImage
{
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//        builder.zone = [QNZone zone2];
    }];
    
    NSLog(@"self.resultTokenInfo.key ==%@",self.resultTokenInfo.key);
    NSLog(@"self.resultTokenInfo.token ==%@",self.resultTokenInfo.token);
    
    [self startLoading];
    
     NSData *imageData = UIImagePNGRepresentation(UpImage);
    //NSData *imageData =[self compressOriginalImage:UpImage toMaxDataSizeKBytes:80];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];

    [upManager putData:imageData key:self.resultTokenInfo.key token:self.resultTokenInfo.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok)
        {
            NSLog(@"请求成功");
            
             [self stopLoading];
            self.userInfo.userIcon = [NSString stringWithFormat:@"%@/%@",self.resultTokenInfo.domain,self.resultTokenInfo.key];
            
            NSLog(@"self.userInfo.userIcon ===== %@", self.userInfo.userIcon);
            
            [self PUTResetPersonalData];
        }
        else{
            NSLog(@"失败");
            
            [self stopLoading];
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:nil];
    

    
    
}


-(void)logOutAction{
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要退出登录吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block BBTPersonalDataViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
            [self_c LoginOutUser];
            
            [[NewHomeViewController getInstance] disconnectWithmKTopic];
            

    
        }
        if (titleBtnTag == 0) {
            
            NSLog(@"sg");
            
        }
    };

    
}

- (void)LoginOutUser
{
    [BBTLoginRequestTool GetloginOutParameter:nil success:^(BBTUserInfoRespone *respone) {
        
        
        
        [[TMCache sharedCache]removeObjectForKey:@"userId"];
        [[TMCache sharedCache]removeObjectForKey:@"token"];
        //            [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
        [[TMCache sharedCache]removeObjectForKey:@"password"];
        [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
        [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
        [[TMCache sharedCache]removeObjectForKey:@"createTime"];
        [[TMCache sharedCache]removeObjectForKey:@"nickName"];
        [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
        [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
        //        [[TMCache sharedCache] removeAllObjects];
        [[TMCache sharedCache]removeObjectForKey:@"currentTrackIcon"];
        
        [[TMCache sharedCache]removeObjectForKey:@"QdeviceTypeId"];
        [[TMCache sharedCache]removeObjectForKey:@"deviceId"];
        [[TMCache sharedCache]removeObjectForKey:@"HuanXinRegister"];
        [[TMCache sharedCache]removeObjectForKey:@"HuanXinLogin"];
        [[TMCache sharedCache] removeObjectForKey:@"YunZhiXunLogin"];
        
        
        [BBTMainTool setLoginRootViewController:CZKeyWindow];
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];

}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex==1) {
//        
//        [[TMCache sharedCache]removeObjectForKey:@"userId"];
//        [[TMCache sharedCache]removeObjectForKey:@"token"];
//        [[TMCache sharedCache]removeObjectForKey:@"phoneNumber"];
//        [[TMCache sharedCache]removeObjectForKey:@"password"];
//        [[TMCache sharedCache]removeObjectForKey:@"bindDeviceNumber"];
//        [[TMCache sharedCache]removeObjectForKey:@"accountStatus"];
//        [[TMCache sharedCache]removeObjectForKey:@"createTime"];
//        [[TMCache sharedCache]removeObjectForKey:@"nickName"];
//        [[TMCache sharedCache]removeObjectForKey:@"onlineStatus"];
//        [[TMCache sharedCache]removeObjectForKey:@"userIcon"];
//        //        [[TMCache sharedCache] removeAllObjects];
//        
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//        
//    }else{
//        
//        
//    }
//}

//-(void)delayMethod{
//    
//    [BBTMainTool setLoginRootViewController:CZKeyWindow];
//    
//}


- (void)getuserinfo:(NSString *)userName
{
    
    [self startLoading];
    
    
    [BBTLoginRequestTool getuserinfo:userName uploadPhone:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        
        if ([registerRespone.errcode isEqualToString:@"0"]) {
            
            self.resultRespone  =  registerRespone.result[0];
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:registerRespone.errinfo];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
    }];
    
    
}



#pragma mark - tableView delegate


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]init];
    
    UIView *headerLabelView = [[UIView alloc]init];
    
    headerLabelView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = BBT_THREE_FONT;
    label.textColor = MainFontColorTWO;
    if(section==0){
        
        headerView.frame = CGRectMake(0, 0, kDeviceWidth, 40);
        headerLabelView.frame = CGRectMake(0, 10, kDeviceWidth, 30);
        label.text = @"基础资料";
        headerView.backgroundColor = [UIColor whiteColor];
    }else{
        
        headerView.frame = CGRectMake(0, 0, kDeviceWidth, 50);
        headerLabelView.frame = CGRectMake(0, 20, kDeviceWidth, 30);
        
        
        headerView.backgroundColor = [UIColor clearColor];
        label.text = @"密保资料";
    }
    label.backgroundColor = [UIColor whiteColor];
    
    [headerLabelView addSubview:label];
    [headerView addSubview:headerLabelView];
    

        
    UIImageView *andImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,29.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
    andImageView.image = [UIImage imageNamed:@"line.png"];
        
    [headerLabelView addSubview:andImageView];
        
 
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        
        
        return self.dataArrayOne.count;
        
    }else{
        
        return self.dataArrayTwo.count;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    PersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[PersonalDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType=UITableViewCellAccessoryNone;
        //cell.contentView.backgroundColor = CellBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.rightImage.hidden = NO;
                    cell.rightImage.userInteractionEnabled = YES;
                    if (self.touxiangImage !=nil) {
                        
                        cell.rightImage.image = self.touxiangImage;
                        
                        [[BBTPersonalCenterViewController getInstance] updateImage: self.touxiangImage];
                        //
                    }else{
                        
                        NSLog(@"userIcon====%@",[[TMCache sharedCache] objectForKey:@"userIcon"]);
                        
                        [cell.rightImage setImageWithURL:[NSURL URLWithString: [[TMCache sharedCache] objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxian.png"]];
                        
                    }
                    
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
                    [cell.rightImage addGestureRecognizer:singleTap];
                    
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    [cell.nameLabel setText:self.dataArrayOne[indexPath.row]];
                    
                    
                }
                    break;
                    
                case 1:
                {
                    
                    cell.subNameLabel.hidden = NO;
                    [cell.nameLabel setText:self.dataArrayOne[indexPath.row]];
                    
                    //                    [cell.subNameLabel setText:self.resultRespone.phone];
                    
                    cell.subNameLabel.text = [[TMCache sharedCache] objectForKey:@"phoneNumber"];
                    
                }
                    break;
                    
                    
                case 2:
                {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    [cell.nameLabel setText:self.dataArrayOne[indexPath.row]];
                    if (IsStrEmpty([[TMCache sharedCache] objectForKey:@"nickName"])) {
                        
                        [cell.subNameLabel setText:@"点击设置"];
                        self.userInfo.nickName  = @" ";
                        
                    }else{
                        
                        [cell.subNameLabel setText:[[TMCache sharedCache] objectForKey:@"nickName"]];
                        
                        self.userInfo.nickName = cell.subNameLabel.text;
                    }
                    
                    
                    
                    
                    cell.subNameLabel.hidden = NO;
                }
                    break;
                    
                case 3:
                {
                    
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    [cell.nameLabel setText:self.dataArrayOne[indexPath.row]];
                    
                    if (IsStrEmpty([[TMCache sharedCache] objectForKey:@"userAddress"])) {
                        
                        [cell.subNameLabel setText:@"未知地区"];
                        self.userInfo.userAddress  = @" ";
                        
                    }else{
                        
                        
                        [cell.subNameLabel setText:[[TMCache sharedCache] objectForKey:@"userAddress"]];
                        
                        self.userInfo.userAddress = cell.subNameLabel.text;;
                    }
                    
                    
                    cell.subNameLabel.hidden = NO;
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    [cell.nameLabel setText:self.dataArrayTwo[indexPath.row]];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
    //    cell.leftImage.image = [UIImage imageNamed:self.dataImageArray[indexPath.row]];
    //    cell.nameLabel.text = self.dataArray[indexPath.row];
    //    cell.onlineLabel.text = @"无消息";
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    [self editPortrait];
                    
                    
                }
                    break;
                    
                case 1:
                {
                    
                    
                    
                }
                    break;
                    
                    
                case 2:
                {
                    
                    BBTBigChangeNickNameViewController *nickNameView = [[BBTBigChangeNickNameViewController alloc]init];
                    nickNameView.delegate = self;

        
                    [self.navigationController pushViewController:nickNameView animated:YES];
                }
                    break;
                    
                case 3:
                {
                    
                    CityListViewController *cityListView = [[CityListViewController alloc]init];
                    cityListView.delegate = self;
                    //热门城市列表
                    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
                    //历史选择城市列表
                    //cityListView.arrayHistoricalCity = [NSMutableArray arrayWithObjects:@"福州",@"厦门",@"泉州", nil];
                    //定位城市列表
                    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:@"深圳", nil];
                    
                    
                    [self.navigationController pushViewController:cityListView animated:YES];
                    
                    //  UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:cityListView];
                    
                    // [self presentViewController:navVC animated:YES completion:nil];
                    
                    
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
            
            
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    [self.navigationController pushViewController:[BBTBigChangePasswordViewController new] animated:YES];
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}




//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)didClickedWithNickName:(NSString*)nickName{

    self.userInfo.nickName =nickName;
    
      [self PUTResetPersonalData];
    
}
- (void)didClickedWithCityName:(NSString*)cityName
{
    
    NSLog(@"cityName==%@",cityName);
    
    //self.addressStr =cityName;
    
    
    
    // [_button setTitle:cityName forState:UIControlStateNormal];
    
    [self editCityName:cityName];
}
- (void)bindingWeChat:(SevenSwitch *)sender {
    
    NSLog(@"notice value to: %@", sender.on ? @"ON" : @"OFF");
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate] suspendButtonHidden:YES];
    
    //获取数据
    //NSLog(@"phone==%@",[[TMCache sharedCache] objectForKey:@"phone"]);
    //    [self getuserinfo:[[TMCache sharedCache] objectForKey:@"phone"]];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 访问系统相册

- (void)editPortrait {
    
    //    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"取消"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    //    [choiceSheet showInView:self.view];
    
    
    NSArray * ar = @[@"拍照",@"从相册中选择",@"取消"];
    
    CustomSheetView *sheet = [[CustomSheetView alloc] initWithBottomBtn:0 leftPoint:0 rightTitleData:ar];
    
    sheet.delegate = self;
    [self.view addSubview:sheet];
    
    
}

- (void)actionSheetDidSelect:(NSInteger)index{
    
    if (index == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 //  NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (index == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 // NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        // NSData *data = UIImageJPEGRepresentation(editedImage, 0.7);
        
        //self.portraitImageView.image = editedImage;
        //// [self.unitView addNewUnit:editedImage withName:data];
        
        // data=nil;
        
        self.touxiangImage =editedImage;
        
        
        [self UpLoadPic:editedImage];
        
        //[self.tableView reloadData];
    }];
    
    
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:NO completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        //NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
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
