////
////  InvitefriendViewController.m
////  BaBaTeng
////
////  Created by xyj on 2019/2/28.
////  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
////
//
//#import "InvitefriendViewController.h"
//#import <Photos/Photos.h>
//
//@interface InvitefriendViewController ()
//@property (nonatomic, strong) UIImageView *bgImageView;
//
//@property (nonatomic, strong) UIButton *lcopyBtn;
//@property (nonatomic, strong) UIButton *confrimBtn;
//@property (nonatomic, strong) UILabel *codeLabel;
//
//@end
//
//@implementation InvitefriendViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.title = @"邀请好友";
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self LoadChlidView];
//
//}
//
//- (void)LoadChlidView
//{
//
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64)];
//    NSLog(@"KDeviceHeight=====%f",KDeviceHeight);
//
//    bgImageView.image = [UIImage imageNamed:@"frend_invite"];
//    bgImageView.userInteractionEnabled = YES;
//    [self.view addSubview:bgImageView];
//
//    self.bgImageView = bgImageView;
//
//    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 73, kDeviceWidth - 50*2, 50)];
//    self.codeLabel.text = self.inviteCodeStr;
//    self.codeLabel.textAlignment = NSTextAlignmentCenter;
//    self.codeLabel.font = [UIFont boldSystemFontOfSize:67.0];
//    self.codeLabel.textColor = [UIColor colorWithRed:73/255.0 green:175/255.0 blue:254/255.0 alpha:1.0];
//    self.codeLabel.backgroundColor = [UIColor clearColor];
//
//
//    [self.view addSubview:self.codeLabel];
//
//    self.lcopyBtn = [[UIButton alloc] initWithFrame:CGRectMake(158, 143 , kDeviceWidth - 158*2, 36)];
//
//    self.lcopyBtn.backgroundColor = [UIColor orangeColor];
//    self.lcopyBtn.layer.cornerRadius=18.0f;
//    self.lcopyBtn.layer.masksToBounds = YES; //没这句话它圆不起来
//    [self.lcopyBtn setTitle:@"复制" forState:UIControlStateNormal];
//    [self.lcopyBtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.bgImageView addSubview:self.lcopyBtn];
//
//
//    UIButton *confrimBtn = [[UIButton alloc] initWithFrame:CGRectMake(133, KDeviceHeight - 80-44 , kDeviceWidth - 133*2, 44)];
//
//    confrimBtn.backgroundColor = [UIColor orangeColor];
//    confrimBtn.layer.cornerRadius=22.0f;
//    confrimBtn.layer.masksToBounds = YES; //没这句话它圆不起来
//    [confrimBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
//
//    [confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [self.bgImageView addSubview:confrimBtn];
//
//    self.confrimBtn = confrimBtn;
//
//    NSString *inviteCode = [NSString stringWithFormat:@"%@register/register.html?inviteCode=%@",BBT_HTTP_URL,self.inviteCodeStr];
//
//    NSLog(@"dddddddd======%@",inviteCode);
//
//    [self setErWeiMaWithUrl:inviteCode AndView:self.bgImageView];
//
//}
//
//- (void)setErWeiMaWithUrl:(NSString *)url AndView:(UIView *)View{
//    // 1、创建滤镜对象
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // 恢复滤镜的默认属性
//    [filter setDefaults];
//    // 2、设置数据
//    NSString *string_data = url;
//    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
//    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
//
//    // 设置过滤器的输入值, KVC赋值
//    [filter setValue:qrImageData forKey:@"inputMessage"];
//
//    // 3、获得滤镜输出的图像
//    CIImage *outputImage = [filter outputImage];
//    // 图片小于(27,27),我们需要放大
//    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
//    // 4、将CIImage类型转成UIImage类型
//    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
//
//    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
//    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
//    UIGraphicsBeginImageContext(start_image.size);
//    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
//    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
//    // 再把小图片画上去
//    NSString *icon_imageName = @"icon_image";
//    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
//    CGFloat icon_imageW = 200;
//    CGFloat icon_imageH = icon_imageW;
//    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
//    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
//    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
//    // 6、获取当前画得的这张图片
//    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
//    // 7、关闭图形上下文
//    UIGraphicsEndImageContext();
//    // 8、借助UIImageView显示二维码
//    UIImageView *imageView = [[UIImageView alloc] init];
//    //    imageView.backgroundColor = [UIColor redColor];
//    CGFloat imageViewW = 130;
//    CGFloat imageViewH = imageViewW;
//    CGFloat imageViewX = (kDeviceWidth - imageViewW)/2.0;
//    CGFloat imageViewY = CGRectGetMaxY(self.lcopyBtn.frame) + 60;
//    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    [View addSubview:imageView];
//    // 9、将最终合得的图片显示在UIImageView上
//    imageView.image = final_image;
//}
//
//
//
//- (void)copyBtnClicked
//{
//
//    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
//
//    pastboard.string = self.codeLabel.text;
//
//    [self showToastWithString:@"复制成功"];
//}
//
//- (void)confrimBtnClicked
//{
//    self.lcopyBtn.hidden = YES;
//    self.confrimBtn.hidden = YES;
//    [self savePhoto];
//}
//
//// 保存图片到相册功能，ALAssetsLibraryiOS9.0 以后用photoliabary 替代，
//-(void)savePhoto
//{
//    UIImage * image = [self captureImageFromView:self.view];
////    PHPhotoLibrary * library = [PHPhotoLibrary new];
////    NSData * data = UIImageJPEGRepresentation(image, 1.0);
//   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
////截图功能
//-(UIImage *)captureImageFromView:(UIView *)view
//{
//    CGRect screenRect = [view bounds];
//    UIGraphicsBeginImageContext(screenRect.size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:ctx];
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
//
//#pragma mark -- <保存到相册>
//-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//
//    self.lcopyBtn.hidden = NO;
//    self.confrimBtn.hidden = NO;
//
//    NSString *msg = nil ;
//    if(error){
////        msg = @"保存图片失败" ;
//        [self showToastWithString:@"保存失败"];
//    }else{
////        msg = @"保存图片成功" ;
//        [self showToastWithString:@"保存成功"];
//    }
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end



#import "InvitefriendViewController.h"
#import <Photos/Photos.h>

#import "NewPagedFlowView.h"


@interface InvitefriendViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *lcopyBtn;
@property (nonatomic, strong) UIButton *confrimBtn;
@property (nonatomic, strong) UILabel *codeLabel;

@property(nonatomic,strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) NSArray *ADImageArray;

@property(nonatomic,strong) PGIndexBannerSubiew *bannercopyView;
@property(nonatomic,strong) PGIndexBannerSubiew *bannerTcopyView;
@property(nonatomic,strong) PGIndexBannerSubiew *bannerScopyView;

@property(nonatomic, assign) NSInteger PageIndex;

@end

@implementation InvitefriendViewController

#pragma mark --轮播图

- (NewPagedFlowView *)pageFlowView
{
    if (_pageFlowView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64 - 75)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = NO;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;
        
        //        _pageFlowView.backgroundColor = [UIColor redColor];
        _pageFlowView.topBottomMargin = 100;
        //初始化pageControl
        //        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 32, kDeviceWidth, 8)];
        //        _pageFlowView.pageControl = pageControl;
        //        [_pageFlowView addSubview:pageControl];
        
        [_pageFlowView reloadData];
    }
    
    return _pageFlowView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ADImageArray = @[@"Zoomout-A",@"Zoomout-B", @"Zoomout-C"];
    
    self.PageIndex = 0;
    
    [self LoadChlidView];
    
}

- (void)LoadChlidView
{
    
    [self.view addSubview:self.pageFlowView];

//    self.lcopyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KDeviceHeight -44 - 64 , kDeviceWidth/2.0, 44)];
//
//
//
//    [self.lcopyBtn setBackgroundImage:[UIImage imageNamed:@"Invitefriend_copy"] forState:UIControlStateNormal];
//
//    [self.lcopyBtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:self.lcopyBtn];
    
    self.lcopyBtn = [[UIButton alloc]initWithFrame:CGRectMake(16,KDeviceHeight - 64 - 44 - 16 -kDevice_Is_iPhoneX  , (kDeviceWidth - 16*3)/2.0, 44)];
    
    self.lcopyBtn.backgroundColor = MNavBackgroundColor;
    self.lcopyBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.lcopyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lcopyBtn setTitle:@"复制邀请码" forState:UIControlStateNormal];
    
    [self.lcopyBtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.lcopyBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.lcopyBtn.layer.cornerRadius= 22.0f;
    
    self.lcopyBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.lcopyBtn];
    
    
//    UIButton *confrimBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0, KDeviceHeight -44 - 64 , kDeviceWidth/2.0, 44)];
//
//
//
//    [confrimBtn setBackgroundImage:[UIImage imageNamed:@"Invitefriend_save"] forState:UIControlStateNormal];
//
//    [confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [self.view addSubview:confrimBtn];
//
//    self.confrimBtn = confrimBtn;
    
    self.confrimBtn = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.lcopyBtn.frame) + 16,KDeviceHeight - 64 -44 - 16 -kDevice_Is_iPhoneX , (kDeviceWidth - 16*3)/2.0, 44)];
    
    self.confrimBtn.backgroundColor = MNavBackgroundColor;
    self.confrimBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.confrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confrimBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    
    [self.confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.confrimBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.confrimBtn.layer.cornerRadius= 22.0f;
    
    self.confrimBtn.clipsToBounds = YES;//去除边界
    
    [self.view addSubview:self.confrimBtn];
    
    
    //
    ////    NSString *inviteCode = [NSString stringWithFormat:@"%@register/register.html?inviteCode=%@",BBT_CZHTTP_URL,self.inviteCodeStr];
    //
    //    NSString *inviteCode = [NSString stringWithFormat:@"%@register/#/?inviteCode=%@",BBT_CZHTTP_URL,self.inviteCodeStr];
    //
    //    NSLog(@"dddddddd======%@",inviteCode);
    //
    //     [self setErWeiMaWithUrl:inviteCode AndView:self.bgImageView];
    //
    ////    /register/register.html?inviteCode=hsdjhfkjhs
    
    
    
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kDeviceWidth - 60, KDeviceHeight - 64 - 75 - 40);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",(long)pageNumber);
    
    self.PageIndex = pageNumber;
    
    //    self.bannercopyView = [flowView dequeueReusableCell];
    
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.ADImageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 15;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = [UIImage imageNamed:self.ADImageArray[index]];
    
    //    BulletinData *bulletindata = self.ADImageArray[index];
    //
    //
    //
    //    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.bulletinIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    //
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    //
    //    bannerView.mainImageView.backgroundColor = [UIColor purpleColor];
    
    //    NSString *inviteCode = [NSString stringWithFormat:@"%@register/register.html?inviteCode=%@",BBT_CZHTTP_URL,self.inviteCodeStr];
    
    NSString *inviteCode = [NSString stringWithFormat:@"%@register/#/?inviteCode=%@",BBT_HTTP_URL,self.inviteCodeStr];
    
    NSLog(@"dddddddd======%@",inviteCode);
    
    [self setErWeiMaWithUrl:inviteCode AndView:bannerView.mainImageView];
    
    //    if (index == 0) {
    //         self.bannercopyView = bannerView;
    //    }
    
    switch (index) {
        case 0:
            self.bannercopyView = bannerView;
            break;
            
        case 1:
            self.bannerTcopyView = bannerView;
            break;
            
        case 2:
            self.bannerScopyView = bannerView;
            break;
            
        default:
            self.bannercopyView = bannerView;
            break;
    }
    
    
    
    
    return bannerView;
}


- (void)setErWeiMaWithUrl:(NSString *)url AndView:(UIView *)View{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 2、设置数据
    NSString *string_data = url;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    // 再把小图片画上去
    NSString *icon_imageName = @"icon_image";
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = 200;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    // 8、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    //    imageView.backgroundColor = [UIColor redColor];
    CGFloat imageViewW = 84;
    
    if (kDevice_IS_PAD) {
        imageViewW = 120;
    }
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (kDeviceWidth -60 - imageViewW)/2.0;
    CGFloat imageViewY = KDeviceHeight - 64 - 44 - 84 - 115;
    if (kDevice_IS_PAD) {
        imageViewY = KDeviceHeight - 64 - 44 - 84 - 115 - 80;
    }
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [View addSubview:imageView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth -60 - 100)/2.0, CGRectGetMaxY(imageView.frame) + 9, 100 , 20)];
    
    
    titlelabel.text =[NSString stringWithFormat:@"%@",self.inviteCodeStr];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textColor = [UIColor colorWithRed:21/255.0 green:38/255.0 blue:35/255.0 alpha:1.0];
    titlelabel.backgroundColor = [UIColor clearColor];
//    titlelabel.layer.cornerRadius = 10.0;
//    titlelabel.layer.masksToBounds = YES;
    
    [View addSubview:titlelabel];
    
    
    // 9、将最终合得的图片显示在UIImageView上
    imageView.image = final_image;
}


- (void)copyBtnClicked
{
    
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = self.inviteCodeStr;
    
    [self showToastWithString:@"复制成功"];
}

- (void)confrimBtnClicked
{
    //    self.lcopyBtn.hidden = YES;
    //    self.confrimBtn.hidden = YES;
    
    [self savePhoto];
}

// 保存图片到相册功能，ALAssetsLibraryiOS9.0 以后用photoliabary 替代，
-(void)savePhoto
{
    
    //    UIImage *image = [self captureImageFromView:self.view];
    //    UIImage *image = [self captureImageFromView:self.pageFlowView];
    switch (self.PageIndex) {
        case 0:
        {
            // 设置绘制图片的大小
            UIGraphicsBeginImageContextWithOptions(self.bannercopyView.bounds.size, NO, 0.0);
            // 绘制图片
            [self.bannercopyView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
        case 1:
        {
            // 设置绘制图片的大小
            UIGraphicsBeginImageContextWithOptions(self.bannerTcopyView.bounds.size, NO, 0.0);
            // 绘制图片
            [self.bannerTcopyView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            
        case 2:
        {
            // 设置绘制图片的大小
            UIGraphicsBeginImageContextWithOptions(self.bannerScopyView.bounds.size, NO, 0.0);
            // 绘制图片
            [self.bannerScopyView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            
        default:
            break;
    }
    
}

//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    self.lcopyBtn.hidden = NO;
    self.confrimBtn.hidden = NO;
    
    NSString *msg = nil ;
    if(error){
        //        msg = @"保存图片失败" ;
        [self showToastWithString:@"保存失败"];
    }else{
        //        msg = @"保存图片成功" ;
        [self showToastWithString:@"保存成功"];
    }
}


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
