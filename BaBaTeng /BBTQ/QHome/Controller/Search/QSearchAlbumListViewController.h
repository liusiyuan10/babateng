//
//  QSearchAlbumListViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSearchAlbumListViewController : CommonViewController

typedef void(^SearchAlbumBlock) ();
@property(nonatomic,copy)SearchAlbumBlock block;
@end

NS_ASSUME_NONNULL_END
