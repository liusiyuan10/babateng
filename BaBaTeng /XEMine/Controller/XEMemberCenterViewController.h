//
//  XEMemberCenterViewController.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/8.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface XEMemberCenterViewController : CommonViewController

@property (nonatomic, copy) NSString *levelIdStr;

@property (nonatomic, copy) NSString *baseScoreStr;
@property (nonatomic, copy) NSString *upgradeScoreStr;
@property (nonatomic, copy) NSString *intelligenceStr;
@property (nonatomic, copy) NSString *directFriend;

@property (nonatomic, copy) NSString *upgradeStatus;
@property(nonatomic, copy) NSString *agentUserStr;

@end

NS_ASSUME_NONNULL_END
