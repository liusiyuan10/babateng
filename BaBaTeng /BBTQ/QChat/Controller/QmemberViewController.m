//
//  QAddmemberViewController.m
//  BaBaTeng
//
//  Created by liu on 17/6/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QmemberViewController.h"
#import "TMQuiltViewCell.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "BBTQAlertView.h"
#import "PYSearchViewController.h"
#import "AddmemberViewController.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"

#import "Family.h"
#import "FamilyData.h"
#import "FamilyDataList.h"
#import "FamilyDevice.h"
#import "FamilyUser.h"
#import "FamilyDevice.h"

#import "UIImageView+AFNetworking.h"

#import "BBTEquipmentRequestTool.h"
#import "BBTEquipmentRespone.h"
#import "Header.h"
#import "HomeViewController.h"
#import "QMembersNicknameViewController.h"
#import "NewHomeViewController.h"

@interface QmemberViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,PYSearchViewControllerDelegate>
{
    BBTQAlertView *_QalertView;
}

@property (nonatomic, strong)     TMQuiltView        *collectionView;
//@property (strong,nonatomic)       NSMutableArray    *memberarr; //组员列表
@property (strong,nonatomic)       NSMutableArray    *dataArray; //组员列表
@property (nonatomic, strong)      UIButton          *deleteBtn;


@property (nonatomic, strong)      FamilyData          *familyData;
@property (nonatomic, strong)      FamilyDataList      *familyDataList;
@property (nonatomic, strong)      FamilyDevice         *familyDevice;
@property (nonatomic, strong)      FamilyUser          *familyUser;

@property (nonatomic, assign)      BOOL    ifgroupmanager;//判断当前登录账号是不是群主

@property (nonatomic, copy) NSString *familyId;//家庭圈id

@end

@implementation QmemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"微聊组员";
    
    self.view.backgroundColor = [UIColor whiteColor];
      [self LoadChlidView];
    
      self.dataArray=[[NSMutableArray alloc]init];
      self.ifgroupmanager = NO;

     [self GETFamilys];//获取家庭圈

}
-(void)GETFamilys{
    
    [self startLoading];
  [BBTMineRequestTool GETFamilys:[[TMCache sharedCache] objectForKey:@"deviceId"] upload:^(Family *respone) {
      [self stopLoading];
      if ([respone.statusCode isEqualToString:@"0"]) {

          
         self.dataArray = respone.data.familyMembers;
          self.familyId =respone.data.familyId;
          if (self.dataArray.count>0) {
              
              for (int i=0; i<self.dataArray.count; i++) {
                  
                  FamilyDataList *model = self.dataArray[i];
                  //拿到列表中群主的成员
                  if ([model.isAdmin isEqualToString:@"1"]) {
                       //对比判断当前登录账号是不是群主
                      if ([model.userId isEqualToString:[[TMCache sharedCache] objectForKey:@"userId"]]) {
                          
                           self.ifgroupmanager = YES;
                          
                      }else{
                      
                           self.ifgroupmanager = NO;
                      }
                      
                      break;
                      
                  }
                  
              }
          
          }
          
          FamilyDataList *lastmodel = [[FamilyDataList alloc]init];
          
          lastmodel.user.nickName = @"邀请加入";
          
          [self.dataArray addObject:lastmodel];
          

         [self.collectionView reloadData];

      }else if([respone.statusCode isEqualToString:@"3705"])
      {
          
          [[NewHomeViewController getInstance] KickedOutDeviceStaues];
          
          
      }else{

          [self showToastWithString:respone.message];
      }

      
  } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
  }];
        
    
}
- (void)LoadChlidView
{

    //适配iphone x
    self.collectionView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 140-kDevice_Is_iPhoneX)];

//        self.collectionView.contentInset=UIEdgeInsetsMake(32, 0,0, 0);
    
    self.collectionView.bounces = NO;
    
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.collectionView];
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.collectionView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.collectionView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
   // self.memberarr=[[NSMutableArray alloc] initWithObjects:@"张三",@"小腾",@"李四",@"邀请加入", nil];
    
    [self.collectionView reloadData];
    
    //适配iphone x
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, KDeviceHeight - 100 -  40-kDevice_Is_iPhoneX, kDeviceWidth - 34, 54)];
    
    self.deleteBtn.backgroundColor = [UIColor redColor];
    
    [self.deleteBtn setTitle:@"解除设备并退出" forState:UIControlStateNormal];
    
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(unbindClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn.layer.cornerRadius = 11;
    
    [self.view addSubview:self.deleteBtn];
    
    
    
}

-(void)unbindClicked{

    NSLog(@"解绑并退出");
    
    
    
    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:@"您确定要解除绑定吗?" andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
    [_QalertView showInView:self.view];
    
    __block QmemberViewController *self_c = self;
    //点击按钮回调方法
    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
        if (titleBtnTag == 1) {
            
            
            NSLog(@"sf");
            
            [self_c startLoading];
            [BBTEquipmentRequestTool getDeletebinddevice:[[TMCache sharedCache] objectForKey:@"userId"] deviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(BBTEquipmentRespone *respone) {
                
                [self_c stopLoading];
                
                if ([respone.statusCode isEqualToString:@"0"]) {
                    
                    [[TMCache sharedCache] removeObjectForKey:@"deviceId"];
                    [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];
                    [[TMCache sharedCache] setObject:@"success" forKey:@"RemoveBind"];
                    [self_c showToastWithString:@"解绑成功"];
                    
                   // [[CustomRootViewController getInstance]comeback];
                      [self_c performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
                    
                }else if([respone.statusCode isEqualToString:@"3705"])
                {
                    
                    [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                    
                    
                }else{
                    
                    [self_c showToastWithString:respone.message];
                }
                
            } failure:^(NSError *error) {
                
                [self_c stopLoading];
                
            }];
            
            
            
            
        }
        if (titleBtnTag == 0) {
            NSLog(@"sg");
            
        }
    };

    
//
//
//
//
//
//    [self startLoading];
//    [BBTEquipmentRequestTool getDeletebinddevice:[[TMCache sharedCache] objectForKey:@"userId"] deviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(BBTEquipmentRespone *respone) {
//
//        [self stopLoading];
//        
//        if ([respone.statusCode isEqualToString:@"0"]) {
//            
//            [[TMCache sharedCache] removeObjectForKey:@"deviceId"];
//            [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];
//            [self showToastWithString:@"解绑成功"];
//            
////            [[CustomRootViewController getInstance]comeback];
//            
//            
//        }else{
//            
//            [self showToastWithString:respone.message];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [self stopLoading];
//        
//    }];

    

}
-(void)delayMethod{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 添加（插入item）
//- (void)addItemBtnClick:(UIBarButtonItem *)btnItem
//{
//    NSIndexPath *indePath = [NSIndexPath indexPathForItem:self.memberarr.count inSection:0];
//
//    [self.collectionView insertCellAtIndexPath:indePath];
//    [self.memberarr addObject:@"sb"];
//    [self.collectionView reloadData];
//
//}

//- (void)deleteItemBtnClick:(NSIndexPath *)indePath
//{
//
//    NSLog(@"indePath====%ld",(long)indePath.row);
////     NSIndexPath *indePath1 = [NSIndexPath indexPathForItem:self.memberarr.count inSection:0];
//    [self.collectionView deleteCellAtIndexPath:indePath];
//    
//    [self.memberarr removeObjectAtIndex:indePath.row];
//    [self.collectionView reloadData];
//    
//}

// 删除（移除item）


//- (void)addcollectionViewcell
//{
//    NSIndexPath *indePath = [NSIndexPath indexPathForItem:self.memberarr.count - 1 inSection:0];
//    
//    [self.collectionView insertCellAtIndexPath:indePath];
//    [self.memberarr insertObject:@"测试" atIndex:self.memberarr.count - 1];
//    [self.collectionView reloadData];
//}


//瀑布流
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
    }
    
    cell.picHeight=75;
    
    
     self.familyDataList =  self.dataArray[indexPath.row];
    

    if (indexPath.row==self.dataArray.count-1) {
        
        
         cell.photoView.image = [UIImage imageNamed:@"wl_tj_nor"];
        
         cell.titleLabel.text  = @"邀请加入";
         cell.toprightImageView.hidden =YES;
         cell.lowerrightImageView.hidden =YES;
        
    }else{
    

       
       // NSLog(@"self.familyDataList.isDevice==%@",self.familyDataList.isDevice);
        
        if ([self.familyDataList.isDevice isEqualToString:@"1"]) {
            [cell.photoView setImageWithURL:[NSURL URLWithString:self.familyDataList.device.deviceIcon] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
            cell.toprightImageView.hidden =YES;
            cell.lowerrightImageView.hidden =NO;
            cell.titleLabel.text = self.familyDataList.device.deviceName;
            cell.lowerrightImageView.image = [UIImage imageNamed:@"identity-3"];
        }else if ([self.familyDataList.isAdmin isEqualToString:@"1"]){
            
            [cell.photoView setImageWithURL:[NSURL URLWithString:self.familyDataList.user.userIcon] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
            cell.toprightImageView.hidden =YES;
            cell.lowerrightImageView.hidden =NO;
            cell.titleLabel.text = self.familyDataList.nickName;
            cell.lowerrightImageView.image = [UIImage imageNamed:@"identity-1"];
        
        }else{
            
            [cell.photoView setImageWithURL:[NSURL URLWithString:self.familyDataList.user.userIcon] placeholderImage:[UIImage imageNamed:@"BBZL_icon_touxian"]];
               cell.titleLabel.text = self.familyDataList.nickName;
            
            if (self.ifgroupmanager) {
                cell.toprightImageView.hidden =NO;
                cell.lowerrightImageView.hidden =YES;
                cell.toprightImageView.image = [UIImage imageNamed:@"identity-2"];
                
                
            }else{
            
                cell.toprightImageView.hidden =YES;
                cell.lowerrightImageView.hidden =YES;
            
            }
        
        }

      
    
    }
    


    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    return 3;
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 120/667.0 * KDeviceHeight;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    
       // NSLog(@"%ld",(long)indexPath.row);
        if (indexPath.row == self.dataArray.count -1) {
            
            [self QSearch];
            
    
//            [self addcollectionViewcell];
    
        }else
        {
            
            self.familyDataList =  self.dataArray[indexPath.row];
            
            
            if ([self.familyDataList.userId isEqualToString:[[TMCache sharedCache] objectForKey:@"userId"]]) {
                
              //  NSLog(@"dagezijiren");
                
                QMembersNicknameViewController *nicknameVc = [[QMembersNicknameViewController alloc] init];
                
                nicknameVc.nickname=self.familyDataList.nickName;
                nicknameVc.familyMemberId =self.familyDataList.familyMemberId;
                nicknameVc.familyId =self.familyId;
                [self.navigationController pushViewController:nicknameVc animated:YES];
                
            }
            
            if ([self.familyDataList.isDevice isEqualToString:@"1"]) {
                
              
                  //  NSLog(@"69999");
         
            }else if ([self.familyDataList.isAdmin isEqualToString:@"1"]){
                
              //  NSLog(@"69999");
           
            }else{
                //只有当前帐号是群主身份才能删除其他设备
                if (self.ifgroupmanager) {
                 
                    NSString *str;
                 
                    if (!IsStrEmpty(self.familyDataList.nickName)) {
                        
                        str =     [NSString stringWithFormat:@"确定删除成员%@?",self.familyDataList.nickName];
                        
                    }else{
                       
                        str= @"确定删除成员?";
                    }
                    
                    _QalertView = [[BBTQAlertView alloc] initWithBBTTitle:@"温馨提示" andWithMassage:str andWithTag:1 andWithButtonTitle:@"取消",@"确定",nil];
                    [_QalertView showInView:self.view];
                    
                    __block QmemberViewController *self_c = self;
                    //点击按钮回调方法
                    _QalertView.resultIndex = ^(NSInteger titleBtnTag,NSInteger alertViewTag){
                        if (titleBtnTag == 1) {
                            
                            [self_c startLoading];
                            [BBTEquipmentRequestTool getDeletebinddevice:self_c.familyDataList.userId deviceId:[[TMCache sharedCache] objectForKey:@"deviceId"] success:^(BBTEquipmentRespone *respone) {
                                
                                [self_c stopLoading];
                                
                                if ([respone.statusCode isEqualToString:@"0"]) {
                                    
//                                    [[TMCache sharedCache] removeObjectForKey:@"deviceId"];
//                                    [[TMCache sharedCache] removeObjectForKey:@"QdeviceTypeId"];
//                                    [self_c showToastWithString:@"解绑成功"];
                                    
                                    //[[CustomRootViewController getInstance]comeback];
                                    
                                    [self_c GETFamilys];//获取家庭圈
                                    
                                }else if([respone.statusCode isEqualToString:@"3705"])
                                {
                                    
                                    [[NewHomeViewController getInstance] KickedOutDeviceStaues];
                                    
                                    
                                }else{
                                    
                                    [self_c showToastWithString:respone.message];
                                }
                                
                            } failure:^(NSError *error) {
                                
                                [self_c stopLoading];
                                
                            }];
                            
                            
                        }
                        if (titleBtnTag == 0) {
                            
                            NSLog(@"sg");
                            
                        }
                    };
                    

                    
                }
                
            }
            
            
        }

}

- (void)QSearch
{

    // 1. Create an Array of popular search
//    NSArray *hotSeaches = @[@"亲子对唱", @"快乐童谣", @"讲故事唱儿歌", @"唐诗三百首", @"成语故事", @"十万个为什么", @"科学幻想", @"弟子规", @"格林童话", @"迪士尼小百科", @"语感启蒙", @"儿歌", @"国学", @"笑话"];
    // 2. Create a search view controller
//    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入手机号" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        AddmemberViewController *memberVc = [[AddmemberViewController alloc] init];
        //memberVc.searchstr = searchText;
        memberVc.familyId =  self.familyId ;
//        [searchViewController.navigationController pushViewController:memberVc animated:YES];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberVc];
        
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.barTintColor = NavBackgroundColor;//[UIColor orangeColor];
        [memberVc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:nav animated:YES completion:nil];
        
//    }];
//    // 3. Set style for popular search and search history
//    
//    searchViewController.hotSearchStyle = 2;
//    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
//    
//    searchViewController.showSearchHistory = NO;
//    // 显示热门搜索
//    searchViewController.showHotSearch = NO;
//    
//    // 4. Set delegate
//    searchViewController.delegate = self;
//    // 5. Present a navigation controller
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
//    
//    nav.navigationBar.barTintColor = [UIColor orangeColor];
//    
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];


    if (!IsStrEmpty([[TMCache sharedCache]objectForKey:@"GroupCard"])) {
        
        [self GETFamilys];//获取家庭圈
    }
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
