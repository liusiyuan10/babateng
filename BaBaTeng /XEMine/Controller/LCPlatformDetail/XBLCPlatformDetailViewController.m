//
//  XBLCPlatformDetailViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/7/31.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XBLCPlatformDetailViewController.h"

@interface XBLCPlatformDetailViewController ()

@property (nonatomic, strong) UILabel *cardholderLabel;
@property (nonatomic, strong) UILabel *cardholdertextLabel;

@property (nonatomic, strong)UILabel *activationLabel;
@property (nonatomic, strong)UILabel *activationtextLabel;

@property (nonatomic, strong) UILabel *cardaccountLabel;
@property (nonatomic, strong)UILabel *cardaccounttextLabel;

@property (nonatomic, strong)UILabel *SalesLabel;
@property (nonatomic, strong)UILabel *SalestextLabel;


@end

@implementation XBLCPlatformDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"学习卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadChlidView];
}

- (void)LoadChlidView
{
    
    UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake( 16 ,16, kDeviceWidth - 32, 180)];
    
    if ([self.listdata.cardType isEqualToString:@"VIP学习卡"]) {
       iconImageview.image = [UIImage imageNamed:@"VIPcard"];
    }
    else if ([self.listdata.cardType isEqualToString:@"体验卡"])
    {
        iconImageview.image = [UIImage imageNamed:@"Experiencecard"];
    }
    else
    {
      iconImageview.image = [UIImage imageNamed:@"studycard"];
    }
    
    
    [self.view addSubview:iconImageview];
    
    
//    UILabel *iconnameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 22, 22, kDeviceWidth - 32 - 21*2, 20)];
//
//    iconnameLabel.font = [UIFont boldSystemFontOfSize:21.0];
//    iconnameLabel.backgroundColor = [UIColor clearColor];
//    iconnameLabel.textColor = [UIColor whiteColor];
//    iconnameLabel.text = @"在线少儿英语";
//    iconnameLabel.textAlignment = NSTextAlignmentLeft;
//
//    [iconImageview addSubview:iconnameLabel];
    
    UILabel *iconpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth -32 - 150)/2.0 - 30,77 , 150, 27)];
    
    iconpriceLabel.font = [UIFont boldSystemFontOfSize:28.0];
    iconpriceLabel.backgroundColor = [UIColor clearColor];
    iconpriceLabel.textColor = [UIColor whiteColor];
    iconpriceLabel.text = [NSString stringWithFormat:@"¥%@",self.listdata.cardPrice] ;
    
    iconpriceLabel.textAlignment = NSTextAlignmentCenter;
    
    [iconImageview addSubview:iconpriceLabel];

    UILabel *iconcardLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(iconpriceLabel.frame), 88, 100, 16)];
    
    iconcardLabel.font = [UIFont systemFontOfSize:16.0];
    iconcardLabel.backgroundColor = [UIColor clearColor];
    iconcardLabel.textColor = [UIColor whiteColor];
    iconcardLabel.text = self.listdata.cardType;
    iconcardLabel.textAlignment = NSTextAlignmentLeft;
    
    [iconImageview addSubview:iconcardLabel];
    
    UILabel *iconclassNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(iconcardLabel.frame) + 40, 150, 16)];
    
    iconclassNoLabel.font = [UIFont systemFontOfSize:16.0];
    iconclassNoLabel.backgroundColor = [UIColor clearColor];
    iconclassNoLabel.textColor = [UIColor whiteColor];
    iconclassNoLabel.text = [NSString stringWithFormat:@"课时数:%@节",self.listdata.studyTimes];
    iconclassNoLabel.textAlignment = NSTextAlignmentLeft;
    
    [iconImageview addSubview:iconclassNoLabel];
    
    
    UILabel *iconvalidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 200 -21 -32, CGRectGetMaxY(iconcardLabel.frame) + 40, 200, 16)];
    
    iconvalidityLabel.font = [UIFont systemFontOfSize:16.0];
    iconvalidityLabel.backgroundColor = [UIColor clearColor];
    iconvalidityLabel.textColor = [UIColor whiteColor];
    iconvalidityLabel.text = [NSString stringWithFormat:@"课程有效期:%@个月",self.listdata.validTime];
    iconvalidityLabel.textAlignment = NSTextAlignmentRight;
    
    [iconImageview addSubview:iconvalidityLabel];
    
    //iconnameLabel,iconpriceLabel,iconcardLabel ,iconclassNoLabel,iconvalidityLabel
    
    //卡号
    UILabel *cardnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(iconImageview.frame) + 31, 50, 17)];
    
    cardnoLabel.font = [UIFont systemFontOfSize:18.0];
    cardnoLabel.backgroundColor = [UIColor clearColor];
    cardnoLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    cardnoLabel.text = @"卡号:";
    cardnoLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardnoLabel];
    
    UILabel *cardnotextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardnoLabel.frame), CGRectGetMaxY(iconImageview.frame) + 31, 300, 17)];
    
    cardnotextLabel.font = [UIFont systemFontOfSize:18.0];
    cardnotextLabel.backgroundColor = [UIColor clearColor];
    cardnotextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    cardnotextLabel.text = self.listdata.cardNo;
    cardnotextLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardnotextLabel];
    
    //课时数
    UILabel *classnolabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(cardnoLabel.frame) + 18, 70, 17)];
    
    classnolabel.font = [UIFont systemFontOfSize:18.0];
    classnolabel.backgroundColor = [UIColor clearColor];
    classnolabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    classnolabel.text = @"课时数:";
    classnolabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:classnolabel];
    
    UILabel *classnotextlabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(classnolabel.frame), CGRectGetMaxY(cardnoLabel.frame) + 18, 300, 17)];
    
    classnotextlabel.font = [UIFont systemFontOfSize:18.0];
    classnotextlabel.backgroundColor = [UIColor clearColor];
    classnotextlabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    classnotextlabel.text = [NSString stringWithFormat:@"%@节",self.listdata.studyTimes];
    classnotextlabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:classnotextlabel];
    
    //课程有效期：
    UILabel *validityLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(classnolabel.frame) + 18, 100, 17)];
    
    validityLabel.font = [UIFont systemFontOfSize:18.0];
    validityLabel.backgroundColor = [UIColor clearColor];
    validityLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    validityLabel.text = @"课程有效期:";
    validityLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:validityLabel];
    
    UILabel *validitytextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(validityLabel.frame), CGRectGetMaxY(classnolabel.frame) + 18, 300, 17)];
    
    validitytextLabel.font = [UIFont systemFontOfSize:18.0];
    validitytextLabel.backgroundColor = [UIColor clearColor];
    validitytextLabel.textColor = MNavBackgroundColor;
    validitytextLabel.text = [NSString stringWithFormat:@"%@个月",self.listdata.validTime]; 
    validitytextLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:validitytextLabel];
    
    //卡面值：
    UILabel *cardpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(validityLabel.frame) + 18, 70, 17)];
    
    cardpriceLabel.font = [UIFont systemFontOfSize:18.0];
    cardpriceLabel.backgroundColor = [UIColor clearColor];
    cardpriceLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    cardpriceLabel.text = @"卡面值:";
    cardpriceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardpriceLabel];
    
    UILabel *cardpricetextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardpriceLabel.frame), CGRectGetMaxY(validityLabel.frame) + 18, 300, 17)];
    
    cardpricetextLabel.font = [UIFont systemFontOfSize:18.0];
    cardpricetextLabel.backgroundColor = [UIColor clearColor];
    cardpricetextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    cardpricetextLabel.text = [NSString stringWithFormat:@"¥%@",self.listdata.cardPrice];
    cardpricetextLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardpricetextLabel];
    
    //卡状态
    UILabel *cardstauesLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(cardpriceLabel.frame) + 18, 70, 17)];
    
    cardstauesLabel.font = [UIFont systemFontOfSize:18.0];
    cardstauesLabel.backgroundColor = [UIColor clearColor];
    cardstauesLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    cardstauesLabel.text = @"卡状态:";
    cardstauesLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardstauesLabel];
    
    UILabel *cardstauestextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardstauesLabel.frame), CGRectGetMaxY(cardpriceLabel.frame) + 18, 300, 17)];
    
    cardstauestextLabel.font = [UIFont systemFontOfSize:18.0];
    cardstauestextLabel.backgroundColor = [UIColor clearColor];
    cardstauestextLabel.textColor = MNavBackgroundColor;
//    cardstauestextLabel.text = @"5节";
    
    if ([self.listdata.cardStatus isEqualToString:@"1"]) {
        cardstauestextLabel.text = @"未激活";
    }else if ([self.listdata.cardStatus isEqualToString:@"2"])
    {
        cardstauestextLabel.text = @"待审核";
    }else if ([self.listdata.cardStatus isEqualToString:@"3"])
    {
        cardstauestextLabel.text = @"已激活";
    }else if ([self.listdata.cardStatus isEqualToString:@"4"])
    {
        cardstauestextLabel.text = @"已过期";
    }
    
    cardstauestextLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:cardstauestextLabel];
    
    //激活时间：
    
    self.activationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(cardstauesLabel.frame) + 18, 80, 17)];
    
    self.activationLabel.font = [UIFont systemFontOfSize:18.0];
    self.activationLabel.backgroundColor = [UIColor clearColor];
    self.activationLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.activationLabel.text = @"激活时间:";
    self.activationLabel.textAlignment = NSTextAlignmentLeft;
    self.activationLabel.hidden = YES;
    [self.view addSubview:self.activationLabel];
    
    self.activationtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.activationLabel.frame), CGRectGetMaxY(cardstauesLabel.frame) + 18, 300, 17)];
    
    self.activationtextLabel.font = [UIFont systemFontOfSize:18.0];
    self.activationtextLabel.backgroundColor = [UIColor clearColor];
    self.activationtextLabel.textColor = MNavBackgroundColor;
    self.activationtextLabel.text = self.listdata.activeTime;
    self.activationtextLabel.textAlignment = NSTextAlignmentLeft;
    self.activationtextLabel.hidden = YES;
    [self.view addSubview:self.activationtextLabel];
    
    // cardnoLabel,classnolabel,validityLabel,cardpriceLabel,cardstauesLabel,activationLabel
    
    if ([self.listdata.cardStatus isEqualToString:@"1"]|| [self.listdata.cardStatus isEqualToString:@"2"]) {
        self.activationLabel.hidden = YES;
        self.activationtextLabel.hidden = YES;
        
        self.cardholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(cardstauesLabel.frame) + 31, 70, 17)];
        self.cardholdertextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cardholderLabel.frame), CGRectGetMaxY(cardstauesLabel.frame) + 31, 300, 17)];
        
    }else if ([self.listdata.cardStatus isEqualToString:@"3"]||[self.listdata.cardStatus isEqualToString:@"4"])
    {
        self.activationLabel.hidden = NO;
        self.activationtextLabel.hidden = NO;
        self.cardholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.activationLabel.frame) + 31, 70, 17)];
        self.cardholdertextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cardholderLabel.frame), CGRectGetMaxY(self.activationLabel.frame) + 31, 300, 17)];
    }
    
    //cardholderLabel,cardaccountLabel,SalesLabel

    //持卡人：
    
    
    self.cardholderLabel.font = [UIFont systemFontOfSize:18.0];
    self.cardholderLabel.backgroundColor = [UIColor clearColor];
    self.cardholderLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.cardholderLabel.text = @"持卡人:";
    self.cardholderLabel.textAlignment = NSTextAlignmentLeft;
    
    self.cardholderLabel.hidden = YES;
    
    [self.view addSubview:self.cardholderLabel];
    
    
    
    self.cardholdertextLabel.font = [UIFont systemFontOfSize:18.0];
    self.cardholdertextLabel.backgroundColor = [UIColor clearColor];
    self.cardholdertextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.cardholdertextLabel.text = self.listdata.cardOwnerName;
    self.cardholdertextLabel.textAlignment = NSTextAlignmentLeft;
    
    self.cardholdertextLabel.hidden = YES;
    
    [self.view addSubview:self.cardholdertextLabel];
    
    //持卡账号：
    
    self.cardaccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.cardholderLabel.frame) + 18, 80, 17)];
    
    self.cardaccountLabel.font = [UIFont systemFontOfSize:18.0];
    self.cardaccountLabel.backgroundColor = [UIColor clearColor];
    self.cardaccountLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.cardaccountLabel.text = @"持卡账号:";
    self.cardaccountLabel.textAlignment = NSTextAlignmentLeft;
    self.cardaccountLabel.hidden = YES;
    
    [self.view addSubview:self.cardaccountLabel];
    
    self.cardaccounttextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cardaccountLabel.frame), CGRectGetMaxY(self.cardholderLabel.frame) + 18, 300, 17)];
    
    self.cardaccounttextLabel.font = [UIFont systemFontOfSize:18.0];
    self.cardaccounttextLabel.backgroundColor = [UIColor clearColor];
    self.cardaccounttextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.cardaccounttextLabel.text = self.listdata.cardOwnerPhone;
    self.cardaccounttextLabel.textAlignment = NSTextAlignmentLeft;
    self.cardaccounttextLabel.hidden = YES;
    
    [self.view addSubview:self.cardaccounttextLabel];
    
    //销售渠道：
    self.SalesLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.cardaccountLabel.frame) + 18, 80, 17)];
    
    self.SalesLabel.font = [UIFont systemFontOfSize:18.0];
    self.SalesLabel.backgroundColor = [UIColor clearColor];
    self.SalesLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.SalesLabel.text = @"销售渠道:";
    self.SalesLabel.textAlignment = NSTextAlignmentLeft;
    self.SalesLabel.hidden = YES;
    
    [self.view addSubview:self.SalesLabel];
    
    self.SalestextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.SalesLabel.frame), CGRectGetMaxY(self.cardaccounttextLabel.frame) + 18, 300, 17)];
    
    self.SalestextLabel.font = [UIFont systemFontOfSize:18.0];
    self.SalestextLabel.backgroundColor = [UIColor clearColor];
    self.SalestextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.SalestextLabel.text = self.listdata.saleChannle;
    self.SalestextLabel.textAlignment = NSTextAlignmentLeft;
    self.SalestextLabel.hidden = YES;
    
    [self.view addSubview:self.SalestextLabel];
    
    
    if ([self.listdata.cardStatus isEqualToString:@"1"]) {
        self.cardholderLabel.hidden = YES;
        self.cardholdertextLabel.hidden = YES;
        self.cardaccountLabel.hidden = YES;
        self.cardaccounttextLabel.hidden = YES;
        self.SalesLabel.hidden = YES;
        self.SalestextLabel.hidden = YES;

    }
    else if ([self.listdata.cardStatus isEqualToString:@"2"]){
        
        self.cardholderLabel.hidden = NO;
        self.cardholdertextLabel.hidden = NO;
        self.cardaccountLabel.hidden = NO;
        self.cardaccounttextLabel.hidden = NO;
        self.SalesLabel.hidden = YES;
        self.SalestextLabel.hidden = YES;
        
    }
    else{

        self.cardholderLabel.hidden = NO;
        self.cardholdertextLabel.hidden = NO;
        self.cardaccountLabel.hidden = NO;
        self.cardaccounttextLabel.hidden = NO;
        self.SalesLabel.hidden = NO;
        self.SalestextLabel.hidden = NO;
        
    }
    
    

    
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
