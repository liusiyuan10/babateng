//
//  QContactViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/3.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QContactViewController.h"

#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "QContactQuiltViewCell.h"

#import "QFamilyCallRequestTool.h"

#import "QFamilyContact.h"
#import "QFamilyContactData.h"
#import "QFamilyAllContact.h"

#import "UIImageView+AFNetworking.h"

#import "UIButton+AFNetworking.h"

#import "QEditContactViewController.h"

#import "QAddContactViewController.h"


@interface QContactViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>

@property (nonatomic, strong)  TMQuiltView *collectionView;

@property (nonatomic, strong) NSArray * contacts;

@property (nonatomic, strong) NSArray * topContacts;

@property (nonatomic, strong) UILabel *FamilyNameLabel;
@property (nonatomic, strong) UILabel *FamilyNumLabel;
@property (nonatomic, strong) UIButton *iconImageView;

@property (nonatomic, strong)  UIView *panel;

@property (nonatomic, strong)  UIView *nopanel;


@end

@implementation QContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"宝贝通讯录";

    self.contacts = [NSArray array];
    
    [self LoadChlidView];
    
//    [self GetfamilyContacts];
    
}

- (void)GetfamilyContacts
{
    NSDictionary *parameter = @{@"deviceId" : [[TMCache sharedCache] objectForKey:@"deviceId"]};
    
    
    [self startLoading];
    [QFamilyCallRequestTool GetfamilyContactsParameter:parameter success:^(QFamilyContact *response) {
        [self stopLoading];
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
          
            
            self.contacts = response.data.contacts;
            self.topContacts = response.data.topContacts;
            
            if (self.topContacts.count >0 ) {

                self.panel.hidden = NO;
                self.nopanel.hidden = YES;
                 QFamilyAllContact *contactRespone = self.topContacts[0];


                    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)contactRespone.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
                
                [self.iconImageView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];


                    self.FamilyNameLabel.text = contactRespone.nickName;

                
            
                    
                    self.FamilyNumLabel.text = contactRespone.phoneNumber;
 
                
                
                
                
            }
            else
            {
                self.panel.hidden = YES;
                self.nopanel.hidden = NO;
            }
            
            
            
            [self.collectionView reloadData];
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
    }];
}


-(void)LoadContactView{
    
    
//    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];
//
//    container.backgroundColor = [UIColor whiteColor];
    
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    
    heardView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    
    [self.view addSubview:heardView];
    
    UILabel *heardLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 100, 20)];
    heardLabel.font = [UIFont systemFontOfSize:14.0];
    heardLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    heardLabel.textAlignment = NSTextAlignmentLeft;
    heardLabel.text = @"常用联系人";
    
    
    [heardView addSubview:heardLabel];
    

    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth/2.0, 120)];
    
    [self.view addSubview:panel];
    
    UIButton *iconImageView = [[UIButton alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];

    
//    [iconImageView setBackgroundImage:[UIImage imageNamed:@"icon_no01"] forState:UIControlStateNormal];
    

    
    [panel addSubview:iconImageView];
    
    self.iconImageView = iconImageView;
    
    
    UILabel *FamilyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 8/375.0 *kDeviceWidth, 38/668.0*KDeviceHeight, 100, 22)];
    
    FamilyNameLabel.font = [UIFont systemFontOfSize:16];
    FamilyNameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    FamilyNameLabel.textAlignment = NSTextAlignmentLeft;
//    FamilyNameLabel.text = contactRespone.nickName;
    
    [panel addSubview:FamilyNameLabel];
    
    self.FamilyNameLabel = FamilyNameLabel;
    
    UILabel *FamilyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 8/375.0 *kDeviceWidth, CGRectGetMaxY(FamilyNameLabel.frame) + 8, 100, 17)];
    
    FamilyNumLabel.font = [UIFont systemFontOfSize:12];
    FamilyNumLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    FamilyNumLabel.textAlignment = NSTextAlignmentLeft;
    
//    FamilyNumLabel.text = contactRespone.phoneNumber;
    
    [panel addSubview:FamilyNumLabel];
    
    self.FamilyNumLabel = FamilyNumLabel;
    
    self.panel = panel;
    
    self.nopanel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heardView.frame), kDeviceWidth, 120)];
    
    self.nopanel.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nopanel];
    
    
    UIImageView *noiconView = [[UIImageView alloc] initWithFrame:CGRectMake(16/375.0 *kDeviceWidth, 28/668.0*KDeviceHeight, 64/375.0 *kDeviceWidth, 64/375.0 *kDeviceWidth)];
    
    noiconView.image = [UIImage imageNamed:@"contact_n"];
    
    [self.nopanel addSubview:noiconView];
    
    UILabel *noFamilhCallLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noiconView.frame) + 8/375.0 *kDeviceWidth,  49/668.0*KDeviceHeight, 100, 22)];
    
    noFamilhCallLabel.font = [UIFont systemFontOfSize:16];
    noFamilhCallLabel.text = @"无常用联系人";
    noFamilhCallLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    noFamilhCallLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.nopanel addSubview:noFamilhCallLabel];
    

    
    
    UIView *heardOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, kDeviceWidth, 40)];
    
    heardOneView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    
    [self.view addSubview:heardOneView];
    
    UILabel *heardOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 100, 20)];
    heardOneLabel.font = [UIFont systemFontOfSize:14.0];
    heardOneLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    heardOneLabel.textAlignment = NSTextAlignmentLeft;
    heardOneLabel.text = @"联系人";
    
    
    [heardOneView addSubview:heardOneLabel];
    
    
}

//contactsId = 87;
//deviceId = 0100110000000211;
//icon = "";
//isCommon = 1;
//nickName = "哥哥";
//nicknameId = 29;
//phoneNumber = 18588203560;
//userId = 152220523863894282;


- (void)LoadChlidView
{
    
    [self LoadContactView];
    
    
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,200,self.view.frame.size.width, self.view.frame.size.height - 64 - 200 )];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    [self setNavigationItem];
    
}

#pragma mark - NavigationItem
-(void)setNavigationItem{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    [rightbutton setImage:[UIImage imageNamed:@"icon_qx002"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"icon_qx002"] forState:UIControlStateSelected];
    [rightbutton addTarget:self action:@selector(AddContact) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
}

- (void)AddContact
{
    
    QAddContactViewController *QAddContactVC = [[QAddContactViewController alloc] init];
    
    
    [self.navigationController pushViewController:QAddContactVC animated:YES];
    
}



//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return self.contacts.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    QContactQuiltViewCell *cell = (QContactQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[QContactQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    //    cell.picHeight=80;
//
//    QMPanelList *listRespone = self.albumListarr[indexPath.row];
//
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
     QFamilyAllContact *contactRespone = self.contacts[indexPath.row];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)contactRespone.icon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
    
//    cell.photoView.image = [UIImage imageNamed:@"Oval Copy"];
    
    
    cell.titleLabel.text = contactRespone.nickName;
    cell.numLabel.text = contactRespone.phoneNumber;
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 2;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KDeviceHeight/668.0*121;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    QFamilyAllContact *contactRespone = self.contacts[indexPath.row];
    
    
    QEditContactViewController *QEditContactVC = [[QEditContactViewController alloc] init];
    
    QEditContactVC.FamilyContact = contactRespone;
    
    [self.navigationController pushViewController:QEditContactVC animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self GetfamilyContacts];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
