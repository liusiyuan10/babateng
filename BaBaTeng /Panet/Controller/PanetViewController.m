//
//  PanetViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/2/25.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetViewController.h"
#import "TreeView.h"
#import "JXButton.h"
#import "PanetCell.h"
#import "KnowledgeViewController.h"
#import "IntelligenceViewController.h"
#import "GetIntelligenceViewController.h"
#import "ForeignViewController.h"
#import "PanetMineViewController.h"

#import "PanetRequestTool.h"
#import "PanetKnIntelModel.h"
#import "PanetKnIntelDataModel.h"
#import "PanetKnInetlCommon.h"

#import "BBTMineRequestTool.h"

#import "BBTUserInfo.h"
#import "BBTUserInfoRespone.h"
#import "ChargeModel.h"
#import "ChargeDataModel.h"

@interface PanetViewController ()<TreeViewDelegate,UIGestureRecognizerDelegate>



@property (nonatomic, weak) TreeView *treeView;

@property (nonatomic, strong) UIView *bgImageView;

@property (nonatomic, strong) UIImageView *knowledgeImageView;
@property (nonatomic, strong) UIButton *knowledgeBtn;
@property (nonatomic, strong) UILabel *knowledgeLabel;
@property (nonatomic, strong) UILabel *knowledgenoLabel;

@property (nonatomic, strong) UIImageView *intelligenceImageView;
@property (nonatomic, strong) UIButton *intelligenceBtn;
@property (nonatomic, strong) UILabel *intelligenceLabel;
@property (nonatomic, strong) UILabel *intelligencenoLabel;

@property (nonatomic, strong) UIButton *personalBtn;
@property (nonatomic, strong) UILabel *personalLabel;

@property (nonatomic, strong) NSArray *PantImageArr;
@property (nonatomic, strong) NSArray *PanttitleArr;
@property (nonatomic, strong) NSArray *PantsubtitleArr;

@property (nonatomic, strong) NSArray *KnowledgeArr;
@property (nonatomic, strong) NSArray *IntelligenceArr;

@property(nonatomic, copy) NSString *intelligenceStr;
@property(nonatomic, copy) NSString *inviteCodeStr;

@property (nonatomic, assign) BOOL isCanSideBack;

@property (nonatomic, strong) UIButton *GetintelligenceBtn;

@end

@implementation PanetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:254/255.0 green:207/255.0 blue:161/255.0 alpha:1.0];
    
    
    
    
    self.PantImageArr = @[@"plant_getintenlligence",@"plant_teacher",@"plant_businessdeal"];
    self.PanttitleArr = @[@"获得智力",@"外教一对一",@"知识豆交易市场"];
    self.PantsubtitleArr = @[@"更多的智力值，加速加快知识豆的获得",@"购买课程，立享钜惠",@"优惠多多，多多优惠"];
    
    self.IntelligenceArr = [NSArray array];
    self.KnowledgeArr = [NSArray array];
    [self LoadChlidView];
    
    
}


- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];

    bgImageView.image = [UIImage imageNamed:@"pant_bg"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];

    self.bgImageView = bgImageView;
    
    
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(16, 23, 34, 34)];
    
    [backbutton setImage:[UIImage imageNamed:@"nav_fanhui"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"nav_fanhui_pre"] forState:UIControlStateSelected];
    
    
    [backbutton addTarget:self action:@selector(backForePage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgImageView addSubview:backbutton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 120)/2.0, 33, 120, 17)];
    titleLabel.text = @"星球";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor whiteColor];
  
    titleLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.bgImageView addSubview:titleLabel];
    
    

    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 165- 16, CGRectGetMaxY(backbutton.frame) + 29, 165, 70)];
    
//    headImageView.backgroundColor = [UIColor redColor];
    
    headImageView.image = [UIImage imageNamed:@"Panet_banner"];
    
    headImageView.userInteractionEnabled = YES;
    
    [self.bgImageView addSubview:headImageView];

    self.knowledgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(backbutton.frame) + 29, 120 + 50+10, 24)];
    
    self.knowledgeImageView.backgroundColor = [UIColor colorWithRed:196/255.0 green:238/255.0 blue:205/255.0 alpha:1.0];
    self.knowledgeImageView.layer.cornerRadius= 12.0f;
    self.knowledgeImageView.layer.borderWidth = 2.0;
    self.knowledgeImageView.layer.borderColor = [UIColor colorWithRed:128/255.0 green:197/255.0 blue:143/255.0 alpha:1.0].CGColor;
    self.knowledgeImageView.clipsToBounds = YES;//去除边界
    
    [self.bgImageView addSubview:self.knowledgeImageView];
    
    UITapGestureRecognizer *knowledgeTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(knowledgeBtnClicked)];
    
    // 2. 将点击事件添加到label上
    [self.knowledgeImageView addGestureRecognizer:knowledgeTapGestureRecognizer];
    self.knowledgeImageView.userInteractionEnabled = YES;
    
    self.knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 125+10, 18)];
    self.knowledgenoLabel.text = @"";
    self.knowledgenoLabel.textAlignment = NSTextAlignmentLeft;
    self.knowledgenoLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.knowledgenoLabel.textColor = [UIColor colorWithRed:26/255.0 green:106/255.0 blue:25/255.0 alpha:1.0];
    //     self.knowledgenoLabel.textColor = [UIColor whiteColor];
    self.knowledgenoLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.knowledgeImageView addSubview:self.knowledgenoLabel];
    
    self.knowledgeBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, (24 - 15)/2.0, 15, 15)];
    [self.knowledgeBtn setImage:[UIImage imageNamed:@"beans"] forState:UIControlStateNormal];
    
    [self.knowledgeBtn addTarget:self action:@selector(knowledgeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.knowledgeImageView addSubview:self.knowledgeBtn];
    
    self.knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.knowledgeBtn.frame) + 3, (24 - 12)/2.0, 40, 12)];
    self.knowledgeLabel.text = @"知识豆";
    self.knowledgeLabel.font = [UIFont systemFontOfSize:10.0];
    self.knowledgeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.knowledgeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.knowledgeImageView addSubview:self.knowledgeLabel];


    self.intelligenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.knowledgeImageView.frame) + 12, 120, 24)];
    
    self.intelligenceImageView.backgroundColor = [UIColor colorWithRed:252/255.0 green:233/255.0 blue:234/255.0 alpha:1.0];
    self.intelligenceImageView.layer.cornerRadius= 12.0f;
    self.intelligenceImageView.layer.borderWidth = 2.0;
    self.intelligenceImageView.layer.borderColor = [UIColor colorWithRed:227/255.0 green:120/255.0 blue:123/255.0 alpha:1.0].CGColor;
    self.intelligenceImageView.clipsToBounds = YES;//去除边界
    
    [self.bgImageView addSubview:self.intelligenceImageView];
    
    
    UITapGestureRecognizer *intelligenceTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intelligenceBtnClicked)];
    
    // 2. 将点击事件添加到label上
    [self.intelligenceImageView addGestureRecognizer:intelligenceTapGestureRecognizer];
    self.intelligenceImageView.userInteractionEnabled = YES;
    
    
    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, 100, 18)];
    self.intelligencenoLabel.text = @"";
    self.intelligencenoLabel.textAlignment = NSTextAlignmentLeft;
    self.intelligencenoLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.intelligencenoLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    self.intelligencenoLabel.backgroundColor = [UIColor clearColor];

    
    [self.intelligenceImageView addSubview:self.intelligencenoLabel];
    
    self.intelligenceBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 7, 11, 10)];
    [self.intelligenceBtn setImage:[UIImage imageNamed:@"intelligence"] forState:UIControlStateNormal];
    [self.intelligenceBtn addTarget:self action:@selector(intelligenceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.intelligenceImageView  addSubview:self.intelligenceBtn];
    
    self.intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.intelligenceBtn.frame) + 3, (24 - 12)/2.0, 30, 12)];
    self.intelligenceLabel.text = @"智力";
    self.intelligenceLabel.font = [UIFont systemFontOfSize:10.0];
    self.intelligenceLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    self.intelligenceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.intelligenceImageView addSubview:self.intelligenceLabel];


 

    TreeView *treeView = [[TreeView alloc] initWithFrame:CGRectMake(0, 147 + 64, kDeviceWidth, 330)];
//    treeView.timeLimitedArr = @[@"0.14523",@"0.59852",@"0.68521"];
//    treeView.unimitedArr = @[@"0.23456",@"0.55663",@"1.4567"];
    
    treeView.backgroundColor = [UIColor clearColor];
    [self.bgImageView addSubview:treeView];
    treeView.delegate = self;
    _treeView = treeView;



    self.GetintelligenceBtn = [[UIButton alloc]initWithFrame:CGRectMake(68,KDeviceHeight - 44 - 36 -kDevice_Is_iPhoneX ,kDeviceWidth - 68*2, 44)];

    self.GetintelligenceBtn.backgroundColor = MNavBackgroundColor;
    self.GetintelligenceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.GetintelligenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.GetintelligenceBtn setTitle:@"获取智力" forState:UIControlStateNormal];
    
    [self.GetintelligenceBtn addTarget:self action:@selector(GetintelligenceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.GetintelligenceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.GetintelligenceBtn.layer.cornerRadius= 22.0f;
    
    self.GetintelligenceBtn.clipsToBounds = YES;//去除边界
    
    [self.bgImageView addSubview:self.GetintelligenceBtn];


}

//- (void)LoadChlidView
//{
////    UIView *bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
////
//////    bgImageView.image = [UIImage imageNamed:@"pant_bg"];
//////    bgImageView.userInteractionEnabled = YES;
////    bgImageView.backgroundColor = [UIColor colorWithRed:254/255.0 green:207/255.0 blue:161/255.0 alpha:1.0];
////
////    [self.view addSubview:bgImageView];
////
////    self.bgImageView = bgImageView;
////
//
//   UIImageView  *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 330)];
//
//    headerView.backgroundColor = [UIColor clearColor];
//    headerView.image = [UIImage imageNamed:@"PanetHead_bg"];
//
//    headerView.userInteractionEnabled = YES;
//    //
//
//    //    [self.view addSubview:bgImageView];
//
//
//    self.knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 118, 20+ 34, 80, 21)];
//    self.knowledgenoLabel.text = @"  300.02";
//    self.knowledgenoLabel.textAlignment = NSTextAlignmentLeft;
//    self.knowledgenoLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    self.knowledgenoLabel.textColor = [UIColor colorWithRed:26/255.0 green:106/255.0 blue:25/255.0 alpha:1.0];
//    self.knowledgenoLabel.backgroundColor = [UIColor colorWithRed:196/255.0 green:238/255.0 blue:205/255.0 alpha:1.0];
//    self.knowledgenoLabel.layer.cornerRadius= 10.5f;
//    self.knowledgenoLabel.layer.borderWidth = 2.0;
//    self.knowledgenoLabel.layer.borderColor = [UIColor colorWithRed:128/255.0 green:197/255.0 blue:143/255.0 alpha:1.0].CGColor;
//    self.knowledgenoLabel.clipsToBounds = YES;//去除边界
//
//    [headerView addSubview:self.knowledgenoLabel];
//
//    self.knowledgeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 50, 20+28, 32, 32)];
//    [self.knowledgeBtn setImage:[UIImage imageNamed:@"beans"] forState:UIControlStateNormal];
//
//    [self.knowledgeBtn addTarget:self action:@selector(knowledgeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [headerView addSubview:self.knowledgeBtn];
//
//    self.knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 50, CGRectGetMaxY(self.knowledgeBtn.frame)+3, 32, 9)];
//    self.knowledgeLabel.text = @"知识豆";
//    self.knowledgeLabel.font = [UIFont systemFontOfSize:9.0];
//    self.knowledgeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    self.knowledgeLabel.textAlignment = NSTextAlignmentCenter;
//
//    [headerView addSubview:self.knowledgeLabel];
//
//
//
//
//    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 86, CGRectGetMaxY(self.knowledgenoLabel.frame) + 33, 50, 21)];
//    self.intelligencenoLabel.text = @"  21";
//    self.intelligencenoLabel.textAlignment = NSTextAlignmentLeft;
//    self.intelligencenoLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    self.intelligencenoLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:35/255.0 alpha:1.0];
//    self.intelligencenoLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:233/255.0 blue:234/255.0 alpha:1.0];
//    self.intelligencenoLabel.layer.cornerRadius= 10.5f;
//    self.intelligencenoLabel.layer.borderWidth = 2.0;
//    self.intelligencenoLabel.layer.borderColor = [UIColor colorWithRed:227/255.0 green:120/255.0 blue:123/255.0 alpha:1.0].CGColor;
//    self.intelligencenoLabel.clipsToBounds = YES;//去除边界
//
//    [headerView addSubview:self.intelligencenoLabel];
//
//    self.intelligenceBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 50, CGRectGetMaxY(self.knowledgeBtn.frame) + 22, 32, 32)];
//    [self.intelligenceBtn setImage:[UIImage imageNamed:@"intelligence"] forState:UIControlStateNormal];
//    [self.intelligenceBtn addTarget:self action:@selector(intelligenceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [headerView addSubview:self.intelligenceBtn];
//
//    self.intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 50, CGRectGetMaxY(self.intelligenceBtn.frame)+3, 32, 9)];
//    self.intelligenceLabel.text = @"智力";
//    self.intelligenceLabel.font = [UIFont systemFontOfSize:9.0];
//    self.intelligenceLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    self.intelligenceLabel.textAlignment = NSTextAlignmentCenter;
//
//    [headerView addSubview:self.intelligenceLabel];
//
//
//    self.personalBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 50, CGRectGetMaxY(self.intelligenceBtn.frame) + 21, 32, 32)];
//    [self.personalBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//    //    [self.knowledgeBtn setTitle:@"知识豆" forState:UIControlStateNormal];
//    [self.personalBtn addTarget:self action:@selector(personalBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:self.personalBtn];
//
//    self.personalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 55, CGRectGetMaxY(self.personalBtn.frame)+3, 40, 9)];
//    self.personalLabel.text = @"个人中心";
//    self.personalLabel.font = [UIFont systemFontOfSize:9.0];
//    self.personalLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    self.personalLabel.textAlignment = NSTextAlignmentCenter;
//
//    [headerView addSubview:self.personalLabel];
//
//
//
//
//
//
//    TreeView *treeView = [[TreeView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth - 50, 330)];
////    treeView.timeLimitedArr = @[@"0.14523",@"0.59852",@"0.68521"];
////    treeView.timeLimitedArr = @[@"0.68521"];
////    treeView.unimitedArr = @[@"0.23456",@"0.55663",@"1.4567"];
//    treeView.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:treeView];
//    treeView.delegate = self;
//    _treeView = treeView;
//
//
//
//    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,-20,kDeviceWidth , KDeviceHeight + 20)style:UITableViewStylePlain];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.tableView.backgroundColor= [UIColor clearColor];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tableView setShowsVerticalScrollIndicator:NO];
//    //
//    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 330)];
//    //
//    //    [self.tableView.tableHeaderView addSubview:self.bgImageView];
//
//    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight  ) style:UITableViewStyleGrouped];
//    //
//    //
//    //    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    //    self.tableView.showsVerticalScrollIndicator = NO;
//    //
//    //    self.tableView.delegate = self;
//    //    self.tableView.dataSource = self;
//    //    self.tableView.backgroundColor = [UIColor clearColor];
//    //
//    //
//    //
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 330)];
//
//    [self.tableView.tableHeaderView addSubview:headerView];
//    //
//
//
//    //适配iphone x
//    if (iPhoneX) {
//        do {\
//            _Pragma("clang diagnostic push")\
//            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
//            if ([self.tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
//                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
//                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
//                NSInteger argument = 2;\
//                invocation.target = self.tableView;\
//                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
//                [invocation setArgument:&argument atIndex:2];\
//                [invocation retainArguments];\
//                [invocation invoke];\
//            }\
//            _Pragma("clang diagnostic pop")\
//        } while (0);
//    }
//
//    [self.view addSubview:self.tableView];
//
//
//
//
//    //    startBtn.layer.cornerRadius= 25.0f;
//    //
//    //    startBtn.layer.borderWidth = 1.2;
//    //    startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    //    startBtn.clipsToBounds = YES;//去除边界
//
//}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    

    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
//    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, height)];
    
    return rect.size.width;
//    return size.width;
    
}


- (void)GetKnowledgeNum
{
    
    [self startLoading];

    [PanetRequestTool getuserScoreproduceWay:@"1" success:^(PanetKnIntelModel * _Nonnull response) {
        [self stopLoading];


        if ([response.statusCode isEqualToString:@"0"]) {

            self.KnowledgeArr = response.data;

            _treeView.timeLimitedArr = self.KnowledgeArr;


        }else{

            [self showToastWithString:response.message];
        }

    } failure:^(NSError * _Nonnull error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

    }];
}

- (void)GetIntelligenceNum
{
//    _treeView.unimitedArr = @[@"0.23456",@"0.55663",@"1.4567"];
    
    [self startLoading];
    
    [PanetRequestTool getuserScoreproduceWay:@"2" success:^(PanetKnIntelModel * _Nonnull response) {
        [self stopLoading];
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            
            self.IntelligenceArr = response.data;
            
//            NSMutableArray *konwarr = [[NSMutableArray alloc] init];
            
//            for (int i =0; i <self.IntelligenceArr.count; i++) {
//                PanetKnIntelDataModel *panetModel = [self.IntelligenceArr objectAtIndex:i];
//
//                [konwarr addObject:panetModel.producePeasValue];
//            }
//
            
//            _treeView.unimitedArr = konwarr;
            
//            if (self.IntelligenceArr.count > 0) {
//                _treeView.unimitedArr = [NSArray array];
//                
                _treeView.unimitedArr = self.IntelligenceArr;
            
            
            
//            }
            
            
            //            _treeView.timeLimitedArr = @[@"0.14523",@"0.59852",@"0.68521"];
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
}

#pragma mark -- 获取个人资料
-(void)GETPersonalData{
    
    
    [self startLoading];
    
    [BBTMineRequestTool GETPersonalData:^(BBTUserInfoRespone *registerRespone) {
        [self stopLoading];
        
        if ([registerRespone.statusCode isEqualToString:@"0"]) {
            
            self.intelligencenoLabel.text =[NSString stringWithFormat:@"    %@",registerRespone.data.intellectValue];
            self.knowledgenoLabel.text = [NSString stringWithFormat:@"  %.5f",registerRespone.data.scoreValue];
            self.intelligenceStr = registerRespone.data.intellectValue;
            self.inviteCodeStr = registerRespone.data.inviteCode;
   
            
            [[TMCache sharedCache]setObject:registerRespone.data.inviteCode forKey:@"inviteCode"];
            
        }else{
            
            [self showToastWithString:registerRespone.message];
        }
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
        
    }];
}



- (void)knowledgeBtnClicked
{
    NSLog(@"---------");
    KnowledgeViewController * KnowledgeVC = [[KnowledgeViewController alloc] init];

    
    [self.navigationController pushViewController:KnowledgeVC animated:YES];
    
}

- (void)intelligenceBtnClicked
{
    NSLog(@"---------");
    IntelligenceViewController *IntelligenceVC = [[IntelligenceViewController alloc] init];
    
    
    [self.navigationController pushViewController:IntelligenceVC animated:YES];
}

- (void)GetintelligenceBtnClicked
{
    GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
    GetIntelligenceVC.intelligenceStr = self.intelligenceStr;
    GetIntelligenceVC.inviteCodeStr = self.inviteCodeStr;
    [self.navigationController pushViewController:GetIntelligenceVC animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = self.tableView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    self.tableView.contentOffset = offset;
//    
//}

- (void)backForePage
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - TreeViewDelegate

- (void)selectTimeLimitedBtnAtIndex:(NSInteger)index
{
    
    NSLog(@"selectTimeLimited----%ld",(long)index);

    [PanetRequestTool GetUserScoreProduceId:[NSString stringWithFormat:@"%ld",(long)index] success:^(ChargeModel * _Nonnull respone) {

        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.knowledgenoLabel.text = [NSString stringWithFormat:@"% .5f",respone.data.scoreValue];
            [_treeView removeTimeLimitedIndex:index];
        }else{

            [self showToastWithString:respone.message];
        }

    } failure:^(NSError * _Nonnull error) {

        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];

    }];
//
    
}

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index
{
       NSLog(@"selectUnlimited----%ld",index);
    
    [PanetRequestTool GetUserScoreProduceId:[NSString stringWithFormat:@"%ld",(long)index] success:^(ChargeModel * _Nonnull respone) {
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
           self.knowledgenoLabel.text = [NSString stringWithFormat:@"% .5f",respone.data.scoreValue];
    
            [_treeView removeunlimitedIndex:index];
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
//    [_treeView removeunlimitedIndex:index];
}

- (void)TimeLimitedCollected
{
    
    NSLog(@"知识豆点完了");
    [_treeView removeAlltimeLimitedBtn];
    
    [self GetKnowledgeNum];
}
- (void)UnlimitedCollected
{
    
    NSLog(@"英豆点完了");
      [_treeView removeAllunlimiteBtn];
   
    [self GetIntelligenceNum];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    [_treeView removeAllRandomBtn];
    
    [self GetKnowledgeNum];
    [self GetIntelligenceNum];
    
    [self GETPersonalData];

//    [UIButton]
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    //
    //    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
