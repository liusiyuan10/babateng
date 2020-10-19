//
//  EquipmentInformationViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/5.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentInformationViewController.h"
#import "EquipmentRecommenlistViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

/** BXImageH */
#define imageH [UIScreen mainScreen].bounds.size.width*0.6
/** 滚动到多少高度开始出现 */
static CGFloat const startH = 0;

#define ORIGINAL_MAX_WIDTH 640.0f

@interface EquipmentInformationViewController ()<UITableViewDelegate,UITableViewDataSource,VPImageCropperDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 头部图片 */
@property (nonatomic, strong) UIImageView *headerImage;
/** 标题 */
@property (nonatomic, copy) NSString *titleName;
/** 导航条View */
@property (nonatomic, weak) UIView *navBarView;


@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, strong) UILabel *personalNameLabel;
@property (nonatomic, strong) UILabel *personalSubNameLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataImageArray;


@end

@implementation EquipmentInformationViewController



#pragma mark -control
- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}


#pragma mark - initView
-(void)initView{
    
    self.titleName = @"宝宝资料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120);
    tableView.contentInset = UIEdgeInsetsMake(imageH, 0, 49, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = CellBackgroundColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+10, kDeviceWidth - 20, 50)];
    [completeButton setImage:[UIImage imageNamed:@"btn_wanchen_nor"] forState:UIControlStateNormal];
    [completeButton setImage:[UIImage imageNamed:@"btn_wanchen_pre"] forState:UIControlStateSelected];
    [completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(0, -imageH, [UIScreen mainScreen].bounds.size.width, imageH);
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    [tableView insertSubview:headerImage atIndex:0];
    self.headerImage = headerImage;
    self.headerImage.image = [UIImage imageNamed:@"bL_6"];
    self.headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalCenterAction)];
    [self.headerImage addGestureRecognizer:singleTap];
    
    
    self.iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-90)/2,self.headerImage.frame.size.height-imageH/2-50, 90, 90)];
    self.iconImageview.layer.cornerRadius = self.iconImageview.frame.size.width / 2;
    self.iconImageview.layer.masksToBounds = YES;
    [self.iconImageview setImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    [headerImage addSubview:self.iconImageview];
    
    
    
    
    //    width                  = 15;
    //    UIImageView *arrow     = [[UIImageView alloc]initWithFrame:CGRectMake(Frame_Width - width - 10, (120 - width)/2+20, width, width)];
    //    arrow.contentMode      = UIViewContentModeScaleAspectFit;
    //    [arrow setImage:[UIImage imageNamed:@"圆角矩形-10"]];
    //    [headerImage addSubview:arrow];
    //
    self.personalNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImage.frame.size.height-imageH/2+50, kDeviceWidth,30)];
    [self.personalNameLabel setText:@"设置头像"];
    self.personalNameLabel.font = [UIFont boldSystemFontOfSize:19];
    self.personalNameLabel.textColor = [UIColor whiteColor];
    self.personalNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerImage addSubview:self.personalNameLabel];
//
//    self.personalSubNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImage.frame.size.height-imageH/2+80, kDeviceWidth,20)];
//    [self.personalSubNameLabel  setText:@"2个设备"];
//    self.personalSubNameLabel .font = [UIFont systemFontOfSize:15];
//    self.personalSubNameLabel .textColor = [UIColor whiteColor];
//    self.personalSubNameLabel.textAlignment = NSTextAlignmentCenter;
//    [headerImage addSubview:self.personalSubNameLabel ];
    //
    
    

    
}

-(void)completeAction{

    [self.navigationController pushViewController:[EquipmentRecommenlistViewController new] animated:YES];

}

#pragma mark -message center
-(void)message{
    
    
    //[self.navigationController pushViewController:[BBTMessageCenterViewController new] animated:YES];
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
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        cell.accessoryView.backgroundColor =CellBackgroundColor;
        cell.contentView.backgroundColor = CellBackgroundColor;
        //需要画一条横线
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,79.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
        topImageView.image = [UIImage imageNamed:@"line.png"];
        
        [cell.contentView addSubview:topImageView];
    }
    
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dataImageArray[indexPath.row]]];
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //[self.navigationController pushViewController:[[CustomRootViewController alloc]init] animated:YES];
    // [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //self.navigationController.navigationBar.hidden = YES;
    
    if (indexPath.row==0) {
        
      //  [self.navigationController pushViewController:[BBTBigHelpAndFeedbackViewController new] animated:YES];
        
    }else if (indexPath.row==1){
        
       // [self.navigationController pushViewController:[BBTBigAboutViewController new] animated:YES];
        
    }else{
        
        
        
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.titleName) {
        self.navigationItem.title = @"";
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > -imageH + startH) {
        CGFloat alpha = MIN(1, 1 - ((-imageH + startH + 64 - offsetY) / 64));
        
        self.navBarView.backgroundColor = BXAlphaColor(243, 126, 8, alpha);
        if (offsetY >= (-imageH + startH + 64)){
            if (self.titleName) {
                self.navigationItem.title = self.titleName;
            }
        }
    } else {
        
        self.navBarView.backgroundColor = BXAlphaColor(243, 126, 8, 0);
    }
    
    // ------------------------------华丽的分割线------------------------------------
    // 设置头部放大
    // 向下拽了多少距离
    CGFloat down = - imageH - scrollView.contentOffset.y;
    if (down < 0) return;
    
    CGRect frame = self.headerImage.frame;
    frame.origin.y = - imageH - down;
    frame.size.height = imageH + down;
    self.headerImage.frame = frame;
    
    // self.messageLabel.frame =CGRectMake(0, self.headerImage.frame.size.height-imageH/2+10,kDeviceWidth, imageH/2);
    
    self.iconImageview.frame =CGRectMake((kDeviceWidth-90)/2, self.headerImage.frame.size.height-imageH/2-50, 90, 90);
    
    self.personalNameLabel.frame =CGRectMake(0, self.headerImage.frame.size.height+50-imageH/2, kDeviceWidth,30);
    self.personalSubNameLabel.frame = CGRectMake(0, self.headerImage.frame.size.height-imageH/2+80, kDeviceWidth,20);
}



#pragma mark - Systems
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];//初始化
    self.dataArray = [NSMutableArray arrayWithObjects:@"宝宝昵称",@"宝宝生日",@"宝宝性别", nil];
    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_nicheng",@"BBZL_icon_shenri",@"icon_xinbie", nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
   // [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    //去掉分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];

    // [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    //self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - 访问系统相册
-(void)personalCenterAction{
    
    
    NSLog(@"personalCenterAction");
    // [self.navigationController pushViewController:[BBTPersonalDataViewController new] animated:YES];
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        // NSData *data = UIImageJPEGRepresentation(editedImage, 0.7);
        
        //self.portraitImageView.image = editedImage;
        //// [self.unitView addNewUnit:editedImage withName:data];
        
        // data=nil;
        
    
        [self.iconImageview setImage:editedImage];
      
    }];
    
    
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
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
        
    } else if (buttonIndex == 1) {
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



@end
