//
//  StudentStyleViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/7.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentStyleViewController : CommonViewController

@property (nonatomic, strong) NSMutableArray *playInfos;
@property (nonatomic, assign) NSInteger playIndex;
@property (nonatomic, copy) NSString *playUrl;

@end

NS_ASSUME_NONNULL_END
