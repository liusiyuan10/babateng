//
//  XECompletedDetailViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XECompletedDetailViewController.h"

#import "OrderDetailReceiveOneCell.h"
#import "OrderDetailTwoCell.h"

#import "OrderDetailReceiveThreeCell.h"

#import "OrderDetailCompletedFourCell.h"

#import "OrderDetailModel.h"

#import "OrderDetailDataModel.h"
#import "MineRequestTool.h"
#import "UIImageView+AFNetworking.h"
#import "BBTOrderDetailShopCell.h"

@interface XECompletedDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderDetailDataModel *orderdetaildata;

@end

@implementation XECompletedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
       self.view.backgroundColor = [UIColor whiteColor];
    [self LoadChlidView];
    
    [self getOrderDetail];
 
}

- (void)LoadChlidView
{
    
    
    CGFloat TableH = KDeviceHeight - kDevice_IsE_iPhoneX;
    
    
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
    
//    UIButton * experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,KDeviceHeight - 64-48,kDeviceWidth, 48)];
//    
//    experienceBtn.backgroundColor = MNavBackgroundColor;
//    experienceBtn.contentMode = UIViewContentModeScaleAspectFill;
//    
//    [experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [experienceBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//    
//    //    [experienceBtn addTarget:self action:@selector(experienceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    experienceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    
//    
//    [self.view addSubview:experienceBtn];
    
}

- (void)getOrderDetail
{
    [self startLoading];
    
    [MineRequestTool GetMallOrderDetailOrderId:self.orderid success:^(OrderDetailModel * _Nonnull response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.orderdetaildata = response.data;
            
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


#pragma mark --UITableView 代理函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0)
    {
        static NSString *cellIndentifier = @"OrderDetailCompletedOne";
        
        
        OrderDetailReceiveOneCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[OrderDetailReceiveOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }

        
        cell.NameLabel.text = self.orderdetaildata.receiverName;
        cell.phonenoLabel.text = self.orderdetaildata.receiverPhone;
        cell.addressLabel.text = self.orderdetaildata.receiverAddress;
        cell.orderStaueLabel.text = @"已完成";
        
        return cell;
        
        
    }
    else if (indexPath.row == 1)
    {
        static NSString *cellIndentifier = @"OrderDetailCompletedTwo";
        
        
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
        
        
        NSString *knowledgeRewardStr = [NSString stringWithFormat:@"%.2f",self.orderdetaildata.knowledgeReward ];
        NSString *goodsRebateStr = [NSString stringWithFormat:@"%.2f",self.orderdetaildata.goodsRebate ];
        
        if (self.orderdetaildata.knowledgeReward <= 0.00) {
            
           cell.rewardLabel.text = [NSString stringWithFormat:@"%@智力", [self removeFloatAllZeroByString:goodsRebateStr]];
        }
        else
        {
            cell.rewardLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力",[self removeFloatAllZeroByString:knowledgeRewardStr],[self removeFloatAllZeroByString:goodsRebateStr]];
        }
        
//        cell.rewardLabel.text =[NSString stringWithFormat:@"%.2f知识豆 %.2f智力",self.orderdetaildata.knowledgeReward,self.orderdetaildata.goodsRebate] ;
        
        return cell;
        
        
    }
    else if (indexPath.row == 2)
    {
        static NSString *cellIndentifierOne = @"OrderDetailCompletedThreecell";
        OrderDetailReceiveThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[OrderDetailReceiveThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        
        cell.ordernoLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.orderdetaildata.orderId];
        cell.ordertimeLabel.text = [NSString stringWithFormat:@"订单时间:%@",self.orderdetaildata.createTime];
        cell.paytimeLabel.text = [NSString stringWithFormat:@"支付时间:%@",self.orderdetaildata.payTime];
        
        if ([self.orderdetaildata.payType isEqualToString:@"1"])
        {
            cell.paytypeLabel.text = @"支付方式：支付宝支付";
        }
        else
        {
            cell.paytypeLabel.text = @"支付方式：微信支付";
        }
        
        
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *cellIndentifierOne = @"OrderDetailCompletedcell";
        OrderDetailCompletedFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[OrderDetailCompletedFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        
        cell.CouriercompanyLabel.text = [NSString stringWithFormat:@"快递公司:%@",self.orderdetaildata.companyName];
        cell.CourierorderLabel.text = [NSString stringWithFormat:@"快递单号:%@",self.orderdetaildata.expressNumber];
        cell.deliverytimeLabel.text = [NSString stringWithFormat:@"发货时间:%@",self.orderdetaildata.deliverTime];
        cell.confirmLabel.text = [NSString stringWithFormat:@"确认收货:%@",self.orderdetaildata.receiveTime];
        [cell.lcopyBtn addTarget:self action:@selector(lcopyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        static NSString *cellIndentifierOne = @"OrderDetailReceivecell";
        BBTOrderDetailShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
        
        if (!cell) {
            
            cell = [[BBTOrderDetailShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
            
        }
        
        
        cell.totalnoLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.goodsTotalPrice];
        cell.freightnoLabel.text =  [NSString stringWithFormat:@"+¥%.2f",self.orderdetaildata.logisticsCost];
        

//        cell.knowledgenoLabel.text =  [NSString stringWithFormat:@"¥%.2f",self.orderdetaildata.payKnowledgeReward];
        
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
            return 123+16;
            break;
            
        case 3:
            return 96+16;
            break;
            
        case 4:
            return 145+16+16;
            break;
            
        default:
            
            return 64;
            break;
    }
    
    
}

- (void)lcopyBtnClicked
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = self.orderdetaildata.expressNumber;
    
    [self showToastWithString:@"复制成功"];
}




@end
