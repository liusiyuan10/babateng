//
//  PanetMineAssetViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/3/1.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "PanetMineAssetViewController.h"
#import "PanetCell.h"
#import "GetIntelligenceViewController.h"
#import "ForeignViewController.h"
#import "KnowledgeViewController.h"
#import "BeansViewController.h"
#import "PanetMineAssetDataModel.h"
#import "PanetMineAssetModel.h"
#import "PanetRequestTool.h"

@interface PanetMineAssetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *assetLabel;
@property (nonatomic, strong) UILabel *assetnoLabel;

@property (nonatomic, strong) UILabel *knowledgeLabel;
@property (nonatomic, strong) UILabel *knowledgenoLabel;
@property (nonatomic, strong) UILabel *knowledgesubLabel;

@property (nonatomic, strong) UILabel *intelligenceLabel;
@property (nonatomic, strong) UILabel *intelligencenoLabel;
@property (nonatomic, strong) UILabel *intelligencesubLabel;

@property (nonatomic, strong) NSArray *PantImageArr;
@property (nonatomic, strong) NSArray *PanttitleArr;
@property (nonatomic, strong) NSArray *PantsubtitleArr;

@property (nonatomic, strong) UIImageView *knowledgeImageView;
@property (nonatomic, strong) UIImageView *intelligenceImageView;

@property (nonatomic, strong) PanetMineAssetDataModel *assetdata;

@end

@implementation PanetMineAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资产";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.PantImageArr = @[@"plant_getintenlligence",@"plant_teacher",@"plant_businessdeal"];
    self.PanttitleArr = @[@"获得智力",@"外教一对一",@"知识豆交易市场"];
    self.PantsubtitleArr = @[@"更多的智力值，加速加快知识豆的获得",@"卖多少，返多少",@"优惠多多，多多优惠"];
    
    [self LoadChlidView];
    
    [self GetMineAsset];


}


- (void)LoadChlidView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 330)];
    
    bgImageView.image = [UIImage imageNamed:@"PanetAsset_bg"];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgImageView];
    
    self.bgImageView = bgImageView;
    
    self.assetLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 100)/2.0 , 60, 100, 11)];
    self.assetLabel.text = @"资产总估值 (元)";
    self.assetLabel.textAlignment = NSTextAlignmentCenter;
    self.assetLabel.font = [UIFont systemFontOfSize:11.0];
    self.assetLabel.textColor = [UIColor colorWithRed:253/255.0 green:254/255.0 blue:253/255.0 alpha:1.0];
    self.assetLabel.backgroundColor = [UIColor clearColor];

    
    [self.bgImageView addSubview:self.assetLabel];
    
    self.assetLabel = [[UILabel alloc] initWithFrame:CGRectMake( (kDeviceWidth - 250)/2.0 , CGRectGetMaxY(self.assetLabel.frame) + 23, 250, 27)];
    self.assetLabel.text = @"5000.56";
    self.assetLabel.textAlignment = NSTextAlignmentCenter;
    self.assetLabel.font = [UIFont systemFontOfSize:36.0];
    self.assetLabel.textColor = [UIColor whiteColor];
    self.assetLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.bgImageView addSubview:self.assetLabel];
    
    CGFloat knowledgeW = (kDeviceWidth - 16 * 3)/2.0;
    self.knowledgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 181, (kDeviceWidth - 16 * 3)/2.0, 138)];
    
    self.knowledgeImageView.userInteractionEnabled = YES;
    self.knowledgeImageView.backgroundColor = [UIColor clearColor];
    
    [self.bgImageView addSubview:self.knowledgeImageView];
    
    UITapGestureRecognizer *knowledgeTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(knowledgeImageViewClick)];
    
    // 2. 将点击事件添加到label上
    [self.knowledgeImageView addGestureRecognizer:knowledgeTapGestureRecognizer];
 
    
    self.knowledgeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 21, knowledgeW, 17)];
    self.knowledgeLabel.text = @"知识豆";
    self.knowledgeLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.knowledgeLabel.textColor = [UIColor colorWithRed:92/255.0 green:173/255.0 blue:100/255.0 alpha:1.0];
    self.knowledgeLabel.textAlignment = NSTextAlignmentCenter;
    self.knowledgeLabel.backgroundColor = [UIColor clearColor];
    
    [ self.knowledgeImageView  addSubview:self.knowledgeLabel];
    
    self.knowledgenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.knowledgeLabel.frame) + 31, knowledgeW, 14)];
    self.knowledgenoLabel.text = @"300.024567";
    self.knowledgenoLabel.textAlignment = NSTextAlignmentCenter;
    self.knowledgenoLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.knowledgenoLabel.textColor = [UIColor colorWithRed:26/255.0 green:106/255.0 blue:25/255.0 alpha:1.0];
    self.knowledgenoLabel.backgroundColor = [UIColor clearColor];
    
    [ self.knowledgeImageView  addSubview:self.knowledgenoLabel];
    
    self.knowledgesubLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.knowledgenoLabel.frame) + 12, knowledgeW, 11)];
    self.knowledgesubLabel.text = @"昨日收益300.024567";
    self.knowledgesubLabel.textAlignment = NSTextAlignmentCenter;
    self.knowledgesubLabel.font = [UIFont systemFontOfSize:11.0];
    self.knowledgesubLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
    self.knowledgesubLabel.backgroundColor = [UIColor clearColor];
    
    [ self.knowledgeImageView  addSubview:self.knowledgesubLabel];
    
    self.intelligenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.knowledgeImageView.frame) + 16, 181, (kDeviceWidth - 16 * 3)/2.0, 138)];
    
    self.intelligenceImageView.userInteractionEnabled = YES;
    self.intelligenceImageView.backgroundColor = [UIColor clearColor];
    
    [self.bgImageView addSubview:self.intelligenceImageView];
    
    UITapGestureRecognizer *intelleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intelleImageViewClick)];
    
    // 2. 将点击事件添加到label上
    [self.intelligenceImageView addGestureRecognizer:intelleTapGestureRecognizer];


//    

    self.intelligenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0  , 21, knowledgeW, 17)];
    self.intelligenceLabel.text = @"英豆";
    self.intelligenceLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.intelligenceLabel.textColor = [UIColor colorWithRed:247/255.0 green:125/255.0 blue:105/255.0 alpha:1.0];
    self.intelligenceLabel.textAlignment = NSTextAlignmentCenter;
    self.intelligenceLabel.backgroundColor = [UIColor clearColor];
    
    [self.intelligenceImageView addSubview:self.intelligenceLabel];
    
    self.intelligencenoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.intelligenceLabel.frame) + 31, knowledgeW, 14)];
    self.intelligencenoLabel.text = @"5300";
    self.intelligencenoLabel.textAlignment = NSTextAlignmentCenter;
    self.intelligencenoLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.intelligencenoLabel.textColor = [UIColor colorWithRed:235/255.0 green:98/255.0 blue:35/255.0 alpha:1.0];
    self.intelligencenoLabel.backgroundColor = [UIColor clearColor];
    
    [self.intelligenceImageView addSubview:self.intelligencenoLabel];
    
    self.intelligencesubLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.intelligencenoLabel.frame) + 12, knowledgeW, 11)];
    self.intelligencesubLabel.text = @"最近释放100";
    self.intelligencesubLabel.textAlignment = NSTextAlignmentCenter;
    self.intelligencesubLabel.font = [UIFont systemFontOfSize:11.0];
    self.intelligencesubLabel.textColor = [UIColor colorWithRed:136/255.0 green:143/255.0 blue:139/255.0 alpha:1.0];
    self.intelligencesubLabel.backgroundColor = [UIColor clearColor];
    
    [self.intelligenceImageView addSubview:self.intelligencesubLabel];

    
    
    
    
//    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 330)];
    [self.tableView.tableHeaderView addSubview:bgImageView];;
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.tableView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }
    
    [self.view addSubview:self.tableView];

    
}

- (void)GetMineAsset
{
    [self startLoading];
    [PanetRequestTool getUserScoreAssetssuccess:^(PanetMineAssetModel * _Nonnull respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.assetdata = respone.data;
            
            self.assetLabel.text = [NSString stringWithFormat:@"%.2f",self.assetdata.myAssets];
            
            self.knowledgenoLabel.text =[NSString stringWithFormat:@"%.5f",self.assetdata.sumScoreVlue];
            self.knowledgesubLabel.text = [NSString stringWithFormat:@"昨日收益%.5f",self.assetdata.scoreVlue];
            self.intelligencenoLabel.text = [NSString stringWithFormat:@"%.5f",self.assetdata.sumPeasValue];
            self.intelligencesubLabel.text = [NSString stringWithFormat:@"最近释放%.5f",self.assetdata.peasValue];
            
        }else{
            
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}

- (void)knowledgeImageViewClick
{
    KnowledgeViewController * KnowledgeVC = [[KnowledgeViewController alloc] init];
    
    
    [self.navigationController pushViewController:KnowledgeVC animated:YES];
}

- (void)intelleImageViewClick
{
    NSLog(@"yingdoudianji");
    BeansViewController *BeansVC = [[BeansViewController alloc] init];
    
    
    [self.navigationController pushViewController:BeansVC animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 106;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"newqalbumlistcell";
    PanetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[PanetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        //        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.leftImage.image = [UIImage imageNamed: [self.PantImageArr objectAtIndex:indexPath.row] ];
    cell.NameLabel.text = [self.PanttitleArr objectAtIndex:indexPath.row];
    cell.DescriptionLabel.text = [self.PantsubtitleArr objectAtIndex:indexPath.row];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
//    //    if (indexPath.row== 0) {
//    //        GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
//    //
//    //
//    //        [self.navigationController pushViewController:GetIntelligenceVC animated:YES];
//    //
//    //    }
//
    switch (indexPath.row) {
        case 0:
        {
            GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
            GetIntelligenceVC.intelligenceStr = self.intelligenceStr;
            
            [self.navigationController pushViewController:GetIntelligenceVC animated:YES];
        }
            break;
            
        case 1:
        {
            ForeignViewController *ForeignVC = [[ForeignViewController alloc] init];
            
            
            [self.navigationController pushViewController:ForeignVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}




@end
