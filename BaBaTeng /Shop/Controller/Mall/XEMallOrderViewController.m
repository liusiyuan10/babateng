//
//  XEMallOrderViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMallOrderViewController.h"

#import "XEMallOrderOneCell.h"
#import "XEMallOrderTwoCell.h"
#import "XEMallOrderThreeCell.h"
#import "XEAlbumPayView.h"

#import "HomeRequestTool.h"

#import "PanetKnInetlCommon.h"

#import "UIImageView+AFNetworking.h"

#import "PanetMineAddressViewController.h"
#import "SaveOrderModel.h"
#import "BBTQAlertView.h"

#import "MineRequestTool.h"
#import "PanetMineAddressModel.h"
#import "PanetMineAddressListModel.h"
#import "BBTOrderThreeCell.h"
#import "BBTOrderFourCell.h"
#import "QAlbumPayView.h"

#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"

#import "WXApi.h"

#import "NSString+Hash.h"
#import <AlipaySDK/AlipaySDK.h>

#import "CoursePayResultViewController.h"

@interface XEMallOrderViewController ()<UITableViewDelegate,UITableViewDataSource,XEMallOrderTwoCellDelegate,QAlbumPayViewDelegate>
{
    BBTQAlertView *_QalertView;

}

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger ordercount;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, copy) NSString  *RemarkStr;

@property(nonatomic, copy) NSString  *addressStr;
@property(nonatomic, copy) NSString  *phonenumStr;
@property(nonatomic, copy) NSString  *nameStr;
@property(nonatomic, copy) NSString  *orderIdStr;

@property(nonatomic, assign) BOOL Ispreferential;
@property(nonatomic, assign) BOOL btnClicked;

@property (nonatomic, copy)   NSString *outTradeNoStr;


@end

@implementation XEMallOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写订单";
     
    self.ordercount = 1;
    self.RemarkStr = @"";
    [self LoadChlidView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForeignShopDetailSuccess:) name:@"ForeignShopDetailSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForeignShopDetailFailure:) name:@"ForeignShopDetailFailure" object:nil];
    
    [self GetAddress];
    
//    if (self.maxDeduction > 0.0 && self.scoreValue > 0.0 && self.scoreValue/self.peasRate > 0.01)
    if (self.maxDeduction > 0.0 )
    {
        self.Ispreferential = NO;
        
        self.btnClicked = NO;
    }
    else
    {
      self.Ispreferential = YES;
        
    }
    
    
}


- (void)LoadChlidView
{

    
    CGFloat TableH = KDeviceHeight - kDevice_IsE_iPhoneX - 47;
    
    
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

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 47 - 64 -kDevice_Is_iPhoneX, kDeviceWidth, 47)];

    bottomView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:bottomView];

    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 17, 17, 180, 15)];
    
    self.priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textColor = MNavBackgroundColor;
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    
//    CGFloat total =  self.sellPrice + [self.goodsPostage floatValue];
//
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.sellPrice + [self.goodsPostage floatValue]];
    
    [bottomView addSubview:self.priceLabel];
    
    UIButton * experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 140,0,140, 47)];

    experienceBtn.backgroundColor = MNavBackgroundColor;
    experienceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [experienceBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    
    [experienceBtn addTarget:self action:@selector(experienceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    experienceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];

    
    [bottomView addSubview:experienceBtn];
    
}

- (void)ForeignShopDetailSuccess:(NSNotification *)noti
{
    
    
    CoursePayResultViewController *PayResultVC = [[CoursePayResultViewController alloc] init];
    
    [self.navigationController pushViewController:PayResultVC animated:YES];
}


- (void)ForeignShopDetailFailure:(NSNotification *)noti
{
    [self showToastWithString:@"支付失败!"];
}


- (void)GetAddress
{

    [self startLoading];

    [MineRequestTool getPanetMineaddressnParameter:nil pageNum:@"1"  success:^(PanetMineAddressModel * _Nonnull respone) {

        [self stopLoading];

        if ([respone.statusCode isEqualToString:@"0"]) {


//            NSString *addressstr = [NSString stringWithFormat:@"%@ %@ %@ %@", listdata.province,listdata.city,listdata.area,listdata.address];
//
//            _block(addressstr,listdata.receiverPhone, listdata.receiverName);
            if ( respone.data.list.count > 0 ) {
                PanetMineAddressListModel *listdata = [respone.data.list objectAtIndex:0];

                self.addressStr = [NSString stringWithFormat:@"%@ %@ %@ %@", listdata.province,listdata.city,listdata.area,listdata.address];
                self.phonenumStr = listdata.receiverPhone;
                self.nameStr = listdata.receiverName;

                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:0 inSection:0];

                [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];

            }


//            [self.tableView reloadData];


        }

    } failure:^(NSError * _Nonnull error) {

    }];
}




#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.Ispreferential) {
        return 3;
    }
    else
    {
      return 4;
    }
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.Ispreferential) {
        
        if (indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"XEMallOrderOne";
            
            
            XEMallOrderOneCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if (!cell) {
                cell = [[XEMallOrderOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            if (self.addressStr.length == 0) {
                cell.NameLabel.text = @"请选择收货地址";
            }else
            {
                cell.NameLabel.text = self.nameStr;
                cell.phonenoLabel.text = self.phonenumStr;
                cell.addressLabel.text = self.addressStr;
            }
            
            return cell;
            
            
        }
        else if (indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"XEMallOrderTwo";
            
            
            XEMallOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if (!cell) {
                cell = [[XEMallOrderTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            
            cell.delegate = self;
            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.goodsFaceImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
            [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            
            cell.nameLabel.text = self.goodsName;
            
            NSString *sellPriceStr = [NSString stringWithFormat:@"%.2f",self.sellPrice];
            
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:sellPriceStr]];
            
            
//            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.sellPrice];
            [cell.phoneBtn addTarget:self action:@selector(phoneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
            
            
        }
        else
        {
            static NSString *cellIndentifierOne = @"XEMallOrdercell";
            XEMallOrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
            
            if (!cell) {
                
                cell = [[XEMallOrderThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                
            }
            
            
            

            
            CGFloat total = self.sellPrice * self.ordercount;
            
            NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
            
            cell.totalnoLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
            
//            cell.totalnoLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
            
            
            if (self.goodsPostage.length == 0) {
                cell.freightnoLabel.text = @"+¥0";
            }
            else
            {
                cell.freightnoLabel.text = [NSString stringWithFormat:@"+¥%@",self.goodsPostage];
            }

            

            
            NSString *knowledgeRewardStr = [NSString stringWithFormat:@"%.2f",self.knowledgeReward *self.ordercount];
            NSString *goodsRebateStr = [NSString stringWithFormat:@"%.2f",self.goodsRebate *self.ordercount];
            
            if (self.knowledgeReward <= 0.00) {
                
                cell.rewardnoLabel.text = [NSString stringWithFormat:@"%@智力", [self removeFloatAllZeroByString:goodsRebateStr]];
            }
            else
            {
            cell.rewardnoLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力",[self removeFloatAllZeroByString:knowledgeRewardStr],[self removeFloatAllZeroByString:goodsRebateStr]];
            }
            

            
            
            return cell;
        }
        
        
    }
    else
    {
        if (indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"XEMallOrderOne";
            
            
            XEMallOrderOneCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if (!cell) {
                cell = [[XEMallOrderOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            if (self.addressStr.length == 0) {
                cell.NameLabel.text = @"请选择收货地址";
            }else
            {
                cell.NameLabel.text = self.nameStr;
                cell.phonenoLabel.text = self.phonenumStr;
                cell.addressLabel.text = self.addressStr;
            }
            
            return cell;
            
            
        }
        else if (indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"XEMallOrderTwo";
            
            
            XEMallOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if (!cell) {
                cell = [[XEMallOrderTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            
            cell.delegate = self;
            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.goodsFaceImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
            [cell.leftImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_empty"]];
            
            cell.nameLabel.text = self.goodsName;
            
            NSString *sellPriceStr = [NSString stringWithFormat:@"%.2f",self.sellPrice];
            
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:sellPriceStr]];
            
//            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.sellPrice];
            
            
            [cell.phoneBtn addTarget:self action:@selector(phoneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
            
            
        }
        else if (indexPath.row == 2)
        {
            static NSString *cellIndentifierOne = @"XEMallOrdercell";
            BBTOrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
            
            if (!cell) {
                
                cell = [[BBTOrderThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                
            }
            
            CGFloat peasrate = self.ordercount *self.peasRate *  self.maxDeduction;
             CGFloat peasratec = self.ordercount * self.maxDeduction;
            
            
            
            if (self.scoreValue > peasrate) {
                NSString *peasrateStr = [NSString stringWithFormat:@"%.2f",peasrate];
                NSString *peasratecStr = [NSString stringWithFormat:@"%.2f",peasratec];
     
                cell.titleLabel.text = [NSString stringWithFormat:@"可使用%@知识豆抵￥%@",[self removeFloatAllZeroByString:peasrateStr],[self removeFloatAllZeroByString:peasratecStr]];
                
//                cell.titleLabel.text = [NSString stringWithFormat:@"可使用%.2f知识豆抵￥%.2f",peasrate,peasratec];
            }
            else
            {
                NSString *peasrateStr = [NSString stringWithFormat:@"%.2f",self.scoreValue];
                NSString *peasratecStr = [NSString stringWithFormat:@"%.2f",self.scoreValue/self.peasRate];
                
//                NSLog(@"ssddddd====%@",peasrateStr);
//                NSLog(@"ssdcccccc====%@",peasratecStr);
                
                cell.titleLabel.text = [NSString stringWithFormat:@"可使用%@知识豆抵￥%@",[self removeFloatAllZeroByString:peasrateStr],[self removeFloatAllZeroByString:peasratecStr]];
                
//                cell.titleLabel.text = [NSString stringWithFormat:@"可使用%.2f知识豆抵￥%.2f",self.scoreValue,self.scoreValue/self.peasRate];
            }
            
            
            

            
            if (self.btnClicked) {
                cell.chickBtn.selected = YES;
            }else
            {
                cell.chickBtn.selected = NO;
            }
            
            [cell.chickBtn addTarget:self action:@selector(chickBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            


             NSLog(@"11111111ddddfdfdfdfdfdf=========%d",cell.chickBtn.selected);
            
            return cell;
        }
        else{
            
            static NSString *cellIndentifierOne = @"XEMallOrdercell";
            BBTOrderFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
            
            if (!cell) {
                
                cell = [[BBTOrderFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
                
            }
            
            
            
            CGFloat total = self.sellPrice * self.ordercount;
            
            NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
            
            cell.totalnoLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
            
            
//            cell.totalnoLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
            
            
            if (self.goodsPostage.length == 0) {
                cell.freightnoLabel.text = @"+¥0";
            }
            else
            {
                cell.freightnoLabel.text = [NSString stringWithFormat:@"+¥%@",self.goodsPostage];
            }
     
            if (self.btnClicked) {
                
                CGFloat peasrate = self.ordercount *self.peasRate *  self.maxDeduction;
                NSLog(@"----------%.f",peasrate);
                
                
                if (self.scoreValue > peasrate) {
                    
                     NSString *knowledgenoStr = [NSString stringWithFormat:@"%.2f",self.ordercount *self.maxDeduction];
                     cell.knowledgenoLabel.text = [NSString stringWithFormat:@"-¥%@", [self removeFloatAllZeroByString:knowledgenoStr]];
                    
//                    cell.knowledgenoLabel.text = [NSString stringWithFormat:@"-%.2f",self.ordercount *self.maxDeduction];
                   
                }
                else
                {
                    NSString *knowledgenoStr = [NSString stringWithFormat:@"%.2f",self.scoreValue];
                    cell.knowledgenoLabel.text = [NSString stringWithFormat:@"-¥%@", [self removeFloatAllZeroByString:knowledgenoStr]];
                    
//                   cell.knowledgenoLabel.text = [NSString stringWithFormat:@"-%.2f", self.scoreValue];
                }
                
                
            }
            else
            {
//                 cell.knowledgenoLabel.text = [NSString stringWithFormat:@"%.2f",0.00];
                cell.knowledgenoLabel.text = @"¥0";
            }
          
            

            
            NSString *knowledgeRewardStr = [NSString stringWithFormat:@"%.2f",self.knowledgeReward *self.ordercount];
            NSString *goodsRebateStr = [NSString stringWithFormat:@"%.2f",self.goodsRebate *self.ordercount];
            
            //            cell.rewardnoLabel.text = [NSString stringWithFormat:@"%.2f知识豆 %.2f智力",self.knowledgeReward *self.ordercount,self.goodsRebate *self.ordercount];
            
            if (self.knowledgeReward <= 0.00) {
                
                cell.rewardnoLabel.text = [NSString stringWithFormat:@"%@智力", [self removeFloatAllZeroByString:goodsRebateStr]];
            }
            else
            {
                cell.rewardnoLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力",[self removeFloatAllZeroByString:knowledgeRewardStr],[self removeFloatAllZeroByString:goodsRebateStr]];
            }
//            cell.rewardnoLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力",[self removeFloatAllZeroByString:knowledgeRewardStr],[self removeFloatAllZeroByString:goodsRebateStr]];
            
            
            return cell;
        }
        
    }
    
    
    
    
    
}

- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.Ispreferential) {
        switch (indexPath.row) {
                
                
            case 0:
                return 90 + 16;
                break;
                
            case 1:
                return 278 + 16 + 16;
                break;
                
            case 2:
                return 60+16;
                break;
                
            case 3:
                return 118 + 16;
                break;
                
            default:
                
                return 145 + 16;
                break;
        }
        
    }
    else
    {
        switch (indexPath.row) {
                
                
            case 0:
                return 90 + 16;
                break;
                
            case 1:
                return 278 + 16 + 16;
                break;
                
            case 2:
                return 60+16;
                break;
                
            case 3:
                return 145 + 16;
                break;
                
            default:
                
                return 145 + 16;
                break;
        }
        
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 0) {
        
        PanetMineAddressViewController *PanetMineAddressSettingVC = [[PanetMineAddressViewController alloc] init];
        PanetMineAddressSettingVC.addressType = @"2";
        __weak __typeof(self) weakSelf = self;
        
        PanetMineAddressSettingVC.block = ^(NSString *addressStr, NSString *phonenumStr, NSString *nameStr) {
            NSLog(@"sdfsdfsdllls===%@    %@   %@",addressStr,phonenumStr,nameStr);
            weakSelf.addressStr = addressStr;
            weakSelf.phonenumStr = phonenumStr;
            weakSelf.nameStr = nameStr;
            NSIndexPath*indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [self.navigationController pushViewController:PanetMineAddressSettingVC animated:YES];
        
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//} 

- (void)XEMallOrderTwoCellBtnClicked:(XEMallOrderTwoCell *)view selectnum:(NSString *)numstr
{
    if (numstr.length >0) {
        NSLog(@"--------%@",numstr);
        
        if (self.Ispreferential) {
            
            self.ordercount = [numstr integerValue];
            
            NSIndexPath*indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
            
            [UIView performWithoutAnimation:^{
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            

            
            CGFloat total =  self.sellPrice * self.ordercount + [self.goodsPostage floatValue];
            
//            NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//
//            self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
            
            
            self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
            
            
        }
        else
        {
            self.ordercount = [numstr integerValue];
            
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];

            [UIView performWithoutAnimation:^{
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [UIView performWithoutAnimation:^{
                 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
     
   
            if (self.btnClicked) {
                
                CGFloat peasrate = self.ordercount *self.peasRate *  self.maxDeduction;
                CGFloat peasratec = 0.00;
                
                if (self.scoreValue > peasrate) {
                    peasratec = self.ordercount * self.maxDeduction;
                }
                else
                {
                    peasratec =   self.scoreValue/self.peasRate;
                }
                
                
                
                CGFloat total =  self.sellPrice * self.ordercount -peasratec + [self.goodsPostage floatValue];
                
//                NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//
//                self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
                
                self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
            }
            else
            {
                CGFloat total =  self.sellPrice * self.ordercount + [self.goodsPostage floatValue];
                
//                NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//
//                self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
                
                self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
            }
            
     
        }
        
    }
    else
    {
        self.ordercount = 0;
    }
    
}

- (void)XEMallOrderTextFieldEditDidEnd:(XEMallOrderTwoCell *)view Text:(NSString *)textstr
{
    self.RemarkStr = textstr;
}

- (void)chickBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    NSLog(@"ddddfdfdfdfdfdf=========%d",btn.selected);
    
    
    self.btnClicked = btn.selected;

    if (btn.selected) {
      NSLog(@"ssssss");
//        [btn setImage:[UIImage imageNamed:@"ic_gouxuan"] forState:UIControlStateNormal];

        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];



        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];

        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];





        CGFloat peasrate = self.ordercount *self.peasRate *  self.maxDeduction;
        CGFloat peasratec = 0.00;
        
        if (self.scoreValue > peasrate) {
            peasratec = self.ordercount * self.maxDeduction;
        }
        else
        {
            peasratec =   self.scoreValue/self.peasRate;
        }
        
        
        
        CGFloat total =  self.sellPrice * self.ordercount -peasratec + [self.goodsPostage floatValue];
        
//        NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
        
//        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",total];



    }
    else
    {
        NSLog(@"llllllll");
//           [btn setImage:[UIImage imageNamed:@"ic_weixuan"] forState:UIControlStateNormal];

        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];



        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];

        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];


        CGFloat total =  self.sellPrice * self.ordercount + [self.goodsPostage floatValue];
        
//        NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
//
//        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:totalStr]];
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",total];
        
    }
    
    
    
}



- (void)phoneBtnClicked
{
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"拨打电话" andWithMassage:[NSString stringWithFormat:@"拨打客服热线：%@",self.storeSevicePhone]  andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
            __block XEMallOrderViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self_c.storeSevicePhone];
            CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
            if (version >= 10.0) {
                /// 大于等于10.0系统使用此openURL方法
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");
            
        }
    };
}

- (void)experienceBtnClicked
{
    
 
    
    NSNumber *goodnumber = [NSNumber numberWithInteger:self.ordercount];

    if (self.addressStr.length == 0 &&self.nameStr.length == 0&&self.phonenumStr.length == 0) {
        [self showToastWithString:@"收货人地址不能为空"];
        return;
    }

    if (self.ordercount == 0) {
        [self showToastWithString:@"请选择购买数量"];
        return;
    }
    
    if (self.ordercount > 99) {
        [self showToastWithString:@"购买数量超过最大限制"];
        return;
    }
    
    if (self.RemarkStr.length == 0) {
        self.RemarkStr = @"";
    }

//    NSDictionary *parameter = @{@"appId" : @1, @"goodsId": self.goodsId, @"goodsNumber": goodnumber,@"orderRemark":  self.RemarkStr,@"orderSn":@"",@"receiverAddress":self.addressStr,@"receiverName": self.nameStr,@"receiverPhone":self.phonenumStr,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"]  };
    
    
      NSString *isUseStr = @"0";
    if (self.Ispreferential) {
        isUseStr = @"0";
        
    }
    else
    {
        if (self.btnClicked) {
            isUseStr = @"1";
        }
        else
        {
            isUseStr = @"0";
        }
    }
  

    
    
//    NSDictionary *parameter = @{@"appName" : @1, @"goodsDeduction" : @"10", @"goodsId": self.goodsId, @"goodsNumber": goodnumber,@"orderRemark":  self.RemarkStr,@"payKnowledgeReward": @"10",@"receiverAddress":self.addressStr,@"receiverName": self.nameStr,@"receiverPhone":self.phonenumStr,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"],@"isUse": isUseStr};
    
    NSDictionary *parameter = @{@"appName" : @1, @"goodsId": self.goodsId, @"goodsNumber": goodnumber,@"orderRemark":  self.RemarkStr,@"receiverAddress":self.addressStr,@"receiverName": self.nameStr,@"receiverPhone":self.phonenumStr,@"userId" : [[TMCache sharedCache] objectForKey:@"userId"],@"isUse": isUseStr};
    

    NSLog(@"-000------%@",parameter);

    [self startLoading];
    [HomeRequestTool PostMallOrderSaveMallOrderInfoParameter:parameter success:^(SaveOrderModel * _Nonnull respone) {

        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {

            NSLog(@"dfdfdfdfdf");
            
            self.outTradeNoStr = respone.data.orderSn;
            
            QAlbumPayView *tfSheetView = [[QAlbumPayView alloc]init];
            
            tfSheetView.delegate = self;
            [tfSheetView showInView:self.view];
            
//            self.orderIdStr = respone.data.orderId;
//
//            CGFloat total = self.sellPrice * self.ordercount;
//
//            NSString *priceStr = [NSString stringWithFormat:@"%.2f积分",total];
//            XEAlbumPayView *tfSheetView = [[XEAlbumPayView alloc]init];
//
//            tfSheetView.delegate = self;
//            tfSheetView.priceStr = priceStr;
//            [tfSheetView showInView:self.view];
            
            

        }
        else{

            [self showToastWithString:respone.message];
        }

    } failure:^(NSError * _Nonnull error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
    }];
    
    

    
}

#pragma mark -- QAlbumPayViewDelegate
-(void)QAlbumPayViewBtnClicked:(QAlbumPayView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex
{
    
    NSLog(@"selectindex=========%ld",(long)selectindex);
    if(selectindex == 0)
    {
        NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"1" };
        
        
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
        NSDictionary *parameter = @{@"outTradeNo" : self.outTradeNoStr , @"payType" : @"2" };
        
        
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
//
//
//    if (self.orderIdStr.length == 0) {
//
//        [self showToastWithString:@"订单号不能为空"];
//    }
//
//    NSDictionary *parameter = @{@"payType" : @1, @"orderId": self.orderIdStr, @"payNo": @"" };
//
//    [HomeRequestTool PostMallOrderPayMallOrderParameter:parameter success:^(PanetKnInetlCommon * _Nonnull respone) {
//
//        [self stopLoading];
//        if ([respone.statusCode isEqualToString:@"0"]) {
//
//            [self showToastWithString:@"支付成功"];
//
//            [self performSelector:@selector(GoToBack) withObject:nil afterDelay:2.0];
//
//
//        }
//        else{
//
//            [self showToastWithString:respone.message];
//        }
//
//    } failure:^(NSError * _Nonnull error) {
//        [self stopLoading];
//        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
//    }];
//
//
//}

- (void)GoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


@end
