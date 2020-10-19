//
//  UpdateLevelDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateLevelDataModel : NSObject

//levelId    需要升级的级别    string
//upgradeScore    升级的积分

@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *upgradeScore;

@property (nonatomic, copy) NSString *levelName;
@end

NS_ASSUME_NONNULL_END
