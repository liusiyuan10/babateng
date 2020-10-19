//
//  QRoleViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/11.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QRoleViewController.h"

#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "QRoleListQuiltViewCell.h"

#import "Header.h"

#import "QFamilyCallRequestTool.h"
#import "QFamilyPhoneNickName.h"

#import "QFamilyPhoneNickNameData.h"



@interface QRoleViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>

@property (nonatomic, strong)  TMQuiltView *collectionView;

@property (nonatomic, strong)  NSArray *phonenicknameArr;

@end

@implementation QRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置身份";
    
    [self LoadChlidView];
    
//    [self.collectionView reloadData];
    
    self.phonenicknameArr = [NSArray array];
    
    [self GetfamilyPhoneNickname];
    

}

- (void)GetfamilyPhoneNickname
{
    [QFamilyCallRequestTool GetfamilyPhoneNicknameParameter:nil success:^(QFamilyPhoneNickName *response) {
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.phonenicknameArr = response.data;
            
 
            
           [self.collectionView reloadData];
            
        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)LoadChlidView
{
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
}


//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return self.phonenicknameArr.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    QRoleListQuiltViewCell *cell = (QRoleListQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[QRoleListQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    //    cell.picHeight=80;
    
//    QMPanelList *listRespone = self.albumListarr[indexPath.row];
//
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)listRespone.trackListIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.photoView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
    QFamilyPhoneNickNameData *phonenicknameRespone = self.phonenicknameArr[indexPath.row];
    
    cell.photoView.image = [UIImage imageNamed:@"role"];
    cell.titleLabel.text = phonenicknameRespone.nickName;
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 3;
    
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KDeviceHeight/568*100;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    QFamilyPhoneNickNameData *phonenicknameRespone = self.phonenicknameArr[indexPath.row];
    
    
    NSDictionary *jsonDict = @{@"RoleName" : phonenicknameRespone.nickName, @"RoleId" : phonenicknameRespone.nicknameId};
//    nicknameId
    if ([self.TypeString isEqualToString:@"Edit"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QRoleRefresh" object:self userInfo:jsonDict];
        
    }else if ([self.TypeString isEqualToString:@"Add"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAddRoleRefresh" object:self userInfo:jsonDict];
    }
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
