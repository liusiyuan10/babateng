//
//  QCustomViewController.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"

@interface BPlayTestViewController : CommonViewController
//{
//    BOOL  IsPlaying;
//}

/** 初始化 */
+ (instancetype)sharedInstance;

- (void)testPlay:(NSInteger)Index;

- (void)testPasue;

- (void)playBtnClick:(UIButton *)button;

@property (nonatomic, assign) BOOL IsBPlaying;




// @property (nonatomic, strong) UIButton *playBtn;

@end
