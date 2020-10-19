//
//  ExperienceViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/18.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "ExperienceViewController.h"

#import "EnglishTeacherCell.h"

#import "ExperienceTimeViewController.h"
#import "TeacherDetailViewController.h"

#import "EnglishRequestTool.h"

#import "AllEgTeacher.h"
#import "AllEgTeacherData.h"

#import "UIImageView+AFNetworking.h"

#import "ExperienceCollectionViewCell.h"
#import "ExpericecgLayout.h"

#import "UILabel+LXAdd.h"

static NSString *ExperiencellID = @"Experiencecell";

@interface ExperienceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *myCollectionView;
@property(strong,nonatomic)  NSMutableArray *AllEgTeacherArray;

@property (nonatomic, strong) UIButton *ExperienceBtn;
@property (nonatomic, assign) NSInteger pageIndex;





@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约老师";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self LoadChlidView];
    
    [self GetAllEgTeacher];
    
    self.pageIndex = 0;
}

- (void)LoadChlidView
{
    
    CGRect collectionViewFrame= CGRectMake(0, 22, kDeviceWidth, KDeviceHeight - 200);
//
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    // 设置UICollectionView为横向滚动
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    // 每一行cell之间的间距
//    flowLayout.minimumLineSpacing = 6;
//    // 每一列cell之间的间距
//    // flowLayout.minimumInteritemSpacing = 10;
//    // 设置第一个cell和最后一个cell,与父控件之间的间距
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
//
//    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
//    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
//    flowLayout.itemSize = CGSizeMake(kDeviceWidth - 100, KDeviceHeight - 200);// 该行代码就算不写,item也会有默认尺寸
    
   ExpericecgLayout *flowLayout   = [[ExpericecgLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    _myCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [self.myCollectionView registerClass:[ExperienceCollectionViewCell class] forCellWithReuseIdentifier:ExperiencellID];
    
    self.ExperienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(68 , KDeviceHeight - 64 - 50 - 44 - kDevice_IsE_iPhoneX, kDeviceWidth - 68*2, 44)];
    
    self.ExperienceBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];
    [self.ExperienceBtn setTitle:@"预约" forState:UIControlStateNormal];
    [self.ExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.ExperienceBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    [self.ExperienceBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ExperienceBtn.layer.cornerRadius = 22; //设置图片圆角的尺度
    self.ExperienceBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    
    [self.view addSubview:self.ExperienceBtn];

    
//    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.tableView.backgroundColor= [UIColor clearColor];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tableView setShowsVerticalScrollIndicator:NO];
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
    
    

    
}



- (void)backForePage
{
    //    NSLog(@"sdfsdfsdcccccc");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GetAllEgTeacher
{
    [self startLoading];
    [EnglishRequestTool getAllEgTeacherParameter:nil success:^(AllEgTeacher *respone) {
        
        [self stopLoading];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            self.AllEgTeacherArray = respone.data;
            
            [self.myCollectionView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
        
    } failure:^(NSError *error) {
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.AllEgTeacherArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ExperienceCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:ExperiencellID forIndexPath:indexPath];
    if (!cell ) {
        NSLog(@"cell为空,创建cell");
        cell = [[ExperienceCollectionViewCell alloc] init];
        
    }
    
        AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:indexPath.row];
    
        cell.teacherLabel.text = teacherdata.name;
    
        //        _numLabel.text = @"剩余可预约次数:20";
    
        cell.noLabel.text = teacherdata.toBeReservedTimes;
    
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)teacherdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];

//    NSMutableAttributedString *introductionstr =[[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《存工资服务协议》%@",@"用户协议"];
    NSString *introductionstr = [NSString stringWithFormat:@"%@%@",teacherdata.introduction,@""];
    
//    NSString *introductionstr = teacherdata.introduction;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[introductionstr stringByAppendingString:@">>更多详情"]];
//    [NSMutableAttributedString stringWithFormat:@"%@%@",teacherdata.introduction,@"用户协议"];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:MNavBackgroundColor range:NSMakeRange(attrStr.length - 6, 6)];
    
    cell.descLabel.attributedText = attrStr;
    cell.descLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnViewwClicked:)];
    cell.descLabel.tag = indexPath.row;
    [cell.descLabel addGestureRecognizer:singleTap];
    
    
//       cell.descLabel.keywords=@"用户协议";
//       cell.descLabel.keywordsColor=[UIColor redColor];
//       cell.descLabel.keywordsFont=[UIFont systemFontOfSize:15];
    //    cell.backgroundColor = [UIColor yellowColor];

    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ExperienceCollectionViewCell *cell1=  [collectionView dequeueReusableCellWithReuseIdentifier:ExperiencellID forIndexPath:indexPath];
//    cell1.backgroundColor = [UIColor redColor];
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ExperienceCollectionViewCell *cell2 =  [collectionView dequeueReusableCellWithReuseIdentifier:ExperiencellID forIndexPath:indexPath];
//    cell2.backgroundColor = [UIColor yellowColor];
//}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    switch (indexPath.row) {
//        case 0:
//        {
//            PanetMineViewController *PanetMineVC = [[PanetMineViewController alloc] init];
//            PanetMineVC.intelligenceStr = self.intelligenceStr;
//            PanetMineVC.inviteCodeStr = self.inviteCodeStr;
//
//            [self.navigationController pushViewController:PanetMineVC animated:YES];
//        }
//            break;
//
//        case 1:
//        {
//            GetIntelligenceViewController *GetIntelligenceVC = [[GetIntelligenceViewController alloc] init];
//            GetIntelligenceVC.intelligenceStr = self.intelligenceStr;
//            GetIntelligenceVC.inviteCodeStr = self.inviteCodeStr;
//            [self.navigationController pushViewController:GetIntelligenceVC animated:YES];
//
//        }
//            break;
//
//        default:
//
//            [self showToastWithString:@"开发中"];
//
//            break;
//    }
    
}


- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //1.根据偏移量判断一下应该显示第几个item
    CGFloat offSetX = targetContentOffset->x;
    
    CGFloat itemWidth = kDeviceWidth - 100;
    
    if (kDevice_IS_PAD) {
        itemWidth = kDeviceWidth - 200;
    }
    
    //item的宽度+行间距 = 页码的宽度
    NSInteger pageWidth = itemWidth;
    
    //根据偏移量计算是第几页
    NSInteger pageNum = (offSetX+pageWidth/2)/pageWidth;
    
    //2.根据显示的第几个item，从而改变偏移量
//    targetContentOffset->x = pageNum*pageWidth;
    
    NSLog(@"----------------%ld",(long)pageNum);
    self.pageIndex = pageNum;
    
//    self.currentIndex = pageNum;
    
}


- (void)ExperienceBtnClicked:(UIButton *)btn
{
    
    NSLog(@"11111111");
    
    AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:self.pageIndex];

    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
    ExperiencetimeControlVC.teacherId = teacherdata.id;

    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
    
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return self.AllEgTeacherArray.count;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 84;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *cellIndentifierOne = @"Experiencecell";
//    EnglishTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
//
//    if (!cell) {
//
//        cell = [[EnglishTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
//
//    }
//
//
//
//    AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:indexPath.row];
//
//    cell.nameLabel.text = teacherdata.name;
//
//    //        _numLabel.text = @"剩余可预约次数:20";
//    cell.numLabel.text = [NSString stringWithFormat:@"剩余可预约次数:%@",teacherdata.toBeReservedTimes];
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)teacherdata.headImgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"Teacher"]];
//
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnViewwClicked:)];
//    cell.iocnView.tag = indexPath.row;
//    [cell.iocnView addGestureRecognizer:singleTap];
//
//    cell.experienceBtn.tag = indexPath.row;
//
//    [cell.experienceBtn addTarget:self action:@selector(experienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//
//    //        cell.textLabel.text = @"测试";
//    return cell;
//
//}
//

-(void)iocnViewwClicked:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;

    UIView *views = (UIView*) tap.view;

    NSUInteger tag = views.tag;

    NSLog(@"-----tag-------------%lu",(unsigned long)tag);

    AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:tag];


    TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];

    TeacherDetailControlVC.teacherId = teacherdata.id;

    [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];
}

//
//- (void)experienceBtnClicked:(UIButton *)btn
//{
//    AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:btn.tag];
//
//    ExperienceTimeViewController *ExperiencetimeControlVC = [[ExperienceTimeViewController alloc] init];
//    ExperiencetimeControlVC.teacherId = teacherdata.id;
//
//    [self.navigationController pushViewController:ExperiencetimeControlVC animated:YES];
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    AllEgTeacherData *teacherdata = [self.AllEgTeacherArray objectAtIndex:indexPath.row];
//    TeacherDetailViewController *TeacherDetailControlVC = [[TeacherDetailViewController alloc] init];
//
//    TeacherDetailControlVC.teacherId = teacherdata.id;
//
//    [self.navigationController pushViewController:TeacherDetailControlVC animated:YES];
//
//}
//



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    
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
