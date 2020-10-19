//
//  MemberDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberDataModel : NSObject

//levelId    会员级别编号    number    @mock=1
//levelName    会员级别名称    string    @mock=金牌2二
//memberRebate    小二币数量
//memberScore    会员积分    string
//userIcon    会员头像

@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, assign) CGFloat memberRebate;
@property (nonatomic, assign) CGFloat memberScore;
@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *baseScore;
@property (nonatomic, assign) CGFloat memberAmount;
@property (nonatomic, copy) NSString *upgradeScore;
@property (nonatomic, copy) NSString *directFriend;
@property (nonatomic, copy) NSString *upgradeStatus;


@end

NS_ASSUME_NONNULL_END
