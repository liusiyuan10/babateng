//
//  ProductViewController.m
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "ChildViewController.h"

#import "ChildViewCell.h"

#import "BBTEquipmentRequestTool.h"

#import "Bulletin.h"

#import "BulletinData.h"
#import "BulletinViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ChildFrame.h"

@interface ChildViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property(strong,nonatomic)  NSMutableArray *ADImageArray;
@property(strong,nonatomic)  NSMutableArray *ADImageFrameArray;
@property (nonatomic, assign) BOOL isCanSideBack;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"育儿";
    
    self.ADImageFrameArray = [[NSMutableArray alloc] init];
    
    [self LoadChlidView];

    [self GetBulletinList];
    
}


- (void)GetBulletinList
{
    
    NSDictionary *parameter = @{@"userId" : [[TMCache sharedCache] objectForKey:@"userId"] , @"token" : [[TMCache sharedCache] objectForKey:@"token"]};
    
    [BBTEquipmentRequestTool GetBulletinDeviceTypeId:@"0" Parameter:parameter success:^(Bulletin *response) {
        
        
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.ADImageArray = response.data;
            
            for (BulletinData *bullindata in response.data) {
                ChildFrame *childframe = [[ChildFrame alloc] init];
                
                childframe.bulltindata = bullindata;
                
                [self.ADImageFrameArray addObject:childframe];
                
                
            }
            
            NSLog(@"self.ADImageArray%@",self.ADImageFrameArray);
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:response.message];
        }
        
    } failure:^(NSError *error) {
        
        //        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    
    
}



- (void)LoadChlidView
{
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ADImageFrameArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildFrame *childframe = self.ADImageFrameArray[indexPath.row];
    
//    return 168 + 87 + 8;
    NSLog(@"sdfdfdfdfdfdfdf=%f",childframe.rowHeight);
    return childframe.rowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifierOne = @"childviewcell";
    ChildViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierOne];
    
    if (!cell) {
        
        cell = [[ChildViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierOne];
        
    }
    

//    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:indexPath.row];
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.bulletinIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
//    [cell.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"yuerbanner"]];
//
//    cell.tilteLabel.text = bulletindata.bulletinTitle;
//    cell.contentLabel.text = bulletindata.bulletinSummary;
    
    cell.childFrame = self.ADImageFrameArray[indexPath.row];
    
    
    
    //        cell.textLabel.text = @"测试";
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    

    BulletinData *bulletindata = [self.ADImageArray objectAtIndex:indexPath.row];
    
    BulletinViewController *bulletinVc = [[BulletinViewController alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Advertising.html?bulletinId=%@",BBT_HTML,bulletindata.bulletinId];
    bulletinVc.URL = [NSURL URLWithString:urlStr];
    
    [self.navigationController pushViewController:bulletinVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self forbiddenSideBack];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];

    [self resetSideBack];

}



/**
 
 * 禁用边缘返回
 
 */

-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    
    //关闭ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        
    }
    
}

/*
 
 恢复边缘返回
 
 */

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    
    //开启ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
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
