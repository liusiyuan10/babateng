//
//  QCategoryListViewController.h
//  BaBaTeng
//
//  Created by liu on 17/6/6.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface QCategoryListViewController : CommonViewController

@property(strong,nonatomic)NSString *controllerTitle;
@property(nonatomic,strong) NSArray *arrayList;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) NSString *categoryid;

@property(nonatomic,strong) NSArray *tagList;

-(void)stopplay:(NSInteger)index;

+(QCategoryListViewController *)getInstance;


@end
