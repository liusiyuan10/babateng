//
//  AddmemberViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "AddmemberViewController.h"
#import "PlaceholderTextView.h"
#import "QmemberViewController.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"
#import "UIImageView+AFNetworking.h"
#import "BBTQAlertView.h"

@interface AddmemberViewController ()<UITextViewDelegate,UITextFieldDelegate,UISearchBarDelegate>{
 
      BBTQAlertView *_QalertView;

}

@property(nonatomic , strong)UISearchBar * searchBar;
@property(nonatomic , strong)UIView * headView;

@property (nonatomic, strong) PlaceholderTextView *textView;
@property(nonatomic, retain)UIScrollView *backScrollView;//添加tab切换

@property (nonatomic, strong) QMessageData *addrespone;

@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UIImageView *memberImageView;

@property (nonatomic, strong) UIButton *AddBtn;

@end

@implementation AddmemberViewController

- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        _backScrollView = [[UIScrollView alloc] init];
        
        //适配iphone x
        CGFloat myheight;
        if (kDevice_Is_iPhoneX==34) {
            myheight =24;
        }else{
            
            myheight =0;
            
        }
        _backScrollView.frame = CGRectMake(0,64+myheight, kDeviceWidth, self.view.size.height - 35);
       _backScrollView.contentSize = CGSizeMake(kDeviceWidth,KDeviceHeight-100);
        //
        _backScrollView.scrollEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator =  NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        //        _backScrollView.alwaysBounceHorizontal = YES;
        //_backScrollView.pagingEnabled = YES;
        _backScrollView.delegate = self;
        //_backScrollView.bounces = NO;
        //        _backScrollView.alwaysBounceVertical = YES;
        //        CGRect rc =_backScrollView.frame;
        
        _backScrollView.backgroundColor = [UIColor clearColor];
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _backScrollView;
}


- (PlaceholderTextView *)textView
{
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc] init];
//        _textView.frame = CGRectMake((kDeviceWidth-200)/3, 0, kDeviceWidth-(kDeviceWidth-200)/3*2, 110);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.textColor = [UIColor darkTextColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;

        _textView.placeholderColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0];
        _textView.placeholder =@"请留下附言内容";
        
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [[UIColor whiteColor] CGColor];
        //_textView.layer.borderColor = [UIColor light_Gray_Color].CGColor;//k233TextBorderColor.CGColor;
        _textView.layer.borderWidth = 1.0;
    }
    return _textView;
}


- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc]init];
        //适配iphone x
        CGFloat myheight;
        if (kDevice_Is_iPhoneX==34) {
            myheight =24;
        }else{
            
            myheight =0;
            
        }
        _headView.frame = CGRectMake(0, 0, kDeviceWidth, 20+myheight);
        
//        _headView.backgroundColor = [UIColor redColor];
    }
    return _headView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        //适配iphone x
        CGFloat myheight;
        if (kDevice_Is_iPhoneX==34) {
            myheight =12;
        }else{
            
            myheight = 0;
            
        }
//        _searchBar.frame = CGRectMake(12, 21+myheight, kDeviceWidth - 12 - 50, 28);
//        //        _searchBar.
////        _searchBar.backgroundColor = [UIColor redColor];
////
////
//        [_searchBar sizeToFit];
//        [_searchBar setPlaceholder:@"手机号码"];
//        _searchBar.text = self.searchstr;
//
//        [_searchBar setDelegate:self];
//        [_searchBar setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
//        [_searchBar setTranslucent:YES];//设置是否透明
//        [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
//
//
//        _searchBar.tintColor = [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
        
        _searchBar.frame = CGRectMake(12, 21+myheight, kDeviceWidth - 12 - 50, 28);
                   _searchBar.barStyle=UIBarStyleDefault;
                   _searchBar.searchBarStyle=UISearchBarStyleDefault;

                   
                   UIImageView *barImageView = [[[_searchBar.subviews firstObject] subviews] firstObject];
                   
                   barImageView.layer.borderColor = [UIColor orangeColor].CGColor;
                   barImageView.layer.borderWidth = 1;



             
                   _searchBar.placeholder=@"请输入关键字";
                    _searchBar.text = self.searchstr;
                   


                   

                   _searchBar.tintColor= [UIColor colorWithRed:83/255.0 green:121/255.0 blue:243/255.0 alpha:1.0];
                   _searchBar.barTintColor=[UIColor orangeColor];
                   

                   
                    UITextField *searchField=[_searchBar valueForKey:@"searchField"];
                    searchField.backgroundColor = [UIColor whiteColor];
             
                   [_searchBar setKeyboardType:UIKeyboardTypeDefault];
                   

           //        //输入框和输入文字的调整
           //        //白色的那个输入框的偏移
                   _searchBar.searchFieldBackgroundPositionAdjustment=UIOffsetMake(0, 0);
                   //输入的文字的位置偏移
                   _searchBar.searchTextPositionAdjustment=UIOffsetMake(0, 0);


                   //设置代理
                   _searchBar.delegate=self;
        
    }
    return _searchBar;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self LoadChlidView];
    
    //  [self GETFamilyPhoneNumber];
    
    
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes
{
  
    return YES;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
//{
//    if (searchBar.text.length > 11) {
//       
//        searchBar.text = [searchBar.text substringToIndex:11];
//        
//    }
//
//    
//}

-(void)GETFamilyPhoneNumber{

    
    [BBTMineRequestTool GETFamilyPhoneNumber:self.searchstr upload:^(QMessage *respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.addrespone =respone.data;
            
            self.memberImageView.hidden = NO;
            self.memberLabel.hidden = NO;
            self.textView.hidden = NO;
            self.AddBtn.hidden = NO;
            
            [self.memberImageView setImageWithURL:[NSURL URLWithString:self.addrespone.userIcon] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
            self.memberLabel.text =  self.addrespone.nickName;

            
        }else{
            
            //[self showToastWithString:respone.message];
            
            
            self.memberImageView.hidden = YES;
            self.memberLabel.hidden = NO;
            self.memberLabel.text =respone.message;
            self.textView.hidden = YES;
            self.AddBtn.hidden = YES;
        }
        
        
    }failure:^(NSError *error) {
        
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];


}

- (void)LoadChlidView
{
    // 创建搜索框

    [self.view addSubview:self.backScrollView];
    
    //适配iphone x
    CGFloat myheight;
    if (kDevice_Is_iPhoneX==34) {
        myheight =24;
    }else{
        
        myheight =0;
        
    }
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64+myheight)];
    navView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:navView];
    
    [navView addSubview:self.headView];
    
//    for (UIView *view in self.searchBar.subviews) {
//
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }//去掉搜索周围的灰色
        
    [navView addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    //适配iphone x
    CGFloat myheight1;
    if (kDevice_Is_iPhoneX==34) {
        myheight1 =16;
    }else{
        
        myheight1 =0;
        
    }
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBar.frame), 21 + 12+myheight1, 32, 20)];
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelBtn setTitleEdgeInsets:(]
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:cancelBtn];
    
    CGFloat pageImageY;
    CGFloat textViewheight;
    //适配ipad；
    if ([IphoneType IFChangeCoordinates]) {
        
        pageImageY = 100;
        textViewheight =80;
        
    }else{
        
        pageImageY = 132;
        textViewheight =146;
        
    }
    
    
    self.memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (kDeviceWidth - pageImageY)/2.0, 20, pageImageY, pageImageY)];
    self.memberImageView.backgroundColor = [UIColor clearColor];

    self.memberImageView.layer.cornerRadius = pageImageY/2;
    
    self.memberImageView.clipsToBounds = YES;
     self.memberImageView.hidden = YES;
    [self.backScrollView addSubview:self.memberImageView];
    
    self.memberLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.memberImageView.frame) + 21, kDeviceWidth, 16)];
    
   // self.memberLabel.text = @"张三";
    self.memberLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    self.memberLabel.font = [UIFont systemFontOfSize:17.0];
    
    self.memberLabel.textAlignment = NSTextAlignmentCenter;
    
    self.memberLabel.hidden = YES;
    [self.backScrollView addSubview:self.memberLabel];
    
    self.textView.frame = CGRectMake(17, CGRectGetMaxY(self.memberLabel.frame) + 31, kDeviceWidth - 34, textViewheight);
    
     self.textView.hidden = YES;
    
    [self.backScrollView addSubview:self.textView];
    
     self.AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(self.textView.frame) + 50, kDeviceWidth - 34, 54)];
    
     self.AddBtn.layer.cornerRadius = 11.0f;
     self.AddBtn.backgroundColor = [UIColor orangeColor];
    [ self.AddBtn setTitle:@"邀请TA加入" forState:UIControlStateNormal];
    [ self.AddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.AddBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.AddBtn.hidden = YES;
    [self.AddBtn addTarget:self action:@selector(AddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backScrollView addSubview: self.AddBtn];
    
    
    
}

- (void)cancelBtnClicked
{
    [self.searchBar resignFirstResponder];
    //[self.navigationController popViewControllerAnimated:YES];
   // [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddBtnClicked
{
    
    
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:[NSString stringWithFormat:@"您确认邀请%@进入群聊吗?",self.addrespone.nickName] andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block AddmemberViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
            [self_c startLoading];
            [BBTMineRequestTool POSTReceiverId:self_c.addrespone.userId FamilyId:self_c.familyId Message:self_c.textView.text upload:^(QMessage *respone) {
                
                [self_c stopLoading];
                
                if ([respone.statusCode isEqualToString:@"0"]) {
                    
                    [self_c showToastWithString:@"要求成功，等待对方接受"];
                    
                    [self_c performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
                    
                    
                }else{
                    
                    [self_c showToastWithString:respone.message];
                    
                }
                
            } failure:^(NSError *error) {
                [self_c showToastWithString:@"网络连接失败，请检查您的网络设置"];
                [self_c stopLoading];
            }];

            
            
        }
        if (titleBtnTag == 0) {
            
            
        }
    };

    
    //    QmemberViewController *memberVc = [[QmemberViewController alloc] init];
//    
//    [self.navigationController pushViewController:memberVc animated:YES];
//    
    
}

-(void)delayMethod{

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark----UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.searchstr =searchBar.text;
    
    [self.searchBar resignFirstResponder];
    
    
//    if (![self isMobileNumber:self.searchstr]) {
//        
//        [self showToastWithString:@"请输入正确的手机号"];
//        
//        return;
//    }
    
    [self GETFamilyPhoneNumber];
    

    
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


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
//    [self.searchBar becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
      [self.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
     [self.searchBar resignFirstResponder];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    
//    [self.searchBar resignFirstResponder];
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
