//
//  XEPaymentDetailViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEPaymentDetailViewController.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"

#import "OrderDetailThreeCell.h"

#import "OrderDetailModel.h"

#import "OrderDetailDataModel.h"
#import "MineRequestTool.h"
#import "UIImageView+AFNetworking.h"

#import "HomeRequestTool.h"
#import "PanetKnInetlCommon.h"
//#import "XEAlbumPayView.h"
#import "BBTQAlertView.h"
#import "HCCountdown.h"

#import "QAlbumPayView.h"

#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"

#import "WXApi.h"

#import "NSString+Hash.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BBTOrderDetailShopCell.h"
#import "BBTOrderDetailNoShopCell.h"

@interface XEPaymentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,QAlbumPayViewDelegate>
{
    BBTQAlertView *_QalertView;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderDetailDataModel *orderdetaildata;

@property (nonatomic, strong) HCCountdown *countdown;

@property (nonatomic) long nowTimeSp;
@property (nonatomic) long fiveMinuteSp;

@property (nonatomic, copy) NSString *timeStr;

@end

@implementation XEPaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    [self LoadChlidView];
    
    self.timeStr = @"";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getOrderDetail];
    
    self.countdown = [[HCCountdown alloc] init];
    
    
}

- (void)LoadChlidView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    CGFloat TableH = KDeviceHeight - kDevice_IsE_iPhoneX - 48;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,kDeviceWidth, TableH)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 48 - 64 -kDevice_Is_iPhoneX, kDeviceWidth, 48)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth - 180, 48)];
    
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [cancelBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    

    
    cancelBtn.layer.borderWidth = 1.0f;
//
    cancelBtn.layer.borderColor = MNavBackgroundColor.CGColor;
//
//    cancelBtn.layer.cornerRadius= 5.0f;
//
    cancelBtn.clipsToBounds = YES;//去除边界
    
    
    [bottomView addSubview:cancelBtn];
    
    UIButton * experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 180,0,180, 48)];
    
    experienceBtn.backgroundColor = MNavBackgroundColor;
    experienceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [experienceBtn setTitle:@"去支付" forState:UIControlStateNormal];
    
    [experienceBtn addTarget:self action:@selector(experienceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    experienceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    
    [bottomView addSubview:experienceBtn];
    

}

- (void)getOrderDetail
{
    [self startLoading];
    
    [MineRequestTool GetMallOrderDetailOrderId:self.orderid success:^(OrderDetailModel * _Nonnull response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.orderdetaildata = response.data;
            
//            [self getNowTimeSP:@"等待付款" response.data.createTime];
            [self getNowTimeSP:@"等待付款" TimeStr:response.data.createTime];
            
            [self.tableView reloadData];
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}

- (void) didInBackground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入后台");
    [_countdown destoryTimer];
    
}

- (void) willEnterForground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入前台");
    [self getNowTimeSP:@"" TimeStr:@""];  //进入前台重新获取当前的时间戳，在进行倒计时， 主要是为了解决app退到后台倒计时停止的问题，缺点就是不能防止用户更改本地时间造成的倒计时错误
    
}

- (void) getNowTimeSP: (NSString *) string TimeStr:(NSString *)timestr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成NSString
    NSString *currentTimeString_1 = [formatter stringFromDate:datenow];
    NSDate *applyTimeString_1 = [formatter dateFromString:currentTimeString_1];
    _nowTimeSp = (long long)[applyTimeString_1 timeIntervalSince1970];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:timestr];
    
    if ([string isEqualToString:@"等待付款"]) {
        
        NSTimeInterval time = 48 *60 *60;//5分钟后的秒数
        NSDate *lastTwoHour = [datestr dateByAddingTimeInterval:time];
        NSString *currentTimeString_2 = [formatter stringFromDate:lastTwoHour];
        NSDate *applyTimeString_2 = [formatter dateFromString:currentTimeString_2];
        _fiveMinuteSp = (long)[applyTimeString_2 timeIntervalSince1970];
        
    }
    
    //时间戳进行倒计时
    long startLong = _nowTimeSp;
    long finishLong = _fiveMinuteSp;
    [self startLongLongStartStamp:startLong longlongFinishStamp:finishLong];
    
    NSLog(@"currentTimeString_1 = %@", currentTimeString_1);
    NSLog(@"_nowTimeSp = %ld", _nowTimeSp);
    NSLog(@"_fiveMinuteSp = %ld", _fiveMinuteSp);
    
}


#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0)
    {
        static NSString *cellIndentifier = @"OrderDetailOne";
        
        
        OrderDetailOneCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[OrderDetailOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
        
//        cell.NameLabel.text = @"店小二";
//        cell.phonenoLabel.text = @"15999223355";
//        cell.addressLabel.text = @"广东深圳固戍梧桐岛";

        cell.NameLabel.text = self.orderdetaildata.receiverName;
        cell.phonenoLabel.text = self.orderdetaildata.receiverPhone;
        cell.addressLabel.text = self.orderdetaildata.receiverAddress;
        cell.moneyLabel.text =[NSString stringWithFormat:@"¥%.2f 等待付款",self.orderdetaildata.orderTotalPrice] ;
        cell.timeLabel.text = self.timeStr;
        
        return cell;
        
        
    }
    else if (indexPath.row == 1)
    {
        static NSString *cellIndentifier = @"OrderDetailTwo";
        
        
        OrderDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[OrderDetailTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }

        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.orderdetaildata.goodsImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        
        [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_empty"]];
        
        cell.nameLabel.text = self.orderdetaildata.goodsName;

        cell.noLabel.text = [NSString stringWithFormat:@"数量:%@",self.orderdetaildata.goodsNumber];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.goodsUnitPrice] ;
        cell.noteLabel.text =[NSString stringWithFormat:@"备注信息 %@",self.orderdetaildata.orderRemark];
        
//        cell.rewardLabel.text =[NSString stringWithFormat:@"%.2f知识豆 %.2f智力",self.orderdetaildata.knowledgeReward,self.orderdetaildata.goodsRebate] ;
        
        NSString *knowledgeRewardStr = [NSString stringWithFormat:@"%.2f",self.orderdetaildata.knowledgeReward ];
        NSString *goodsRebateStr = [NSString stringWithFormat:@"%.2f",self.orderdetaildata.goodsRebate ];
        
        if (self.orderdetaildata.knowledgeReward <= 0.00) {
            
            cell.rewardLabel.text = [NSString stringWithFormat:@"%@智力", [self removeFloatAllZeroByString:goodsRebateStr]];
        }
        else
        {
            cell.rewardLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力",[self removeFloatAllZeroByString:knowledgeRewardStr],[self removeFloatAllZeroByString:goodsRebateStr]];
        }
        
        return cell;
        
        
    }
    else if (indexPath.row == 2)
    {
        static NSString *cellIndentifierOne = @"OrderDetailcell";
        OrderDetailThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[OrderDetailThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }


        cell.ordernoLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.orderdetaildata.orderId];
        cell.ordertimeLabel.text = [NSString stringWithFormat:@"订单时间:%@",self.orderdetaildata.createTime];
        
        return cell;
    }
    else
    {
        NSLog(@"----------%.2f",self.orderdetaildata.payKnowledgeReward);
        

            
            static NSString *cellIndentifierOne = @"OrderDetailReceivecell";
            BBTOrderDetailShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
            
            if (!cell) {
                
                cell = [[BBTOrderDetailShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                
            }
            
            
            cell.totalnoLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.goodsTotalPrice];
            cell.freightnoLabel.text =  [NSString stringWithFormat:@"+¥%.2f",self.orderdetaildata.logisticsCost];
        
        
        if (self.orderdetaildata.goodsDeduction > 0.0) {
            
            cell.knowledgenoLabel.hidden = NO;
            cell.knowledgeLabel.hidden = NO;
            cell.knowledgenoLabel.text =  [NSString stringWithFormat:@"-¥%.2f",self.orderdetaildata.goodsDeduction];
        }
        else
        {
            cell.knowledgenoLabel.hidden = YES;
            cell.knowledgeLabel.hidden = YES;
        }
     
        cell.rewardnoLabel.text = [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.orderTotalPrice];
            
            cell.rewardLabel.text = @"需付款";
             return cell;
    }
    
    
    
}


- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
            
            
        case 0:
            return 138 + 20;
            break;
            
        case 1:
            return 179 + 16;
            break;
            
        case 2:
            return 62+16;
            break;
            
        case 3:

            return 145+16+16;
     
            
            break;
        default:
            
            return 64;
            break;
    }
    
    
}


- (void)cancelBtnClicked
{
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确认要取消订单吗？"  andWithTag:1 andWithButtonTitle:@"取消",@"确认",nil];
    [_QalertView showInView:self.view];
    
    __block XEPaymentDetailViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            [self_c startLoading];
        
            [MineRequestTool PutMallOrderCancelOrderId:self_c.orderdetaildata.orderId success:^(PanetKnInetlCommon * _Nonnull response) {
        
                [self_c stopLoading];
                if ([response.statusCode isEqualToString:@"0"]) {
        
                    [self_c showToastWithString:@"取消成功"];
                    NSLog(@"111111111");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"XEMyOrderViewRefresh" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"XEPaymentViewRefresh" object:nil];
                    
                    [self_c.navigationController popViewControllerAnimated:YES];
        
                }
                else{
        
                    [self_c showToastWithString:response.message];
                }
        
        
            } failure:^(NSError * _Nonnull error) {
        
                [self_c stopLoading];
                [self_c showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
            }];

        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");
            
        }
    };
    
    

    
    
}

- (void)experienceBtnClicked
{
//    NSString *priceStr = [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.goodsTotalPrice];
//    XEAlbumPayView *tfSheetView = [[XEAlbumPayView alloc]init];
//
//    tfSheetView.delegate = self;
//    tfSheetView.priceStr = priceStr;
//    [tfSheetView showInView:self.view];
    

    
    QAlbumPayView *tfSheetView = [[QAlbumPayView alloc]init];
    
    tfSheetView.delegate = self;
    [tfSheetView showInView:self.view];
    

}

#pragma mark -- QAlbumPayViewDelegate
-(void)QAlbumPayViewBtnClicked:(QAlbumPayView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex
{
    
    NSLog(@"selectindex=========%ld",(long)selectindex);
    if(selectindex == 0)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.orderdetaildata.orderSn , @"payType" : @"1" };
        
        
        [self startLoading];
        [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PayCourseOrder *respone) {
            
            [self stopLoading];
            
            if ([respone.statusCode isEqualToString:@"0"]) {
                
                NSString *str = respone.data.bizContent;
                //
                NSLog(@"bizContent===========%@",str);
                
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:str fromScheme:@"BaBaTeng" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslutssssssssssss = %@",resultDic);
                    
                    
                }];
                
                
                
                
            }
            else
            {
                [self showToastWithString:respone.message];
            }
            
            
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
        }];
        
        
        
    }
    else if (selectindex == 1)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.orderdetaildata.orderSn  , @"payType" : @"2" };
        
        
        [self startLoading];
        [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PayCourseOrder *respone) {
            
            [self stopLoading];
            
            if ([respone.statusCode isEqualToString:@"0"]) {
                
                NSString *str = respone.data.bizContent;
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                
                req.partnerId           = respone.data.partnerid;
                req.prepayId            = respone.data.prepayid;
                req.nonceStr            = respone.data.noncestr;
                req.timeStamp           = respone.data.timestamp.intValue;
                req.package             = @"Sign=WXPay";
                req.sign                = respone.data.sign;
                
                
                
                NSLog(@"sing==========%@",req.sign);
                
                [WXApi sendReq:req];
                //
                NSLog(@"bizContent===========%@",str);
                
                
            }
            else
            {
                [self showToastWithString:respone.message];
            }
            
            
            
        } failure:^(NSError *error) {
            
            [self stopLoading];
            [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
            
        }];
        
    }else
    {
        [self showToastWithString:@"暂不支持"];
    }
    
}

//- (void)XEAlbumPayViewBtnClicked:(XEAlbumPayView *)view
//{
//    if (self.orderdetaildata.orderId.length == 0) {
//
//        [self showToastWithString:@"订单号不能为空"];
//    }
//
//    NSDictionary *parameter = @{@"payType" : @1, @"orderId": self.orderdetaildata.orderId, @"payNo": @"" };
//
////    [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
////
////        [self stopLoading];
////        if ([respone.statusCode isEqualToString:@"0"]) {
////
////            [self showToastWithString:@"支付成功"];
////            NSLog(@"111111111");
////
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"XEReceiveViewRefresh" object:nil];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"XEMyOrderViewRefresh" object:nil];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"XEPaymentViewRefresh" object:nil];
////
////            [self.navigationController popViewControllerAnimated:YES];
////
////        }
////        else{
////
////            [self showToastWithString:respone.message];
////        }
////
////    } failure:^(NSError * _Nonnull error) {
////        [self stopLoading];
////        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
////    }];
////
//
//}

///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long)strtL longlongFinishStamp:(long) finishL {
    __weak __typeof(self) weakSelf= self;
    
    NSLog(@"second = %ld, minute = %ld", strtL, finishL);
    
    [_countdown countDownWithStratTimeStamp:strtL finishTimeStamp:finishL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        
        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    
    NSLog(@"day=====%ld,hour=====%ld,minute=====%ld,second=====%ld",(long)day,(long)hour,(long)minute,(long)second);
    
    if (day==1) {
        hour = 24 + hour;
    }
    NSString *str_1 = [NSString stringWithFormat:@"%ld", (long)minute];
    NSString *str_2 = [NSString stringWithFormat:@"%ld", (long)hour];
    
    
    NSString *hourStr = @"";
    NSString *minuteStr = @"";
    if (hour<10) {
        

        hourStr = [NSString stringWithFormat:@"%@%@", @"0",str_2];
        
    }else{
        
        hourStr = str_2;
    }
    if (minute<10) {
        
        
        minuteStr = [NSString stringWithFormat:@"%@%@", @"0",str_1];
        
    }else{
        
        minuteStr = str_1;
    }
    
//    @"剩余时间：47小时50分钟";
    self.timeStr = [NSString stringWithFormat:@"剩余时间：%@小时%@分钟",hourStr,minuteStr];
    
    
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)dealloc {
    
    [_countdown destoryTimer];  //控制器释放的时候一点要停止计时器，以免再次进入发生错误
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
