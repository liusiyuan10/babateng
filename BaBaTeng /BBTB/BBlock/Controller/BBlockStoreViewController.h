//
//  BBlockStoreViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"
#import "BStoreHeadView.h"

@interface BBlockStoreViewController : CommonViewController<BStoreHeadViewDelegate>
{
    NSInteger _currentSection;
    NSInteger _currentRow;
}

@end
