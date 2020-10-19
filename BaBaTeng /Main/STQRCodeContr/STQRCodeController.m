//
//  STQRCodeController.m
//  STQRCodeController
//
//  Created by ST on 16/11/28.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "STQRCodeController.h"
#import "STQRCodeReaderView.h"
#import "STQRCodeAlert.h"

#import "NSBundle+STQRCodeController.h"
#import "EquipmentManuallyEnterViewController.h"

@interface STQRCodeController ()<STQRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
/** 1.读取二维码界面 */
@property(nonatomic, strong)STQRCodeReaderView *readview;
/** 2.图片探测器 */
@property(nonatomic, strong)CIDetector *detector;
@end

@implementation STQRCodeController

#pragma mark - --- 1.init 生命周期 ---

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    
    // 1.设置标题和背景色
    self.title = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.设置UIBarButtonItem， iOS8系统之后才支持本地扫描
    if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
        //        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbEvent)];
        //        self.navigationItem.rightBarButtonItem = rightItem;
        
        
        UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
        [rightbutton setTitle:@"相册" forState:UIControlStateNormal];
        [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(alumbEvent) forControlEvents:UIControlEventTouchUpInside];
        rightbutton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
        
    }
    
    //    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backEvent)];
    //    self.navigationItem.leftBarButtonItem = leftItem;
    
    //    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    [button setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    
    [self.view addSubview:self.readview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self authorizationStatus];
}

- (void)authorizationStatus{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self.readview startScan];
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange:) userInfo:nil repeats:YES];
    }else{
        [STQRCodeAlert showWithTitle:@"请在设置中开启摄像头权限"];
        [self.readview stopScan];
    }
}

- (void)observeAuthrizationStatusChange:(NSTimer *)sender{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [sender invalidate];
        [self.readview startScan];
    }
}

#pragma mark - --- 2.delegate 视图委托 ---
#pragma mark - --- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.获取图片信息
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    // 2.退出图片控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        
        NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
         CIQRCodeFeature *feature1 = [features objectAtIndex:0];
        NSLog(@"feature1==%@",feature1);
        NSLog(@"feature1.messageString==%@",feature1.messageString);
        NSLog(@"features==%@",features);
      
        if (features.count) { // 1.识别到二维码
            
            // 1.播放提示音
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle st_qrcodeControllerBundle] pathForResource:@"st_noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            // 2.显示扫描结果信息
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            //            [STQRCodeAlert showWithTitle:feature.messageString];
            
            NSLog(@"feature==%@",feature);
            NSLog(@"feature.messageString==%@",feature.messageString);
            if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
                [self.delegate qrcodeController:self readerScanResult:feature.messageString type:STQRCodeResultTypeSuccess];
//                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            //            [STQRCodeAlert showWithTitle:@"没有识别到二维码信息"];
            if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
                [self.delegate qrcodeController:self readerScanResult:nil type:STQRCodeResultTypeNoInfo];
//                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - --- STQRCodeReaderView Delegate

- (void)qrcodeReaderView:(STQRCodeReaderView *)qrcodeReaderView readerScanResult:(NSString *)readerScanResult
{
    // 1.播放提示音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle st_qrcodeControllerBundle] pathForResource:@"st_noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    // 2.显示扫描结果信息
    //    [STQRCodeAlert showWithTitle:readerScanResult];
    
    if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
        [self.delegate qrcodeController:self readerScanResult:readerScanResult type:STQRCodeResultTypeSuccess];
//        [self dismissViewControllerAnimated:YES completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.readview performSelector:@selector(startScan) withObject:nil afterDelay:2];
}

-(void)manuallyEnter{
    
    [self.navigationController pushViewController:[EquipmentManuallyEnterViewController new] animated:YES];
    NSLog(@"手动输入");
}

#pragma mark - --- 3.event response 事件相应 ---
- (void)backEvent
{
//    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alumbEvent
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        [STQRCodeAlert showWithTitle:@"未开启访问相册权限，请在设置中开始"];
    }else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }
}

#pragma mark - --- 4.private methods 私有方法 ---

#pragma mark - --- 5.setters 属性 ---

#pragma mark - --- 6.getters 属性 —--

- (STQRCodeReaderView *)readview
{
    if (!_readview) {
        _readview = [[STQRCodeReaderView alloc]init];
        _readview.delegate = self;
    }
    return _readview;
}

- (CIDetector *)detector
{
    if (!_detector) {
        _detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    }
    return _detector;
}
@end

