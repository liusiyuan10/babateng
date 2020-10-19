//
//  QCategoryViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCategorybackViewController.h"
#import "MultilevelMenu.h"
#import "Header.h"
#import "UIView+Extension.h"
#import "QCategoryListViewController.h"
//#import "UIView+SNFoundation.h"

@interface QCategorybackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *arrayLists;
@property (nonatomic, strong) UIButton *readerButton;

@property(nonatomic,strong) NSArray *categoryarray;
@property(nonatomic,strong) NSArray *subcategoryarray;
@property(nonatomic,strong) NSArray *threecategoryarray;


@end

@implementation QCategorybackViewController

- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        _backScrollView = [[UIScrollView alloc] init];
        
        
        _backScrollView.frame = CGRectMake(0, 0, kDeviceWidth, self.view.size.height);
        _backScrollView.contentSize = CGSizeMake(self.leftParamView.size.width + self.righParamtView.size.width,0);
        //
        _backScrollView.scrollEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator =  NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        //        _backScrollView.alwaysBounceHorizontal = YES;
        _backScrollView.pagingEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.bounces = NO;
        //        _backScrollView.alwaysBounceVertical = YES;
        //        CGRect rc =_backScrollView.frame;
        
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _backScrollView;
}

-(UIView *)righParamtView{
    
    if (!_righParamtView) {
        
        _righParamtView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth, 3, kDeviceWidth, self.backScrollView.frame.size.height)];
        
        _righParamtView.backgroundColor = [UIColor clearColor];
        
        _righParamtView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        
        [self.backScrollView addSubview:_righParamtView];
    }
    
    return _righParamtView;
}


-(UIView *)leftParamView{
    
    if (!_leftParamView) {
        
        _leftParamView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.backScrollView.frame.size.height)];
        
        _leftParamView.backgroundColor = [UIColor clearColor];
        
        _leftParamView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self.backScrollView addSubview:_leftParamView];
    }
    
    return _leftParamView;
}


- (NSArray *)arrayLists
{
    if (_arrayLists == nil) {
        _arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"QCategory.plist" ofType:nil]];
    }
    return _arrayLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"分类";
    
    [self.view addSubview:self.backScrollView];
    
    [self loadCategory];
    

}

- (void)loadCategory
{
    
    
        NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    
        /**
         *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
         */
        //NSInteger countMax=6;
        for (int i=0; i<self.arrayLists.count; i++) {
    
            rightMeun * meun=[[rightMeun alloc] init];
            meun.meunName=[self.arrayLists[i] objectForKey:@"leftTitle"];
            NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
            for ( int j=0; j <[[self.arrayLists[i] objectForKey:@"leftKey"] count]; j++) {
    
                rightMeun * meun1=[[rightMeun alloc] init];
                meun1.meunName=  [[self.arrayLists[i] objectForKey:@"leftKey"][j] objectForKey:@"subTitle"]; //
    
                [sub addObject:meun1];
    

    
//                NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
//         
//    
//                for ( int z=0; z < [[[self.arrayLists[i] objectForKey:@"leftKey"][j] objectForKey:@"subArrayKey"] count]; z++) {
//    
//                    rightMeun * meun2=[[rightMeun alloc] init];
//                    meun2.meunName=  [[self.arrayLists[i] objectForKey:@"leftKey"][j] objectForKey:@"subArrayKey"][z];   
//    
//                    [zList addObject:meun2];
//    
//                }
               
    
//                meun1.secondArray = sub;
            }
            
            
            meun.secondArray=sub;
            [lis addObject:meun];
        }
    
    NSLog(@"lislislislislislislislis%@",lis);
    
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    /**
     默认是 选中第一行
     
     :returns: <#return value description#>
     */
    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-103) WithData:lis withSelectIndex:^(NSInteger left, NSInteger rightGroup,NSInteger right,rightMeun* info) {
        
        rightMeun * title;
        title=lis[left];
        
//        rightMeun * groupTitle;
//
//        groupTitle=title.secondArray[rightGroup];
        
        
//        rightMeun * meun;
//        meun=groupTitle.nextArray[right];
        

        
        
        QCategoryListViewController *categoryList = [[QCategoryListViewController alloc]init];
        categoryList.hidesBottomBarWhenPushed = YES;
//        categoryList.controllerTitle =groupTitle.meunName;
        categoryList.controllerTitle =@"sg";
//        categoryList.categoryid = meun.ID;
        categoryList.arrayList = title.secondArray;
        categoryList.index =right;
        [self.navigationController pushViewController:categoryList animated:YES];
    }];
    
    
    view.needToScorllerIndex=0;
    
    view.isRecordLastScroll=NO;
    
    
    [self.leftParamView addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;

    
}

@end
