//
//  BBTBigChangeNickNameViewController.h
//  BaBaTeng
//
//  Created by MrfengJW on 17/3/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "CommonViewController.h"


@protocol NickNameViewDelegate <NSObject>

- (void)didClickedWithNickName:(NSString*)nickName;

@end

@interface BBTBigChangeNickNameViewController : CommonViewController
@property (strong, nonatomic) id<NickNameViewDelegate>delegate;
@end
