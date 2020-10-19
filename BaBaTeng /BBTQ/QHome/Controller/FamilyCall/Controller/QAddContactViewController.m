//
//  QAddContactViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QAddContactViewController.h"

#import "QEditContactCell.h"

#import "VPImageCropperViewController.h"

#import "CustomSheetView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "QRoleViewController.h"
#import "QiniuSDK.h"

#import "BBTUserInfo.h"

#import "BBTLoginRequestTool.h"
#import "BBTUserInfoRespone.h"

#import "QFamilyCallRequestTool.h"
#import "QFamilyEditContact.h"
#import "UIImageView+AFNetworking.h"


/** BXImageH */
#define imageH [UIScreen mainScreen].bounds.size.width*0.6
/** 滚动到多少高度开始出现 */
static CGFloat const startH = 0;

#define ORIGINAL_MAX_WIDTH 640.0f

@interface QAddContactViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,CustomSheetViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *IconView;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *lineOneView;
@property (nonatomic, strong) UIImageView *lineTwoView;
@property (nonatomic, strong) UIImageView *lineThreeView;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UITextField *numTextField;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *arrowOneView;
@property (nonatomic, strong) UISwitch *switchview;

@property (nonatomic, strong)  BBTUserInfo *resultTokenInfo;

@property (nonatomic, copy) NSString *Icon;


@property (nonatomic, copy) NSString *RoleName;

@property (nonatomic, copy) NSString *nicknameId;

@property (nonatomic, copy) NSString *IsCommn;




@end

@implementation QAddContactViewController

-(UIImageView *)IconView
{
    if (_IconView == nil) {
        
        _IconView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 64- 54, 27/667.0 *KDeviceHeight, 64/667.0 *KDeviceHeight, 64/667.0 *KDeviceHeight)];
        _IconView.image = [UIImage imageNamed:@"BBZL_icon_touxian"];
        _IconView.userInteractionEnabled = YES;
        _IconView.layer.cornerRadius = 32.0/667.0 *KDeviceHeight;
        _IconView.layer.masksToBounds = YES;
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_IconView addGestureRecognizer:singleTap];
        
    }
    
    return _IconView;
}

- (UIImageView *)arrowView
{
    
    if (_arrowView == nil) {
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 14- 24, 53/667.0 *KDeviceHeight, 14/667.0 *KDeviceHeight, 14/667.0 *KDeviceHeight)];
        _arrowView.image = [UIImage imageNamed:@"icon_more04"];
        
    }
    
    return _arrowView;
    
}

- (UIImageView *)arrowOneView
{
    
    if (_arrowOneView == nil) {
        
        _arrowOneView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 14- 24, 42/667.0 *KDeviceHeight, 14/667.0 *KDeviceHeight, 14/667.0 *KDeviceHeight)];
        _arrowOneView.image = [UIImage imageNamed:@"icon_more04"];
        
    }
    
    return _arrowOneView;
    
}

-(UIImageView *)lineView
{
    
    if (_lineView == nil) {
        
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 119/667.0 *KDeviceHeight, kDeviceWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
    }
    
    return _lineView;
    
}

-(UIImageView *)lineOneView
{
    
    if (_lineOneView == nil) {
        
        _lineOneView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 97/667.0 *KDeviceHeight, kDeviceWidth, 1)];
        _lineOneView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
    }
    
    return _lineOneView;
    
}

-(UIImageView *)lineTwoView
{
    
    if (_lineTwoView == nil) {
        
        _lineTwoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 97/667.0 *KDeviceHeight, kDeviceWidth, 1)];
        _lineTwoView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
    }
    
    return _lineTwoView;
    
}

-(UIImageView *)lineThreeView
{
    
    if (_lineThreeView == nil) {
        
        _lineThreeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 97/667.0 *KDeviceHeight, kDeviceWidth, 1)];
        _lineThreeView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
    }
    
    return _lineThreeView;
    
}

-(UITextField *)numTextField
{
    if (_numTextField == nil) {
        
        _numTextField = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth - 95 - 24, 39/667.0 *KDeviceHeight, 95, 20)];
        _numTextField.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
        _numTextField.font = [UIFont systemFontOfSize:14.0];
        
        _numTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        [_numTextField becomeFirstResponder];
        _numTextField.placeholder = @"输入手机号码";
//        _numTextField.text = @"13300803614";
        
    }
    
    return _numTextField;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 100 - 54, 39/667.0 *KDeviceHeight, 100, 20)];
        _nameLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
//        _nameLabel.text = @"爸爸";
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _nameLabel;
}


- (UISwitch *)switchview
{
    
    if (_switchview == nil) {
        
        _switchview = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth - 42 - 24, 36/667.0 *KDeviceHeight, 42, 23)];
        _switchview.onTintColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:9/255.0 alpha:1.0];
        //        _switchview.backgroundColor = [UIColor redColor];
        
        [_switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _switchview;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加联系人";
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QAddRoleRefresh:) name:@"QAddRoleRefresh" object:nil];
    
    self.IsCommn = @"0";
    
    [self POSTTokenHead];
    
    [self LoadChlidView];
    
    
    
    
}


- (void)LoadChlidView
{
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, (120 + 98 * 3)/667.0 *KDeviceHeight)];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=[UIColor clearColor];//DefaultBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(self.tableView.frame) + 70 /667.0 *KDeviceHeight, kDeviceWidth - 70, 74)];
    
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_key"] forState:UIControlStateNormal];
    
    //    self.saveBtn.backgroundColor = [UIColor redColor];
    
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.saveBtn];
    
}

-(void)switchAction:(id)sender
{
    
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        
        self.IsCommn = @"1";
        
    }
    else
    {
        self.IsCommn = @"0";
    }
}

- (void)saveBtnClicked
{
    
    if (self.Icon.length == 0) {
        self.Icon = @"";
    }
    
    if (self.numTextField.text.length == 0) {
        
        [self showToastWithString:@"手机号码不能为空"];
        return;
    }
    
    if (![self isMobileNumber:self.numTextField.text])
    {
        [self showToastWithString:@"手机号格式错误，请输入正确的手机号"];
        
        return;
    }
 

    
    
    if (self.nameLabel.text.length == 0) {
        
        [self showToastWithString:@"身份不能为空"];
        return;
    }
    

    
    if (self.nicknameId.length == 0)
    {
         [self showToastWithString:@"身份不能为空"];
        return;
    }
    
    

    
//    NSDictionary *parameter = @{@"phoneNumber" : self.numTextField.text, @"deviceId": [[TMCache sharedCache] objectForKey:@"deviceId"], @"icon": self.Icon,@"isCommon": self.IsCommn,@"nickName":self.nameLabel.text,@"nicknameId":self.nicknameId };
    
    NSDictionary *parameter = @{@"phoneNumber" : self.numTextField.text, @"deviceId": [[TMCache sharedCache] objectForKey:@"deviceId"], @"icon": self.Icon,@"isCommon": self.IsCommn,@"nicknameId":self.nicknameId };
    
    [self startLoading];
    [QFamilyCallRequestTool AddfamilyContactsParameter:parameter success:^(QFamilyEditContact *response) {
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
    
    
    
    
}


//简单匹配是否是 手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    if (mobileNum.length<11) {
        
        return NO;
    }
    
    //这个正则没有把176，177，178号段包括进去，应该改为
    //NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    //NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9]|6[0-9]|9[0-9]|2[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
    
}

- (void)QAddRoleRefresh:(NSNotification *)noti
{
    self.RoleName = [noti.userInfo objectForKey:@"RoleName"];
    
    self.nicknameId = [noti.userInfo objectForKey:@"RoleId"];
    
    [self.tableView reloadData];
}


#pragma mark - 数据源方法
// 每个分组中的数据总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // students数组中元素的数量
    // 取出数组中对应的学员信息
    //    HMStudent *stu = self.dataList[section];
    //    return stu.students.count;
    
    return 4;
    
    
}

// 告诉表格控件，每一行cell单元表格的细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"FamilyCallcellDetail";
    
    QEditContactCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QEditContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"头像";
            [cell.contentView addSubview:self.IconView];
            [cell.contentView addSubview:self.arrowView];
            [cell.contentView addSubview:self.lineView];
            
            break;
            
        case 1:
            cell.textLabel.text = @"电话";
            [cell.contentView addSubview:self.lineTwoView];
            
            [cell.contentView addSubview:self.numTextField];
            
            break;
            
        case 2:
            cell.textLabel.text = @"身份";
            //            cell.textLabel.text = self.RoleName;
            [cell.contentView addSubview:self.lineOneView];
            [cell.contentView addSubview:self.arrowOneView];
            [cell.contentView addSubview:self.nameLabel];
            if (self.RoleName.length == 0) {
                 self.nameLabel.text = @"设置身份";
            }
            else{
                self.nameLabel.text = self.RoleName;
            }
            
            
            break;
            
        case 3:
            cell.textLabel.text = @"设置为常用联系人";
            [cell.contentView addSubview:self.lineThreeView];
            [cell.contentView addSubview:self.switchview];
            
            break;
            
        default:
            cell.textLabel.text = @"最长通话";
            break;
    }
    
    //    cell.timeLabel.text = @"12月12日 10:52";
    //    cell.callTypeLabel.text = @"播出电话";
    //    cell.calltimeLabel.text = @"0分 48秒";
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        
        QRoleViewController *QRoleVC = [[QRoleViewController alloc] init];
        
//        if ([self.TypeString isEqualToString:@"Add"])
        QRoleVC.TypeString = @"Add";
        
        [self.navigationController pushViewController:QRoleVC animated:YES];
        NSLog(@"设置身份");
        
    }
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 120/667.0 *KDeviceHeight;
    }
    else
    {
        return 98.0/667.0 *KDeviceHeight;
    }
    
    
}

#pragma mark - 访问系统相册

- (void)editPortrait {
    
    //    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"取消"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    //    [choiceSheet showInView:self.view];
    
    [self.numTextField resignFirstResponder];
    
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
        
        self.IconView.image =editedImage;
//        [self.numTextField becomeFirstResponder];
        
        [self UpLoadPic:editedImage];
        
        
        
//        [_numTextField becomeFirstResponder];
        
        [self.tableView reloadData];
    }];
    
    
}

-(void)POSTTokenHead{
    
    [BBTLoginRequestTool POSTTokenHeadNowTimeTimestamp:[self getNowTimeTimestamp] upload:^(BBTUserInfoRespone *registerRespone) {
        
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            self.resultTokenInfo = registerRespone.data;
            
            
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
            self.Icon = [NSString stringWithFormat:@"%@/%@",self.resultTokenInfo.domain,self.resultTokenInfo.key];
            
             [self.numTextField becomeFirstResponder];
            
            NSLog(@"self.userInfo.userIcon ===== %@", self.Icon);
            
            
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
