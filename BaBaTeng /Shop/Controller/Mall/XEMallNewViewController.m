//
//  XEMallNewViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/16.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMallNewViewController.h"

#import "BBTQAlertView.h"
#import "XEMallOrderViewController.h"

#import "XEGoodDetailModel.h"
#import "XEGoodDataDetailModel.h"
#import "XEGoodsImageListDataModel.h"

#import "JKBannarView.h"
#import "HomeRequestTool.h"
#import "UIImageView+AFNetworking.h"
#import "LPLabel.h"


@interface XEMallNewViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIView *HeaderView;

@property(nonatomic,strong) UIWebView  *webView;

@property (nonatomic, strong) XEGoodDataDetailModel *gooddatamodel;
@property (nonatomic, strong) NSMutableArray *goodsImageListArr;

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *buyLabel;

@property(nonatomic,strong) UILabel *sellVolumeLabel;
@property(nonatomic,strong) UILabel *goodsDescLabel;
@property(nonatomic,strong) UIImageView *goodsDescimageView;
@property(nonatomic,strong) UIButton *buyShopBtn;

@property(nonatomic,strong) UILabel *specificationtextLabel;
@property(nonatomic,strong) UILabel *rewardtextLabel;

@property(nonatomic,strong)UILabel *freighttextLabel;

@property(nonatomic,strong) UILabel *scoreLabel;

@property(nonatomic,strong)UILabel *scoretextLabel;

@property (nonatomic,strong)  LPLabel *marketPriceLabel; //钱



@end

@implementation XEMallNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.goodsImageListArr = [[NSMutableArray alloc] init];
    
//      [self LoadChlidView];
      [self GetcoursePackageDetail];
}

- (void)LoadChlidView
{
    CGFloat bgViewH = 717 + 64 + 16 + 17;
    
    self.HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -bgViewH, kDeviceWidth, bgViewH)];
    
    self.HeaderView.backgroundColor = [UIColor clearColor];
    

    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 343  + 17, 150, 20)];
    buyLabel.textColor = MNavBackgroundColor;
    buyLabel.font=[UIFont boldSystemFontOfSize:24.0f];
    
    buyLabel.backgroundColor= [UIColor clearColor];
    buyLabel.text = @"¥ 4800.00";
    [self.HeaderView addSubview:buyLabel];
    self.buyLabel = buyLabel;
    
    self.marketPriceLabel=[[LPLabel alloc]init];
    self.marketPriceLabel.frame=CGRectMake(CGRectGetMaxX(self.buyLabel.frame), 343 + 20, 120, 11);
    self.marketPriceLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.marketPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.marketPriceLabel.font = [UIFont systemFontOfSize:12.0];
     self.marketPriceLabel.strikeThroughColor = [UIColor grayColor];
    self.marketPriceLabel.strikeThroughEnabled = YES;
    
    
    [self.HeaderView addSubview:self.marketPriceLabel];
    
    self.sellVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 100 - 15, 343 + 18, 100 , 11)];
    
    self.sellVolumeLabel.font = [UIFont systemFontOfSize:12.0];
    self.sellVolumeLabel.backgroundColor = [UIColor clearColor];
    self.sellVolumeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.sellVolumeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.HeaderView addSubview:self.sellVolumeLabel];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.buyLabel.frame) + 16 , kDeviceWidth - 32, 60)];
    titleLabel.textColor =[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    titleLabel.font=[UIFont boldSystemFontOfSize:21.0];
    //    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor= [UIColor clearColor];
    titleLabel.text = @"巴巴腾在线少儿英语英语课程套餐一 (80节)";
    
    
    
    [self.HeaderView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    self.goodsDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.titleLabel.frame) + 12 , kDeviceWidth - 32 , 46)];
    
    self.goodsDescLabel.font = [UIFont systemFontOfSize:12.0];
    self.goodsDescLabel.backgroundColor = [UIColor clearColor];
    self.goodsDescLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.goodsDescLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsDescLabel.numberOfLines = 0;
    
    [self.HeaderView addSubview:self.goodsDescLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.goodsDescLabel.frame) + 5, kDeviceWidth, 1.0)];

    lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];

    [self.HeaderView addSubview:lineView];
    
    UILabel *specificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(lineView.frame) + 17 , 50, 13)];
    specificationLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    specificationLabel.font=[UIFont systemFontOfSize:14.0];

    specificationLabel.backgroundColor= [UIColor clearColor];
    specificationLabel.text = @"规格";
    
    [self.HeaderView addSubview:specificationLabel];
    
    self.specificationtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(specificationLabel.frame), CGRectGetMaxY(lineView.frame) + 16 , 300 , 15)];
    
    self.specificationtextLabel.font = [UIFont systemFontOfSize:14.0];
    self.specificationtextLabel.backgroundColor = [UIColor clearColor];
    self.specificationtextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.specificationtextLabel.textAlignment = NSTextAlignmentLeft;
    self.specificationtextLabel.text = @"蓝月亮白增艳薰衣草洗衣液1000g*1";
    
    [self.HeaderView addSubview:self.specificationtextLabel];
    
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(specificationLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line1View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line1View];
    
    UILabel *rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line1View.frame) + 17 , 50, 13)];
    rewardLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    rewardLabel.font=[UIFont systemFontOfSize:14.0];
    
    rewardLabel.backgroundColor= [UIColor clearColor];
    rewardLabel.text = @"奖励";
    
    [self.HeaderView addSubview:rewardLabel];
    
    self.rewardtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rewardLabel.frame), CGRectGetMaxY(line1View.frame) + 16 , 300 , 15)];
    
    self.rewardtextLabel.font = [UIFont systemFontOfSize:14.0];
    self.rewardtextLabel.backgroundColor = [UIColor clearColor];
    self.rewardtextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.rewardtextLabel.textAlignment = NSTextAlignmentLeft;
    self.rewardtextLabel.text = @"赠送200知识豆；赠送33智力";
    
    [self.HeaderView addSubview:self.rewardtextLabel];
    
    
    UIImageView *line2View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(rewardLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line2View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line2View];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line2View.frame) + 17 , 50, 13)];
    freightLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    freightLabel.font=[UIFont systemFontOfSize:14.0];
    
    freightLabel.backgroundColor= [UIColor clearColor];
    freightLabel.text = @"运费";
    
    [self.HeaderView addSubview:freightLabel];
    
    self.freighttextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(freightLabel.frame), CGRectGetMaxY(line2View.frame) + 16 , 300 , 15)];
    
    self.freighttextLabel.font = [UIFont systemFontOfSize:14.0];
    self.freighttextLabel.backgroundColor = [UIColor clearColor];
    self.freighttextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.freighttextLabel.textAlignment = NSTextAlignmentLeft;
    self.freighttextLabel.text = @"免运费";
    
    [self.HeaderView addSubview:self.freighttextLabel];
    
    
    UIImageView *line3View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(freightLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line3View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line3View];
    

    
    UIImageView *deductionimageView = [[UIImageView alloc] initWithFrame:CGRectMake(16,  CGRectGetMaxY(line3View.frame) + 16, kDeviceWidth - 32, 64)];
    
//    deductionimageView.backgroundColor = [UIColor redColor];
    deductionimageView.image = [UIImage imageNamed:@"shopbeanBG"];
    
    [self.HeaderView addSubview:deductionimageView];
    
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 17 , 200 , 13)];
    
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentLeft;
    self.scoreLabel.text = @"";
    
    [deductionimageView addSubview:self.scoreLabel];
    
    self.scoretextLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(self.scoreLabel.frame) + 8 , 250 , 10)];
    
    self.scoretextLabel.font = [UIFont systemFontOfSize:10.0];
    self.scoretextLabel.backgroundColor = [UIColor clearColor];
    self.scoretextLabel.textColor = [UIColor whiteColor];
    self.scoretextLabel.textAlignment = NSTextAlignmentLeft;
    self.scoretextLabel.text = @"";
    
    [deductionimageView addSubview:self.scoretextLabel];
    
    
    UIImageView *line4View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(deductionimageView.frame) + 16, kDeviceWidth, 16)];
    
    line4View.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line4View];

    self.goodsDescimageView = [[UIImageView alloc] initWithFrame:CGRectMake(  (kDeviceWidth - 172) /2.0, CGRectGetMaxY(line4View.frame) + 16, 172, 17)];
    self.goodsDescimageView.image = [UIImage imageNamed:@"good_detail"];

    
    [self.HeaderView addSubview:self.goodsDescimageView];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.frame = CGRectMake(0, -20, kDeviceWidth, KDeviceHeight - 20);
    //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.autohome.com.cn/beijing/"]]];
    
//    NSString *htmls = [NSString stringWithFormat:@"<html> \n""<head> \n""<style type=\"text/css\"> \n""body {font-size:15px;}\n""</style> \n""</head> \n""<body>""<script type='text/javascript'>""window.onload = function(){\n""var $img = document.getElementsByTagName('img');\n""for(var p in  $img){\n"" $img[p].style.width = '100%%';\n""$img[p].style.height ='auto'\n""}\n""}""</script>%@""</body>""</html>",[NSString stringWithFormat:@"%@commodityDtl.html?goodsId=%@",BBT_HTML,self.packageId]];
//

//     [self.webView loadHTMLString:htmls baseURL:nil];
    
    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@commodityDtl.html?goodsId=%@",BBT_HTML,self.packageId]]]];
    
//    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmls]]];
    
    NSLog(@"sfddfd===%@",[NSString stringWithFormat:@"%@commodityDlt.html?goodsId=%@",BBT_HTML,self.packageId]);
    self.webView .delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(bgViewH, 0, 0, 0);
    
//    [self.webView setScalesPageToFit:YES];
    
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView addSubview:self.HeaderView];
    
    
    self.buyShopBtn = [[UIButton alloc] initWithFrame:CGRectMake( 0, KDeviceHeight - 48 , kDeviceWidth, 48)];
    
    self.buyShopBtn.backgroundColor = MNavBackgroundColor;
    
    [self.buyShopBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.buyShopBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.buyShopBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.buyShopBtn];
    
//
}


- (void)LoadNoChlidView
{
    CGFloat bgViewH = 621 + 64 + 16 + 17;
    
    self.HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -bgViewH, kDeviceWidth, bgViewH)];
    
    self.HeaderView.backgroundColor = [UIColor clearColor];
    
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 343  + 17, 150, 20)];
    buyLabel.textColor = MNavBackgroundColor;
    buyLabel.font=[UIFont boldSystemFontOfSize:24.0f];
    
    buyLabel.backgroundColor= [UIColor clearColor];
    buyLabel.text = @"¥ 4800.00";
    
    [self.HeaderView addSubview:buyLabel];
    self.buyLabel = buyLabel;
    
    self.marketPriceLabel=[[LPLabel alloc]init];
    self.marketPriceLabel.frame=CGRectMake(CGRectGetMaxX(self.buyLabel.frame), 343 + 20, 120, 11);
    self.marketPriceLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.marketPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.marketPriceLabel.font = [UIFont systemFontOfSize:12.0];
    self.marketPriceLabel.strikeThroughColor = [UIColor grayColor];
    self.marketPriceLabel.strikeThroughEnabled = YES;
    
    
    [self.HeaderView addSubview:self.marketPriceLabel];
    
    self.sellVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 100 - 15, 343 + 18, 100 , 11)];
    
    self.sellVolumeLabel.font = [UIFont systemFontOfSize:12.0];
    self.sellVolumeLabel.backgroundColor = [UIColor clearColor];
    self.sellVolumeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.sellVolumeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.HeaderView addSubview:self.sellVolumeLabel];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.buyLabel.frame) + 16 , kDeviceWidth - 32, 60)];
    titleLabel.textColor =[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    titleLabel.font=[UIFont boldSystemFontOfSize:21.0];
    //    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor= [UIColor clearColor];
    titleLabel.text = @"巴巴腾在线少儿英语英语课程套餐一 (80节)";
    
    
    
    [self.HeaderView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    self.goodsDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.titleLabel.frame) + 12 , kDeviceWidth - 32 , 46)];
    
    self.goodsDescLabel.font = [UIFont systemFontOfSize:12.0];
    self.goodsDescLabel.backgroundColor = [UIColor clearColor];
    self.goodsDescLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    self.goodsDescLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsDescLabel.numberOfLines = 0;
    
    [self.HeaderView addSubview:self.goodsDescLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.goodsDescLabel.frame) + 5, kDeviceWidth, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:lineView];
    
    UILabel *specificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(lineView.frame) + 17 , 50, 13)];
    specificationLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    specificationLabel.font=[UIFont systemFontOfSize:14.0];
    
    specificationLabel.backgroundColor= [UIColor clearColor];
    specificationLabel.text = @"规格";
    
    [self.HeaderView addSubview:specificationLabel];
    
    self.specificationtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(specificationLabel.frame), CGRectGetMaxY(lineView.frame) + 16 , 300 , 15)];
    
    self.specificationtextLabel.font = [UIFont systemFontOfSize:14.0];
    self.specificationtextLabel.backgroundColor = [UIColor clearColor];
    self.specificationtextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.specificationtextLabel.textAlignment = NSTextAlignmentLeft;
    self.specificationtextLabel.text = @"蓝月亮白增艳薰衣草洗衣液1000g*1";
    
    [self.HeaderView addSubview:self.specificationtextLabel];
    
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(specificationLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line1View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line1View];
    
    UILabel *rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line1View.frame) + 17 , 50, 13)];
    rewardLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    rewardLabel.font=[UIFont systemFontOfSize:14.0];
    
    rewardLabel.backgroundColor= [UIColor clearColor];
    rewardLabel.text = @"奖励";
    
    [self.HeaderView addSubview:rewardLabel];
    
    self.rewardtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rewardLabel.frame), CGRectGetMaxY(line1View.frame) + 16 , 300 , 15)];
    
    self.rewardtextLabel.font = [UIFont systemFontOfSize:14.0];
    self.rewardtextLabel.backgroundColor = [UIColor clearColor];
    self.rewardtextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.rewardtextLabel.textAlignment = NSTextAlignmentLeft;
    self.rewardtextLabel.text = @"赠送200知识豆；赠送33智力";
    
    [self.HeaderView addSubview:self.rewardtextLabel];
    
    
    UIImageView *line2View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(rewardLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line2View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line2View];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line2View.frame) + 17 , 50, 13)];
    freightLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    freightLabel.font=[UIFont systemFontOfSize:14.0];
    
    freightLabel.backgroundColor= [UIColor clearColor];
    freightLabel.text = @"运费";
    
    [self.HeaderView addSubview:freightLabel];
    
    self.freighttextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(freightLabel.frame), CGRectGetMaxY(line2View.frame) + 16 , 300 , 15)];
    
    self.freighttextLabel.font = [UIFont systemFontOfSize:14.0];
    self.freighttextLabel.backgroundColor = [UIColor clearColor];
    self.freighttextLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.freighttextLabel.textAlignment = NSTextAlignmentLeft;
    self.freighttextLabel.text = @"免运费";
    
    [self.HeaderView addSubview:self.freighttextLabel];
    
    
    UIImageView *line3View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(freightLabel.frame) + 16, kDeviceWidth, 1.0)];
    
    line3View.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line3View];
    

    
    UIImageView *line4View = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(line3View.frame), kDeviceWidth, 16)];
    
    line4View.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [self.HeaderView addSubview:line4View];
    
    self.goodsDescimageView = [[UIImageView alloc] initWithFrame:CGRectMake(  (kDeviceWidth - 172) /2.0, CGRectGetMaxY(line4View.frame) + 16, 172, 17)];
    self.goodsDescimageView.image = [UIImage imageNamed:@"good_detail"];
    
    
    [self.HeaderView addSubview:self.goodsDescimageView];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.frame = CGRectMake(0, -20, kDeviceWidth, KDeviceHeight - 20);
    //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.autohome.com.cn/beijing/"]]];
    
    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@commodityDtl.html?goodsId=%@",BBT_HTML,self.packageId]]]];
    NSLog(@"sfddfd===%@",[NSString stringWithFormat:@"%@commodityDlt.html?goodsId=%@",BBT_HTML,self.packageId]);
    
    self.webView .delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(bgViewH, 0, 0, 0);
    
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView addSubview:self.HeaderView];
    
    
    self.buyShopBtn = [[UIButton alloc] initWithFrame:CGRectMake( 0, KDeviceHeight - 48 , kDeviceWidth, 48)];
    
    self.buyShopBtn.backgroundColor = MNavBackgroundColor;
    
    [self.buyShopBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.buyShopBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.buyShopBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.buyShopBtn];
    
    //
}


- (void)LoadGoodImageView
{
    
//    CGFloat bgViewH = 717;
    
    if (self.goodsImageListArr.count >0) {
        
        JKBannarView *bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 343) viewSize:CGSizeMake(kDeviceWidth,343)];
        bannerView.items = self.goodsImageListArr;
        
        
        [self.HeaderView addSubview:bannerView];
    }

    
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    navImageView.image = [UIImage imageNamed:@"gradient"];
    navImageView.userInteractionEnabled = YES;
    
    UIButton *navbutton = [[UIButton alloc]initWithFrame:CGRectMake(17,24, 34, 34)];
    
    [navbutton setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [navbutton setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    //        button.backgroundColor = [UIColor whiteColor];
    
    [navbutton addTarget:self action:@selector(navbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navImageView addSubview:navbutton];
    
    [self.view addSubview:navImageView];
    

}

- (void)GetcoursePackageDetail
{
    [self startLoading];
    
    [HomeRequestTool GetGoodsDetailGoodsId:self.packageId success:^(XEGoodDetailModel * _Nonnull respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            if (respone.data.maxDeduction >0.0) {
                
                [self LoadChlidView];
            }
            else
            {
                 [self LoadNoChlidView];
            }
            

            self.titleLabel.text = respone.data.goodsName;
            
             NSString *sellPriceStr = [NSString stringWithFormat:@"%.2f",respone.data.sellPrice];

            self.buyLabel.text = [NSString stringWithFormat:@"¥%@", [self removeFloatAllZeroByString:sellPriceStr]];
            
            //            self.buyLabel.text = [NSString stringWithFormat:@"¥%.2f",respone.data.sellPrice];
            
            if (respone.data.marketPrice > 0.0) {
                
    
                self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价:%.2f",respone.data.marketPrice];
            }
            

            
            self.sellVolumeLabel.text = [NSString stringWithFormat:@"已兑购%@件",respone.data.sellVolume];
            
            self.goodsDescLabel.text = respone.data.goodsDesc;
            
            self.specificationtextLabel.text  = respone.data.goodsSpecification;
//            self.rewardtextLabel.text = respone.data.rewardKeyWords;
            
            
            NSString *knowledgeRewardStr = [NSString stringWithFormat:@"%.2f",respone.data.knowledgeReward];
            NSString *goodsRebateStr = [NSString stringWithFormat:@"%.2f",respone.data.goodsRebate];
            
            if (respone.data.knowledgeReward <= 0.00) {
               
                 self.rewardtextLabel.text = [NSString stringWithFormat:@"%@智力", [self removeFloatAllZeroByString:goodsRebateStr]];
            }
            else
            {
                self.rewardtextLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力", [self removeFloatAllZeroByString:knowledgeRewardStr], [self removeFloatAllZeroByString:goodsRebateStr]];
            }

//            if (respone.data.goodsRebate <= 0.00) {
//                
//                self.rewardtextLabel.text = [NSString stringWithFormat:@"%@知识豆", [self removeFloatAllZeroByString:knowledgeRewardStr]];
//            }
//            else
//            {
//                self.rewardtextLabel.text = [NSString stringWithFormat:@"%@知识豆 %@智力", [self removeFloatAllZeroByString:knowledgeRewardStr], [self removeFloatAllZeroByString:goodsRebateStr]];
//            }
            

            if (respone.data.goodsPostage.length == 0 || [respone.data.goodsPostage isEqualToString:@"0"]) {
               self.freighttextLabel.text = @"免运费";
            }
            else
            {
                 self.freighttextLabel.text = [NSString stringWithFormat:@"¥%@",respone.data.goodsPostage];
            }
            
           
            NSString *scoreStr = [NSString stringWithFormat:@"%.2f",respone.data.scoreValue];
            
            self.scoreLabel.text = [NSString stringWithFormat:@"共%@知识豆", [self removeFloatAllZeroByString:scoreStr]];
            
//            self.scoreLabel.text = [NSString stringWithFormat:@"共%.2f知识豆",respone.data.scoreValue];

             NSString *rateChangeStr = [NSString stringWithFormat:@"%.2f",respone.data.rateChange * respone.data.maxDeduction];
             NSString *maxDeductionStr = [NSString stringWithFormat:@"%.2f",respone.data.maxDeduction];
            
            self.scoretextLabel.text = [NSString stringWithFormat:@"最高可使用%@抵￥%@",[self removeFloatAllZeroByString:rateChangeStr],[self removeFloatAllZeroByString:maxDeductionStr]];
            
//            self.scoretextLabel.text = [NSString stringWithFormat:@"最高可使用%.2f抵￥%.2f",respone.data.rateChange * respone.data.maxDeduction,respone.data.maxDeduction];

            
            self.gooddatamodel = respone.data;
            

            
            for (int i = 0; i<respone.data.goodsImageList.count; i++) {
                XEGoodsImageListDataModel *listdata = [respone.data.goodsImageList objectAtIndex:i];
                
                [self.goodsImageListArr addObject:listdata.imageUrl];
            }
            NSLog(@"ss------------------%lu",(unsigned long)self.goodsImageListArr.count);
            
            [self LoadGoodImageView];
            
        }else{
         
            
            [self showToastWithString:respone.message];
            [self LoadGoodImageView];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        [self LoadGoodImageView];
        
    }];
    
}


- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
    
}
- (void)navbuttonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyBtnClicked
{
    
    XEMallOrderViewController *XEMallOrderVC = [[XEMallOrderViewController alloc] init];
    
    XEMallOrderVC.goodsId = self.packageId;
    XEMallOrderVC.goodsFaceImage = self.gooddatamodel.goodsFaceImage;
    XEMallOrderVC.goodsName = self.gooddatamodel.goodsName;
    XEMallOrderVC.sellPrice = self.gooddatamodel.sellPrice;
    XEMallOrderVC.goodsRebate = self.gooddatamodel.goodsRebate;
    XEMallOrderVC.storeSevicePhone = self.gooddatamodel.storeSevicePhone;
    
    XEMallOrderVC.goodsPostage = self.gooddatamodel.goodsPostage;
    XEMallOrderVC.peasRate = self.gooddatamodel.rateChange;
    
    XEMallOrderVC.maxDeduction = self.gooddatamodel.maxDeduction;
    
    XEMallOrderVC.rewardKeyWords = self.gooddatamodel.rewardKeyWords;
    XEMallOrderVC.scoreValue = self.gooddatamodel.scoreValue;
    XEMallOrderVC.knowledgeReward = self.gooddatamodel.knowledgeReward;
    
    [self.navigationController pushViewController:XEMallOrderVC animated:YES];
    
}


#pragma mark webViewdelge
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//     NSString *js=@"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth;"
//     "var maxwidth = %f;"
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "if(myimg.width > maxwidth){"
//     "oldwidth = myimg.width;"
//     "myimg.width = %f;"
//     "}"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);";
//     js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
//     [self.webView stringByEvaluatingJavaScriptFromString:js];
//     [self.webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
//    NSString *js = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
//    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
//
//    [self.webView stringByEvaluatingJavaScriptFromString:js];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
//    [self.webView stringByEvaluatingJavaScriptFromString:
//
//     @"var script = document.createElement('script');"
//
//     "script.type = 'text/javascript';"
//
//     "script.text = \"function ResizeImages() { "
//
//     "var myimg,oldwidth;"
//
//     "var maxwidth=300;" //缩放系数  改变参数控制图片缩放大小
//
//     "for(i=0;i <document.images.length;i++){"
//
//     "myimg = document.images[i];"
//
//     "if(myimg.width > maxwidth){"
//
//     "oldwidth = myimg.width;"
//
//     "myimg.width = maxwidth;"
//
//     "myimg.height = myimg.height * (maxwidth/oldwidth);"
//
//     "}"
//
//     "}"
//
//     "}\";"
//
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//
//
//
//    [self.webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
     [self stopLoading];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopLoading];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
//       self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"gradient"]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
//

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = MNavBackgroundColor;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
//       [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
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
