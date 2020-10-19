//
//  BBTMessageSetViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTMessageSetViewController.h"
#import "MessageSetCell.h"
#import "TMCache.h"
@interface BBTMessageSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataArray1;


@end

@implementation BBTMessageSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息设置";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, kDeviceWidth,KDeviceHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
    self.dataArray = [NSMutableArray arrayWithObjects:@"系统消息",@"设备通知",@"家人邀请", nil];
    
    self.dataArray1 = [NSMutableArray arrayWithObjects:@"消息免打扰",@"免打扰时段", nil];
    // Do any additional setup after loading the view.
}


#pragma mark - tableView delegate


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
//    headerView.backgroundColor = [UIColor clearColor];
//
//    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kDeviceWidth-30, 30)];
//    headerLabel.textAlignment = NSTextAlignmentLeft;
//    headerLabel.font = [UIFont systemFontOfSize:18];
//    headerLabel.textColor = [UIColor lightGrayColor];
//    if(section==0){
//        headerLabel.text = @"系统推送";
//    }else{
//        headerLabel.text = @"免打扰";
//    }
//    headerLabel.backgroundColor = [UIColor clearColor];
//
//    [headerView addSubview:headerLabel];
//
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    return 40;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // if(section==0){
    
    
    return self.dataArray.count;
    
    //    }else{
    //
    //        return self.dataArray1.count;
    //    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    MessageSetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[MessageSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        //cell.contentView.backgroundColor = CellBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        if (indexPath.row==0) {
        //
        //            UIImageView *andImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
        //            //andImageView.image = [UIImage imageNamed:@"line.png"];
        //            andImageView.backgroundColor = [UIC]
        //            [cell.contentView addSubview:andImageView];
        //
        //        }
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.sevenSwitch.hidden = NO;
                    [cell.textLabel setText:self.dataArray[indexPath.row]];
                    
                    if ([[[TMCache sharedCache] objectForKey:@"SystemSevenSwitch"]isEqualToString:@"OFF"]) {
                        
                        [cell.sevenSwitch setOn: NO animated:YES];
                        
                    }else{
                        
                        [cell.sevenSwitch setOn: YES animated:YES];
                    }
                    
                    [cell.sevenSwitch addTarget:self action:@selector(notice:) forControlEvents:UIControlEventValueChanged];
                }
                    break;
                    
                case 1:
                {
                    
                    cell.sevenSwitch.hidden = NO;
                    [cell.textLabel setText:self.dataArray[indexPath.row]];
                    
                    if ([[[TMCache sharedCache] objectForKey:@"DeviceSevenSwitch"]isEqualToString:@"OFF"]) {
                        
                        [cell.sevenSwitch setOn: NO animated:YES];
                        
                    }else{
                        
                        [cell.sevenSwitch setOn: YES animated:YES];
                    }
                    
                    
                    [cell.sevenSwitch addTarget:self action:@selector(share:) forControlEvents:UIControlEventValueChanged];
                }
                    break;
                    
                    
                case 2:
                {
                    cell.sevenSwitch.hidden = NO;
                    [cell.textLabel setText:self.dataArray[indexPath.row]];
                    if ([[[TMCache sharedCache] objectForKey:@"FamilySevenSwitch"]isEqualToString:@"OFF"]) {
                        
                        [cell.sevenSwitch setOn: NO animated:YES];
                        
                    }else{
                        
                        [cell.sevenSwitch setOn: YES animated:YES];
                    }
                    
                    
                    [cell.sevenSwitch addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventValueChanged];
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
            
            //        case 1:
            //        {
            //
            //            switch (indexPath.row) {
            //                case 0:
            //                {
            //                    cell.sevenSwitch.hidden = NO;
            //                    [cell.textLabel setText:self.dataArray1[indexPath.row]];
            //                     [cell.sevenSwitch addTarget:self action:@selector(disturb:) forControlEvents:UIControlEventValueChanged];
            //                }
            //                    break;
            //
            //                case 1:
            //                {
            //                    cell.sevenSwitch.hidden = YES;
            //                    cell.subNameLabel.hidden = NO;
            //                    [cell.textLabel setText:self.dataArray1[indexPath.row]];
            //                }
            //                    break;
            //
            //
            //                default:
            //                    break;
            //            }
            //
            //        }
            //            break;
            
        default:
            break;
    }
    
    
    
    //    cell.leftImage.image = [UIImage imageNamed:self.dataImageArray[indexPath.row]];
    //    cell.nameLabel.text = self.dataArray[indexPath.row];
    //    cell.onlineLabel.text = @"无消息";
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)notice:(SevenSwitch *)sender {
    NSLog(@"notice value to: %@", sender.on ? @"ON" : @"OFF");
    if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"ON"]) {
        
        [[TMCache sharedCache]setObject: @"ON" forKey:@"SystemSevenSwitch"];
        
    }else if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"OFF"]){
        
        [[TMCache sharedCache]setObject: @"OFF" forKey:@"SystemSevenSwitch"];
    }
    
}
- (void)share:(SevenSwitch *)sender {
    NSLog(@"share value to: %@", sender.on ? @"ON" : @"OFF");
    
    if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"ON"]) {
        
        [[TMCache sharedCache]setObject: @"ON" forKey:@"DeviceSevenSwitch"];
        
    }else if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"OFF"]){
        
        [[TMCache sharedCache]setObject: @"OFF" forKey:@"DeviceSevenSwitch"];
    }
}
- (void)invitation:(SevenSwitch *)sender {
    NSLog(@"invitation value to: %@", sender.on ? @"ON" : @"OFF");
    
    if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"ON"]) {
        
        [[TMCache sharedCache]setObject: @"ON" forKey:@"FamilySevenSwitch"];
        
    }else if ([sender.on ? @"ON" : @"OFF" isEqualToString:@"OFF"]){
        
        [[TMCache sharedCache]setObject: @"OFF" forKey:@"FamilySevenSwitch"];
    }
}
//- (void)disturb:(SevenSwitch *)sender {
//    NSLog(@"disturb value to: %@", sender.on ? @"ON" : @"OFF");
//}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
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
