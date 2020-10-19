//
//  MemberLevellDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberLevellDataModel : NSObject

//levelId    会员级别编号    number    @mock=$order(1,2,3)
//levelName    会员级别    string    @mock=$order('金牌2二','见习小二','普通小二')
//upgradeScore    升级积分

@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *upgradeScore;


@end

NS_ASSUME_NONNULL_END
