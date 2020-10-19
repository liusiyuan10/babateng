//
//  ForeignShopDetailViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/28.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "ForeignShopDetailViewController.h"
#import "ForeignDetailData.h"
#import "ForeignDetailModel.h"
#import "PanetRequestTool.h"
#import "UIImageView+AFNetworking.h"

#import "CoursePackage.h"
#import "CoursePackageData.h"
#import "SaveCourseOrder.h"
#import "PayCourseOrder.h"
#import "PayCourseOrderData.h"
#import "SaveCourseOrderData.h"

#import "QAlbumPayView.h"

#import "EnglishRequestTool.h"

#import "WXApi.h"

#import "NSString+Hash.h"
#import <AlipaySDK/AlipaySDK.h>

#import "CoursePayResultViewController.h"

#define kEndH 80
#define kScreenH [[UIScreen mainScreen] bounds].size.height

@interface ForeignShopDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,QAlbumPayViewDelegate>
{
    CGFloat minY;
    CGFloat maxY;
    // 是否显示底部视图，
    BOOL _isShowBottom;
}

@property(nonatomic,strong) UIView           *contentView;

@property(nonatomic,strong) UIScrollView     *middleView;
@property(nonatomic,strong) UIWebView        *webView;
@property(nonatomic,strong) UILabel          *bottomLab;
@property(nonatomic,strong) UILabel          *middleLab;

@property(nonatomic,strong) UIImageView *bgIamgeView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *buyLabel;

@property(nonatomic,strong) UIButton *buyBtn;
@property(nonatomic,strong) UIButton *buyShopBtn;

@property (nonatomic, strong)   NSString *outTradeNoStr;


@end

@implementation ForeignShopDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"课程详情";
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.middleView];
    [self.contentView addSubview:self.webView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForeignShopDetailSuccess:) name:@"ForeignShopDetailSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForeignShopDetailFailure:) name:@"ForeignShopDetailFailure" object:nil];
    
    
    [self LoadChlidView];

    [self GetcoursePackageDetail];

    
}

- (void)LoadChlidView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 21, kDeviceWidth - 32, KDeviceHeight - 64-21 -84)];
    
//    bgView.backgroundColor = [UIColor redColor];
    [bgView.layer setCornerRadius:15];
    [bgView.layer setBorderWidth:0.6];
    [bgView.layer setBorderColor:[UIColor colorWithWhite:0.85 alpha:1.0f].CGColor];
    
    [self.middleView addSubview:bgView];
    CGFloat bgViewH = KDeviceHeight - 64-21 -84;
    
    UIImageView *bgIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 32, 343/499.0 *bgViewH)];
    bgIamgeView.contentMode = UIViewContentModeScaleAspectFill;
    bgIamgeView.clipsToBounds = YES;
    bgIamgeView.image =[UIImage imageNamed:@"classdetail_empty"];
    [bgView addSubview:bgIamgeView];
    
    self.bgIamgeView = bgIamgeView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(bgIamgeView.frame) + 32/499.0 *bgViewH, kDeviceWidth - 72, 50)];
    titleLabel.textColor =[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    titleLabel.font=[UIFont boldSystemFontOfSize:21.0];
//    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor= [UIColor clearColor];
    titleLabel.text = @"巴巴腾在线少儿英语英语课程套餐一 (80节)";
    
    
    
    [bgView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
     UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(titleLabel.frame) + 17/499.0 *bgViewH, kDeviceWidth - 72, 16)];
    buyLabel.textColor =[UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1.0];
    buyLabel.font=[UIFont boldSystemFontOfSize:16.0f];

    buyLabel.backgroundColor= [UIColor clearColor];
    buyLabel.text = @"¥ 4800.00";
    [bgView addSubview:buyLabel];
    self.buyLabel = buyLabel;
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake( 111, CGRectGetMaxY(bgView.frame) -22 , kDeviceWidth- 111*2, 44)];
    
    self.buyBtn.backgroundColor = [UIColor orangeColor];
    self.buyBtn.layer.cornerRadius= 22.0f;

    self.buyBtn.clipsToBounds = YES;
    [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    [self.buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.middleView addSubview: self.buyBtn];
    
    UIButton *confrimBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth - 50)/2.0, KDeviceHeight - 70-44 , 50, 36)];
    
    confrimBtn.backgroundColor = [UIColor clearColor];
    [confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.middleView addSubview:confrimBtn];
    
    UILabel *confrimLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 43, 14)];
    confrimLabel.textColor =[UIColor colorWithRed:180/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    confrimLabel.font=[UIFont systemFontOfSize:14.0f];
    confrimLabel.textAlignment = NSTextAlignmentCenter;
    
    confrimLabel.backgroundColor= [UIColor clearColor];
    confrimLabel.text = @"详情页";
    [confrimBtn addSubview:confrimLabel];
    
    UIImageView *confrimIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake( (50 - 12)/2.0, CGRectGetMaxY(confrimLabel.frame) + 8, 12,13)];
    confrimIamgeView.contentMode = UIViewContentModeScaleAspectFill;
    confrimIamgeView.clipsToBounds = YES;
    confrimIamgeView.image =[UIImage imageNamed:@"Foreign_down"];
    confrimIamgeView.userInteractionEnabled = YES;
    [confrimBtn addSubview:confrimIamgeView];
    
    self.buyShopBtn = [[UIButton alloc] initWithFrame:CGRectMake( 0, KDeviceHeight - 64 - 48 , kDeviceWidth, 48)];
    
    self.buyShopBtn.backgroundColor = [UIColor orangeColor];

    [self.buyShopBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.buyShopBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.buyShopBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.webView addSubview: self.buyShopBtn];
    
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

- (void)GetcoursePackageDetail
{
    [self startLoading];
    
    [PanetRequestTool GetcoursePackageDetailPackageId:self.packageId success:^(ForeignDetailModel * _Nonnull respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
//            self.packageArr = respone.data;
//
//            [self.collectionView reloadData];
            
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)respone.data.packageImage, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
            [self.bgIamgeView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"classdetail_empty"]];
            
            self.titleLabel.text = respone.data.packageName;
            self.buyLabel.text = respone.data.totalPrice;
            
            
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)buyBtnClicked
{

    
    NSDictionary *parameter = @{@"packageId" :self.packageId , @"phoneNumber" : [[TMCache sharedCache] objectForKey:@"phoneNumber"] };
    [self startLoading];
    
    [PanetRequestTool PostSaveCourseOrder:parameter OrderFlag:@"2" success:^(SaveCourseOrder *respone) {
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.outTradeNoStr = respone.data.outTradeNo;
            
            QAlbumPayView *tfSheetView = [[QAlbumPayView alloc]init];
            
            tfSheetView.delegate = self;
            [tfSheetView showInView:self.view];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
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
        [EnglishRequestTool PostPayCourseOrder:parameter success:^(PayCourseOrder *respone) {
            
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
        [EnglishRequestTool PostPayCourseOrder:parameter success:^(PayCourseOrder *respone) {
            
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


#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.middleView)
    {
        if (offset <= self.middleView.contentSize.height -kScreenH  + kEndH)
        {
            self.middleLab.text = @"释放返回中间View";
        } else
        {
            self.middleLab.text = @"上拉显示底部View";
        }
    }else
    {
        // WebView中的ScrollView
        if (offset <= -kEndH)
        {
            self.bottomLab.text = @"释放返回中间View";
        } else
        {
            self.bottomLab.text = @"下拉返回中间View";
        }
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        CGFloat offset = scrollView.contentOffset.y;
        NSLog(@"----offset=%f",offset);
        if (scrollView == self.middleView)
        {
            if (offset < 0)
            {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        }
        else
        {
            minY = MIN(minY, offset);
        }
        // 滚到底部视图
        NSLog(@"----maxY=%f",maxY);
        NSLog(@"----contentSize=%f",self.middleView.contentSize.height);
        if (maxY >= self.middleView.contentSize.height - kScreenH + kEndH)
        {
            NSLog(@"----%@",NSStringFromCGRect(self.contentView.frame));
            _isShowBottom = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0,-kScreenH);
            } completion:^(BOOL finished) {
                maxY = 0.0f;
                _isShowBottom = YES;
            }];
        }
        
        // 滚到中间视图
        if (minY <= -kEndH && _isShowBottom)
        {
            NSLog(@"----minY=%f",minY);
            NSLog(@"----%@",NSStringFromCGRect(self.contentView.frame));
            _isShowBottom = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                minY = 0.0f;
            }];
        }
        
    }
}

- (void)confrimBtnClicked
{
    _isShowBottom = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0,-kScreenH);
    } completion:^(BOOL finished) {
        maxY = 0.0f;
        _isShowBottom = YES;
    }];
}


#pragma mark webViewdelge
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopLoading];
}


#pragma mark - getter/setter
- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, 0, kDeviceWidth, kScreenH * 2);
        _contentView.backgroundColor = [UIColor grayColor];
        
    }
    return _contentView;
}

- (UIScrollView *)middleView
{
    if (!_middleView)
    {
        _middleView = [[UIScrollView alloc] init];
        _middleView.backgroundColor = [UIColor whiteColor];
        _middleView.frame = CGRectMake(0, 0, kDeviceWidth, kScreenH);
        _middleView.contentSize = CGSizeMake(0, kScreenH + 60);
        _middleView.delegate = self;
        [_middleView addSubview:self.middleLab];
    }
    return _middleView;
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor orangeColor];
        _webView.frame = CGRectMake(0, kScreenH, kDeviceWidth, kScreenH);
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.autohome.com.cn/beijing/"]]];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@detail.html?packageId=%@",BBT_HTML,self.packageId]]]];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (UILabel *)bottomLab
{
    if (!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -kEndH, kDeviceWidth, kEndH)];
        _bottomLab.font = [UIFont systemFontOfSize:13.0f];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.text = @"下拉返回中间View";
        [self.webView.scrollView addSubview:_bottomLab];
    }
    return _bottomLab;
}

- (UILabel *)middleLab
{
    if (!_middleLab)
    {
        _middleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.middleView.contentSize.height, kDeviceWidth, kEndH)];
        _middleLab.font = [UIFont systemFontOfSize:13.0f];
        _middleLab.textAlignment = NSTextAlignmentCenter;
        _middleLab.backgroundColor = [UIColor purpleColor];
        _middleLab.text = @"上拉显示底部View";
        _middleLab.textColor = [UIColor blackColor];
    }
    return _middleLab;
}

@end
