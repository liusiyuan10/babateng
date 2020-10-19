//
//  EquipmentRecommenlistViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/4/5.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentRecommenlistViewController.h"
/** BXImageH */
#define imageH [UIScreen mainScreen].bounds.size.width*0.3
@interface EquipmentRecommenlistViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>
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

@implementation EquipmentRecommenlistViewController



#pragma mark - initView
-(void)initView{
    
    self.title = @"推荐列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120-64);
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
    headerImage.contentMode = UIViewContentModeScaleToFill;
    [tableView insertSubview:headerImage atIndex:0];
    self.headerImage = headerImage;
    self.headerImage.image = [UIImage imageNamed:@"bg_shang"];
    self.headerImage.userInteractionEnabled = YES;

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
}


-(void)completeAction{


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


#pragma mark - Systems
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];//初始化 
    self.dataArray = [NSMutableArray arrayWithObjects:@"测试",@"测试",@"测试", nil];
    self.dataImageArray = [NSMutableArray arrayWithObjects:@"icon_nicheng",@"BBZL_icon_shenri",@"icon_xinbie", nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
      self.navigationController.navigationBar.translucent = YES;
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
