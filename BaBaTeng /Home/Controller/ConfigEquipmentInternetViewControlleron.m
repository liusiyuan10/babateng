//
//  ConfigEquipmentInternetViewControlleron.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/27.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "ConfigEquipmentInternetViewControlleron.h"
#import "EquipmentCell.h"
#import "EquipmentInformationViewController.h"
@interface ConfigEquipmentInternetViewControlleron ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ConfigEquipmentInternetViewControlleron

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title  = @"搜索设备";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,KDeviceHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Identifier";
    
    EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[EquipmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row==0) {
        
        cell.leftImage.image = [UIImage imageNamed:@"SB_xiaoba_nor"];
        
    }else{
        
        cell.leftImage.image = [UIImage imageNamed:@"SB_xiaotun_nor"];
    }
    
    cell.nameLabel.text = @"小豚";
   // cell.onlineLabel.text = @"设备在线";
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[EquipmentInformationViewController new] animated:YES];
    
   
}

@end
