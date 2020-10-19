//
//  QCategoryScrollListViewController.h
//  BaBaTeng
//
//  Created by liu on 17/6/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

#import "QCategoryListViewController.h"

@interface BCategoryScrollListViewController : CommonViewController
{
  
}
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign)  BOOL  IsPlaying;//是否正在播放
@property (nonatomic, strong) NSString *categoryid;

@property (nonatomic, strong)     UITableView *tableView;
@property (nonatomic, strong)     NSMutableArray *Qcateoryarr;
@property (nonatomic, strong)   NSMutableArray *playSaveArray;




@end
