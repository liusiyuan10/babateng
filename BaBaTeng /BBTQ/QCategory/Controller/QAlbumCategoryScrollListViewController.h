//
//  QAlbumCategoryScrollListViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QAlbumCategoryScrollListViewController : CommonViewController
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) NSString *categoryid;

@end

NS_ASSUME_NONNULL_END
