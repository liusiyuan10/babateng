//
//  EquipmentUseHelpViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/17.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentUseHelpViewController.h"
#import "ECListView.h"
@interface EquipmentUseHelpViewController ()

@end

@implementation EquipmentUseHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    

    self.view.backgroundColor = CellBackgroundColor;
    

    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kDeviceWidth - 15, 30)];
    
    ruleLabel.text = @"如何区分小豚版本:";
    ruleLabel.textColor = [UIColor orangeColor];
    ruleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:ruleLabel];
    
    
    NSArray *itemArr = [NSArray arrayWithObjects:
                        @"小豚智慧版:配套黄色上衣，胸前只有一个红心键",
                        @"小豚魔法版:配套红白条纹毛衣,胸前只有一个红心键",
                        
                        nil];
    
    CGFloat bulletY = CGRectGetMaxY(ruleLabel.frame)+10;
    ECListView *bulletListView = [[ECListView alloc] initWithFrame:CGRectMake(15, bulletY, kDeviceWidth - 30, 0.0)
                                                         textItems:itemArr
                                                         listStyle:ListStyleBulleted];
    bulletListView.indentation = 8.0;
    bulletListView.itemsSpacing = 5.0;
    bulletListView.textColor = [UIColor colorWithRed:252.0/255 green:150.0/255 blue:88.0/255 alpha:1.0f];
    bulletListView.font = [UIFont systemFontOfSize:16.0];
    bulletListView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bulletListView];

    [self setUpNavigationItem];
    // Do any additional setup after loading the view.
}

- (void)setUpNavigationItem
{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    [button setImage:[UIImage imageNamed:@"nav_bangzu"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_bangzu_pre"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(usinghelpAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

-(void)usinghelpAction{


}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
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
